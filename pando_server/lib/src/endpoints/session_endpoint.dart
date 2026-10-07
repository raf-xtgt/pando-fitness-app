import 'dart:math' as math;

import 'package:serverpod/serverpod.dart';

import '../generated/protocol.dart';
import '../generated/future_calls.dart';
import '../goals/goal_calculator.dart';
import '../pando_services.dart';
import 'caller.dart';

/// Activity sessions: what to aim for next, saving a finished walk, and the
/// history for Home. Every call is scoped to the signed-in user.
class SessionEndpoint extends Endpoint {
  @override
  bool get requireLogin => true;

  /// The report (and its notification) is due this long after a session.
  static const Duration reportDelay = Duration(minutes: 5);

  /// The goal, stride, resume point and signs for the next activity.
  Future<ActivityPlan> plan(Session session) async {
    final profile = await session.requireCallerProfile();
    final stride = GoalCalculator.strideM(profile.heightM!);
    final history = await _newestFirst(session, profile.id!);
    final goalSteps = GoalCalculator.goalSteps([
      for (final s in history) s.steps,
    ]);
    return ActivityPlan(
      goalSteps: goalSteps,
      goalM: goalSteps * stride,
      strideM: stride,
      resumeMetres: history.isEmpty ? 0 : history.first.endPathM,
      signMetres: [0, for (final s in history.reversed) s.endPathM],
      isFirstActivity: history.every((s) => s.isSeeded),
    );
  }

  /// Saves a finished session. Safe to retry: a second call with the same
  /// `clientSessionId` returns the first result and changes nothing.
  Future<ActivitySession> save(Session session, SessionInput input) async {
    final profile = await session.requireCallerProfile();
    final existing = await ActivitySession.db.findFirstRow(
      session,
      where: (t) => t.clientSessionId.equals(input.clientSessionId),
    );
    if (existing != null) {
      if (existing.profileId != profile.id) {
        throw StateError('Session id already used');
      }
      return existing;
    }

    final stride = GoalCalculator.strideM(profile.heightM!);
    final distance = math.max(0, input.steps) * stride;
    final goalM = input.goalSteps * stride;
    final goalMet = input.steps >= input.goalSteps;
    final previous = await _newestFirst(session, profile.id!, limit: 1);
    final startPathM = previous.isEmpty ? 0.0 : previous.first.endPathM;

    final draft = ActivitySession(
      profileId: profile.id!,
      clientSessionId: input.clientSessionId,
      startedAt: input.startedAt,
      endedAt: input.endedAt,
      steps: input.steps,
      strideM: stride,
      distanceM: distance,
      goalSteps: input.goalSteps,
      goalM: goalM,
      goalMet: goalMet,
      extraM: goalMet ? distance - goalM : 0,
      feel: input.feel,
      stoppedEarly: !goalMet,
      paceDropped: input.paceDropped,
      startPathM: startPathM,
      endPathM: startPathM + distance,
      reportReadyAt: input.endedAt.add(reportDelay),
    );
    final saved = await ActivitySession.db.insertRow(
      session,
      draft.copyWith(
        reportMessage: await PandoServices.reportBuilder.message(draft),
      ),
    );
    await _scheduleReport(session, saved);
    return saved;
  }

  /// The push goes out at `reportReadyAt`, or straight away for a session
  /// that synced late (no signal in the park).
  static Future<void> _scheduleReport(
    Session session,
    ActivitySession saved,
  ) async {
    final now = DateTime.now().toUtc();
    final runAt = saved.reportReadyAt.isBefore(now) ? now : saved.reportReadyAt;
    await session.serverpod.futureCalls
        .callAtTime(runAt, identifier: 'report-${saved.id}')
        .sendReportNotification
        .send(saved.id!);
    // Cloud Run: wake the maintenance job a little after the call is due.
    // A failed alarm must not lose the walk: the call stays due, the next
    // alarm runs it, and the Home row opens the report meanwhile.
    try {
      await PandoServices.alarm.ringAt(runAt.add(alarmMargin));
    } catch (e) {
      session.log(
        'Maintenance alarm failed for session ${saved.id}: $e',
        level: LogLevel.warning,
      );
    }
  }

  /// The maintenance job only runs calls that are already due.
  static const Duration alarmMargin = Duration(seconds: 10);

  /// The report for one of the caller's sessions.
  Future<SessionReport> report(Session session, int sessionId) async {
    final profile = await session.requireCallerProfile();
    final s = await ActivitySession.db.findById(session, sessionId);
    if (s == null || s.profileId != profile.id) {
      throw StateError('No such session');
    }
    return SessionReport(
      sessionId: sessionId,
      endedAt: s.endedAt,
      message: s.reportMessage ?? await PandoServices.reportBuilder.message(s),
      distanceM: s.distanceM,
      // Sessions chain along the path from 0, so this is every metre so far.
      totalDistanceAllM: s.endPathM,
      goalMet: s.goalMet,
      extraM: s.extraM,
    );
  }

  /// The caller's sessions, newest first.
  Future<List<ActivitySession>> list(Session session) async {
    final profile = await session.callerProfile();
    if (profile == null) return [];
    return _newestFirst(session, profile.id!, limit: 50);
  }

  static Future<List<ActivitySession>> _newestFirst(
    Session session,
    int profileId, {
    int? limit,
  }) => ActivitySession.db.find(
    session,
    where: (t) => t.profileId.equals(profileId),
    orderByList: (t) => [t.endedAt.desc(), t.id.desc()],
    limit: limit,
  );
}

import 'dart:math' as math;

import 'package:serverpod/serverpod.dart';

import '../generated/protocol.dart';
import '../goals/goal_calculator.dart';
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

    return ActivitySession.db.insertRow(
      session,
      ActivitySession(
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
      ),
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

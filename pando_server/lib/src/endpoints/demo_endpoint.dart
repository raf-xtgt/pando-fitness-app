import 'package:serverpod/serverpod.dart';

import '../generated/protocol.dart';
import '../goals/goal_calculator.dart';
import '../pando_services.dart';
import 'caller.dart';

/// Demo-only history, so the demo shows a goal that grows from past walks.
/// Refused unless `allowDemoSeed` is on in the server config.
class DemoEndpoint extends Endpoint {
  @override
  bool get requireLogin => true;

  /// Steps of the three seeded walks, oldest first.
  static const List<int> seededSteps = [1100, 1200, 1250];

  /// Adds three past walks over the previous week, chained along the path
  /// like real ones. Only for a fresh profile (no sessions yet), so seeded
  /// and real walks never overlap on the map.
  Future<List<ActivitySession>> seedThreeSessions(Session session) async {
    if (!PandoServices.allowDemoSeed) {
      throw StateError('Demo seed is off on this server');
    }
    final profile = await session.requireCallerProfile();
    final existing = await ActivitySession.db.count(
      session,
      where: (t) => t.profileId.equals(profile.id!),
    );
    if (existing > 0) {
      throw StateError('Demo seed needs a profile with no sessions');
    }

    final stride = GoalCalculator.strideM(profile.heightM!);
    final now = DateTime.now().toUtc();
    final seeded = <ActivitySession>[];
    var pathM = 0.0;
    for (final (i, steps) in seededSteps.indexed) {
      final goalSteps = GoalCalculator.goalSteps([
        for (final s in seeded.reversed) s.steps,
      ]);
      // 6, 4 and 2 days ago, at about 100 steps a minute.
      final endedAt = now.subtract(Duration(days: 6 - 2 * i));
      final distance = steps * stride;
      final goalM = goalSteps * stride;
      final goalMet = steps >= goalSteps;
      final draft = ActivitySession(
        profileId: profile.id!,
        clientSessionId: 'seed-${profile.id}-$i',
        startedAt: endedAt.subtract(Duration(minutes: steps ~/ 100)),
        endedAt: endedAt,
        steps: steps,
        strideM: stride,
        distanceM: distance,
        goalSteps: goalSteps,
        goalM: goalM,
        goalMet: goalMet,
        extraM: goalMet ? distance - goalM : 0,
        feel: Feel.justRight,
        stoppedEarly: !goalMet,
        paceDropped: false,
        startPathM: pathM,
        endPathM: pathM + distance,
        reportReadyAt: endedAt.add(const Duration(minutes: 5)),
        // Old walks: no push for them.
        notificationSentAt: endedAt.add(const Duration(minutes: 5)),
        isSeeded: true,
      );
      seeded.add(
        await ActivitySession.db.insertRow(
          session,
          draft.copyWith(
            reportMessage: await PandoServices.reportBuilder.message(draft),
          ),
        ),
      );
      pathM += distance;
    }
    return seeded;
  }
}

import 'package:pando_server/src/generated/protocol.dart';
import 'package:pando_server/src/goals/goal_calculator.dart';
import 'package:pando_server/src/pando_services.dart';
import 'package:test/test.dart';

import 'test_tools/serverpod_test_tools.dart';

void main() {
  withServerpod('Given a fresh walker', (sessionBuilder, endpoints) {
    final walker = sessionBuilder.copyWith(
      authentication: AuthenticationOverride.authenticationInfo(
        '550e8400-e29b-41d4-a716-446655440000',
        {},
      ),
    );

    setUp(() async {
      PandoServices.allowDemoSeed = false;
      await endpoints.profile.saveHeight(walker, 1.70);
    });

    test('when the flag is off then the seed is refused', () async {
      expect(
        () => endpoints.demo.seedThreeSessions(walker),
        throwsA(anything),
      );
      expect(await endpoints.session.list(walker), isEmpty);
    });

    group('when the flag is on and the seed runs', () {
      setUp(() async {
        PandoServices.allowDemoSeed = true;
        await endpoints.demo.seedThreeSessions(walker);
      });

      test('then three seeded sessions exist, chained on the path', () async {
        final sessions = await endpoints.session.list(walker);
        expect(sessions, hasLength(3));
        expect(sessions.every((s) => s.isSeeded), isTrue);
        expect([for (final s in sessions) s.steps], [1250, 1200, 1100]);
        expect(sessions.last.startPathM, 0);
        expect(sessions[1].startPathM, sessions.last.endPathM);
        expect(sessions.first.startPathM, sessions[1].endPathM);
        expect(sessions.every((s) => s.reportMessage != null), isTrue);
      });

      test('then it is still the first activity', () async {
        final plan = await endpoints.session.plan(walker);
        expect(plan.isFirstActivity, isTrue);
      });

      test('then the goal is max(1,000, average + max(2%, 100))', () async {
        final plan = await endpoints.session.plan(walker);
        const average = (1100 + 1200 + 1250) / 3;
        final expected =
            (average + (average * 0.02 > 100 ? average * 0.02 : 100)).round();
        expect(plan.goalSteps, expected < 1000 ? 1000 : expected);
        expect(
          plan.goalM,
          closeTo(plan.goalSteps * GoalCalculator.strideM(1.70), 1e-6),
        );
      });

      test('then a second seed is refused', () async {
        expect(
          () => endpoints.demo.seedThreeSessions(walker),
          throwsA(anything),
        );
      });

      test('then a real session ends the first activity', () async {
        final now = DateTime.now().toUtc();
        await endpoints.session.save(
          walker,
          SessionInput(
            clientSessionId: 'real-1',
            startedAt: now.subtract(const Duration(minutes: 10)),
            endedAt: now,
            steps: 900,
            goalSteps: 1283,
            feel: null,
            paceDropped: false,
          ),
        );
        final plan = await endpoints.session.plan(walker);
        expect(plan.isFirstActivity, isFalse);
      });
    });
  });
}

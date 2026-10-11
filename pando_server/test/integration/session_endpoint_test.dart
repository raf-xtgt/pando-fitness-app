import 'package:pando_server/src/generated/protocol.dart';
import 'package:test/test.dart';

import 'test_tools/serverpod_test_tools.dart';

void main() {
  withServerpod('Given a walker with a saved height', (
    sessionBuilder,
    endpoints,
  ) {
    final walker = sessionBuilder.copyWith(
      authentication: AuthenticationOverride.authenticationInfo(
        '550e8400-e29b-41d4-a716-446655440000',
        {},
      ),
    );
    final other = sessionBuilder.copyWith(
      authentication: AuthenticationOverride.authenticationInfo(
        '6ba7b810-9dad-11d1-80b4-00c04fd430c8',
        {},
      ),
    );
    final start = DateTime.utc(2026, 10, 7, 18);

    SessionInput input(String id, int steps, int goalSteps, {int hour = 0}) =>
        SessionInput(
          clientSessionId: id,
          startedAt: start.add(Duration(hours: hour)),
          endedAt: start.add(Duration(hours: hour, minutes: 15)),
          steps: steps,
          goalSteps: goalSteps,
          feel: Feel.justRight,
          paceDropped: false,
        );

    setUp(() async {
      await endpoints.profile.saveHeight(walker, 1.70);
      await endpoints.profile.saveHeight(other, 1.60);
    });

    test(
      'when there is no history then the plan is the first goal at 0 m',
      () async {
        final plan = await endpoints.session.plan(walker);
        expect(plan.goalSteps, 1000);
        expect(plan.strideM, closeTo(0.7055, 1e-9));
        expect(plan.goalM, closeTo(705.5, 1e-6));
        expect(plan.resumeMetres, 0);
        expect(plan.signMetres, [0]);
      },
    );

    test(
      'when a session is saved then distance, goal and path are computed',
      () async {
        final saved = await endpoints.session.save(
          walker,
          input('a', 1200, 1000),
        );
        expect(saved.distanceM, closeTo(1200 * 0.7055, 1e-6));
        expect(saved.goalMet, isTrue);
        expect(saved.stoppedEarly, isFalse);
        expect(saved.extraM, closeTo(200 * 0.7055, 1e-6));
        expect(saved.startPathM, 0);
        expect(saved.endPathM, closeTo(saved.distanceM, 1e-9));
        expect(
          saved.reportReadyAt,
          saved.endedAt.add(const Duration(minutes: 5)),
        );
      },
    );

    test(
      'when a goal is missed then it counts as stopped early, no extra',
      () async {
        final saved = await endpoints.session.save(
          walker,
          input('a', 300, 1000),
        );
        expect(saved.goalMet, isFalse);
        expect(saved.stoppedEarly, isTrue);
        expect(saved.extraM, 0);
      },
    );

    test(
      'when the same session is saved twice then only one row exists',
      () async {
        final first = await endpoints.session.save(
          walker,
          input('a', 1200, 1000),
        );
        final second = await endpoints.session.save(
          walker,
          input('a', 1200, 1000),
        );
        expect(second.id, first.id);
        expect(await endpoints.session.list(walker), hasLength(1));
      },
    );

    test(
      'when sessions are saved then the next plan resumes at the last sign',
      () async {
        final one = await endpoints.session.save(
          walker,
          input('a', 1000, 1000),
        );
        final two = await endpoints.session.save(
          walker,
          input('b', 500, 1100, hour: 1),
        );
        expect(two.startPathM, closeTo(one.endPathM, 1e-9));

        final plan = await endpoints.session.plan(walker);
        expect(plan.resumeMetres, closeTo(two.endPathM, 1e-9));
        expect(plan.signMetres, [0, one.endPathM, two.endPathM]);
        // Baseline (1000 + 500) / 2 = 750, +100 = 850: below the floor.
        expect(plan.goalSteps, 1000);
      },
    );

    test('when sessions are listed then the newest comes first', () async {
      await endpoints.session.save(walker, input('a', 100, 1000));
      await endpoints.session.save(walker, input('b', 200, 1000, hour: 1));
      final list = await endpoints.session.list(walker);
      expect([for (final s in list) s.clientSessionId], ['b', 'a']);
    });

    test(
      'when another user saves then the walker sees only their own',
      () async {
        await endpoints.session.save(walker, input('a', 100, 1000));
        await endpoints.session.save(other, input('b', 200, 1000));
        final list = await endpoints.session.list(walker);
        expect([for (final s in list) s.clientSessionId], ['a']);
        expect((await endpoints.session.plan(other)).signMetres, hasLength(2));
      },
    );

    test(
      'when the timeline is asked then it has totals and pages of 5 signs',
      () async {
        for (var i = 0; i < 7; i++) {
          await endpoints.session.save(
            walker,
            input('w$i', 100, 1000, hour: i),
          );
        }
        await endpoints.session.save(other, input('x', 900, 1000));

        final first = await endpoints.session.timeline(walker, 0);
        expect(first.walkCount, 7);
        expect(first.totalSteps, 700);
        expect(first.totalM, closeTo(700 * 0.7055, 1e-6));
        expect(first.totalS, 7 * 15 * 60);
        expect(first.hasEarlier, isTrue);
        expect(first.checkpoints, hasLength(5));
        // Newest first; each sign holds the journey total so far.
        expect(first.checkpoints.first.totalM, closeTo(first.totalM, 1e-6));
        expect(first.checkpoints.first.distanceM, closeTo(70.55, 1e-6));
        expect(first.checkpoints.first.durationS, 15 * 60);
        expect(first.checkpoints.first.ran, isFalse);

        final second = await endpoints.session.timeline(walker, 1);
        expect(second.checkpoints, hasLength(2));
        expect(second.hasEarlier, isFalse);
        expect(second.checkpoints.last.totalM, closeTo(70.55, 1e-6));
        expect(second.totalSteps, 700);
      },
    );

    test('when there are no walks then the timeline is empty', () async {
      final page = await endpoints.session.timeline(walker, 0);
      expect(page.walkCount, 0);
      expect(page.checkpoints, isEmpty);
      expect(page.hasEarlier, isFalse);
    });
  });
}

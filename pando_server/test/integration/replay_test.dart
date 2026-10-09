import 'package:pando_server/src/generated/protocol.dart';
import 'package:pando_server/src/notifications/push_sender.dart';
import 'package:pando_server/src/pando_services.dart';
import 'package:pando_server/src/walks/walk_slices.dart';
import 'package:pando_shared/pando_shared.dart';
import 'package:serverpod/serverpod.dart' show Uuid;
import 'package:test/test.dart';

import 'test_tools/serverpod_test_tools.dart';

/// Sends nothing.
class _NoPush implements PushSender {
  @override
  Future<bool> send({
    required String token,
    required String title,
    required String body,
    required Map<String, String> data,
  }) async => true;
}

void main() {
  withServerpod('Given a saved walk → run → walk', (sessionBuilder, endpoints) {
    final walker = sessionBuilder.copyWith(
      authentication: AuthenticationOverride.authenticationInfo(
        '550e8400-e29b-41d4-a716-446655440000',
        {},
      ),
    );
    final stranger = sessionBuilder.copyWith(
      authentication: AuthenticationOverride.unauthenticated(),
    );
    final start = DateTime.utc(2026, 10, 9, 8);
    late ActivitySession saved;

    /// The synced slices, per walk (what offline sync would have stored).
    var synced = <String, List<WalkSlice>>{};
    var reads = 0;

    WalkSlice slice(int index, int steps) => WalkSlice(
      clientSessionId: 'walk-1',
      startAt: start.add(Duration(seconds: 30 * index)),
      endAt: start.add(Duration(seconds: 30 * (index + 1))),
      steps: steps,
    );

    setUp(() async {
      PandoServices.push = _NoPush();
      reads = 0;
      synced = {
        'walk-1': [slice(0, 50), slice(1, 50), slice(2, 70), slice(3, 50)],
      };
      PandoServices.walkSlices =
          (session, {required authUserId, required clientSessionId}) async {
            reads++;
            return synced[clientSessionId] ?? [];
          };
      await endpoints.profile.saveHeight(walker, 1.70);
      saved = await endpoints.session.save(
        walker,
        SessionInput(
          clientSessionId: 'walk-1',
          startedAt: start,
          endedAt: start.add(const Duration(minutes: 2)),
          steps: 220,
          goalSteps: 1000,
          paceDropped: false,
        ),
      );
    });

    tearDown(() => PandoServices.walkSlices = walkSlicesFor);

    test('then the report call builds and stores the replay once', () async {
      await endpoints.futureCalls.sendReportNotification.send(
        walker,
        saved.id!,
      );
      final report = await endpoints.session.report(walker, saved.id!);
      expect(report.replayId, isNotNull);

      final replay = await endpoints.replay.get(stranger, report.replayId!);
      expect(replay, isNotNull);
      expect(replay!.segments.map((s) => s.gait), [
        Gait.walking,
        Gait.running,
        Gait.walking,
      ]);
      expect(replay.startPathM, saved.startPathM);
      expect(replay.endPathM, closeTo(saved.endPathM, 1e-9));
      expect(replay.durationS, 15);

      // Built once: the report and a second run don't rebuild it.
      await endpoints.futureCalls.sendReportNotification.send(
        walker,
        saved.id!,
      );
      final again = await endpoints.session.report(walker, saved.id!);
      expect(again.replayId, report.replayId);
      expect(reads, 1);
    });

    test('when the slices sync late then the report builds it', () async {
      synced = {};
      await endpoints.futureCalls.sendReportNotification.send(
        walker,
        saved.id!,
      );
      expect(
        (await endpoints.session.report(walker, saved.id!)).replayId,
        isNull,
      );

      synced = {
        'walk-1': [slice(0, 50)],
      };
      final report = await endpoints.session.report(walker, saved.id!);
      expect(report.replayId, isNotNull);
    });

    test('then an unknown replay id gives nothing', () async {
      expect(
        await endpoints.replay.get(stranger, const Uuid().v4obj()),
        isNull,
      );
    });

    test('when reading the slices fails then the report still works', () async {
      PandoServices.walkSlices =
          (session, {required authUserId, required clientSessionId}) =>
              throw StateError('sync broke');
      await endpoints.futureCalls.sendReportNotification.send(
        walker,
        saved.id!,
      );
      final report = await endpoints.session.report(walker, saved.id!);
      expect(report.replayId, isNull);
      expect(report.message, isNotEmpty);
    });
  });
}

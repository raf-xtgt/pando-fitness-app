import 'package:pando_server/src/generated/protocol.dart';
import 'package:pando_server/src/notifications/push_sender.dart';
import 'package:pando_server/src/pando_services.dart';
import 'package:test/test.dart';

import 'test_tools/serverpod_test_tools.dart';

/// Counts pushes instead of sending them.
class _FakePush implements PushSender {
  final sent = <Map<String, String>>[];

  @override
  Future<bool> send({
    required String token,
    required String title,
    required String body,
    required Map<String, String> data,
  }) async {
    sent.add({'token': token, ...data});
    return true;
  }
}

void main() {
  withServerpod('Given a walker who saved a session', (
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
    late _FakePush push;
    late ActivitySession first;
    late ActivitySession second;

    SessionInput input(String id, int steps, int hour) => SessionInput(
      clientSessionId: id,
      startedAt: DateTime.utc(2026, 10, 7, hour),
      endedAt: DateTime.utc(2026, 10, 7, hour, 15),
      steps: steps,
      goalSteps: 1000,
      feel: null,
      paceDropped: false,
    );

    setUp(() async {
      push = _FakePush();
      PandoServices.push = push;
      await endpoints.profile.saveHeight(walker, 1.70);
      await endpoints.profile.saveHeight(other, 1.60);
      first = await endpoints.session.save(walker, input('a', 1200, 8));
      second = await endpoints.session.save(walker, input('b', 400, 18));
    });

    test('then save stores a filled-in report message', () async {
      expect(first.reportMessage, contains('796 m'));
      expect(first.reportMessage, contains('133 m'));
      expect(second.reportMessage, isNot(contains('{')));
    });

    test('then the report totals every session up to it', () async {
      final report = await endpoints.session.report(walker, second.id!);
      expect(report.message, second.reportMessage);
      expect(report.goalMet, isFalse);
      expect(report.extraM, 0);
      expect(
        report.totalDistanceAllM,
        closeTo(first.distanceM + second.distanceM, 1e-6),
      );
    });

    test('then another user cannot read the report', () async {
      expect(
        () => endpoints.session.report(other, first.id!),
        throwsA(anything),
      );
    });

    test('when there is no push token then nothing is sent', () async {
      await endpoints.futureCalls.sendReportNotification.send(
        walker,
        first.id!,
      );
      expect(push.sent, isEmpty);
      final row = await endpoints.session.list(walker);
      expect(row.last.notificationSentAt, isNull);
    });

    test('when the call runs twice then the push is sent once', () async {
      await endpoints.profile.registerPushToken(walker, 'token-1');
      await endpoints.futureCalls.sendReportNotification.send(
        walker,
        first.id!,
      );
      await endpoints.futureCalls.sendReportNotification.send(
        walker,
        first.id!,
      );
      expect(push.sent, [
        {'token': 'token-1', 'sessionId': '${first.id}'},
      ]);
      final rows = await endpoints.session.list(walker);
      final sent = rows.firstWhere((s) => s.id == first.id);
      expect(sent.notificationSentAt, isNotNull);
    });
  });
}

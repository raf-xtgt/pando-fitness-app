import 'package:flutter_test/flutter_test.dart';
import 'package:pando_client/pando_client.dart';
import 'package:pando_flutter/services/api_client.dart';
import 'package:pando_flutter/services/pending_queue.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Records what reached "the server", in order, without a network.
class FakeApi extends ApiClient {
  FakeApi(this.calls);

  final List<String> calls;
  bool online = true;

  @override
  Future<ActivitySession> saveSession(SessionInput input) async {
    if (!online) throw Exception('no signal');
    calls.add('save ${input.clientSessionId}');
    return ActivitySession(
      profileId: 1,
      clientSessionId: input.clientSessionId,
      startedAt: input.startedAt,
      endedAt: input.endedAt,
      steps: input.steps,
      strideM: 0.7,
      distanceM: input.steps * 0.7,
      goalSteps: input.goalSteps,
      goalM: input.goalSteps * 0.7,
      goalMet: false,
      extraM: 0,
      stoppedEarly: true,
      paceDropped: input.paceDropped,
      startPathM: 0,
      endPathM: input.steps * 0.7,
      reportReadyAt: input.endedAt.add(const Duration(minutes: 5)),
    );
  }
}

void main() {
  late List<String> calls;
  late FakeApi api;
  late PendingQueue queue;
  var syncFails = 0;

  SessionInput walk(String id) => SessionInput(
    clientSessionId: id,
    startedAt: DateTime.utc(2026, 10, 9, 8),
    endedAt: DateTime.utc(2026, 10, 9, 8, 10),
    steps: 900,
    goalSteps: 1000,
    paceDropped: false,
  );

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    calls = [];
    api = FakeApi(calls);
    syncFails = 0;
    queue = PendingQueue(
      await SharedPreferences.getInstance(),
      api,
      syncWalks: () async {
        if (syncFails > 0) {
          syncFails--;
          throw Exception('sync failed');
        }
        calls.add('sync');
      },
    );
  });

  test('the walk slices sync before the session is saved', () async {
    await queue.enqueue(PendingQueue.saveSessionOp, walk('a').toJson());
    await queue.flush();
    expect(calls, ['sync', 'save a']);
    expect(queue.items, isEmpty);
  });

  test('a failed sync keeps the session waiting, unsaved', () async {
    syncFails = 1;
    await queue.enqueue(PendingQueue.saveSessionOp, walk('a').toJson());
    await queue.flush();
    expect(calls, isEmpty);
    expect(queue.pendingSessions.single.clientSessionId, 'a');

    await queue.flush();
    expect(calls, ['sync', 'save a']);
  });

  test('after repeated sync failures, the session is saved anyway', () async {
    syncFails = PendingQueue.maxSyncFailures;
    await queue.enqueue(PendingQueue.saveSessionOp, walk('a').toJson());
    for (var i = 0; i < PendingQueue.maxSyncFailures - 1; i++) {
      await queue.flush();
      expect(calls, isEmpty);
    }
    await queue.flush();
    expect(calls, ['save a']);
  });

  test('no signal: neither sync nor save goes through', () async {
    api.online = false;
    syncFails = 1;
    await queue.enqueue(PendingQueue.saveSessionOp, walk('a').toJson());
    await queue.flush();
    expect(calls, isEmpty);
    expect(queue.pendingSessions, hasLength(1));
  });
}

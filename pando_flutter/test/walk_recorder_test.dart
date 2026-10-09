import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:pando_client/pando_client.dart';
import 'package:pando_flutter/services/step_history.dart';
import 'package:pando_flutter/services/walk_recorder.dart';
import 'package:serverpod_database/serverpod_database.dart';

/// Returns the slices it was given, or throws when [unavailable].
class FakeStepHistory implements StepHistory {
  List<StepSlice> history = [];
  bool unavailable = false;

  @override
  Future<void> ensureRecording() async {}

  @override
  Future<List<StepSlice>> slices(
    DateTime from,
    DateTime to,
    Duration size,
  ) async {
    if (unavailable) throw const StepHistoryUnavailable('no Play services');
    return history;
  }
}

void main() {
  late Directory dir;
  late ClientDatabaseSession db;
  late FakeStepHistory history;
  late WalkRecorder recorder;

  final start = DateTime.utc(2026, 10, 9, 8);
  DateTime at(int seconds) => start.add(Duration(seconds: seconds));

  setUp(() async {
    dir = await Directory.systemTemp.createTemp('pando_db_test');
    // The real client-side database (SQLite file + generated migrations).
    db = await Client(
      'http://localhost:8080/',
    ).createSession('${dir.path}/pando.db', isDebugMode: true);
    history = FakeStepHistory();
    recorder = WalkRecorder(db, history);
  });

  tearDown(() async {
    await db.close();
    await dir.delete(recursive: true);
  });

  Future<void> beginWalk() => recorder.begin(
    clientSessionId: 'walk-1',
    startedAt: start,
    goalSteps: 1000,
    resumeMetres: 40.5,
  );

  test(
    'Start → Stop keeps the slices and clears the walk in progress',
    () async {
      await beginWalk();
      expect((await recorder.inProgress())?.clientSessionId, 'walk-1');

      history.history = [
        StepSlice(at(0), at(30), 50),
        StepSlice(at(30), at(60), 80),
        StepSlice(at(60), at(90), 45),
      ];
      final slices = await recorder.recordSlices('walk-1', start, at(90));
      await recorder.end('walk-1');

      expect(slices.map((s) => s.steps), [50, 80, 45]);
      expect(WalkRecorder.totalSteps(await recorder.slicesOf('walk-1')), 175);
      expect(await recorder.inProgress(), isNull);
    },
  );

  test('a leftover walk is found after a restart, with its plan', () async {
    await beginWalk();
    await recorder.setStartCount('walk-1', 12000);

    // Pando is killed: a new recorder over the same database file.
    final reopened = WalkRecorder(db, history);
    final leftover = await reopened.inProgress();
    expect(leftover, isNotNull);
    expect(leftover!.startedAt, start);
    expect(leftover.startCount, 12000);
    expect(leftover.goalSteps, 1000);
    expect(leftover.resumeMetres, 40.5);

    // Finish walk: steps come from the step history.
    history.history = [StepSlice(at(0), at(30), 40)];
    final slices = await reopened.recordSlices(
      'walk-1',
      leftover.startedAt,
      at(30),
    );
    await reopened.end('walk-1');
    expect(WalkRecorder.totalSteps(slices), 40);
    expect(await reopened.inProgress(), isNull);
  });

  test('reading the slices twice replaces them, never doubles them', () async {
    await beginWalk();
    history.history = [StepSlice(at(0), at(30), 50)];
    await recorder.recordSlices('walk-1', start, at(30));
    history.history = [
      StepSlice(at(0), at(30), 52),
      StepSlice(at(30), at(60), 10),
    ];
    await recorder.recordSlices('walk-1', start, at(60));

    expect((await recorder.slicesOf('walk-1')).map((s) => s.steps), [52, 10]);
  });

  test('no step history: throws and keeps nothing', () async {
    await beginWalk();
    history.unavailable = true;
    await expectLater(
      recorder.recordSlices('walk-1', start, at(30)),
      throwsA(isA<StepHistoryUnavailable>()),
    );
    expect(await recorder.slicesOf('walk-1'), isEmpty);
    expect(await recorder.inProgress(), isNotNull);
  });

  test('slices become a cumulative timeline for the passive signals', () {
    final timeline = WalkRecorder.timeline(start, [
      WalkSlice(clientSessionId: 'w', startAt: at(0), endAt: at(30), steps: 50),
      WalkSlice(clientSessionId: 'w', startAt: at(30), endAt: at(60), steps: 0),
      WalkSlice(
        clientSessionId: 'w',
        startAt: at(60),
        endAt: at(90),
        steps: 20,
      ),
    ]);
    expect(timeline.map((s) => s.steps), [0, 50, 50, 70]);
    expect(timeline.first.time, start);
    expect(timeline.last.time, at(90));
  });
}

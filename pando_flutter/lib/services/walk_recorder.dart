import 'package:flutter/foundation.dart';
import 'package:pando_client/pando_client.dart';
import 'package:pando_shared/pando_shared.dart';
import 'package:serverpod_database/serverpod_database.dart';

import '../domain/gait_detector.dart';
import 'step_history.dart';

/// Keeps the walk in Pando's on-phone database, so it survives the app being
/// killed:
/// - Start: a [WalkInProgress] row.
/// - Stop: the walk's 30 s [WalkSlice]s, read from the [StepHistory].
/// - Saved (session queued for the server): the [WalkInProgress] row goes.
///
/// A [WalkInProgress] row found at app start means Pando was killed
/// mid-walk; Home offers **Finish walk**.
class WalkRecorder {
  WalkRecorder(this._openDb, this._history);

  static const Duration sliceSize = Duration(seconds: 30);

  /// The on-phone database, opened on first use (see `LocalDb`).
  final Future<DatabaseSession> Function() _openDb;
  final StepHistory _history;

  Future<void> begin({
    required String clientSessionId,
    required DateTime startedAt,
    required int goalSteps,
    required double resumeMetres,
  }) async {
    await WalkInProgress.db.insertRow(
      await _openDb(),
      WalkInProgress(
        clientSessionId: clientSessionId,
        startedAt: startedAt.toUtc(),
        goalSteps: goalSteps,
        resumeMetres: resumeMetres,
      ),
    );
  }

  /// The step counter's value at Start, known after the first sensor event.
  Future<void> setStartCount(String clientSessionId, int count) async {
    final row = await _find(clientSessionId);
    if (row == null) return;
    await WalkInProgress.db.updateRow(
      await _openDb(),
      row.copyWith(startCount: count),
    );
  }

  /// The walk Pando was killed in the middle of, if any.
  Future<WalkInProgress?> inProgress() async => WalkInProgress.db.findFirstRow(
    await _openDb(),
    orderBy: (t) => t.startedAt,
  );

  /// Reads the walk from the step history and keeps it as [WalkSlice] rows,
  /// replacing any kept before (so a retried Finish walk is safe). Returns
  /// the slices; throws [StepHistoryUnavailable] if the history can't be
  /// read, and keeps nothing then.
  Future<List<WalkSlice>> recordSlices(
    String clientSessionId,
    DateTime startedAt,
    DateTime endedAt,
  ) async {
    final history = await _history.slices(startedAt, endedAt, sliceSize);
    final slices = [
      for (final s in history)
        WalkSlice(
          clientSessionId: clientSessionId,
          startAt: s.startAt.toUtc(),
          endAt: s.endAt.toUtc(),
          steps: s.steps,
        ),
    ];
    final db = await _openDb();
    await db.db.transaction((transaction) async {
      await WalkSlice.db.deleteWhere(
        db,
        where: (t) => t.clientSessionId.equals(clientSessionId),
        transaction: transaction,
      );
      if (slices.isNotEmpty) {
        await WalkSlice.db.insert(db, slices, transaction: transaction);
      }
    });
    debugPrint(
      'Pando walk: ${slices.length} slices, '
      '${totalSteps(slices)} steps from the step history',
    );
    for (final s in slices) {
      debugPrint(
        'Pando walk slice: ${s.startAt.toLocal()}–${s.endAt.toLocal()} '
        '${s.steps} steps',
      );
    }
    return slices;
  }

  /// The kept slices of a walk, oldest first.
  Future<List<WalkSlice>> slicesOf(String clientSessionId) async =>
      WalkSlice.db.find(
        await _openDb(),
        where: (t) => t.clientSessionId.equals(clientSessionId),
        orderBy: (t) => t.startAt,
      );

  /// The session is safely queued for the server; the walk is no longer in
  /// progress. The slices stay; offline sync sends them before the session
  /// is saved (see `PendingQueue`).
  Future<void> end(String clientSessionId) async {
    await WalkInProgress.db.deleteWhere(
      await _openDb(),
      where: (t) => t.clientSessionId.equals(clientSessionId),
    );
  }

  Future<WalkInProgress?> _find(String clientSessionId) async =>
      WalkInProgress.db.findFirstRow(
        await _openDb(),
        where: (t) => t.clientSessionId.equals(clientSessionId),
      );

  static int totalSteps(Iterable<WalkSlice> slices) =>
      slices.fold(0, (sum, s) => sum + s.steps);

  /// The slices as a cumulative step timeline from [startedAt], like the
  /// live counter's, for the passive signals.
  static List<StepSample> timeline(
    DateTime startedAt,
    Iterable<WalkSlice> slices,
  ) {
    var steps = 0;
    return [
      StepSample(startedAt, 0),
      for (final s in slices) StepSample(s.endAt, steps += s.steps),
    ];
  }
}

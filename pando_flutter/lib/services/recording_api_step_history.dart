import 'package:flutter/services.dart';

import 'step_history.dart';

/// Android's Recording API, through the `pando/step_history` channel in
/// `MainActivity.kt`. On-device only: no Google account, kept ~10 days.
class RecordingApiStepHistory implements StepHistory {
  static const _channel = MethodChannel('pando/step_history');

  @override
  Future<void> ensureRecording() async {
    try {
      await _channel.invokeMethod<void>('ensureRecording');
    } on PlatformException catch (e) {
      throw StepHistoryUnavailable('${e.code}: ${e.message}');
    }
  }

  @override
  Future<List<StepSlice>> slices(
    DateTime from,
    DateTime to,
    Duration size,
  ) async {
    final List<Object?> raw;
    try {
      raw =
          await _channel.invokeListMethod<Object?>('slices', {
            'fromMs': from.millisecondsSinceEpoch,
            'toMs': to.millisecondsSinceEpoch,
            'sizeS': size.inSeconds,
          }) ??
          const [];
    } on PlatformException catch (e) {
      throw StepHistoryUnavailable('${e.code}: ${e.message}');
    }
    return [
      for (final item in raw.cast<Map<Object?, Object?>>())
        StepSlice(
          DateTime.fromMillisecondsSinceEpoch(item['startMs']! as int),
          DateTime.fromMillisecondsSinceEpoch(item['endMs']! as int),
          item['steps']! as int,
        ),
    ]..sort((a, b) => a.startAt.compareTo(b.startAt));
  }
}

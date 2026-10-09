/// The phone's own record of steps over time, kept by the OS even while
/// Pando is closed or the screen is off. The live map uses the step counter;
/// the replay uses this. Android: `RecordingApiStepHistory`. iOS (Core
/// Motion) comes with iOS support.
library;

/// Steps taken between [startAt] and [endAt].
class StepSlice {
  const StepSlice(this.startAt, this.endAt, this.steps);

  final DateTime startAt;
  final DateTime endAt;
  final int steps;

  @override
  String toString() =>
      '${startAt.toIso8601String()}–${endAt.toIso8601String()}: $steps';
}

/// The step history can't be used on this phone (e.g. no Google Play
/// services), or reading it failed.
class StepHistoryUnavailable implements Exception {
  const StepHistoryUnavailable(this.message);

  final String message;

  @override
  String toString() => 'StepHistoryUnavailable: $message';
}

abstract interface class StepHistory {
  /// Asks the OS to start keeping steps. History exists only from the first
  /// call, so this runs right after the activity permission is granted.
  /// Safe to call again. Throws [StepHistoryUnavailable].
  Future<void> ensureRecording();

  /// Steps between [from] and [to] in buckets of [size], oldest first.
  /// Buckets with no steps may be missing. Throws [StepHistoryUnavailable].
  Future<List<StepSlice>> slices(DateTime from, DateTime to, Duration size);
}

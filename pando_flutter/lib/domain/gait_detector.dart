/// Pure Dart: decides whether the walker is standing, walking or running
/// from the step timeline. Thresholds are constants, tuned in testing.
library;

enum Gait { standing, walking, running }

/// Cumulative steps for this session at a point in time.
class StepSample {
  const StepSample(this.time, this.steps);

  final DateTime time;
  final int steps;
}

class GaitDetector {
  const GaitDetector({
    this.cadenceWindow = const Duration(seconds: 10),
    this.standingWindow = const Duration(seconds: 3),
    this.runningStepsPerMinute = 140,
  });

  /// Cadence is averaged over this window.
  final Duration cadenceWindow;

  /// Fewer than one step in this window means standing.
  final Duration standingWindow;

  /// At or above this cadence the runner runs.
  final double runningStepsPerMinute;

  /// [timeline] is in time order and starts with the session start sample
  /// (0 steps). Returns [Gait.standing] for an empty timeline.
  Gait classify(List<StepSample> timeline, DateTime now) {
    if (timeline.isEmpty) return Gait.standing;

    final stepsNow = _stepsAt(timeline, now);
    if (stepsNow - _stepsAt(timeline, now.subtract(standingWindow)) < 1) {
      return Gait.standing;
    }

    return cadence(timeline, now) >= runningStepsPerMinute
        ? Gait.running
        : Gait.walking;
  }

  /// Steps per minute over the last [cadenceWindow] (or since the session
  /// started, if that's shorter).
  double cadence(List<StepSample> timeline, DateTime now) {
    if (timeline.isEmpty) return 0;
    var windowStart = now.subtract(cadenceWindow);
    if (windowStart.isBefore(timeline.first.time)) {
      windowStart = timeline.first.time;
    }
    final seconds = now.difference(windowStart).inMilliseconds / 1000;
    if (seconds <= 0) return 0;
    final steps = _stepsAt(timeline, now) - _stepsAt(timeline, windowStart);
    return steps / seconds * 60;
  }

  /// The step count known at [time]: the last sample at or before it.
  static int _stepsAt(List<StepSample> timeline, DateTime time) {
    var steps = 0;
    for (final sample in timeline) {
      if (sample.time.isAfter(time)) break;
      steps = sample.steps;
    }
    return steps;
  }
}

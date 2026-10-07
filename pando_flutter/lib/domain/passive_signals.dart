/// Pure Dart: what the step timeline says about how a session went, without
/// asking the walker. Computed at Stop and sent to the server.
library;

import 'gait_detector.dart';

class PassiveSignals {
  const PassiveSignals({required this.stoppedEarly, required this.paceDropped});

  /// Shorter sessions don't say much about pace.
  static const Duration minimumForPace = Duration(minutes: 2);

  /// The "end" of a session is its last fifth...
  static const double finalFraction = 0.2;

  /// ...and the pace dropped if the end was slower than this share of the
  /// session's average cadence.
  static const double dropRatio = 0.8;

  /// The goal wasn't reached.
  final bool stoppedEarly;

  /// The walker slowed down noticeably near the end.
  final bool paceDropped;

  /// [timeline] starts with the session start sample (0 steps).
  factory PassiveSignals.compute({
    required List<StepSample> timeline,
    required DateTime endedAt,
    required bool goalMet,
  }) {
    return PassiveSignals(
      stoppedEarly: !goalMet,
      paceDropped: _paceDropped(timeline, endedAt),
    );
  }

  static bool _paceDropped(List<StepSample> timeline, DateTime endedAt) {
    if (timeline.isEmpty) return false;
    final duration = endedAt.difference(timeline.first.time);
    if (duration < minimumForPace) return false;

    final total = stepsAt(timeline, endedAt);
    if (total <= 0) return false;
    final averagePerMs = total / duration.inMilliseconds;

    final finalWindow = duration * finalFraction;
    final finalSteps = total - stepsAt(timeline, endedAt.subtract(finalWindow));
    final finalPerMs = finalSteps / finalWindow.inMilliseconds;

    return finalPerMs < averagePerMs * dropRatio;
  }
}

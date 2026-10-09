import 'generated/protocol.dart';

/// The cadence limits for standing, walking and running. One place, so the
/// live map (`GaitDetector` in the app) and the replay classify the same way.
/// Tuned in testing.
abstract final class GaitRules {
  /// At or above this cadence (steps per minute) the walker runs. 130, not
  /// 140: an indoor jog at ~132/min should count as running (learner,
  /// 2026-10-09); re-check after the park test.
  static const double runningStepsPerMinute = 130;

  /// Fewer than one step in this window means standing.
  static const Duration standingWindow = Duration(seconds: 3);

  /// The same limit as a cadence: one step per [standingWindow].
  static double get standingStepsPerMinute =>
      60 / (standingWindow.inMilliseconds / 1000);

  /// The gait for a cadence measured over a window.
  static Gait fromCadence(double stepsPerMinute) {
    if (stepsPerMinute < standingStepsPerMinute) return Gait.standing;
    if (stepsPerMinute >= runningStepsPerMinute) return Gait.running;
    return Gait.walking;
  }

  /// The gait for [steps] taken over [duration] (e.g. one 30 s walk slice).
  static Gait fromSteps(int steps, Duration duration) {
    final minutes = duration.inMilliseconds / 60000;
    if (minutes <= 0) return Gait.standing;
    return fromCadence(steps / minutes);
  }
}

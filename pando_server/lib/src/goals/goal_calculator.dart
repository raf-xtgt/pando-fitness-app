import 'dart:math' as math;

/// How much a new goal grows over the baseline: the larger of a percentage
/// and a fixed number of steps. Only [easy] is used in the PoC.
enum Difficulty {
  easy(0.02, 100),
  moderate(0.05, 250),
  highEffort(0.10, 500);

  const Difficulty(this.fraction, this.minimumSteps);

  final double fraction;
  final int minimumSteps;

  double increaseOver(double baseline) =>
      math.max(baseline * fraction, minimumSteps.toDouble());
}

/// Pure Dart goal rules. Goals are kept in steps and shown in metres.
abstract final class GoalCalculator {
  static const double strideFactor = 0.415;
  static const int firstGoalSteps = 1000;

  /// How many recent sessions make the baseline.
  static const int baselineSessions = 3;

  static double strideM(double heightM) => heightM * strideFactor;

  /// [recentSteps] are the step counts of past sessions, newest first.
  /// No history → [firstGoalSteps]. Otherwise the average of the last
  /// [baselineSessions] (or fewer) plus the [difficulty] increase, but never
  /// below [firstGoalSteps], so a few short walks can't shrink the goal.
  static int goalSteps(
    List<int> recentSteps, {
    Difficulty difficulty = Difficulty.easy,
  }) {
    if (recentSteps.isEmpty) return firstGoalSteps;
    final recent = recentSteps.take(baselineSessions).toList();
    final baseline = recent.reduce((a, b) => a + b) / recent.length;
    final goal = (baseline + difficulty.increaseOver(baseline)).round();
    return math.max(firstGoalSteps, goal);
  }
}

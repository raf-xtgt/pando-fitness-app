/// App-wide settings. Build-time values come from `--dart-define`.
abstract final class AppConfig {
  /// The Serverpod server, e.g. `--dart-define=SERVER_URL=http://192.168.1.5:8080/`.
  static const String serverUrl = String.fromEnvironment('SERVER_URL');

  /// Demo builds (`--dart-define=DEMO=true`) can seed past sessions.
  static const bool isDemo = bool.fromEnvironment('DEMO');

  /// Testing only (`--dart-define=TEST_GOAL_STEPS=30`): replaces the goal,
  /// so going past it and the celebration can be tried indoors. 0 = off.
  static const int testGoalSteps = int.fromEnvironment('TEST_GOAL_STEPS');

  /// Used until the user's real height is known.
  static const double defaultHeightMetres = 1.70;

  /// Stride length = height × this.
  static const double strideFactor = 0.415;

  /// The first goal is this many steps.
  static const int firstGoalSteps = 1000;

  static double strideMetres(double heightMetres) =>
      heightMetres * strideFactor;

  static double firstGoalMetres(double heightMetres) =>
      firstGoalSteps * strideMetres(heightMetres);
}

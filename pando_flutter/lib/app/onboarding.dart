import 'package:flutter/widgets.dart';

import '../features/home/home_screen.dart';
import '../features/onboarding/height_screen.dart';
import '../features/safety/safety_check_screen.dart';
import '../services/local_cache.dart';

/// Where onboarding is: height first, then the safety check, then Home.
/// Each is asked once; a walker who onboarded before the safety check
/// existed gets it once on the next launch.
enum OnboardingStep { height, safetyCheck, done }

OnboardingStep nextOnboardingStep({
  required bool hasHeight,
  required bool hasScreening,
}) {
  if (!hasHeight) return OnboardingStep.height;
  if (!hasScreening) return OnboardingStep.safetyCheck;
  return OnboardingStep.done;
}

/// The screen for the next step, from what the phone has cached.
Widget nextOnboardingScreen(LocalCache cache) => switch (nextOnboardingStep(
  hasHeight: cache.heightMetres != null,
  hasScreening: cache.screening != null,
)) {
  OnboardingStep.height => const HeightScreen(),
  OnboardingStep.safetyCheck => const SafetyCheckScreen(),
  OnboardingStep.done => const HomeScreen(),
};

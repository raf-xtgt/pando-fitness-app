import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pando_flutter/app/onboarding.dart';
import 'package:pando_flutter/features/safety/safety_check_screen.dart';

void main() {
  group('onboarding order', () {
    test('no height → Height first', () {
      expect(
        nextOnboardingStep(hasHeight: false, hasScreening: false),
        OnboardingStep.height,
      );
    });

    test('height but no safety check → the check (once, also for walkers '
        'who onboarded before it existed)', () {
      expect(
        nextOnboardingStep(hasHeight: true, hasScreening: false),
        OnboardingStep.safetyCheck,
      );
    });

    test('both done → Home', () {
      expect(
        nextOnboardingStep(hasHeight: true, hasScreening: true),
        OnboardingStep.done,
      );
    });
  });

  group('safety check screen', () {
    var opened = 0;

    Future<void> pump(WidgetTester tester) async {
      opened = 0;
      await tester.pumpWidget(
        MaterialApp(
          home: SafetyCheckScreen(openForm: () async => opened++),
        ),
      );
    }

    /// The answer buttons are inert until the box is ticked.
    bool answerEnabled(WidgetTester tester, String label) =>
        tester
            .widget<GestureDetector>(
              find
                  .ancestor(
                    of: find.text(label),
                    matching: find.byType(GestureDetector),
                  )
                  .first,
            )
            .onTap !=
        null;

    testWidgets('the answers wait for the confirmation box', (tester) async {
      await pump(tester);
      expect(answerEnabled(tester, 'None apply'), isFalse);
      expect(answerEnabled(tester, 'Yes, some apply'), isFalse);

      await tester.tap(find.byType(Checkbox));
      await tester.pump();
      expect(answerEnabled(tester, 'None apply'), isTrue);
      expect(answerEnabled(tester, 'Yes, some apply'), isTrue);
    });

    testWidgets('the button opens the official PAR-Q+', (tester) async {
      await pump(tester);
      await tester.tap(find.text('Open the PAR-Q+'));
      await tester.pump();
      expect(opened, 1);
      expect(SafetyCheckScreen.officialForm.host, 'eparmedx.com');
    });

    testWidgets('no PAR-Q+ question is shown in the app', (tester) async {
      await pump(tester);
      expect(find.textContaining('heart condition'), findsNothing);
      expect(find.textContaining('chest'), findsNothing);
    });
  });
}

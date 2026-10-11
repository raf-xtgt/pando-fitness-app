import 'package:pando_server/src/goals/goal_calculator.dart';
import 'package:test/test.dart';

void main() {
  group('Given the goal calculator', () {
    test('when there is no history then the goal is 1,000 steps', () {
      expect(GoalCalculator.goalSteps([]), 1000);
    });

    test('when height is 1.75 m then the first goal is about 680 m', () {
      final metres =
          GoalCalculator.goalSteps([]) * GoalCalculator.strideM(1.75);
      expect(metres, closeTo(682.5, 0.01));
    });

    test(
      'when there are fewer than 3 sessions then all of them are averaged',
      () {
        // Baseline 1,500; 2% = 30 < 100, so +100.
        expect(GoalCalculator.goalSteps([1000, 2000]), 1600);
      },
    );

    test(
      'when there are more than 3 sessions then only the newest 3 count',
      () {
        // Newest first: (3000 + 3000 + 3000) / 3 = 3000; ignores 100.
        expect(GoalCalculator.goalSteps([3000, 3000, 3000, 100]), 3100);
      },
    );

    test('when 2% is more than 100 steps then the goal grows by 2%', () {
      // Baseline 10,000; 2% = 200 > 100.
      expect(GoalCalculator.goalSteps([10000, 10000, 10000]), 10200);
    });

    test('when recent walks were short then the goal stays at 1,000', () {
      expect(GoalCalculator.goalSteps([0, 0, 0]), 1000);
      expect(GoalCalculator.goalSteps([24, 17, 18]), 1000);
      // Baseline 950 + 100 = 1,050: above the floor, so it counts.
      expect(GoalCalculator.goalSteps([950]), 1050);
    });

    test('when difficulty is moderate then the increase is max(5%, 250)', () {
      expect(
        GoalCalculator.goalSteps([1000], difficulty: Difficulty.moderate),
        1250,
      );
    });
  });
}

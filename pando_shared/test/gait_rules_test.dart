import 'package:pando_shared/pando_shared.dart';
import 'package:test/test.dart';

void main() {
  const slice = Duration(seconds: 30);

  test('cadence limits: standing below 20/min, running from 140/min', () {
    expect(GaitRules.standingStepsPerMinute, 20);
    expect(GaitRules.fromCadence(0), Gait.standing);
    expect(GaitRules.fromCadence(19.9), Gait.standing);
    expect(GaitRules.fromCadence(20), Gait.walking);
    expect(GaitRules.fromCadence(139.9), Gait.walking);
    expect(GaitRules.fromCadence(140), Gait.running);
  });

  test('30 s slices from the walk → jog → walk phone test', () {
    expect(GaitRules.fromSteps(50, slice), Gait.walking); // 100/min
    expect(GaitRules.fromSteps(66, slice), Gait.walking); // 132/min
    expect(GaitRules.fromSteps(73, slice), Gait.running); // 146/min
    expect(GaitRules.fromSteps(0, slice), Gait.standing);
    expect(GaitRules.fromSteps(5, Duration.zero), Gait.standing);
  });
}

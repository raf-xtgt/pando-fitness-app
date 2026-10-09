import 'package:flutter_test/flutter_test.dart';
import 'package:pando_flutter/domain/gait_detector.dart';

void main() {
  const detector = GaitDetector();
  final start = DateTime(2026, 10, 7, 18);

  /// A timeline with one sample per second at [stepsPerMinute], for
  /// [seconds] seconds.
  List<StepSample> steady(double stepsPerMinute, int seconds) => [
    for (var s = 0; s <= seconds; s++)
      StepSample(
        start.add(Duration(seconds: s)),
        (stepsPerMinute / 60 * s).floor(),
      ),
  ];

  test('an empty timeline is standing', () {
    expect(detector.classify([], start), Gait.standing);
  });

  test('no steps since start is standing', () {
    final timeline = [StepSample(start, 0)];
    expect(
      detector.classify(timeline, start.add(const Duration(seconds: 5))),
      Gait.standing,
    );
  });

  test('a normal walking cadence is walking', () {
    final timeline = steady(100, 20);
    expect(
      detector.classify(timeline, start.add(const Duration(seconds: 20))),
      Gait.walking,
    );
  });

  test('130 steps per minute or more is running', () {
    final timeline = steady(160, 20);
    expect(
      detector.classify(timeline, start.add(const Duration(seconds: 20))),
      Gait.running,
    );
  });

  test('no step for 3 seconds after walking is standing', () {
    final timeline = steady(100, 20);
    expect(
      detector.classify(timeline, start.add(const Duration(seconds: 24))),
      Gait.standing,
    );
  });

  test('cadence uses only the last 10 seconds', () {
    // Ran for 20 s, then walked for 20 s: the window sees only the walk.
    final ran = steady(160, 20);
    final walked = [
      for (var s = 1; s <= 20; s++)
        StepSample(
          start.add(Duration(seconds: 20 + s)),
          ran.last.steps + (100 / 60 * s).floor(),
        ),
    ];
    final now = start.add(const Duration(seconds: 40));
    expect(detector.cadence([...ran, ...walked], now), closeTo(100, 10));
    expect(detector.classify([...ran, ...walked], now), Gait.walking);
  });

  test('bursty sensor events still count as walking', () {
    // The sensor often reports a few steps at once, every couple of seconds.
    final timeline = [
      StepSample(start, 0),
      for (var i = 1; i <= 10; i++)
        StepSample(start.add(Duration(seconds: 2 * i)), 3 * i),
    ];
    expect(
      detector.classify(timeline, start.add(const Duration(seconds: 21))),
      Gait.walking,
    );
  });
}

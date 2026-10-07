import 'package:flutter_test/flutter_test.dart';
import 'package:pando_flutter/domain/gait_detector.dart';
import 'package:pando_flutter/domain/passive_signals.dart';

void main() {
  final start = DateTime(2026, 10, 7, 18);

  /// One sample per 10 s; [stepsPer10s] gives the steps in each slot.
  List<StepSample> timeline(List<int> stepsPer10s) {
    var total = 0;
    return [
      StepSample(start, 0),
      for (var i = 0; i < stepsPer10s.length; i++)
        StepSample(
          start.add(Duration(seconds: 10 * (i + 1))),
          total += stepsPer10s[i],
        ),
    ];
  }

  DateTime endOf(List<int> slots) =>
      start.add(Duration(seconds: 10 * slots.length));

  test('stoppedEarly is the opposite of goalMet', () {
    final t = timeline([10, 10]);
    expect(
      PassiveSignals.compute(
        timeline: t,
        endedAt: endOf([10, 10]),
        goalMet: true,
      ).stoppedEarly,
      isFalse,
    );
    expect(
      PassiveSignals.compute(
        timeline: t,
        endedAt: endOf([10, 10]),
        goalMet: false,
      ).stoppedEarly,
      isTrue,
    );
  });

  test('a steady pace has not dropped', () {
    final slots = List.filled(30, 15); // 5 minutes at 90 steps/min
    final s = PassiveSignals.compute(
      timeline: timeline(slots),
      endedAt: endOf(slots),
      goalMet: true,
    );
    expect(s.paceDropped, isFalse);
  });

  test('a much slower final fifth means the pace dropped', () {
    // 4 minutes at 90/min, then 1 minute at 30/min.
    final slots = [...List.filled(24, 15), ...List.filled(6, 5)];
    final s = PassiveSignals.compute(
      timeline: timeline(slots),
      endedAt: endOf(slots),
      goalMet: false,
    );
    expect(s.paceDropped, isTrue);
  });

  test('sessions under 2 minutes never count as a pace drop', () {
    final slots = [15, 15, 15, 15, 15, 15, 15, 15, 0, 0, 0];
    final s = PassiveSignals.compute(
      timeline: timeline(slots),
      endedAt: endOf(slots),
      goalMet: false,
    );
    expect(s.paceDropped, isFalse);
  });

  test('a session with no steps has no pace drop', () {
    final slots = List.filled(30, 0);
    final s = PassiveSignals.compute(
      timeline: timeline(slots),
      endedAt: endOf(slots),
      goalMet: false,
    );
    expect(s.paceDropped, isFalse);
  });
}

import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/foundation.dart';
import 'package:pedometer/pedometer.dart';
import 'package:permission_handler/permission_handler.dart';

import '../domain/gait_detector.dart';

/// Asks for Android's "physical activity" permission, needed for the step
/// counter. Returns whether it was granted.
Future<bool> requestStepPermission() async {
  final status = await Permission.activityRecognition.request();
  return status.isGranted;
}

/// Wraps the phone's step counter. The sensor reports steps since the phone
/// booted, so the count at Start is the baseline. If the screen turns off
/// the stream pauses, but the cumulative count catches up on resume.
class StepCounterService {
  final _steps = StreamController<int>.broadcast();
  final List<StepSample> _timeline = [];
  StreamSubscription<StepCount>? _subscription;
  int? _baseline;

  /// Steps taken since [start].
  int stepsSoFar = 0;

  /// `(time, steps)` samples since [start], starting with `(start, 0)`.
  List<StepSample> get timeline => List.unmodifiable(_timeline);

  /// Emits [stepsSoFar] whenever it changes.
  Stream<int> get steps => _steps.stream;

  void start() {
    _timeline
      ..clear()
      ..add(StepSample(DateTime.now(), 0));
    stepsSoFar = 0;
    _baseline = null;
    _subscription = Pedometer.stepCountStream.listen(
      _onCount,
      onError: (Object e) => debugPrint('Pando steps: sensor error $e'),
    );
  }

  void _onCount(StepCount event) {
    _baseline ??= event.steps;
    final steps = math.max(0, event.steps - _baseline!);
    debugPrint('Pando steps: sensor=${event.steps} session=$steps');
    if (steps == stepsSoFar) return;
    stepsSoFar = steps;
    _timeline.add(StepSample(DateTime.now(), steps));
    _steps.add(steps);
  }

  Future<void> dispose() async {
    await _subscription?.cancel();
    await _steps.close();
  }
}

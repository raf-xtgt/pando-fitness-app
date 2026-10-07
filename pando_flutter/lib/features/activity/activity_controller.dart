import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/foundation.dart';

import '../../domain/gait_detector.dart';
import '../../services/step_counter_service.dart';

/// Where the activity is. Later slices add stopped → celebrating → asking
/// → saving → done.
enum ActivityState { ready, moving, standing }

/// Turns step events into distance and gait for the Activity screen.
class ActivityController extends ChangeNotifier {
  ActivityController({
    required this.strideMetres,
    required this.goalMetres,
    StepCounterService? steps,
    this.gaitDetector = const GaitDetector(),
  }) : _steps = steps ?? StepCounterService();

  /// How often gait is re-checked, so standing still is noticed even when
  /// no step events arrive.
  static const Duration gaitTick = Duration(milliseconds: 500);

  final double strideMetres;
  final double goalMetres;
  final GaitDetector gaitDetector;
  final StepCounterService _steps;

  StreamSubscription<int>? _stepSub;
  Timer? _ticker;
  int _lastNotifiedSteps = 0;

  ActivityState state = ActivityState.ready;
  Gait gait = Gait.standing;

  int get steps => _steps.stepsSoFar;

  /// Distance covered this session.
  double get metres => steps * strideMetres;

  /// Never below zero; going past the goal is shown differently (slice 5).
  double get remainingMetres => math.max(0, goalMetres - metres);

  void start() {
    _steps.start();
    _stepSub = _steps.steps.listen((_) => _evaluate());
    _ticker = Timer.periodic(gaitTick, (_) => _evaluate());
  }

  void _evaluate() {
    final newGait = gaitDetector.classify(_steps.timeline, DateTime.now());
    final newState = switch ((state, newGait)) {
      (ActivityState.ready, Gait.standing) => ActivityState.ready,
      (_, Gait.standing) => ActivityState.standing,
      _ => ActivityState.moving,
    };
    if (newGait == gait && newState == state && steps == _lastNotifiedSteps) {
      return;
    }
    gait = newGait;
    state = newState;
    _lastNotifiedSteps = steps;
    notifyListeners();
  }

  @override
  void dispose() {
    _ticker?.cancel();
    _stepSub?.cancel();
    _steps.dispose();
    super.dispose();
  }
}

import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/foundation.dart';

import '../../domain/gait_detector.dart';
import '../../domain/passive_signals.dart';
import '../../services/step_counter_service.dart';

/// Where the activity is:
/// `ready → moving ↔ standing → celebrating? → asking → done`.
/// `celebrating` only happens when the goal was met.
enum ActivityState {
  ready,
  moving,
  standing,
  celebrating,
  asking,
  done;

  /// Still counting steps.
  bool get isLive => index <= standing.index;
}

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

  late final DateTime startedAt;
  DateTime? endedAt;
  PassiveSignals? signals;

  /// Set when finishing a walk Pando was killed in (from the step history).
  int? _recoveredSteps;

  int get steps => _recoveredSteps ?? _steps.stepsSoFar;

  /// The step counter's value at Start (steps since boot).
  Future<int> get startCount => _steps.baseline;

  /// Distance covered this session.
  double get metres => steps * strideMetres;

  /// Never below zero; past the goal, [extraMetres] counts up instead.
  double get remainingMetres => math.max(0, goalMetres - metres);

  double get extraMetres => math.max(0, metres - goalMetres);

  bool get goalMet => metres >= goalMetres;

  void start() {
    startedAt = DateTime.now();
    _steps.start();
    _stepSub = _steps.steps.listen((_) => _evaluate());
    _ticker = Timer.periodic(gaitTick, (_) => _evaluate());
  }

  /// Ends step counting and works out the passive signals. A met goal
  /// gets the celebration first; [celebrationDone] then asks the question.
  void stop() {
    if (!state.isLive) return;
    _ticker?.cancel();
    _stepSub?.cancel();
    endedAt = DateTime.now();
    signals = PassiveSignals.compute(
      timeline: _steps.timeline,
      endedAt: endedAt!,
      goalMet: goalMet,
    );
    gait = Gait.standing;
    state = goalMet ? ActivityState.celebrating : ActivityState.asking;
    notifyListeners();
  }

  /// Finish walk: Pando was killed mid-walk, so the steps come from the
  /// step history instead of the live counter. Goes straight to the same
  /// states as [stop].
  void stopRecovered({
    required DateTime startedAt,
    required DateTime endedAt,
    required List<StepSample> timeline,
  }) {
    if (state != ActivityState.ready) return;
    this.startedAt = startedAt;
    this.endedAt = endedAt;
    _recoveredSteps = timeline.isEmpty ? 0 : timeline.last.steps;
    signals = PassiveSignals.compute(
      timeline: timeline,
      endedAt: endedAt,
      goalMet: goalMet,
    );
    state = goalMet ? ActivityState.celebrating : ActivityState.asking;
    notifyListeners();
  }

  void celebrationDone() {
    if (state != ActivityState.celebrating) return;
    state = ActivityState.asking;
    notifyListeners();
  }

  /// The feel question was answered or skipped.
  void finish() {
    state = ActivityState.done;
    notifyListeners();
  }

  void _evaluate() {
    if (!state.isLive) return;
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

import 'dart:async';

import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:pando_client/pando_client.dart';
import 'package:pando_shared/pando_shared.dart';

import '../../app/theme.dart';
import '../../domain/gait_detector.dart';
import '../../game/asset_manifest.dart';
import '../../game/park_game.dart';
import '../../services/app_services.dart';
import '../../services/pending_queue.dart';
import '../../services/step_counter_service.dart';
import '../../services/step_history.dart';
import '../../services/walk_recorder.dart';
import '../celebration/celebration_overlay.dart';
import 'activity_controller.dart';
import 'distance_display.dart';
import 'feel_question.dart';
import 'fire_text.dart';
import 'mascot_bubble.dart';

/// The park map with Flutter overlays on top. Owns the [ActivityController]
/// and tells the game what to show; the game never sees steps.
///
/// With [recovered], this is **Finish walk**: Pando was killed mid-walk, so
/// the screen skips live counting and goes straight to the Stop flow with
/// the steps from the step history.
class ActivityScreen extends StatefulWidget {
  const ActivityScreen({super.key, required this.plan, this.recovered});

  /// Goal, stride, resume point and signs, from the server (or its cache).
  final ActivityPlan plan;

  /// The walk left in the on-phone database when Pando was killed.
  final WalkInProgress? recovered;

  @override
  State<ActivityScreen> createState() => _ActivityScreenState();
}

class _ActivityScreenState extends State<ActivityScreen> {
  late final ActivityController _controller;
  late final ParkGame _game;

  final _services = AppServices.instance;

  /// Made on the phone, so a retried save is recognised by the server.
  late final String _clientSessionId =
      widget.recovered?.clientSessionId ?? const Uuid().v4();

  /// The walk's row in the on-phone database is written.
  Future<void> _recordingStarted = Future.value();

  /// The walk's slices are read from the step history and kept.
  Future<void> _slicesKept = Future.value();

  ActivityPlan get _plan => widget.plan;

  @override
  void initState() {
    super.initState();
    _game = ParkGame(
      resumeMetres: _plan.resumeMetres,
      signMetres: _plan.signMetres,
    );
    _controller = ActivityController(
      strideMetres: _plan.strideM,
      goalMetres: _plan.goalM,
    )..addListener(_onActivityChanged);
    if (widget.recovered case final walk?) {
      unawaited(_finishRecovered(walk));
      return;
    }
    _controller.start();
    _recordingStarted = _startRecording();
    // Only the very first real walk. Steps already count underneath.
    if (_plan.isFirstActivity) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        unawaited(
          CelebrationOverlay.show(
            context,
            // Seen once, so longer and calm: only the floating mascot.
            const CelebrationOverlay(
              image: AssetManifest.mascotStillTalk,
              title: "We're about to start a new journey.",
              subtitle: "Every step counts. Let's go!",
              duration: Duration(seconds: 5),
              festive: false,
            ),
          ),
        );
      });
    }
  }

  void _onActivityChanged() {
    _game
      ..setDistance(_plan.resumeMetres + _controller.metres)
      ..setGait(_controller.gait);
  }

  /// Writes the walk to the on-phone database, so it survives Pando being
  /// killed. The counter's start value follows with its first event.
  Future<void> _startRecording() async {
    final recorder = _services.recorder;
    try {
      await recorder.begin(
        clientSessionId: _clientSessionId,
        startedAt: _controller.startedAt,
        goalSteps: _plan.goalSteps,
        resumeMetres: _plan.resumeMetres,
      );
      unawaited(
        _controller.startCount.then(
          (count) => recorder.setStartCount(_clientSessionId, count),
        ),
      );
    } catch (e) {
      debugPrint('Pando walk: not recorded on the phone ($e)');
    }
  }

  /// Reads the walk's 30 s slices from the step history and keeps them.
  Future<void> _keepSlices() async {
    final startedAt = _controller.startedAt;
    final endedAt = _controller.endedAt!;
    debugPrint('Pando walk: counter ${_controller.steps} steps');
    try {
      await _services.recorder.recordSlices(
        _clientSessionId,
        startedAt,
        endedAt,
      );
    } catch (e) {
      debugPrint('Pando walk: no slices kept ($e)');
    }
  }

  /// Finish walk: the steps come from the step history (or, without it,
  /// from the step counter's value at Start), then the normal Stop flow.
  Future<void> _finishRecovered(WalkInProgress walk) async {
    final now = DateTime.now();
    final startedAt = walk.startedAt.toLocal();
    var slices = <WalkSlice>[];
    try {
      slices = await _services.recorder.recordSlices(
        walk.clientSessionId,
        startedAt,
        now,
      );
    } on StepHistoryUnavailable catch (e) {
      debugPrint('Pando walk: finishing without the step history ($e)');
    }
    var timeline = WalkRecorder.timeline(startedAt, slices);
    final lastSteps = slices.where((s) => s.steps > 0).lastOrNull;
    var endedAt = lastSteps?.endAt ?? now;
    final startCount = walk.startCount;
    if (slices.isEmpty && startCount != null) {
      // A reboot resets the counter, so a smaller value can't be used.
      final count = await currentStepCount();
      if (count != null && count >= startCount) {
        timeline = [
          StepSample(startedAt, 0),
          StepSample(now, count - startCount),
        ];
        endedAt = now;
      }
    }
    await _game.loaded;
    if (!mounted) return;
    _controller.stopRecovered(
      startedAt: startedAt,
      endedAt: endedAt.toLocal(),
      timeline: timeline,
    );
    await _afterStop();
  }

  Future<void> _stop() async {
    _controller.stop();
    _slicesKept = _keepSlices();
    await _afterStop();
  }

  /// Sign, then the celebration if the goal was met. The feel question
  /// follows (the controller is in `asking` afterwards).
  Future<void> _afterStop() async {
    _game.placeSign(_plan.resumeMetres + _controller.metres);
    if (_controller.state == ActivityState.celebrating) {
      await CelebrationOverlay.show(
        context,
        CelebrationOverlay(
          image: AssetManifest.mascotStillCelebrate,
          title: 'You beat your goal!',
          highlight: FireText(
            '+${_controller.extraMetres.round()} m',
            height: 64,
          ),
          subtitle: "That's extra distance, all yours.",
        ),
      );
      if (!mounted) return;
      _controller.celebrationDone();
    }
  }

  /// Saves on the phone first, queues the server save, and goes Home.
  Future<void> _finish(Feel? feel) async {
    _controller.finish();
    final services = _services;
    final input = SessionInput(
      clientSessionId: _clientSessionId,
      startedAt: _controller.startedAt.toUtc(),
      endedAt: _controller.endedAt!.toUtc(),
      steps: _controller.steps,
      goalSteps: _plan.goalSteps,
      feel: feel,
      paceDropped: _controller.signals!.paceDropped,
    );

    // The next walk starts at this sign, even before the server knows.
    final endMetres = _plan.resumeMetres + _controller.metres;
    await services.cache.setPlan(
      _plan.copyWith(
        resumeMetres: endMetres,
        signMetres: [..._plan.signMetres, endMetres],
        isFirstActivity: false,
      ),
    );
    await services.queue.enqueue(PendingQueue.saveSessionOp, input.toJson());
    unawaited(services.queue.flush());
    // The session is safe in the queue, so the walk is no longer in progress.
    try {
      await _recordingStarted;
      await _slicesKept;
      await services.recorder.end(_clientSessionId);
    } catch (e) {
      debugPrint('Pando walk: walk in progress not cleared ($e)');
    }
    if (mounted) Navigator.of(context).pop();
  }

  @override
  void dispose() {
    _controller
      ..removeListener(_onActivityChanged)
      ..dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      // Stop is the way out, so a walk is never lost by accident.
      canPop: false,
      child: Scaffold(
        body: Stack(
          children: [
            Positioned.fill(child: GameWidget(game: _game)),
            SafeArea(
              child: ListenableBuilder(
                listenable: _controller,
                builder: (context, _) => Column(
                  children: [
                    const SizedBox(height: 12),
                    DistanceDisplay(
                      remainingMetres: _controller.remainingMetres,
                      extraMetres: _controller.extraMetres,
                      goalMet: _controller.goalMet,
                    ),
                    if (_bubbleText case final text?) ...[
                      const SizedBox(height: 16),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 32),
                        child: MascotBubble(text),
                      ),
                    ],
                    const Spacer(),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
                      child: _bottom(),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// The greeting until the first steps. (The goal cheer is the
  /// full-screen celebration.)
  String? get _bubbleText => switch (_controller.state) {
    ActivityState.ready => MascotBubble.greeting,
    _ => null,
  };

  Widget _bottom() {
    if (_controller.state.isLive) {
      return GestureDetector(
        onTap: _stop,
        child: const WobblyBox(
          seed: 5,
          strokeWidth: 2.6,
          padding: EdgeInsets.symmetric(horizontal: 30, vertical: 14),
          child: Text(
            'Stop activity',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
          ),
        ),
      );
    }
    if (_controller.state == ActivityState.asking) {
      return FeelQuestion(onAnswer: _finish);
    }
    return const SizedBox.shrink();
  }
}

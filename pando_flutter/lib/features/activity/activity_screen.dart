import 'dart:async';

import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:pando_client/pando_client.dart';

import '../../app/theme.dart';
import '../../game/asset_manifest.dart';
import '../../game/park_game.dart';
import '../../services/app_services.dart';
import '../../services/pending_queue.dart';
import '../celebration/celebration_overlay.dart';
import 'activity_controller.dart';
import 'distance_display.dart';
import 'feel_question.dart';
import 'fire_text.dart';
import 'mascot_bubble.dart';

/// The park map with Flutter overlays on top. Owns the [ActivityController]
/// and tells the game what to show; the game never sees steps.
class ActivityScreen extends StatefulWidget {
  const ActivityScreen({super.key, required this.plan});

  /// Goal, stride, resume point and signs, from the server (or its cache).
  final ActivityPlan plan;

  @override
  State<ActivityScreen> createState() => _ActivityScreenState();
}

class _ActivityScreenState extends State<ActivityScreen> {
  late final ActivityController _controller;
  late final ParkGame _game;

  /// Made on the phone, so a retried save is recognised by the server.
  final String _clientSessionId = const Uuid().v4();

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
    _controller.start();
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

  Future<void> _stop() async {
    _controller.stop();
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
    final services = AppServices.instance;
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
    unawaited(
      services.queue.add(PendingQueue.saveSessionOp, input.toJson()),
    );
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

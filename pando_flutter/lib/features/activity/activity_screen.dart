import 'package:flame/game.dart';
import 'package:flutter/material.dart';

import '../../app/config.dart';
import '../../game/park_game.dart';
import 'activity_controller.dart';
import 'distance_display.dart';

/// The park map with Flutter overlays on top. Owns the [ActivityController]
/// and tells the game what to show; the game never sees steps.
class ActivityScreen extends StatefulWidget {
  const ActivityScreen({super.key});

  @override
  State<ActivityScreen> createState() => _ActivityScreenState();
}

class _ActivityScreenState extends State<ActivityScreen> {
  // Slice 1: no server yet, so the default height and a fresh journey.
  static const double _heightMetres = AppConfig.defaultHeightMetres;
  static const double _resumeMetres = 0;

  late final ActivityController _controller;
  late final ParkGame _game;

  @override
  void initState() {
    super.initState();
    _game = ParkGame(resumeMetres: _resumeMetres, signMetres: const [0]);
    _controller = ActivityController(
      strideMetres: AppConfig.strideMetres(_heightMetres),
      goalMetres: AppConfig.firstGoalMetres(_heightMetres),
    )..addListener(_onActivityChanged);
    _controller.start();
  }

  void _onActivityChanged() {
    _game
      ..setDistance(_resumeMetres + _controller.metres)
      ..setGait(_controller.gait);
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
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(child: GameWidget(game: _game)),
          SafeArea(
            child: Align(
              alignment: Alignment.topCenter,
              child: Padding(
                padding: const EdgeInsets.only(top: 12),
                child: ListenableBuilder(
                  listenable: _controller,
                  builder: (context, _) => DistanceDisplay(
                    remainingMetres: _controller.remainingMetres,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

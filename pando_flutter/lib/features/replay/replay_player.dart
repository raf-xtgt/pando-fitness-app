import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:pando_shared/pando_shared.dart';

import '../../app/theme.dart';
import '../../game/park_game.dart';
import 'replay_loading.dart';

/// Where the player is: map loading → waiting for **Play** → playing →
/// finished (**Replay**).
enum _Phase { loading, ready, playing, finished }

/// Plays a [Replay] on the park: the runner walks, runs or stands segment by
/// segment from the start sign, the mascot follows, and the end sign drops
/// at the end. It waits for **Play**; **Replay** plays it again. Used by the
/// replay web page.
class ReplayPlayer extends StatefulWidget {
  const ReplayPlayer({super.key, required this.replay});

  final Replay replay;

  @override
  State<ReplayPlayer> createState() => _ReplayPlayerState();
}

class _ReplayPlayerState extends State<ReplayPlayer>
    with SingleTickerProviderStateMixin {
  late ParkGame _game;
  late final Ticker _ticker = createTicker(_onTick);
  _Phase _phase = _Phase.loading;

  /// A new game for each play, so the end sign of the last play is gone.
  int _play = 0;

  Replay get _replay => widget.replay;

  @override
  void initState() {
    super.initState();
    _newGame(autoplay: false);
  }

  /// A fresh map at the start sign. Plays once the map is loaded (so the
  /// first seconds aren't lost) if [autoplay], else waits for **Play**.
  Future<void> _newGame({required bool autoplay}) async {
    _ticker.stop();
    final game = ParkGame(
      resumeMetres: _replay.startPathM,
      signMetres: [_replay.startPathM],
    );
    setState(() {
      _phase = _Phase.loading;
      _play++;
      _game = game;
    });
    await game.loaded;
    if (!mounted || game != _game) return;
    if (autoplay) {
      _playNow();
    } else {
      setState(() => _phase = _Phase.ready);
    }
  }

  void _playNow() {
    setState(() => _phase = _Phase.playing);
    _ticker.start();
  }

  void _onTick(Duration elapsed) {
    final playS = elapsed.inMilliseconds / 1000;
    final at = replayAt(_replay, playS);
    _game.showAt(at.metres, at.gait);
    if (playS >= _replay.durationS) {
      _ticker.stop();
      _game.placeSign(_replay.endPathM);
      setState(() => _phase = _Phase.finished);
    }
  }

  @override
  void dispose() {
    _ticker.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          child: GameWidget(key: ValueKey(_play), game: _game),
        ),
        if (_phase == _Phase.loading)
          const Positioned.fill(child: ReplayLoading()),
        if (_phase == _Phase.ready)
          Positioned.fill(
            child: Center(
              child: _Button(
                icon: Icons.play_arrow_rounded,
                label: 'Play',
                big: true,
                onTap: _playNow,
              ),
            ),
          ),
        if (_phase == _Phase.finished)
          Positioned(
            left: 0,
            right: 0,
            bottom: 24,
            child: Center(
              child: _Button(
                icon: Icons.replay,
                label: 'Replay',
                onTap: () => _newGame(autoplay: true),
              ),
            ),
          ),
      ],
    );
  }
}

/// A hand-drawn button: icon and label in a wobbly paper box.
class _Button extends StatelessWidget {
  const _Button({
    required this.icon,
    required this.label,
    required this.onTap,
    this.big = false,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final bool big;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: label,
      child: GestureDetector(
        onTap: onTap,
        child: WobblyBox(
          seed: big ? 13 : 11,
          strokeWidth: 2.6,
          padding: EdgeInsets.symmetric(
            horizontal: big ? 34 : 26,
            vertical: big ? 16 : 12,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, color: PandoColors.ink, size: big ? 36 : 24),
              const SizedBox(width: 8),
              Text(
                label,
                style: TextStyle(
                  fontSize: big ? 24 : 18,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

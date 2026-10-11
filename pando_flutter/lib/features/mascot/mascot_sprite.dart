import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

import '../../game/asset_manifest.dart';

/// The mascot's hover sheet (`mascot_hover.png`, 8 frames of 96 px) in
/// Flutter, outside the park game: wings flap, it floats up and down, and
/// now and then it blinks at you.
///
/// Frame 5 of the sheet is the blink. The hover loop leaves it out, so the
/// blink comes only every [blinkEvery] (with a little jitter), for
/// [blinkFor]. With the system's "remove animations" setting on, it shows
/// the first frame, still.
class MascotSprite extends StatefulWidget {
  const MascotSprite({super.key, this.size = 72});

  /// Width and height of one frame on screen.
  final double size;

  static const int frames = 8;
  static const int blinkFrame = 5;
  static const double fps = 8;
  static const Duration blinkEvery = Duration(milliseconds: 3200);
  static const Duration blinkFor = Duration(milliseconds: 180);

  /// Float height, as a fraction of [size].
  static const double lift = 0.05;

  /// The frame to show [elapsed] into the animation: the hover loop
  /// without the blink frame, except during a blink. [nextBlink] is when
  /// the current blink starts.
  static int frameAt(Duration elapsed, Duration nextBlink) {
    if (elapsed >= nextBlink && elapsed < nextBlink + blinkFor) {
      return blinkFrame;
    }
    const loop = [0, 1, 2, 3, 4, 6, 7];
    final tick = (elapsed.inMilliseconds * fps / 1000).floor();
    return loop[tick % loop.length];
  }

  @override
  State<MascotSprite> createState() => _MascotSpriteState();
}

class _MascotSpriteState extends State<MascotSprite>
    with SingleTickerProviderStateMixin {
  late final Ticker _ticker = createTicker(_onTick);
  final _random = math.Random();
  Duration _elapsed = Duration.zero;
  Duration _nextBlink = MascotSprite.blinkEvery;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final still = MediaQuery.disableAnimationsOf(context);
    if (still && _ticker.isActive) {
      _ticker.stop();
      setState(() => _elapsed = Duration.zero);
    } else if (!still && !_ticker.isActive) {
      _ticker.start();
    }
  }

  void _onTick(Duration elapsed) {
    if (elapsed >= _nextBlink + MascotSprite.blinkFor) {
      // Not like clockwork: 3.2 s ± 0.8 s to the next blink.
      _nextBlink =
          elapsed +
          MascotSprite.blinkEvery +
          Duration(milliseconds: _random.nextInt(1600) - 800);
    }
    setState(() => _elapsed = elapsed);
  }

  @override
  void dispose() {
    _ticker.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = widget.size;
    final frame = MascotSprite.frameAt(_elapsed, _nextBlink);
    final turn = _elapsed.inMilliseconds / 2800 * 2 * math.pi;
    return Transform.translate(
      offset: Offset(0, math.sin(turn) * size * MascotSprite.lift),
      child: SizedBox.square(
        dimension: size,
        child: ClipRect(
          child: OverflowBox(
            maxWidth: size * MascotSprite.frames,
            alignment: Alignment.centerLeft,
            child: Transform.translate(
              offset: Offset(-frame * size, 0),
              child: Image.asset(
                AssetManifest.imagePrefix + AssetManifest.mascotHover.file,
                width: size * MascotSprite.frames,
                height: size,
                fit: BoxFit.fill,
                filterQuality: FilterQuality.medium,
                gaplessPlayback: true,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

import 'dart:math' as math;
import 'dart:ui' show ImageFilter;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../app/theme.dart';
import '../../game/asset_manifest.dart';

/// Text drawn from the fire glyph SVGs, one per character, burning: each
/// glyph flickers (stretches up from its base and sways), a hot glow pulses
/// behind it, and embers rise above the text. Supports digits, `m`, `+`
/// and spaces (e.g. `+123 m`).
///
/// One clock drives everything, and each glyph's motion comes from its
/// position, so the flames keep going when the digits change on a step.
/// With the system's "remove animations" setting on, the text stands still
/// with a steady glow.
class FireText extends StatefulWidget {
  const FireText(this.text, {super.key, this.height = 52});

  final String text;

  /// Glyph height; every glyph has the same 60:100 box.
  final double height;

  @override
  State<FireText> createState() => _FireTextState();
}

class _FireTextState extends State<FireText>
    with SingleTickerProviderStateMixin {
  /// Seconds since the text appeared.
  final ValueNotifier<double> _seconds = ValueNotifier(0);
  late final Ticker _ticker = createTicker(
    (elapsed) => _seconds.value = elapsed.inMicroseconds / 1e6,
  );

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (MediaQuery.disableAnimationsOf(context)) {
      if (_ticker.isActive) _ticker.stop();
    } else if (!_ticker.isActive) {
      _ticker.start();
    }
  }

  @override
  void dispose() {
    _ticker.dispose();
    _seconds.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final h = widget.height;
    final w = h * 0.6;
    final chars = widget.text.split('');

    return Semantics(
      label: widget.text,
      excludeSemantics: true,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          ValueListenableBuilder<double>(
            valueListenable: _seconds,
            builder: (context, t, _) => Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                for (final (i, char) in chars.indexed)
                  if (char == ' ')
                    SizedBox(width: w * 0.4)
                  else
                    _BurningGlyph(
                      asset: AssetManifest.fireGlyph(char),
                      width: w,
                      height: h,
                      flicker: _flicker(t, i),
                      sway: _flicker(t * 0.7, i + 11),
                    ),
              ],
            ),
          ),
          // Embers rise from the top half of the glyphs, up to about one
          // glyph height above the text.
          Positioned(
            left: 0,
            right: 0,
            top: -h * 0.9,
            height: h * 1.4,
            child: IgnorePointer(
              child: CustomPaint(painter: _EmberPainter(_seconds)),
            ),
          ),
        ],
      ),
    );
  }

  /// Flame-like noise in about -1..1: three fast sines at odd ratios, with
  /// a different phase for every glyph position [i].
  static double _flicker(double t, int i) =>
      0.5 * math.sin(t * 11.3 + i * 1.7) +
      0.3 * math.sin(t * 17.9 + i * 3.1) +
      0.2 * math.sin(t * 29.7 + i * 5.3);
}

/// One glyph: a pulsing blurred glow behind, the SVG in front, both
/// stretched up and swayed from the glyph's base.
class _BurningGlyph extends StatelessWidget {
  const _BurningGlyph({
    required this.asset,
    required this.width,
    required this.height,
    required this.flicker,
    required this.sway,
  });

  final String asset;
  final double width;
  final double height;

  /// -1..1: how much the flame is up (taller, brighter) or down.
  final double flicker;

  /// -1..1: lean to the left or right.
  final double sway;

  /// Tunables for "clearly burning".
  static const double stretch = 0.07; // up to 7% taller or shorter
  static const double lean = 0.06; // skew at the top
  static const double glowMin = 0.45;
  static const double glowMax = 0.95;

  @override
  Widget build(BuildContext context) {
    final glyph = SvgPicture.asset(asset, width: width, height: height);
    final glow = 0.5 + 0.5 * flicker; // 0..1
    final transform = Matrix4.identity()
      ..scaleByDouble(1 - stretch * 0.3 * flicker, 1 + stretch * flicker, 1, 1)
      ..setEntry(0, 1, -lean * sway);

    return SizedBox(
      width: width,
      height: height,
      child: Transform(
        alignment: Alignment.bottomCenter,
        transform: transform,
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            // The glow: the glyph's shape in hot orange, blurred, a bit
            // larger, brighter when the flame is up.
            Positioned.fill(
              child: Opacity(
                opacity: glowMin + (glowMax - glowMin) * glow,
                child: Transform.scale(
                  scale: 1.12,
                  alignment: Alignment.bottomCenter,
                  child: ImageFiltered(
                    imageFilter: ImageFilter.blur(
                      sigmaX: height * 0.1,
                      sigmaY: height * 0.12,
                    ),
                    child: ColorFiltered(
                      colorFilter: const ColorFilter.mode(
                        Color(0xFFFF8A2A),
                        BlendMode.srcIn,
                      ),
                      child: glyph,
                    ),
                  ),
                ),
              ),
            ),
            glyph,
          ],
        ),
      ),
    );
  }
}

/// Small embers that rise from the text, drift, shrink and fade, then
/// start again. A fixed seed, so nothing is allocated per frame.
class _EmberPainter extends CustomPainter {
  _EmberPainter(this.seconds) : super(repaint: seconds);

  final ValueListenable<double> seconds;

  static const List<Color> _colors = [
    Color(0xFFF6B53A), // fire yellow
    PandoColors.fire,
    Color(0xFFFF8A2A), // glow orange
  ];

  static final List<_Ember> _embers = () {
    final random = math.Random(3);
    return List.generate(26, (i) {
      return _Ember(
        x: 0.05 + random.nextDouble() * 0.9,
        phase: random.nextDouble(),
        life: 1.1 + random.nextDouble() * 0.9,
        drift: 4 + random.nextDouble() * 8,
        radius: 2.2 + random.nextDouble() * 2.2,
        color: _colors[i % _colors.length],
      );
    });
  }();

  @override
  void paint(Canvas canvas, Size size) {
    final t = seconds.value;
    if (t == 0) return;
    final paint = Paint();
    // Embers start at 65% of the box height (the glyphs' upper half) and
    // rise to the top of the box.
    final startY = size.height * 0.65;
    for (final e in _embers) {
      final age = (t / e.life + e.phase) % 1.0; // 0 = born, 1 = gone
      final y = startY - age * startY;
      final x =
          e.x * size.width + math.sin((t + e.phase * 7) * 3) * e.drift * age;
      final fade = age < 0.15 ? age / 0.15 : 1 - (age - 0.15) / 0.85;
      paint.color = e.color.withValues(alpha: fade.clamp(0, 1).toDouble());
      canvas.drawCircle(Offset(x, y), e.radius * (1 - age * 0.5), paint);
    }
  }

  @override
  bool shouldRepaint(_EmberPainter old) => false;
}

class _Ember {
  const _Ember({
    required this.x,
    required this.phase,
    required this.life,
    required this.drift,
    required this.radius,
    required this.color,
  });

  final double x;
  final double phase;
  final double life;
  final double drift;
  final double radius;
  final Color color;
}

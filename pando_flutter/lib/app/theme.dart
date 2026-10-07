import 'dart:math' as math;

import 'package:flutter/material.dart';

/// Pando's palette: a printed picture book, not a dashboard.
abstract final class PandoColors {
  static const Color paper = Color(0xFFF3EDE2);
  static const Color ink = Color(0xFF2A2622);
  static const Color accent = Color(0xFF6B8F4E); // leaf green
  static const Color fire = Color(0xFFE2582B);
}

ThemeData buildPandoTheme() {
  final base = ThemeData(
    useMaterial3: true,
    fontFamily: 'Mulish',
    scaffoldBackgroundColor: PandoColors.paper,
    colorScheme: ColorScheme.fromSeed(
      seedColor: PandoColors.accent,
      surface: PandoColors.paper,
      onSurface: PandoColors.ink,
      primary: PandoColors.ink,
    ),
    splashFactory: NoSplash.splashFactory,
  );
  return base.copyWith(
    textTheme: base.textTheme.apply(
      bodyColor: PandoColors.ink,
      displayColor: PandoColors.ink,
    ),
  );
}

/// A paper panel with a hand-drawn, slightly wobbly ink border. No rounded
/// corners, no shadows, no gradients.
class WobblyBox extends StatelessWidget {
  const WobblyBox({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
    this.seed = 1,
    this.fill = PandoColors.paper,
    this.strokeWidth = 2.2,
  });

  final Widget child;
  final EdgeInsetsGeometry padding;

  /// Different seeds give differently wobbled edges.
  final int seed;
  final Color fill;
  final double strokeWidth;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: WobblyBorderPainter(
        seed: seed,
        fill: fill,
        strokeWidth: strokeWidth,
      ),
      child: Padding(padding: padding, child: child),
    );
  }
}

class WobblyBorderPainter extends CustomPainter {
  WobblyBorderPainter({
    required this.seed,
    this.fill = PandoColors.paper,
    this.ink = PandoColors.ink,
    this.strokeWidth = 2.2,
    this.wobble = 1.6,
  });

  final int seed;
  final Color fill;
  final Color ink;
  final double strokeWidth;

  /// How far, in pixels, the edge may stray from a straight line.
  final double wobble;

  @override
  void paint(Canvas canvas, Size size) {
    final random = math.Random(seed);
    final inset = strokeWidth;
    final corners = [
      Offset(inset, inset),
      Offset(size.width - inset, inset),
      Offset(size.width - inset, size.height - inset),
      Offset(inset, size.height - inset),
    ];
    double jitter() => (random.nextDouble() * 2 - 1) * wobble;

    final path = Path();
    for (var c = 0; c < 4; c++) {
      final a = corners[c] + Offset(jitter(), jitter());
      final b = corners[(c + 1) % 4];
      if (c == 0) path.moveTo(a.dx, a.dy);
      final length = (b - a).distance;
      final steps = math.max(1, (length / 14).round());
      for (var i = 1; i <= steps; i++) {
        final p = Offset.lerp(a, b, i / steps)!;
        path.lineTo(p.dx + jitter(), p.dy + jitter());
      }
    }
    path.close();

    canvas.drawPath(path, Paint()..color = fill);
    canvas.drawPath(
      path,
      Paint()
        ..color = ink
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth
        ..strokeJoin = StrokeJoin.round,
    );
  }

  @override
  bool shouldRepaint(WobblyBorderPainter old) =>
      old.seed != seed || old.fill != fill || old.strokeWidth != strokeWidth;
}

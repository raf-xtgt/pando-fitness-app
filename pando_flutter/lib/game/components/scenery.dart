import 'dart:math' as math;
import 'dart:ui';

import 'package:flame/components.dart';

/// A tree that sways from its base, like in a light breeze.
///
/// The sprite is skewed about its bottom edge: the base stays put and the
/// top moves at most [amplitude] × height to the side. Two sine waves with
/// a random [phase] per tree, so the park never sways in step.
class SwayingSprite extends SpriteComponent {
  SwayingSprite({
    required Sprite super.sprite,
    required Vector2 super.size,
    required Vector2 super.position,
    required int super.priority,
    required this.phase,
  }) : super(anchor: Anchor.bottomCenter);

  /// Sideways skew at the top, as a share of the height (~7 px on a tree).
  static const double amplitude = 0.02;

  /// Seconds per slow sway.
  static const double period = 4.2;

  final double phase;
  double _t = 0;

  @override
  void update(double dt) {
    _t += dt;
  }

  @override
  void render(Canvas canvas) {
    final w = 2 * math.pi * _t / period + phase;
    final skew = amplitude * (math.sin(w) + 0.3 * math.sin(2.3 * w + phase));
    canvas
      ..save()
      ..translate(0, size.y)
      ..skew(skew, 0)
      ..translate(0, -size.y);
    super.render(canvas);
    canvas.restore();
  }
}

/// Small white glints that fade in and out on the fountain's water.
///
/// Add as a child of the fountain sprite (same size). The glints appear
/// at [_spots], points sampled from the water in `park_fountain.png`
/// (fractions of the image's width and height).
class FountainSparkle extends PositionComponent {
  FountainSparkle({required Vector2 size, required int seed})
    : _random = math.Random(seed),
      super(size: size);

  static const int glints = 8;

  static const List<Offset> _spots = [
    Offset(0.550, 0.040), Offset(0.600, 0.200), Offset(0.675, 0.333), //
    Offset(0.662, 0.360), Offset(0.500, 0.413), Offset(0.562, 0.453),
    Offset(0.463, 0.453), Offset(0.263, 0.480), Offset(0.738, 0.560),
    Offset(0.125, 0.587), Offset(0.800, 0.627), Offset(0.662, 0.627),
    Offset(0.713, 0.627), Offset(0.863, 0.627), Offset(0.263, 0.680),
    Offset(0.450, 0.680), Offset(0.175, 0.680), Offset(0.400, 0.680),
    Offset(0.650, 0.693), Offset(0.300, 0.707), Offset(0.588, 0.707),
    Offset(0.637, 0.707), Offset(0.537, 0.720), Offset(0.312, 0.733),
  ];

  final math.Random _random;
  late final List<_Glint> _glints = [
    for (var i = 0; i < glints; i++) _newGlint(delay: _random.nextDouble()),
  ];
  final Paint _paint = Paint();
  final Paint _glow = Paint()
    ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 3);

  _Glint _newGlint({double delay = 0}) => _Glint(
    spot: _spots[_random.nextInt(_spots.length)],
    life: 0.6 + 0.6 * _random.nextDouble(),
    radius: 6 + 4 * _random.nextDouble(),
    age: -delay - 0.4 * _random.nextDouble(),
  );

  @override
  void update(double dt) {
    for (var i = 0; i < _glints.length; i++) {
      final g = _glints[i]..age += dt;
      if (g.age > g.life) _glints[i] = _newGlint();
    }
  }

  @override
  void render(Canvas canvas) {
    for (final g in _glints) {
      if (g.age < 0) continue;
      final a = math.sin(math.pi * g.age / g.life);
      final c = Offset(g.spot.dx * size.x, g.spot.dy * size.y);
      final r = g.radius * (0.6 + 0.4 * a);
      _paint.color = Color.fromRGBO(255, 255, 255, 0.95 * a);
      _glow.color = Color.fromRGBO(255, 255, 255, 0.45 * a);
      canvas.drawCircle(c, r * 0.45, _glow);
      // A four-point star: two thin diamonds across each other.
      canvas
        ..drawPath(_diamond(c, r, r * 0.22), _paint)
        ..drawPath(_diamond(c, r * 0.22, r), _paint);
    }
  }

  static Path _diamond(Offset c, double rx, double ry) => Path()
    ..moveTo(c.dx - rx, c.dy)
    ..lineTo(c.dx, c.dy - ry)
    ..lineTo(c.dx + rx, c.dy)
    ..lineTo(c.dx, c.dy + ry)
    ..close();
}

class _Glint {
  _Glint({
    required this.spot,
    required this.life,
    required this.radius,
    required this.age,
  });

  final Offset spot;
  final double life;
  final double radius;
  double age;
}

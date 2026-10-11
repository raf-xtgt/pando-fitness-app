import 'dart:math' as math;
import 'dart:ui';

/// Where things go on the timeline trail. Pure geometry, no widgets.
///
/// The trail winds up the screen: node 0 (the newest sign) at the top, older
/// signs below it, swinging left and right. Between two nodes an S-curve
/// carries a line of footprints, left and right in turn, toes pointing up
/// the trail (towards the newer sign).
class TrailLayout {
  TrailLayout({
    required this.width,
    required this.nodeCount,
    this.top = 120,
    this.spacing = 200,
    this.tail = 0,
  });

  final double width;

  /// Signs on the trail (checkpoints, plus the start sign if shown).
  final int nodeCount;

  /// Room above the newest sign (for the mascot).
  final double top;

  /// Vertical distance between two signs.
  final double spacing;

  /// Extra trail below the last sign, for "older walks continue below".
  final double tail;

  /// Prints per gap between two signs.
  static const int printsPerGap = 7;

  /// Sideways offset of each print from the trail's centre line.
  static const double printSpread = 13;

  double get height => top + math.max(0, nodeCount - 1) * spacing + 110 + tail;

  /// Even nodes sit left of centre, odd nodes right.
  bool isLeft(int i) => i.isEven;

  Offset node(int i) =>
      Offset(width * (isLeft(i) ? 0.27 : 0.73), top + i * spacing);

  /// The curve from the older node [i] + 1 up to node [i].
  Offset _curve(Offset from, Offset to, double t) {
    final c1 = from + Offset(0, -spacing * 0.55);
    final c2 = to + Offset(0, spacing * 0.55);
    final u = 1 - t;
    return from * (u * u * u) +
        c1 * (3 * u * u * t) +
        c2 * (3 * u * t * t) +
        to * (t * t * t);
  }

  /// Footprints from node [i] + 1 (older) up to node [i]; for the tail, pass
  /// `i = nodeCount - 1` and [fromBelow] to come in from under the last sign.
  /// Skips the ends, so the prints don't cover the signs.
  List<Footprint> gap(int i, {bool fromBelow = false}) {
    final to = node(i);
    final from = fromBelow ? to + Offset(0, tail) : node(i + 1);
    // Even spacing along the curve: sample it finely, then walk its length.
    const samples = 64;
    final points = [
      for (var k = 0; k <= samples; k++) _curve(from, to, k / samples),
    ];
    final lengths = <double>[0];
    for (var k = 1; k < points.length; k++) {
      lengths.add(lengths.last + (points[k] - points[k - 1]).distance);
    }
    final total = lengths.last;
    final prints = <Footprint>[];
    for (var n = 0; n < printsPerGap; n++) {
      final want = total * (0.2 + 0.62 * n / (printsPerGap - 1));
      var k = 1;
      while (k < lengths.length - 1 && lengths[k] < want) {
        k++;
      }
      final a = points[k - 1];
      final b = points[k];
      final dir = b - a;
      final heading = math.atan2(dir.dy, dir.dx);
      final left = n.isEven;
      // Perpendicular to the direction of travel.
      final side = Offset(-dir.dy, dir.dx) / dir.distance;
      final t = (want - lengths[k - 1]) / (lengths[k] - lengths[k - 1]);
      final at =
          Offset.lerp(a, b, t)! + side * (left ? -printSpread : printSpread);
      prints.add(
        Footprint(
          position: at,
          // The image points up (-y); heading 0 is +x.
          angle: heading + math.pi / 2,
          left: left,
        ),
      );
    }
    return prints;
  }
}

/// One sneaker print on the trail: centre, turn (radians) and which foot.
class Footprint {
  const Footprint({
    required this.position,
    required this.angle,
    required this.left,
  });

  final Offset position;
  final double angle;
  final bool left;
}

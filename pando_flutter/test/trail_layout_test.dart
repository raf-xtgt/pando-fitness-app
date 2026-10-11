import 'dart:math' as math;

import 'package:flutter_test/flutter_test.dart';
import 'package:pando_flutter/features/timeline/trail_layout.dart';

void main() {
  final layout = TrailLayout(width: 360, nodeCount: 4);

  test('signs swing left and right, newest at the top', () {
    expect(layout.node(0).dx, lessThan(180));
    expect(layout.node(1).dx, greaterThan(180));
    expect(layout.node(1).dy - layout.node(0).dy, layout.spacing);
    expect(layout.height, greaterThan(layout.node(3).dy));
  });

  test('prints go up the trail, left and right in turn, off the signs', () {
    final prints = layout.gap(0);
    expect(prints, hasLength(TrailLayout.printsPerGap));
    expect(
      [for (final p in prints) p.left],
      [
        for (var n = 0; n < TrailLayout.printsPerGap; n++) n.isEven,
      ],
    );
    // From the older sign (below) up to the newer one.
    for (var n = 1; n < prints.length; n++) {
      // The left/right offset can lift a print a little where the trail
      // runs sideways.
      expect(
        prints[n].position.dy,
        lessThan(prints[n - 1].position.dy + 2 * TrailLayout.printSpread),
      );
    }
    for (final p in prints) {
      expect(
        p.position.dy,
        inExclusiveRange(layout.node(0).dy, layout.node(1).dy),
      );
      // Toes point up-ish: within a quarter turn of straight up.
      expect(p.angle.abs(), lessThan(math.pi / 2));
    }
  });

  test('the tail comes in from below the last sign', () {
    final tailed = TrailLayout(width: 360, nodeCount: 2, tail: 90);
    final prints = tailed.gap(1, fromBelow: true);
    expect(prints.first.position.dy, greaterThan(tailed.node(1).dy));
  });
}

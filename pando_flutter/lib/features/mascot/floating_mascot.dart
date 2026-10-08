import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../game/asset_manifest.dart';

/// The mascot's sharp still, floating: a slow up-and-down drift plus a
/// small side-to-side sway, like it holds itself up with its wings.
/// Used on the splash (full motion) and as the height marker (small
/// motion, so the measurement still reads as exact).
///
/// With the system's "remove animations" setting on, it stands still.
class FloatingMascot extends StatefulWidget {
  const FloatingMascot({
    super.key,
    this.size = 280,
    this.lift = 0.04,
    this.sway = 0.035,
  });

  /// Width and height of the square image box.
  final double size;

  /// Float height, as a fraction of [size] (up and down).
  final double lift;

  /// Sway angle in radians (side to side).
  final double sway;

  /// Tunable: one full float cycle. The sway runs twice per cycle.
  static const Duration period = Duration(milliseconds: 2800);

  @override
  State<FloatingMascot> createState() => _FloatingMascotState();
}

class _FloatingMascotState extends State<FloatingMascot>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: FloatingMascot.period,
  );

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (MediaQuery.disableAnimationsOf(context)) {
      _controller.stop();
    } else if (!_controller.isAnimating) {
      _controller.repeat();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final image = Image.asset(
      AssetManifest.mascotStill,
      width: widget.size,
      height: widget.size,
      filterQuality: FilterQuality.medium,
      // The art is gitignored; a clone without it still runs.
      errorBuilder: (_, _, _) => SizedBox.square(dimension: widget.size),
    );

    return AnimatedBuilder(
      animation: _controller,
      child: image,
      builder: (context, child) {
        final turn = _controller.value * 2 * math.pi;
        // Float: up and down once per cycle. Sway: twice per cycle,
        // pivoting near the top like it hangs from its wings.
        final lift = math.sin(turn) * widget.size * widget.lift;
        final sway = math.sin(turn * 2) * widget.sway;
        return Transform.translate(
          offset: Offset(0, lift),
          child: Transform.rotate(
            angle: sway,
            alignment: const Alignment(0, -0.3),
            child: child,
          ),
        );
      },
    );
  }
}

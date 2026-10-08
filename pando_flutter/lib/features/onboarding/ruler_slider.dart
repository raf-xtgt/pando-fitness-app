import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../app/theme.dart';
import '../../domain/units.dart';
import '../mascot/floating_mascot.dart';

/// A vertical measuring-tape ruler. Drag up to grow taller, down to shrink.
/// Snaps to whole inches between [minHeightInches] and [maxHeightInches].
///
/// The mascot is the marker: it floats at the middle, right of the ticks,
/// and a short pointer joins it to the tick that is the height. A "Drag me"
/// label under it fades out after the first drag.
class RulerSlider extends StatefulWidget {
  const RulerSlider({
    super.key,
    required this.inches,
    required this.onChanged,
  });

  final int inches;
  final ValueChanged<int> onChanged;

  @override
  State<RulerSlider> createState() => _RulerSliderState();
}

class _RulerSliderState extends State<RulerSlider> {
  /// Screen pixels between inch ticks.
  static const double pixelsPerInch = 16;

  /// Mascot image box. The body fills about 80% of the width, and its
  /// middle sits at 60% of the height (the still has room above the
  /// antennae), so the box is moved up to put the body on the line.
  static const double mascotSize = 84;
  static const double mascotMiddle = 0.6;

  /// Space between the end of the longest tick and the mascot's box.
  static const double pointerLength = 14;

  bool _dragged = false;

  /// The exact (unsnapped) value while dragging, for a smooth feel.
  late double _exact = widget.inches.toDouble();

  void _onDrag(DragUpdateDetails d) {
    setState(() {
      _dragged = true;
      // Dragging up (negative dy) increases the height.
      _exact = (_exact - d.delta.dy / pixelsPerInch).clamp(
        minHeightInches.toDouble(),
        maxHeightInches.toDouble(),
      );
    });
    final snapped = _exact.round();
    if (snapped != widget.inches) {
      HapticFeedback.selectionClick();
      widget.onChanged(snapped);
    }
  }

  void _onDragEnd(DragEndDetails _) =>
      setState(() => _exact = widget.inches.toDouble());

  @override
  Widget build(BuildContext context) {
    return Semantics(
      slider: true,
      label: 'Height',
      value: formatFeetInches(widget.inches),
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onVerticalDragUpdate: _onDrag,
        onVerticalDragEnd: _onDragEnd,
        child: LayoutBuilder(
          builder: (context, constraints) {
            final centerY = constraints.maxHeight / 2;
            final mascotLeft =
                _RulerPainter.spine + _RulerPainter.longestTick + pointerLength;
            return Stack(
              clipBehavior: Clip.none,
              children: [
                Positioned.fill(
                  child: CustomPaint(
                    painter: _RulerPainter(
                      exact: _exact,
                      pixelsPerInch: pixelsPerInch,
                      pointerEnd: mascotLeft + mascotSize * 0.1,
                    ),
                  ),
                ),
                Positioned(
                  left: mascotLeft,
                  top: centerY - mascotSize * mascotMiddle,
                  child: const FloatingMascot(
                    size: mascotSize,
                    lift: 0.012,
                    sway: 0.025,
                  ),
                ),
                Positioned(
                  left: mascotLeft - 8,
                  width: mascotSize + 16,
                  top: centerY + mascotSize * (1 - mascotMiddle),
                  child: AnimatedOpacity(
                    opacity: _dragged ? 0 : 1,
                    duration: const Duration(milliseconds: 400),
                    child: const Text(
                      'Drag me',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: PandoColors.ink,
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _RulerPainter extends CustomPainter {
  _RulerPainter({
    required this.exact,
    required this.pixelsPerInch,
    required this.pointerEnd,
  });

  /// x of the ruler's spine. The foot labels go to its left, so the space
  /// right of the ticks stays free for the mascot.
  static const double spine = 52;
  static const double longestTick = 64;

  final double exact;
  final double pixelsPerInch;

  /// x where the pointer meets the mascot's wing.
  final double pointerEnd;

  @override
  void paint(Canvas canvas, Size size) {
    final centerY = size.height / 2;
    const left = spine;
    final ink = Paint()
      ..color = PandoColors.ink
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round;

    // The ruler's spine, slightly hand-drawn.
    canvas.drawLine(Offset(left, 0), Offset(left + 1, size.height), ink);

    for (var inch = minHeightInches; inch <= maxHeightInches; inch++) {
      final y = centerY - (inch - exact) * pixelsPerInch;
      if (y < -20 || y > size.height + 20) continue;
      final isFoot = inch % 12 == 0;
      final isHalf = inch % 6 == 0;
      final length = isFoot ? longestTick : (isHalf ? 42.0 : 24.0);
      canvas.drawLine(
        Offset(left, y),
        Offset(left + length, y + (inch.isEven ? 0.6 : -0.6)),
        ink..strokeWidth = isFoot ? 3 : 2,
      );
      if (isFoot) {
        final label = TextPainter(
          text: TextSpan(
            text: '${inch ~/ 12} ft',
            style: const TextStyle(
              fontFamily: 'Mulish',
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: PandoColors.ink,
            ),
          ),
          textDirection: TextDirection.ltr,
        )..layout();
        label.paint(
          canvas,
          Offset(left - 10 - label.width, y - label.height / 2),
        );
      }
    }

    // The fixed pointer from the spine to the mascot (the marker).
    final pointer = Paint()
      ..color = PandoColors.fire
      ..strokeWidth = 3.5
      ..strokeCap = StrokeCap.round;
    canvas.drawLine(
      Offset(left - 4, centerY),
      Offset(pointerEnd, centerY - 1),
      pointer,
    );
  }

  @override
  bool shouldRepaint(_RulerPainter old) =>
      old.exact != exact || old.pointerEnd != pointerEnd;
}

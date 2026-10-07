import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../app/theme.dart';
import '../../domain/units.dart';

/// A vertical measuring-tape ruler. Drag up to grow taller, down to shrink.
/// Snaps to whole inches between [minHeightInches] and [maxHeightInches].
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

  /// The exact (unsnapped) value while dragging, for a smooth feel.
  late double _exact = widget.inches.toDouble();

  void _onDrag(DragUpdateDetails d) {
    setState(() {
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
        child: CustomPaint(
          painter: _RulerPainter(exact: _exact, pixelsPerInch: pixelsPerInch),
          size: Size.infinite,
        ),
      ),
    );
  }
}

class _RulerPainter extends CustomPainter {
  _RulerPainter({required this.exact, required this.pixelsPerInch});

  final double exact;
  final double pixelsPerInch;

  @override
  void paint(Canvas canvas, Size size) {
    final centerY = size.height / 2;
    final left = size.width * 0.18;
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
      final length = isFoot ? 64.0 : (isHalf ? 42.0 : 24.0);
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
        label.paint(canvas, Offset(left + 74, y - label.height / 2));
      }
    }

    // The fixed marker the ruler slides past.
    final marker = Paint()
      ..color = PandoColors.fire
      ..strokeWidth = 3.5
      ..strokeCap = StrokeCap.round;
    canvas.drawLine(
      Offset(left - 18, centerY),
      Offset(size.width - 12, centerY - 1),
      marker,
    );
  }

  @override
  bool shouldRepaint(_RulerPainter old) => old.exact != exact;
}

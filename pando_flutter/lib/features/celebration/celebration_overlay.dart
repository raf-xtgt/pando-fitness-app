import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

import '../../app/theme.dart';
import '../mascot/floating_mascot.dart';

/// A full-screen celebration (also called a milestone or interstitial
/// screen): the mascot floats with one short line; by default it also pops
/// in and confetti falls ([festive]).
/// It closes by itself after [duration], or early on a tap anywhere or on
/// the ✕. Reusable for any milestone: pass a different still and text.
class CelebrationOverlay extends StatefulWidget {
  const CelebrationOverlay({
    super.key,
    required this.image,
    required this.title,
    this.highlight,
    this.subtitle,
    this.duration = defaultDuration,
    this.festive = true,
  });

  /// Tunable: how long a celebration stays up if nobody taps.
  static const Duration defaultDuration = Duration(seconds: 3);

  /// Which 512 px mascot still to show (`AssetManifest.mascotStill*`).
  final String image;

  final String title;

  /// Optional widget between the mascot and the title, e.g. fire lettering.
  final Widget? highlight;

  final String? subtitle;
  final Duration duration;

  /// Pop-in and confetti. Off for a calm moment: only the floating mascot.
  final bool festive;

  /// Pushes the overlay as a full-screen route. Completes when it closes.
  static Future<void> show(BuildContext context, CelebrationOverlay overlay) {
    return Navigator.of(context).push(
      PageRouteBuilder<void>(
        transitionDuration: const Duration(milliseconds: 250),
        reverseTransitionDuration: const Duration(milliseconds: 200),
        pageBuilder: (_, _, _) => overlay,
        transitionsBuilder: (_, animation, _, child) =>
            FadeTransition(opacity: animation, child: child),
      ),
    );
  }

  @override
  State<CelebrationOverlay> createState() => _CelebrationOverlayState();
}

class _CelebrationOverlayState extends State<CelebrationOverlay>
    with TickerProviderStateMixin {
  late final AnimationController _popIn = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 700),
  );

  /// Seconds since the overlay opened; drives the confetti.
  final ValueNotifier<double> _seconds = ValueNotifier(0);
  late final Ticker _ticker = createTicker(
    (elapsed) => _seconds.value = elapsed.inMicroseconds / 1e6,
  );
  late final Timer _timer;
  bool _closed = false;

  @override
  void initState() {
    super.initState();
    _timer = Timer(widget.duration, _close);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Not festive, or "remove animations" on: no pop, no falling confetti.
    if (!widget.festive || MediaQuery.disableAnimationsOf(context)) {
      _popIn.value = 1;
      if (_ticker.isActive) _ticker.stop();
    } else {
      if (_popIn.value == 0) _popIn.forward();
      if (!_ticker.isActive) _ticker.start();
    }
  }

  /// Closes once, whichever comes first: the timer, a tap or the ✕.
  void _close() {
    if (_closed || !mounted) return;
    _closed = true;
    Navigator.of(context).pop();
  }

  @override
  void dispose() {
    _timer.cancel();
    _popIn.dispose();
    _ticker.dispose();
    _seconds.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    return Scaffold(
      body: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: _close,
        child: Stack(
          children: [
            Positioned.fill(
              child: IgnorePointer(
                child: CustomPaint(painter: _ConfettiPainter(_seconds)),
              ),
            ),
            SafeArea(
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ScaleTransition(
                        scale: CurvedAnimation(
                          parent: _popIn,
                          curve: Curves.elasticOut,
                        ),
                        child: FloatingMascot(image: widget.image, size: 260),
                      ),
                      if (widget.highlight case final highlight?) ...[
                        const SizedBox(height: 8),
                        highlight,
                      ],
                      const SizedBox(height: 16),
                      Text(
                        widget.title,
                        textAlign: TextAlign.center,
                        style: text.headlineSmall!.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      if (widget.subtitle case final subtitle?) ...[
                        const SizedBox(height: 8),
                        Text(
                          subtitle,
                          textAlign: TextAlign.center,
                          style: text.titleMedium,
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ),
            SafeArea(
              child: Align(
                alignment: Alignment.topRight,
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: IconButton(
                    onPressed: _close,
                    tooltip: 'Close',
                    iconSize: 30,
                    color: PandoColors.ink,
                    icon: const Icon(Icons.close),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Paper confetti falling across the screen: small squares and dots that
/// drift sideways and spin. Positions come from a fixed seed, so every
/// celebration looks the same and nothing is allocated per frame.
class _ConfettiPainter extends CustomPainter {
  _ConfettiPainter(this.seconds) : super(repaint: seconds);

  final ValueListenable<double> seconds;

  /// Tunable: seconds for an average piece to fall the full height.
  static const double fallSeconds = 2.6;

  static const List<Color> _colors = [
    PandoColors.fire,
    PandoColors.accent,
    Color(0xFFF6B53A), // fire yellow
    Color(0xFF7CCFC8), // mascot teal
    Color(0xFFF2A1A8), // cheek pink
  ];

  static final List<_Piece> _pieces = () {
    final random = math.Random(7);
    return List.generate(46, (i) {
      return _Piece(
        x: random.nextDouble(),
        phase: random.nextDouble(),
        speed: 0.75 + random.nextDouble() * 0.5,
        drift: 10 + random.nextDouble() * 20,
        size: 6 + random.nextDouble() * 6,
        spin: (random.nextDouble() - 0.5) * 12,
        round: i % 3 == 0,
        color: _colors[i % _colors.length],
      );
    });
  }();

  @override
  void paint(Canvas canvas, Size size) {
    final t = seconds.value / fallSeconds;
    final paint = Paint();
    if (t == 0) return;
    for (final p in _pieces) {
      // Each piece falls from just above the top to just below the
      // bottom, then starts again; its phase spreads the pieces out.
      final fall = (t * p.speed + p.phase) % 1.0;
      final y = -20 + fall * (size.height + 40);
      final x =
          p.x * size.width + math.sin((fall + p.phase) * 2 * math.pi) * p.drift;
      paint.color = p.color;
      canvas
        ..save()
        ..translate(x, y)
        ..rotate(fall * p.spin);
      if (p.round) {
        canvas.drawCircle(Offset.zero, p.size / 2, paint);
      } else {
        canvas.drawRect(
          Rect.fromCenter(
            center: Offset.zero,
            width: p.size,
            height: p.size * 0.6,
          ),
          paint,
        );
      }
      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(_ConfettiPainter old) => false;
}

class _Piece {
  const _Piece({
    required this.x,
    required this.phase,
    required this.speed,
    required this.drift,
    required this.size,
    required this.spin,
    required this.round,
    required this.color,
  });

  final double x;
  final double phase;
  final double speed;
  final double drift;
  final double size;
  final double spin;
  final bool round;
  final Color color;
}

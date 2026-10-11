import 'package:flutter/material.dart';

import '../features/home/home_screen.dart';
import '../features/mascot/mascot_sprite.dart';
import '../features/timeline/timeline_screen.dart';
import 'theme.dart';

/// The two main tabs after onboarding, with a floating paper bar: one
/// closed capsule over the bottom of the screen holding **Home** (default)
/// and **Timeline**, with the mascot breaking through its top edge in the
/// middle. The pages scroll under it. Tapping the mascot starts a walk (or finishes one left in
/// progress). Both tabs stay alive (`IndexedStack`), so Home keeps its list
/// and scroll when you switch.
class MainShell extends StatefulWidget {
  const MainShell({super.key});

  /// The open tab: 0 Home, 1 Timeline. Other screens set it, e.g. the
  /// report's **Timeline** button.
  static final ValueNotifier<int> tab = ValueNotifier(0);

  static const int home = 0;
  static const int timeline = 1;

  /// Bottom padding for a tab's scrolling list, so its end clears the
  /// floating bar and the mascot's bubble.
  static const double contentBottomInset = 150;

  /// Closes the screens on top and shows the Timeline tab.
  static void openTimeline(BuildContext context) {
    Navigator.of(context).popUntil((route) => route.isFirst);
    tab.value = timeline;
  }

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  final _home = GlobalKey<HomeScreenState>();

  /// The walk starts from Home (its permission and "no plan" messages show
  /// there), so switch to Home first.
  void _startFromMascot() {
    MainShell.tab.value = MainShell.home;
    _home.currentState?.start();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<int>(
      valueListenable: MainShell.tab,
      builder: (context, current, _) => Scaffold(
        // The pages run under the floating bar; their lists leave room at
        // the bottom (`MainShell.contentBottomInset`).
        extendBody: true,
        body: IndexedStack(
          index: current,
          children: [
            HomeScreen(key: _home),
            TimelineScreen(visible: current == MainShell.timeline),
          ],
        ),
        bottomNavigationBar: _FloatingBar(
          current: current,
          onSelect: (i) => MainShell.tab.value = i,
          mascot: _MascotButton(
            showBubble: current == MainShell.home,
            onTap: _startFromMascot,
          ),
        ),
      ),
    );
  }
}

/// The mascot's paper circle, the capsule's height, and how far the circle
/// rises above the capsule's top edge.
const double _buttonSize = 72;
const double _pillHeight = 62;
const double _rise = 24;

/// The mascot in a paper circle, raised over the bar, with a speech bubble
/// above it on Home.
class _MascotButton extends StatelessWidget {
  const _MascotButton({required this.showBubble, required this.onTap});

  final bool showBubble;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: HomeScreen.walkInProgress,
      builder: (context, inProgress, _) {
        final label = inProgress
            ? 'Tap me to finish your walk'
            : 'Tap me to start!';
        return SizedBox.square(
          dimension: _buttonSize,
          child: Stack(
            clipBehavior: Clip.none,
            alignment: Alignment.center,
            children: [
              Semantics(
                button: true,
                label: inProgress ? 'Finish your walk' : 'Start a walk',
                child: GestureDetector(
                  onTap: onTap,
                  child: Container(
                    decoration: BoxDecoration(
                      color: PandoColors.paper,
                      shape: BoxShape.circle,
                      border: Border.all(color: PandoColors.ink, width: 2.4),
                    ),
                    alignment: Alignment.center,
                    child: const ExcludeSemantics(
                      child: MascotSprite(size: 70),
                    ),
                  ),
                ),
              ),
              Positioned(
                bottom: _buttonSize + 6,
                child: IgnorePointer(
                  child: AnimatedOpacity(
                    opacity: showBubble ? 1 : 0,
                    duration: const Duration(milliseconds: 200),
                    child: ExcludeSemantics(child: _Bubble(text: label)),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

/// A small paper speech bubble with its tail pointing down at the mascot.
class _Bubble extends StatelessWidget {
  const _Bubble({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        WobblyBox(
          seed: 61,
          strokeWidth: 2.2,
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
          child: Text(
            text,
            maxLines: 1,
            softWrap: false,
            style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
          ),
        ),
        CustomPaint(size: const Size(16, 9), painter: _TailPainter()),
      ],
    );
  }
}

/// The bubble's tail: a small paper triangle, ink on its two slanted sides,
/// drawn over the bubble's bottom edge so it looks joined.
class _TailPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final path = Path()
      ..moveTo(0, -2.5)
      ..lineTo(size.width / 2, size.height)
      ..lineTo(size.width, -2.5);
    canvas.drawPath(
      Path.from(path)..close(),
      Paint()..color = PandoColors.paper,
    );
    canvas.drawPath(
      path,
      Paint()
        ..color = PandoColors.ink
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.2
        ..strokeJoin = StrokeJoin.round,
    );
  }

  @override
  bool shouldRepaint(_TailPainter old) => false;
}

/// The floating capsule: paper, rounded ends, ink border and a soft
/// shadow, inset from the screen edges; the two tabs inside, the mascot
/// centred over its top edge.
class _FloatingBar extends StatelessWidget {
  const _FloatingBar({
    required this.current,
    required this.onSelect,
    required this.mascot,
  });

  final int current;
  final ValueChanged<int> onSelect;
  final Widget mascot;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(18, 0, 18, 12),
        child: SizedBox(
          height: _pillHeight + _rise,
          child: Stack(
            clipBehavior: Clip.none,
            alignment: Alignment.topCenter,
            children: [
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                height: _pillHeight,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: PandoColors.paper,
                    borderRadius: BorderRadius.circular(_pillHeight / 2),
                    border: Border.all(color: PandoColors.ink, width: 2.2),
                    boxShadow: [
                      BoxShadow(
                        color: PandoColors.ink.withValues(alpha: 0.18),
                        blurRadius: 14,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      _Item(
                        icon: Icons.home_rounded,
                        label: 'Home',
                        selected: current == MainShell.home,
                        onTap: () => onSelect(MainShell.home),
                      ),
                      // Room for the mascot.
                      const SizedBox(width: _buttonSize + 28),
                      _Item(
                        icon: Icons.route_rounded,
                        label: 'Timeline',
                        selected: current == MainShell.timeline,
                        onTap: () => onSelect(MainShell.timeline),
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(top: 0, child: mascot),
            ],
          ),
        ),
      ),
    );
  }
}

/// One tab: icon over label; the selected one is ink and bold with a short
/// fire-orange stroke under it, the other faded.
class _Item extends StatelessWidget {
  const _Item({
    required this.icon,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color = selected
        ? PandoColors.ink
        : PandoColors.ink.withValues(alpha: 0.45);
    return Expanded(
      child: Semantics(
        button: true,
        selected: selected,
        label: label,
        child: InkResponse(
          onTap: onTap,
          highlightShape: BoxShape.rectangle,
          child: ExcludeSemantics(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, color: color, size: 26),
                Text(
                  label,
                  style: TextStyle(
                    color: color,
                    fontSize: 14,
                    fontWeight: selected ? FontWeight.w700 : FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 3),
                AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  height: 3,
                  width: selected ? 26 : 0,
                  decoration: BoxDecoration(
                    color: PandoColors.fire,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';

import '../features/home/home_screen.dart';
import '../features/timeline/timeline_screen.dart';
import 'theme.dart';

/// The two main tabs after onboarding, with a paper bottom bar: **Home**
/// (default) and **Timeline**. Both stay alive (`IndexedStack`), so Home
/// keeps its list and scroll when you switch.
class MainShell extends StatelessWidget {
  const MainShell({super.key});

  /// The open tab: 0 Home, 1 Timeline. Other screens set it, e.g. the
  /// report's **Timeline** button.
  static final ValueNotifier<int> tab = ValueNotifier(0);

  static const int home = 0;
  static const int timeline = 1;

  /// Closes the screens on top and shows the Timeline tab.
  static void openTimeline(BuildContext context) {
    Navigator.of(context).popUntil((route) => route.isFirst);
    tab.value = timeline;
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<int>(
      valueListenable: tab,
      builder: (context, current, _) => Scaffold(
        body: IndexedStack(
          index: current,
          children: [
            const HomeScreen(),
            TimelineScreen(visible: current == timeline),
          ],
        ),
        bottomNavigationBar: _BottomBar(
          current: current,
          onSelect: (i) => tab.value = i,
        ),
      ),
    );
  }
}

class _BottomBar extends StatelessWidget {
  const _BottomBar({required this.current, required this.onSelect});

  final int current;
  final ValueChanged<int> onSelect;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: PandoColors.paper,
        border: Border(top: BorderSide(color: PandoColors.ink, width: 1.4)),
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: 64,
          child: Row(
            children: [
              _Item(
                icon: Icons.home_rounded,
                label: 'Home',
                selected: current == MainShell.home,
                onTap: () => onSelect(MainShell.home),
              ),
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

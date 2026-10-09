import 'package:flutter/material.dart';

import '../../app/theme.dart';
import '../mascot/floating_mascot.dart';

/// "Loading your walk…" with the floating mascot, on paper. The replay page's
/// `web/index.html` shows the same look while Flutter starts, and the report
/// shows it while the WebView starts, so the loading looks like one piece.
class ReplayLoading extends StatelessWidget {
  const ReplayLoading({super.key});

  static const String text = 'Loading your walk…';

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: PandoColors.paper,
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const FloatingMascot(size: 120),
            const SizedBox(height: 12),
            Text(text, style: Theme.of(context).textTheme.bodyLarge),
          ],
        ),
      ),
    );
  }
}

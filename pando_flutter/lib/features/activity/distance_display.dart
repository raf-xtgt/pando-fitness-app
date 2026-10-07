import 'package:flutter/material.dart';

import '../../app/theme.dart';

/// "Remaining XYZ m till the goal", rounded to whole metres.
class DistanceDisplay extends StatelessWidget {
  const DistanceDisplay({super.key, required this.remainingMetres});

  final double remainingMetres;

  @override
  Widget build(BuildContext context) {
    final style = Theme.of(context).textTheme.titleMedium!.copyWith(
      fontWeight: FontWeight.w600,
    );
    return WobblyBox(
      seed: 7,
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
      child: Text.rich(
        TextSpan(
          style: style,
          children: [
            const TextSpan(text: 'Remaining '),
            TextSpan(
              text: '${remainingMetres.round()} m',
              style: const TextStyle(fontSize: 26, fontWeight: FontWeight.w700),
            ),
            const TextSpan(text: ' till the goal'),
          ],
        ),
      ),
    );
  }
}

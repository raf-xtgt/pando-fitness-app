import 'package:flutter/material.dart';

import '../../app/theme.dart';

/// What the mascot says, in a hand-drawn speech bubble.
class MascotBubble extends StatelessWidget {
  const MascotBubble(this.text, {super.key});

  static const String greeting =
      "Just start walking or running, we'll take it from here.";

  final String text;

  @override
  Widget build(BuildContext context) {
    return WobblyBox(
      seed: 13,
      strokeWidth: 2.4,
      padding: const EdgeInsets.fromLTRB(18, 12, 18, 14),
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: Theme.of(
          context,
        ).textTheme.titleMedium!.copyWith(fontWeight: FontWeight.w600),
      ),
    );
  }
}

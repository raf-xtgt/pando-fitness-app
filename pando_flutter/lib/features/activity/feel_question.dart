import 'package:flutter/material.dart';
import 'package:pando_client/pando_client.dart';

import '../../app/theme.dart';

/// The mascot asks "How did that feel?". One tap answers; Skip is fine too.
class FeelQuestion extends StatelessWidget {
  const FeelQuestion({super.key, required this.onAnswer});

  /// Called with the answer, or null for Skip.
  final ValueChanged<Feel?> onAnswer;

  static const Map<Feel, String> labels = {
    Feel.tooEasy: 'Too easy',
    Feel.justRight: 'Just right',
    Feel.tooHard: 'Too hard',
  };

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    return WobblyBox(
      seed: 21,
      strokeWidth: 2.6,
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 12),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'How did that feel?',
            style: text.titleLarge!.copyWith(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 14),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            alignment: WrapAlignment.center,
            children: [
              for (final entry in labels.entries)
                _Choice(
                  label: entry.value,
                  seed: entry.key.index + 30,
                  onTap: () => onAnswer(entry.key),
                ),
            ],
          ),
          TextButton(
            onPressed: () => onAnswer(null),
            style: TextButton.styleFrom(foregroundColor: PandoColors.ink),
            child: const Text('Skip'),
          ),
        ],
      ),
    );
  }
}

class _Choice extends StatelessWidget {
  const _Choice({required this.label, required this.seed, required this.onTap});

  final String label;
  final int seed;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      child: GestureDetector(
        onTap: onTap,
        child: WobblyBox(
          seed: seed,
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          child: Text(
            label,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
        ),
      ),
    );
  }
}

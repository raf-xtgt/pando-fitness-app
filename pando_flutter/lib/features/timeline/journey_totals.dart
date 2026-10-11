import 'package:flutter/material.dart';
import 'package:pando_client/pando_client.dart';

import '../../app/theme.dart';
import '../../domain/units.dart';

/// Steps, km and hours over every walk, in three paper tiles. On Home (in
/// place of the old **+**) and at the top of the Timeline.
class JourneyTotals extends StatelessWidget {
  const JourneyTotals({
    super.key,
    required this.steps,
    required this.metres,
    required this.seconds,
  });

  /// From the server's timeline totals.
  JourneyTotals.of(TimelinePage page, {Key? key})
    : this(
        key: key,
        steps: page.totalSteps,
        metres: page.totalM,
        seconds: page.totalS,
      );

  final int steps;
  final double metres;
  final double seconds;

  @override
  Widget build(BuildContext context) {
    final km = metres / 1000;
    final hours = seconds / 3600;
    return Row(
      children: [
        Expanded(
          child: _Tile(seed: 51, value: formatCount(steps), unit: 'steps'),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _Tile(
            seed: 52,
            value: km.toStringAsFixed(km < 10 ? 2 : 1),
            unit: 'km',
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _Tile(
            seed: 53,
            value: hours.toStringAsFixed(1),
            unit: hours == 1 ? 'hour' : 'hours',
          ),
        ),
      ],
    );
  }
}

class _Tile extends StatelessWidget {
  const _Tile({required this.seed, required this.value, required this.unit});

  final int seed;
  final String value;
  final String unit;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: '$value $unit',
      child: ExcludeSemantics(
        child: WobblyBox(
          seed: seed,
          strokeWidth: 2.4,
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 12),
          child: Column(
            children: [
              FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  value,
                  style: const TextStyle(
                    fontSize: 26,
                    height: 1.1,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              Text(unit, style: const TextStyle(fontSize: 15)),
            ],
          ),
        ),
      ),
    );
  }
}

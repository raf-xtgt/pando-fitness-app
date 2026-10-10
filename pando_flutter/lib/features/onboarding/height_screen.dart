import 'dart:async';

import 'package:flutter/material.dart';

import '../../app/onboarding.dart';
import '../../app/theme.dart';
import '../../domain/units.dart';
import '../../services/app_services.dart';
import '../../services/pending_queue.dart';
import 'ruler_slider.dart';

/// First launch: one fun picker, so steps can become distance.
class HeightScreen extends StatefulWidget {
  const HeightScreen({super.key});

  @override
  State<HeightScreen> createState() => _HeightScreenState();
}

class _HeightScreenState extends State<HeightScreen> {
  int _inches = defaultHeightInches;

  Future<void> _confirm() async {
    final services = AppServices.instance;
    final metres = inchesToMetres(_inches);
    // Cached first, so Pando works even if the server can't be reached;
    // the queue sends it when it can.
    await services.cache.setHeightMetres(metres);
    unawaited(
      services.queue.add(PendingQueue.saveHeightOp, {'heightM': metres}),
    );
    if (!mounted) return;
    // Then the safety check (unless it was answered already).
    await Navigator.of(context).pushReplacement(
      MaterialPageRoute<void>(
        builder: (_) => nextOnboardingScreen(services.cache),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 24, 24, 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'How tall are you?',
                style: text.headlineSmall!.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                'Pando uses it to turn your steps into distance.',
                style: text.bodyLarge,
              ),
              const SizedBox(height: 16),
              Expanded(
                child: Row(
                  children: [
                    Expanded(
                      child: RulerSlider(
                        inches: _inches,
                        onChanged: (v) => setState(() => _inches = v),
                      ),
                    ),
                    Text(
                      formatFeetInches(_inches),
                      style: text.headlineMedium!.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Center(
                child: GestureDetector(
                  onTap: _confirm,
                  child: const WobblyBox(
                    seed: 11,
                    strokeWidth: 2.6,
                    padding: EdgeInsets.symmetric(horizontal: 36, vertical: 14),
                    child: Text(
                      "That's me",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

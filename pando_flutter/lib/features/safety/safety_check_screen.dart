import 'dart:async';

import 'package:flutter/material.dart';
import 'package:pando_client/pando_client.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../app/main_shell.dart';
import '../../app/theme.dart';
import '../../services/app_services.dart';
import '../../services/pending_queue.dart';
import '../mascot/floating_mascot.dart';

/// A calm health check before the first walk. Pando doesn't show the PAR-Q+
/// questions itself (its terms forbid partial or electronic copies without
/// the PAR-Q+ Collaboration's written consent): it opens the official form,
/// asks the walker to confirm they completed it, and keeps their result.
/// "Yes, some apply" gets a warm doctor note and never blocks.
class SafetyCheckScreen extends StatefulWidget {
  const SafetyCheckScreen({super.key, this.openForm = openOfficialParq});

  /// The official PAR-Q+ (always the current edition there).
  static final Uri officialForm = Uri.parse('https://eparmedx.com/');

  /// Stored with the answer: which edition the walker was pointed to.
  static const String version = 'PAR-Q+ 2025 (eparmedx.com)';

  /// Opens the form; tests swap it.
  final Future<void> Function() openForm;

  static Future<void> openOfficialParq() async {
    await launchUrl(officialForm, mode: LaunchMode.externalApplication);
  }

  @override
  State<SafetyCheckScreen> createState() => _SafetyCheckScreenState();
}

class _SafetyCheckScreenState extends State<SafetyCheckScreen> {
  bool _confirmed = false;

  /// Set after "Yes, some apply": shows the doctor note, then Continue.
  bool _showNote = false;

  Future<void> _answer(ScreeningResult result) async {
    final services = AppServices.instance;
    // Cached first (asked once), then sent through the pending queue.
    await services.cache.setScreening(result);
    unawaited(
      services.queue.add(PendingQueue.saveScreeningOp, {
        'result': result.toJson(),
        'version': SafetyCheckScreen.version,
      }),
    );
    if (!mounted) return;
    if (result == ScreeningResult.someApply) {
      setState(() => _showNote = true);
    } else {
      _goHome();
    }
  }

  void _goHome() => Navigator.of(context).pushReplacement(
    MaterialPageRoute<void>(builder: (_) => const MainShell()),
  );

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
          children: [
            const Center(child: FloatingMascot(size: 120, lift: 0.03)),
            const SizedBox(height: 12),
            Text(
              'Before you get moving',
              textAlign: TextAlign.center,
              style: text.headlineSmall!.copyWith(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 16),
            if (_showNote) ..._note(text) else ..._check(text),
          ],
        ),
      ),
    );
  }

  List<Widget> _check(TextTheme text) => [
    Text(
      'Walking is safe for most people. The PAR-Q+, a short official '
      'questionnaire with 7 general health questions, tells you if you '
      'should talk to a doctor or a qualified exercise professional before '
      'becoming more active.',
      style: text.bodyLarge!.copyWith(height: 1.4),
    ),
    const SizedBox(height: 20),
    Center(
      child: _PaperButton(
        label: 'Open the PAR-Q+',
        icon: Icons.open_in_new,
        seed: 41,
        onTap: widget.openForm,
      ),
    ),
    const SizedBox(height: 6),
    Text(
      'eparmedx.com, the official site',
      textAlign: TextAlign.center,
      style: text.bodySmall,
    ),
    const SizedBox(height: 24),
    CheckboxListTile(
      value: _confirmed,
      onChanged: (v) => setState(() => _confirmed = v ?? false),
      controlAffinity: ListTileControlAffinity.leading,
      contentPadding: EdgeInsets.zero,
      activeColor: PandoColors.accent,
      title: Text(
        'I have read and answered the official PAR-Q+ on eparmedx.com.',
        style: text.bodyLarge,
      ),
    ),
    const SizedBox(height: 12),
    Text(
      'What did it say?',
      style: text.titleMedium!.copyWith(fontWeight: FontWeight.w700),
    ),
    const SizedBox(height: 12),
    Opacity(
      opacity: _confirmed ? 1 : 0.4,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _PaperButton(
            label: 'None apply',
            seed: 43,
            onTap: _confirmed ? () => _answer(ScreeningResult.noneApply) : null,
          ),
          const SizedBox(height: 12),
          _PaperButton(
            label: 'Yes, some apply',
            seed: 47,
            onTap: _confirmed ? () => _answer(ScreeningResult.someApply) : null,
          ),
        ],
      ),
    ),
    const SizedBox(height: 24),
    Text(
      'Pando keeps only your answer, the date and the PAR-Q+ edition. '
      'PAR-Q+ © PAR-Q+ Collaboration.',
      style: text.bodySmall,
    ),
  ];

  List<Widget> _note(TextTheme text) => [
    WobblyBox(
      seed: 53,
      strokeWidth: 2.6,
      padding: const EdgeInsets.fromLTRB(20, 18, 20, 20),
      child: Text(
        'Thanks for checking. Please talk with your doctor or a qualified '
        'exercise professional before you increase your activity. Pando '
        'keeps your goals gentle, so you can walk at your own pace.',
        style: text.titleMedium!.copyWith(height: 1.4),
      ),
    ),
    const SizedBox(height: 24),
    Center(
      child: _PaperButton(label: 'Continue', seed: 59, onTap: _goHome),
    ),
  ];
}

/// A hand-drawn button; greyed and inert when [onTap] is null.
class _PaperButton extends StatelessWidget {
  const _PaperButton({
    required this.label,
    required this.seed,
    required this.onTap,
    this.icon,
  });

  final String label;
  final int seed;
  final VoidCallback? onTap;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      enabled: onTap != null,
      label: label,
      child: GestureDetector(
        onTap: onTap,
        child: WobblyBox(
          seed: seed,
          strokeWidth: 2.6,
          padding: const EdgeInsets.symmetric(horizontal: 26, vertical: 14),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (icon != null) ...[
                Icon(icon, color: PandoColors.ink),
                const SizedBox(width: 8),
              ],
              Text(
                label,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

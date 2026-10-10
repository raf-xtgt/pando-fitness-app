import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../app/onboarding.dart';
import '../../game/asset_manifest.dart';
import '../../services/app_services.dart';
import '../mascot/floating_mascot.dart';

/// Wordmark, floating mascot and welcome while startup runs: sign in, send
/// anything queued, fetch the profile. Then Home, or Height on first
/// launch. If the server can't be reached, the cached profile decides.
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  /// The wordmark stays up at least this long, even on a fast start.
  static const Duration minimumShow = Duration(milliseconds: 3500);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    unawaited(_startup());
  }

  Future<void> _startup() async {
    final shown = Future<void>.delayed(SplashScreen.minimumShow);
    final services = AppServices.instance;
    try {
      await services.queue.flush();
      final profile = await services.api.getProfile();
      final height = profile?.heightM;
      if (height != null) await services.cache.setHeightMetres(height);
      final screening = profile?.screeningResult;
      if (screening != null) await services.cache.setScreening(screening);
    } catch (e) {
      debugPrint('Pando startup: server not reached, using cache ($e)');
    }
    await shown;
    if (!mounted) return;

    await Navigator.of(context).pushReplacement(
      MaterialPageRoute<void>(
        builder: (_) => nextOnboardingScreen(services.cache),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // The mascot is the focus: its visible body (~230 px of the
                // 280 px box) is wider than the wordmark.
                SvgPicture.asset(AssetManifest.wordmark, width: 200),
                const FloatingMascot(size: 280),
                const SizedBox(height: 8),
                Text(
                  'Your pace, your path.\nEvery step counts here.',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

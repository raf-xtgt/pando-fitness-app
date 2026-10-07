import 'package:flutter/material.dart';

import '../features/splash/splash_screen.dart';
import 'theme.dart';

/// The app shell: Splash → Height (first launch) or Home. Report arrives in
/// slice 4.
class PandoApp extends StatelessWidget {
  const PandoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pando',
      debugShowCheckedModeBanner: false,
      theme: buildPandoTheme(),
      home: const SplashScreen(),
    );
  }
}

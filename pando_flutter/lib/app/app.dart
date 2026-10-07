import 'package:flutter/material.dart';

import '../features/home/home_screen.dart';
import 'theme.dart';

/// The app shell. Splash and Height arrive in slice 2, Report in slice 4.
class PandoApp extends StatelessWidget {
  const PandoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pando',
      debugShowCheckedModeBanner: false,
      theme: buildPandoTheme(),
      home: const HomeScreen(),
    );
  }
}

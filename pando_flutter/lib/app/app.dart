import 'package:flutter/material.dart';

import '../features/report/report_screen.dart';
import '../features/splash/splash_screen.dart';
import '../services/app_services.dart';
import 'theme.dart';

/// The app shell: Splash → Height (first launch) or Home. A tapped report
/// notification opens Report on top of whatever is showing.
class PandoApp extends StatefulWidget {
  const PandoApp({super.key});

  @override
  State<PandoApp> createState() => _PandoAppState();
}

class _PandoAppState extends State<PandoApp> {
  final _navigator = GlobalKey<NavigatorState>();

  @override
  void initState() {
    super.initState();
    AppServices.instance.push.onOpenReport = (sessionId) =>
        _navigator.currentState?.push(
          MaterialPageRoute<void>(
            builder: (_) => ReportScreen(sessionId: sessionId),
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pando',
      navigatorKey: _navigator,
      debugShowCheckedModeBanner: false,
      theme: buildPandoTheme(),
      home: const SplashScreen(),
    );
  }
}

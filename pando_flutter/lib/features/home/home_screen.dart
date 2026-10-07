import 'package:flutter/material.dart';

import '../../app/theme.dart';
import '../../services/step_counter_service.dart';
import '../activity/activity_screen.dart';

/// A big + to start walking. The session list arrives in slice 3.
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String? _message;

  Future<void> _start() async {
    setState(() => _message = null);
    final granted = await requestStepPermission();
    if (!mounted) return;
    if (!granted) {
      setState(() => _message = 'App needs permission to continue');
      return;
    }
    await Navigator.of(
      context,
    ).push(MaterialPageRoute<void>(builder: (_) => const ActivityScreen()));
  }

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Pando',
                style: text.headlineMedium!.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 40),
              Center(
                child: Semantics(
                  button: true,
                  label: 'Start an activity',
                  child: GestureDetector(
                    onTap: _start,
                    child: const WobblyBox(
                      seed: 3,
                      strokeWidth: 3,
                      padding: EdgeInsets.fromLTRB(44, 8, 44, 18),
                      child: Text(
                        '+',
                        style: TextStyle(
                          fontSize: 88,
                          height: 1,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              if (_message != null) ...[
                const SizedBox(height: 20),
                Center(child: Text(_message!, style: text.bodyLarge)),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

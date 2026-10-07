import 'dart:async';

import 'package:flutter/material.dart';

import '../../app/theme.dart';
import '../../services/app_services.dart';
import '../../services/step_counter_service.dart';
import '../activity/activity_screen.dart';
import 'session_row.dart';

/// A big + to start walking, and the walks so far (newest first).
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  /// Rows switch from "report on its way" without a reload.
  static const Duration rowTick = Duration(seconds: 20);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _services = AppServices.instance;
  String? _message;
  List<SessionRowData> _rows = [];
  Timer? _ticker;

  @override
  void initState() {
    super.initState();
    _rows = _buildRows();
    unawaited(_refresh());
    _ticker = Timer.periodic(HomeScreen.rowTick, (_) => setState(() {}));
  }

  @override
  void dispose() {
    _ticker?.cancel();
    super.dispose();
  }

  /// Queued sessions first (they're the newest), then the server's list.
  List<SessionRowData> _buildRows() {
    final cache = _services.cache;
    final saved = cache.sessions;
    final savedIds = {for (final s in saved) s.clientSessionId};
    final stride = cache.plan?.strideM ?? 0;
    final pending = [
      for (final input in _services.queue.pendingSessions.reversed)
        if (!savedIds.contains(input.clientSessionId))
          SessionRowData.pending(input, stride),
    ];
    return [...pending, for (final s in saved) SessionRowData.saved(s)];
  }

  /// Sends anything queued, then reloads the list and the next plan.
  Future<void> _refresh() async {
    try {
      await _services.queue.flush();
      final sessions = await _services.api.listSessions();
      await _services.cache.setSessions(sessions);
      if (_services.queue.pendingSessions.isEmpty) {
        // Only trust the server's plan once it has every session.
        await _services.cache.setPlan(await _services.api.plan());
      }
    } catch (e) {
      debugPrint('Pando home: server not reached, showing cache ($e)');
    }
    if (mounted) setState(() => _rows = _buildRows());
  }

  Future<void> _start() async {
    setState(() => _message = null);
    if (_services.cache.plan == null) await _refresh();
    final plan = _services.cache.plan;
    if (plan == null) {
      setState(
        () => _message =
            'Pando needs a connection the first time. '
            'Please try again with signal.',
      );
      return;
    }

    final granted = await requestStepPermission();
    if (!mounted) return;
    if (!granted) {
      setState(() => _message = 'App needs permission to continue');
      return;
    }
    await Navigator.of(context).push(
      MaterialPageRoute<void>(builder: (_) => ActivityScreen(plan: plan)),
    );
    if (!mounted) return;
    setState(() => _rows = _buildRows());
    unawaited(_refresh());
  }

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    return Scaffold(
      body: SafeArea(
        child: RefreshIndicator(
          color: PandoColors.ink,
          onRefresh: _refresh,
          child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            children: [
              Text(
                'Pando',
                style: text.headlineMedium!.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 32),
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
                Text(
                  _message!,
                  textAlign: TextAlign.center,
                  style: text.bodyLarge,
                ),
              ],
              if (_rows.isNotEmpty) ...[
                const SizedBox(height: 36),
                Text(
                  'Your walks',
                  style: text.titleLarge!.copyWith(fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 4),
                for (final row in _rows) ...[
                  const Divider(color: PandoColors.ink, thickness: 1.2),
                  SessionRow(data: row),
                ],
              ],
            ],
          ),
        ),
      ),
    );
  }
}

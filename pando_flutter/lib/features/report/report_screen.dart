import 'package:flutter/material.dart';
import 'package:pando_client/pando_client.dart';

import '../../app/main_shell.dart';
import '../../app/theme.dart';
import '../../services/app_services.dart';
import '../home/session_row.dart';
import '../replay/replay_share.dart';
import '../replay/replay_view.dart';

/// The delayed report for one session: a warm message, the walk's replay
/// (or "replay on its way"), then the summary.
/// Opened from the notification or a Home row; ✕ goes back.
class ReportScreen extends StatefulWidget {
  const ReportScreen({super.key, required this.sessionId});

  final int sessionId;

  @override
  State<ReportScreen> createState() => _ReportScreenState();
}

class _ReportScreenState extends State<ReportScreen> {
  late Future<SessionReport> _report = _load();

  Future<SessionReport> _load() =>
      AppServices.instance.api.report(widget.sessionId);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 8, 12, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Align(
                alignment: Alignment.centerRight,
                child: IconButton(
                  tooltip: 'Close',
                  iconSize: 32,
                  color: PandoColors.ink,
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(right: 12),
                  child: FutureBuilder<SessionReport>(
                    future: _report,
                    builder: (context, snap) {
                      if (snap.hasData) return _ReportBody(report: snap.data!);
                      if (snap.hasError) {
                        return _Unreachable(
                          onRetry: () => setState(() => _report = _load()),
                        );
                      }
                      return const Center(
                        child: CircularProgressIndicator(
                          color: PandoColors.ink,
                        ),
                      );
                    },
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

class _ReportBody extends StatelessWidget {
  const _ReportBody({required this.report});

  final SessionReport report;

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    return ListView(
      children: [
        Text(
          'Your report',
          style: text.headlineMedium!.copyWith(fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 4),
        Text(
          SessionRow.formatDate(report.endedAt),
          style: text.bodyLarge,
        ),
        const SizedBox(height: 28),
        WobblyBox(
          seed: 31,
          strokeWidth: 2.6,
          padding: const EdgeInsets.fromLTRB(20, 18, 20, 20),
          child: Text(
            report.message,
            style: text.titleLarge!.copyWith(height: 1.35),
          ),
        ),
        const SizedBox(height: 24),
        _Replay(replayId: report.replayId, distanceM: report.distanceM),
        const SizedBox(height: 24),
        _Line(label: 'This walk', value: '${report.distanceM.round()} m'),
        _Line(
          label: 'All your walks',
          value: '${report.totalDistanceAllM.round()} m',
        ),
        _Line(
          label: 'Goal accomplished',
          value: report.goalMet ? 'Yes' : 'Not this time',
        ),
        _Line(
          label: 'Extra distance',
          value: '${report.extraM.round()} m',
          valueColor: report.extraM > 0 ? PandoColors.fire : null,
        ),
      ],
    );
  }
}

/// The walk replayed on the park, in a fixed-height frame.
class _Replay extends StatelessWidget {
  const _Replay({required this.replayId, required this.distanceM});

  final UuidValue? replayId;
  final double distanceM;

  static const double height = 380;

  @override
  Widget build(BuildContext context) {
    final id = replayId;
    if (id == null) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          WobblyBox(
            seed: 23,
            padding: const EdgeInsets.all(18),
            child: Text(
              'Your replay is on its way. Open this report again in a moment.',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ),
          const SizedBox(height: 14),
          const Center(child: _TimelineButton()),
        ],
      );
    }
    final link = AppServices.instance.api.replayPage(id);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        WobblyBox(
          seed: 23,
          strokeWidth: 2.6,
          padding: const EdgeInsets.all(6),
          child: SizedBox(
            height: height,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(6),
              child: ReplayView(url: link),
            ),
          ),
        ),
        const SizedBox(height: 14),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _ReportButton(
              seed: 29,
              icon: Icons.share,
              label: 'Share',
              semantics: 'Share your walk',
              onTap: () => shareReplay(distanceM, link),
            ),
            const SizedBox(width: 12),
            const _TimelineButton(),
          ],
        ),
      ],
    );
  }
}

/// **Timeline**: closes the report and opens the Timeline tab.
class _TimelineButton extends StatelessWidget {
  const _TimelineButton();

  @override
  Widget build(BuildContext context) => _ReportButton(
    seed: 37,
    icon: Icons.route_rounded,
    label: 'Timeline',
    semantics: 'See your journey timeline',
    onTap: () => MainShell.openTimeline(context),
  );
}

/// A hand-drawn button under the replay: icon and label in a paper box.
class _ReportButton extends StatelessWidget {
  const _ReportButton({
    required this.seed,
    required this.icon,
    required this.label,
    required this.semantics,
    required this.onTap,
  });

  final int seed;
  final IconData icon;
  final String label;
  final String semantics;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => Semantics(
    button: true,
    label: semantics,
    child: GestureDetector(
      onTap: onTap,
      child: WobblyBox(
        seed: seed,
        strokeWidth: 2.6,
        padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 12),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: PandoColors.ink),
            const SizedBox(width: 8),
            Text(
              label,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
            ),
          ],
        ),
      ),
    ),
  );
}

/// One summary line: label on the left, value on the right, ink rule below.
class _Line extends StatelessWidget {
  const _Line({required this.label, required this.value, this.valueColor});

  final String label;
  final String value;
  final Color? valueColor;

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: PandoColors.ink, width: 1.2)),
      ),
      child: Row(
        children: [
          Expanded(child: Text(label, style: text.bodyLarge)),
          Text(
            value,
            style: text.titleMedium!.copyWith(
              fontWeight: FontWeight.w700,
              color: valueColor,
            ),
          ),
        ],
      ),
    );
  }
}

class _Unreachable extends StatelessWidget {
  const _Unreachable({required this.onRetry});

  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            "Pando couldn't reach your report just now.",
            textAlign: TextAlign.center,
            style: text.bodyLarge,
          ),
          const SizedBox(height: 16),
          GestureDetector(
            onTap: onRetry,
            child: const WobblyBox(seed: 7, child: Text('Try again')),
          ),
        ],
      ),
    );
  }
}

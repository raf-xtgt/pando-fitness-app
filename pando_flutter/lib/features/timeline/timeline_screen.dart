import 'dart:async';

import 'package:flutter/material.dart';
import 'package:pando_client/pando_client.dart';

import '../../app/main_shell.dart';
import '../../app/theme.dart';
import '../../domain/units.dart';
import '../../game/asset_manifest.dart';
import '../../services/app_services.dart';
import '../home/session_row.dart';
import '../mascot/floating_mascot.dart';
import '../report/report_screen.dart';
import 'journey_totals.dart';
import 'trail_layout.dart';

/// The journey timeline: totals over every walk (steps, km, hours), then the
/// trail of wooden signs, newest at the top, one per walk, each with the
/// journey total there. Five signs at a time; **Show earlier** adds the
/// five before. Tapping a sign opens that walk's report.
class TimelineScreen extends StatefulWidget {
  const TimelineScreen({super.key, required this.visible, this.load});

  /// Reloads from the newest page each time this turns true (the tab is
  /// opened), so a new walk shows up.
  final bool visible;

  /// Loads one page (0 = newest); the server's `session.timeline` unless a
  /// test passes its own.
  final Future<TimelinePage> Function(int page)? load;

  @override
  State<TimelineScreen> createState() => _TimelineScreenState();
}

class _TimelineScreenState extends State<TimelineScreen> {
  late final Future<TimelinePage> Function(int page) _load =
      widget.load ?? AppServices.instance.api.timeline;
  TimelinePage? _totals;
  final List<TimelineCheckpoint> _checkpoints = [];
  int _page = 0;
  bool _hasEarlier = false;
  bool _loading = false;
  bool _failed = false;

  @override
  void initState() {
    super.initState();
    if (widget.visible) unawaited(_reload());
  }

  @override
  void didUpdateWidget(TimelineScreen old) {
    super.didUpdateWidget(old);
    if (widget.visible && !old.visible) unawaited(_reload());
  }

  /// Back to the newest five, with fresh totals.
  Future<void> _reload() async {
    setState(() {
      _loading = true;
      _failed = false;
    });
    try {
      final page = await _load(0);
      if (!mounted) return;
      setState(() {
        _totals = page;
        _checkpoints
          ..clear()
          ..addAll(page.checkpoints);
        _page = 0;
        _hasEarlier = page.hasEarlier;
      });
    } catch (e) {
      debugPrint('Pando timeline: server not reached ($e)');
      if (mounted) setState(() => _failed = true);
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _showEarlier() async {
    setState(() => _loading = true);
    try {
      final page = await _load(_page + 1);
      if (!mounted) return;
      setState(() {
        _checkpoints.addAll(page.checkpoints);
        _page++;
        _hasEarlier = page.hasEarlier;
      });
    } catch (e) {
      debugPrint('Pando timeline: earlier page failed ($e)');
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  void _openReport(int sessionId) => Navigator.of(context).push(
    MaterialPageRoute<void>(
      builder: (_) => ReportScreen(sessionId: sessionId),
    ),
  );

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    final totals = _totals;
    return Scaffold(
      body: SafeArea(
        // The list runs under the floating bar (`MainShell`).
        bottom: false,
        child: RefreshIndicator(
          color: PandoColors.ink,
          onRefresh: _reload,
          child: ListView(
            // Room at the bottom for the floating bar.
            padding: const EdgeInsets.fromLTRB(
              20,
              16,
              20,
              MainShell.contentBottomInset,
            ),
            children: [
              Text(
                'Your journey',
                style: text.headlineMedium!.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 20),
              if (totals == null && _failed)
                Padding(
                  padding: const EdgeInsets.only(top: 40),
                  child: Text(
                    "Pando couldn't load your journey. "
                    'Pull down to try again.',
                    textAlign: TextAlign.center,
                    style: text.bodyLarge,
                  ),
                )
              else if (totals == null)
                const Padding(
                  padding: EdgeInsets.only(top: 60),
                  child: Center(
                    child: CircularProgressIndicator(color: PandoColors.ink),
                  ),
                )
              else ...[
                JourneyTotals.of(totals),
                if (_checkpoints.isEmpty)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 24),
                    child: Text(
                      'Your first walk puts the first sign here.',
                      textAlign: TextAlign.center,
                      style: text.bodyLarge,
                    ),
                  ),
                _Trail(
                  checkpoints: _checkpoints,
                  hasEarlier: _hasEarlier,
                  onOpen: _openReport,
                ),
                if (_hasEarlier)
                  Center(
                    child: Semantics(
                      button: true,
                      label: 'Show earlier walks',
                      child: GestureDetector(
                        onTap: _loading ? null : _showEarlier,
                        child: WobblyBox(
                          seed: 41,
                          strokeWidth: 2.6,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 12,
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(
                                Icons.expand_more_rounded,
                                color: PandoColors.ink,
                              ),
                              const SizedBox(width: 6),
                              Text(
                                _loading ? 'Loading…' : 'Show earlier',
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

/// The winding trail: signs, labels, footprints, and the mascot by the
/// newest sign. The start sign (0 m) closes the trail once every walk is
/// loaded; otherwise the prints fade out below the last sign.
class _Trail extends StatelessWidget {
  const _Trail({
    required this.checkpoints,
    required this.hasEarlier,
    required this.onOpen,
  });

  final List<TimelineCheckpoint> checkpoints;
  final bool hasEarlier;
  final ValueChanged<int> onOpen;

  static const double signHeight = 84;
  static const double printHeight = 40;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final showStart = !hasEarlier;
        final nodes = checkpoints.length + (showStart ? 1 : 0);
        final layout = TrailLayout(
          width: constraints.maxWidth,
          nodeCount: nodes,
          tail: hasEarlier ? 170 : 0,
          top: checkpoints.isEmpty ? 30 : 160,
        );
        // All prints in ink: a walk with a little running in it would read
        // as all running in orange (learner, 2026-10-12).
        final prints = <(Footprint, double fade)>[
          for (var i = 0; i < nodes - 1; i++)
            for (final p in layout.gap(i)) (p, 1.0),
          if (hasEarlier && checkpoints.isNotEmpty)
            for (final (n, p) in layout.gap(nodes - 1, fromBelow: true).indexed)
              (p, (n + 1) / TrailLayout.printsPerGap),
        ];
        return SizedBox(
          height: layout.height,
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              for (final (p, fade) in prints)
                Positioned(
                  left: p.position.dx - printHeight * 0.21,
                  top: p.position.dy - printHeight / 2,
                  child: Transform.rotate(
                    angle: p.angle,
                    child: Image.asset(
                      p.left
                          ? AssetManifest.printLeft
                          : AssetManifest.printRight,
                      height: printHeight,
                      color: PandoColors.ink.withValues(alpha: 0.8 * fade),
                      colorBlendMode: BlendMode.srcIn,
                      filterQuality: FilterQuality.medium,
                    ),
                  ),
                ),
              if (checkpoints.isNotEmpty)
                Positioned(
                  left: layout.node(0).dx - 40,
                  top: layout.node(0).dy - signHeight - 84,
                  child: const FloatingMascot(size: 80, lift: 0.06),
                ),
              for (var i = 0; i < checkpoints.length; i++)
                ..._node(
                  layout,
                  i,
                  _Label.checkpoint(checkpoints[i], newest: i == 0),
                  onTap: () => onOpen(checkpoints[i].sessionId),
                ),
              if (showStart) ..._node(layout, nodes - 1, const _Label.start()),
            ],
          ),
        );
      },
    );
  }

  /// The sign (base on the trail point) and its label on the open side.
  List<Widget> _node(
    TrailLayout layout,
    int i,
    _Label label, {
    VoidCallback? onTap,
  }) {
    final at = layout.node(i);
    final left = layout.isLeft(i);
    const signWidth = signHeight * 51 / 128;
    final labelWidth = layout.width * 0.5;
    return [
      Positioned(
        left: at.dx - signWidth / 2,
        top: at.dy - signHeight,
        child: Image.asset(
          AssetManifest.imagePrefix + AssetManifest.woodenSign,
          height: signHeight,
          filterQuality: FilterQuality.medium,
        ),
      ),
      Positioned(
        left: left ? at.dx + signWidth / 2 + 10 : null,
        right: left ? null : layout.width - at.dx + signWidth / 2 + 10,
        // Centred on the sign's base: the trail leaves upwards and arrives
        // from below, so this band beside the base stays clear of prints.
        top: at.dy - 44,
        width: labelWidth,
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: onTap,
          child: Align(
            alignment: left ? Alignment.centerLeft : Alignment.centerRight,
            child: label,
          ),
        ),
      ),
    ];
  }
}

/// A sign's words: the journey total big, then this walk and its date.
class _Label extends StatelessWidget {
  _Label.checkpoint(TimelineCheckpoint c, {required bool newest})
    : total = formatWalkDistance(c.totalM),
      line =
          '+${formatWalkDistance(c.distanceM)} · '
          '${formatStretchTime(c.durationS)}',
      date = newest ? 'Latest · ${_day(c.endedAt)}' : _day(c.endedAt),
      highlight = newest;

  const _Label.start()
    : total = '0 m',
      line = 'Start',
      date = null,
      highlight = false;

  /// "Sat 10 Oct" (the Home row's date without the time).
  static String _day(DateTime t) => SessionRow.formatDate(t).split(',').first;

  final String total;
  final String line;
  final String? date;
  final bool highlight;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: [total, line, ?date].join(', '),
      child: ExcludeSemantics(
        child: WobblyBox(
          seed: total.hashCode % 97,
          fill: highlight ? PandoColors.fire : PandoColors.paper,
          strokeWidth: 2.2,
          padding: const EdgeInsets.fromLTRB(12, 6, 12, 8),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                total,
                style: TextStyle(
                  fontSize: 22,
                  height: 1.15,
                  fontWeight: FontWeight.w700,
                  color: highlight ? PandoColors.paper : PandoColors.ink,
                ),
              ),
              Text(
                line,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: highlight ? PandoColors.paper : PandoColors.ink,
                ),
              ),
              if (date != null)
                Text(
                  date!,
                  style: TextStyle(
                    fontSize: 12.5,
                    color: (highlight ? PandoColors.paper : PandoColors.ink)
                        .withValues(alpha: 0.8),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

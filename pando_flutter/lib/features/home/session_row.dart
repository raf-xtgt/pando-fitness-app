import 'package:flutter/material.dart';
import 'package:pando_client/pando_client.dart';

import '../activity/feel_question.dart';

/// What one Home row shows. Built from a saved session, or from one still
/// waiting in the pending queue.
class SessionRowData {
  const SessionRowData({
    required this.clientSessionId,
    required this.endedAt,
    required this.distanceM,
    required this.goalMet,
    required this.feel,
    required this.reportReadyAt,
  });

  factory SessionRowData.saved(ActivitySession s) => SessionRowData(
    clientSessionId: s.clientSessionId,
    endedAt: s.endedAt,
    distanceM: s.distanceM,
    goalMet: s.goalMet,
    feel: s.feel,
    reportReadyAt: s.reportReadyAt,
  );

  /// A session the server hasn't received yet. [strideM] comes from the
  /// cached plan; the server computes the same numbers when it arrives.
  factory SessionRowData.pending(SessionInput input, double strideM) =>
      SessionRowData(
        clientSessionId: input.clientSessionId,
        endedAt: input.endedAt,
        distanceM: input.steps * strideM,
        goalMet: input.steps >= input.goalSteps,
        feel: input.feel,
        reportReadyAt: input.endedAt.add(const Duration(minutes: 5)),
      );

  final String clientSessionId;
  final DateTime endedAt;
  final double distanceM;
  final bool goalMet;
  final Feel? feel;
  final DateTime reportReadyAt;

  bool get reportPending => DateTime.now().isBefore(reportReadyAt);
}

class SessionRow extends StatelessWidget {
  const SessionRow({super.key, required this.data});

  final SessionRowData data;

  static const _days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
  static const _months = [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec',
  ];

  /// `Tue 7 Oct, 18:05` in the phone's time zone.
  static String formatDate(DateTime time) {
    final t = time.toLocal();
    String two(int n) => n.toString().padLeft(2, '0');
    return '${_days[t.weekday - 1]} ${t.day} ${_months[t.month - 1]}, '
        '${two(t.hour)}:${two(t.minute)}';
  }

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    final feel = data.feel;
    final details = [
      '${data.distanceM.round()} m',
      data.goalMet ? 'goal met' : 'goal not met',
      if (feel != null) 'felt ${FeelQuestion.labels[feel]!.toLowerCase()}',
    ].join(' · ');

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            formatDate(data.endedAt),
            style: text.titleMedium!.copyWith(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 2),
          Text(details, style: text.bodyLarge),
          if (data.reportPending) ...[
            const SizedBox(height: 4),
            Text(
              'Rest for now, report on its way.',
              style: text.bodyMedium!.copyWith(fontStyle: FontStyle.italic),
            ),
          ],
        ],
      ),
    );
  }
}

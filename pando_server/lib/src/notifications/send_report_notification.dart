import 'package:serverpod/serverpod.dart';

import '../generated/protocol.dart';
import '../pando_services.dart';
import '../replays/replay_store.dart';

/// The delayed report's push. `session.save` schedules it for
/// `reportReadyAt`; Serverpod runs it then (the local server, or the
/// maintenance job on Cloud Run). It also builds the walk's replay first,
/// so the report opens with it.
class SendReportNotificationFutureCall extends FutureCall {
  /// Sends at most once per session: `notificationSentAt` is set after a
  /// push succeeds, so a repeated run does nothing.
  Future<void> send(Session session, int sessionId) async {
    final found = await ActivitySession.db.findById(session, sessionId);
    if (found == null) {
      session.log('Report push: session $sessionId not found');
      return;
    }
    // Never blocks the push: without slices the report says "replay on its
    // way" and `session.report` tries again.
    final activity = await ensureReplay(session, found);
    if (activity.notificationSentAt != null) {
      session.log('Report push: session $sessionId already sent, skipped');
      return;
    }
    final profile = await UserProfile.db.findById(session, activity.profileId);
    final token = profile?.fcmToken;
    if (token == null) {
      session.log('Report push: no push token for session $sessionId');
      return;
    }

    try {
      final sent = await PandoServices.push.send(
        token: token,
        title: 'Your report is ready',
        body:
            'You walked ${activity.distanceM.round()} m. '
            'Tap to see how it went.',
        data: {'sessionId': '$sessionId'},
      );
      if (!sent) return;
    } catch (e) {
      // The Home row still opens the report after 5 minutes.
      session.log(
        'Report push failed for session $sessionId: $e',
        level: LogLevel.warning,
      );
      return;
    }

    await ActivitySession.db.updateRow(
      session,
      activity.copyWith(notificationSentAt: DateTime.now().toUtc()),
    );
    session.log('Report push sent for session $sessionId');
  }
}

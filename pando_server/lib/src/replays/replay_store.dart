import 'package:pando_shared/pando_shared.dart';
import 'package:serverpod/serverpod.dart';

import '../generated/protocol.dart';
import '../pando_services.dart';

/// Builds and stores a session's replay once, from its synced walk slices.
/// Called by the report future call (before the push) and, as a fallback,
/// by `session.report`. Returns the session, with the replay if there is one.
///
/// No slices yet (or a failed read) → no replay; a later call tries again.
/// Never throws: the report must work without a replay.
Future<ActivitySession> ensureReplay(
  Session session,
  ActivitySession activity,
) async {
  if (activity.replayId != null) return activity;
  try {
    final profile = await UserProfile.db.findById(session, activity.profileId);
    if (profile == null) return activity;
    final slices = await PandoServices.walkSlices(
      session,
      authUserId: profile.authUserId,
      clientSessionId: activity.clientSessionId,
    );
    if (slices.isEmpty) {
      session.log('Replay: no walk slices yet for session ${activity.id}');
      return activity;
    }
    final replay = buildReplay(
      slices: slices,
      startedAt: activity.startedAt,
      endedAt: activity.endedAt,
      steps: activity.steps,
      strideM: activity.strideM,
      startPathM: activity.startPathM,
    );
    final saved = await ActivitySession.db.updateRow(
      session,
      activity.copyWith(replayId: const Uuid().v4obj(), replay: replay),
    );
    session.log(
      'Replay: built for session ${activity.id} '
      '(${replay.segments.length} segments, ${replay.durationS} s)',
    );
    return saved;
  } catch (e) {
    session.log(
      'Replay: not built for session ${activity.id}: $e',
      level: LogLevel.warning,
    );
    return activity;
  }
}

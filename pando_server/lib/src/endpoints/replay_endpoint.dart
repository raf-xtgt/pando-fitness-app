import 'package:pando_shared/pando_shared.dart';
import 'package:serverpod/serverpod.dart';

import '../generated/protocol.dart';

/// The public replay page (`/replay/<replayId>`) reads its replay here. No
/// login: whoever holds the unguessable link can watch it. Returns only the
/// replay itself, nothing else about the user or the walk.
class ReplayEndpoint extends Endpoint {
  @override
  bool get requireLogin => false;

  /// The replay with this id, or null if there is none.
  Future<Replay?> get(Session session, UuidValue replayId) async {
    final activity = await ActivitySession.db.findFirstRow(
      session,
      where: (t) => t.replayId.equals(replayId),
    );
    return activity?.replay;
  }
}

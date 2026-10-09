import 'package:pando_shared/pando_shared.dart';
import 'package:serverpod/serverpod.dart' show DatabaseSession, UuidValue;
import 'package:serverpod_offline_sync_server/serverpod_offline_sync_server.dart'
    show OfflineSyncDatabaseAccess;

/// The walk slices the phone synced (Serverpod offline sync) for one walk,
/// oldest first. Synced rows live in the user's own sync space, so the read
/// runs as that user: another user's slices are never visible.
///
/// [session] is an endpoint or future-call `Session`, whose database the sync
/// engine wraps.
Future<List<WalkSlice>> walkSlicesFor(
  DatabaseSession session, {
  required UuidValue authUserId,
  required String clientSessionId,
}) {
  return session.offlineSyncDb.transactionForUser(
    authUserId,
    (transaction) => WalkSlice.db.find(
      session,
      where: (t) => t.clientSessionId.equals(clientSessionId),
      orderBy: (t) => t.startAt,
      transaction: transaction,
    ),
  );
}

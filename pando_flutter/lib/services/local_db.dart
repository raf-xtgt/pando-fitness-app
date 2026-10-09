import 'package:flutter/foundation.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:serverpod_offline_sync_client/serverpod_offline_sync_client.dart'
    show OfflineSyncDatabaseSession;

import 'api_client.dart';

/// Pando's on-phone SQLite database: Serverpod's client-side database with
/// the same generated models as the server, wrapped by Serverpod offline
/// sync (`WalkSlice` is `database: sync`). Pending client migrations run on
/// open.
///
/// Opened on first use, not at app start: the sync session belongs to the
/// signed-in user, and a fresh install signs in on Splash. A failed open
/// (e.g. first launch without signal) is tried again on the next use.
class LocalDb {
  LocalDb(this._api);

  final ApiClient _api;
  Future<OfflineSyncDatabaseSession>? _session;

  Future<OfflineSyncDatabaseSession> get session => _session ??= _open();

  Future<OfflineSyncDatabaseSession> _open() async {
    try {
      final dir = await getApplicationSupportDirectory();
      return await _api.openSyncDatabase(
        p.join(dir.path, 'pando.db'),
        isDebugMode: kDebugMode,
      );
    } catch (_) {
      _session = null;
      rethrow;
    }
  }

  /// Sends the walk slices to the server (see `ApiClient.syncOnce`).
  Future<void> syncOnce() async => _api.syncOnce(await session);
}

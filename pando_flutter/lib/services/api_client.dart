import 'package:flutter/foundation.dart';
import 'package:pando_client/pando_client.dart';
import 'package:serverpod_auth_idp_flutter/serverpod_auth_idp_flutter.dart'
    hide UserProfile;
import 'package:serverpod_database/serverpod_database.dart'
    show DatabaseSession;
import 'package:serverpod_flutter/serverpod_flutter.dart';
import 'package:serverpod_offline_sync_client/serverpod_offline_sync_client.dart'
    show OfflineSyncClientExtension, OfflineSyncDatabaseSession;

/// Wraps the Serverpod client that `serverpod generate` builds from the
/// server's endpoints and models. The rest of the app talks to this.
class ApiClient {
  /// Calls give up after this long, so a missing server never hangs the UI.
  static const Duration callTimeout = Duration(seconds: 10);

  late final Client _client;

  /// Server URL: `--dart-define=SERVER_URL=...`, else `assets/config.json`.
  Future<void> init() async {
    final url = await getServerUrl();
    debugPrint('Pando server: $url');
    _client = Client(url, connectionTimeout: callTimeout)
      ..connectivityMonitor = FlutterConnectivityMonitor()
      ..authSessionManager = FlutterAuthSessionManager();
    await _client.auth.initialize();
  }

  /// A one-shot offline sync gives up after this long.
  static const Duration syncTimeout = Duration(seconds: 30);

  /// The on-phone SQLite database (the `database: client` and `database:
  /// sync` models), wrapped by Serverpod offline sync for this user. Needs
  /// the user signed in, since synced rows belong to the user's space.
  Future<OfflineSyncDatabaseSession> openSyncDatabase(
    String path, {
    bool isDebugMode = false,
  }) async {
    await ensureSignedIn();
    return _client.createSyncSession(
      path,
      isDebugMode: isDebugMode,
      persistentUserId: _client.auth.authInfo!.authUserId,
    );
  }

  /// Sends the phone's new synced rows (walk slices) to the server's
  /// Postgres, and merges anything new from the server, once.
  Future<void> syncOnce(DatabaseSession db) async {
    await ensureSignedIn();
    await _client.offlineSync.syncOnce(db).timeout(syncTimeout);
  }

  /// Anonymous sign-in, once per install: one phone = one user. The session
  /// is kept on the phone, so later launches skip this call.
  Future<void> ensureSignedIn() async {
    if (_client.auth.isAuthenticated) return;
    final success = await _client.anonymousIdp.login();
    await _client.auth.updateSignedInUser(success);
  }

  Future<UserProfile?> getProfile() async {
    await ensureSignedIn();
    return _client.profile.get();
  }

  Future<UserProfile> saveHeight(double heightM) async {
    await ensureSignedIn();
    return _client.profile.saveHeight(heightM);
  }

  Future<ActivityPlan> plan() async {
    await ensureSignedIn();
    return _client.session.plan();
  }

  /// Safe to retry: the server ignores a second save of the same session.
  Future<ActivitySession> saveSession(SessionInput input) async {
    await ensureSignedIn();
    return _client.session.save(input);
  }

  Future<List<ActivitySession>> listSessions() async {
    await ensureSignedIn();
    return _client.session.list();
  }

  Future<void> registerPushToken(String token) async {
    await ensureSignedIn();
    await _client.profile.registerPushToken(token);
  }

  Future<SessionReport> report(int sessionId) async {
    await ensureSignedIn();
    return _client.session.report(sessionId);
  }

  /// Demo builds only: adds three past walks (the server must allow it).
  Future<void> seedDemoSessions() async {
    await ensureSignedIn();
    await _client.demo.seedThreeSessions();
  }
}

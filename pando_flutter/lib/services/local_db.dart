import 'package:flutter/foundation.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:serverpod_database/serverpod_database.dart';

import 'api_client.dart';

/// Opens Pando's on-phone SQLite database: Serverpod's client-side database,
/// with the same generated models as the server (`database: client`).
/// Pending client migrations run on open.
Future<ClientDatabaseSession> openLocalDb(ApiClient api) async {
  final dir = await getApplicationSupportDirectory();
  return api.createLocalSession(
    p.join(dir.path, 'pando.db'),
    isDebugMode: kDebugMode,
  );
}

import 'package:pando_server/src/generated/sync_tables.dart';
import 'package:pando_server/src/walks/walk_slices.dart';
import 'package:pando_shared/pando_shared.dart';
import 'package:serverpod/serverpod.dart';
import 'package:serverpod_offline_sync_server/serverpod_offline_sync_server.dart'
    show
        OfflineSyncDatabaseAccess,
        OfflineSyncInitialize,
        offlineSyncDatabaseInterceptor;
import 'package:test/test.dart';

import 'test_tools/serverpod_test_tools.dart';

/// A session over a given database (here: the server's sync-wrapped one).
class _DbSession implements DatabaseSession {
  _DbSession(this.db);

  @override
  final Database db;

  @override
  Transaction? get transaction => null;

  @override
  LogQueryFunction? get logQuery => null;

  @override
  LogWarningFunction? get logWarning => null;
}

void main() {
  withServerpod(
    'Given walk slices synced from two phones',
    // As in the real server: the sync engine wraps each session's database.
    databaseInterceptor: offlineSyncDatabaseInterceptor,
    // The test tools' rollback proxy would hide the sync wrapper, so the
    // database is used directly and each run uses fresh users instead.
    rollbackDatabase: RollbackDatabase.disabled,
    (sessionBuilder, endpoints) {
      final walker = const Uuid().v4obj();
      final other = const Uuid().v4obj();
      final start = DateTime.utc(2026, 10, 9, 8);
      late DatabaseSession db;

      WalkSlice slice(String walk, int index, int steps) => WalkSlice(
        clientSessionId: walk,
        startAt: start.add(Duration(seconds: 30 * index)),
        endAt: start.add(Duration(seconds: 30 * (index + 1))),
        steps: steps,
      );

      /// Writes rows the way offline sync stores them: as the user, in the
      /// user's own space.
      Future<void> sync(UuidValue user, List<WalkSlice> rows) =>
          db.offlineSyncDb.transactionForUser(
            user,
            (transaction) =>
                WalkSlice.db.insert(db, rows, transaction: transaction),
          );

      setUpAll(() async {
        final session = sessionBuilder.build();
        // The generated server class does this at startup; the test server
        // is a plain Serverpod, so the sync engine is registered here.
        session.server.serverpod.initializeOfflineSync(syncTables: syncTables);
        db = _DbSession(session.server.createDatabase(session));

        // Inserted out of order, to check the read sorts by time.
        await sync(walker, [slice('walk-1', 1, 70), slice('walk-1', 0, 50)]);
        await sync(walker, [slice('walk-2', 0, 10)]);
        await sync(other, [slice('walk-1', 0, 99)]);
      });

      test(
        'then a walk\'s slices are read back for its owner, oldest first',
        () async {
          final slices = await walkSlicesFor(
            db,
            authUserId: walker,
            clientSessionId: 'walk-1',
          );
          expect(slices.map((s) => s.steps), [50, 70]);
          expect(slices.first.id, isNotNull);
        },
      );

      test('then another user\'s slices are never visible', () async {
        final slices = await walkSlicesFor(
          db,
          authUserId: other,
          clientSessionId: 'walk-1',
        );
        expect(slices.map((s) => s.steps), [99]);
      });

      test('then an unknown walk has no slices', () async {
        final slices = await walkSlicesFor(
          db,
          authUserId: walker,
          clientSessionId: 'nope',
        );
        expect(slices, isEmpty);
      });
    },
  );
}

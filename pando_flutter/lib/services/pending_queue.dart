import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:pando_client/pando_client.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'api_client.dart';

/// Server writes that haven't gone through yet (no signal in the park,
/// server asleep). Kept as a JSON list in shared_preferences, sent in order,
/// and flushed on startup, on Home, and right after anything is added.
///
/// A session is saved only after [syncWalks] (Serverpod offline sync of the
/// walk slices) succeeds, so the server always has a session's slices when
/// it has the session. Offline sync is experimental: after
/// [maxSyncFailures] failed syncs for one session, it's saved anyway (the
/// report then comes without a replay) rather than never.
class PendingQueue {
  PendingQueue(this._prefs, this._api, {required this.syncWalks});

  static const maxSyncFailures = 3;

  static const _key = 'pending_queue';

  final SharedPreferences _prefs;
  final ApiClient _api;

  /// Sends the phone's walk slices to the server.
  final Future<void> Function() syncWalks;

  /// The send in progress, so a second caller waits for it.
  Future<void>? _flushing;

  List<Map<String, dynamic>> get items {
    final raw = _prefs.getString(_key);
    if (raw == null) return [];
    return (jsonDecode(raw) as List).cast<Map<String, dynamic>>();
  }

  Future<void> _save(List<Map<String, dynamic>> items) =>
      _prefs.setString(_key, jsonEncode(items));

  /// Queues a write and tries to send it straight away.
  Future<void> add(String op, Map<String, dynamic> payload) async {
    await enqueue(op, payload);
    await flush();
  }

  /// Queues a write without sending it; completes once it's on the phone.
  Future<void> enqueue(String op, Map<String, dynamic> payload) => _save([
    ...items,
    {'id': const Uuid().v4(), 'op': op, 'payload': payload},
  ]);

  /// Sends queued writes in order. Stops at the first failure and keeps it
  /// (and everything after it) for next time. If a send is already running,
  /// waits for it, so a caller that reads the server next sees the result.
  Future<void> flush() =>
      _flushing ??= _flushAll().whenComplete(() => _flushing = null);

  Future<void> _flushAll() async {
    while (items.isNotEmpty) {
      final item = items.first;
      try {
        if (item['op'] == saveSessionOp) await _syncBeforeSave(item);
        await _send(item['op'] as String, item['payload'] as Map);
      } catch (e) {
        debugPrint('Pando queue: ${item['op']} not sent yet ($e)');
        return;
      }
      await _save(items.where((i) => i['id'] != item['id']).toList());
      debugPrint('Pando queue: sent ${item['op']}');
    }
  }

  /// Syncs the walk slices. A failure stops the flush (the session waits),
  /// unless this session's sync already failed [maxSyncFailures] times.
  Future<void> _syncBeforeSave(Map<String, dynamic> item) async {
    try {
      await syncWalks();
      debugPrint('Pando queue: walk slices synced');
    } catch (e) {
      final failures = (item['syncFailures'] as int? ?? 0) + 1;
      await _save([
        for (final i in items)
          if (i['id'] == item['id']) {...i, 'syncFailures': failures} else i,
      ]);
      if (failures < maxSyncFailures) rethrow;
      debugPrint(
        'Pando queue: walk sync failed $failures times ($e); '
        'saving the session without its slices',
      );
    }
  }

  /// Sessions saved on the phone but not yet on the server, oldest first.
  List<SessionInput> get pendingSessions => [
    for (final item in items)
      if (item['op'] == saveSessionOp)
        SessionInput.fromJson(item['payload'] as Map<String, dynamic>),
  ];

  static const saveHeightOp = 'saveHeight';
  static const saveSessionOp = 'saveSession';
  static const registerPushTokenOp = 'registerPushToken';

  Future<void> _send(String op, Map payload) => switch (op) {
    saveHeightOp => _api.saveHeight((payload['heightM'] as num).toDouble()),
    saveSessionOp => _api.saveSession(
      SessionInput.fromJson(payload.cast<String, dynamic>()),
    ),
    registerPushTokenOp => _api.registerPushToken(payload['token'] as String),
    _ => throw UnsupportedError('Unknown queued op $op'),
  };
}

import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:pando_client/pando_client.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'api_client.dart';

/// Server writes that haven't gone through yet (no signal in the park,
/// server asleep). Kept as a JSON list in shared_preferences, sent in order,
/// and flushed on startup, on Home, and right after anything is added.
class PendingQueue {
  PendingQueue(this._prefs, this._api);

  static const _key = 'pending_queue';

  final SharedPreferences _prefs;
  final ApiClient _api;
  bool _flushing = false;

  List<Map<String, dynamic>> get items {
    final raw = _prefs.getString(_key);
    if (raw == null) return [];
    return (jsonDecode(raw) as List).cast<Map<String, dynamic>>();
  }

  Future<void> _save(List<Map<String, dynamic>> items) =>
      _prefs.setString(_key, jsonEncode(items));

  /// Queues a write and tries to send it straight away.
  Future<void> add(String op, Map<String, dynamic> payload) async {
    await _save([
      ...items,
      {'id': const Uuid().v4(), 'op': op, 'payload': payload},
    ]);
    await flush();
  }

  /// Sends queued writes in order. Stops at the first failure and keeps it
  /// (and everything after it) for next time.
  Future<void> flush() async {
    if (_flushing) return;
    _flushing = true;
    try {
      while (items.isNotEmpty) {
        final item = items.first;
        try {
          await _send(item['op'] as String, item['payload'] as Map);
        } catch (e) {
          debugPrint('Pando queue: ${item['op']} not sent yet ($e)');
          return;
        }
        await _save(items.where((i) => i['id'] != item['id']).toList());
        debugPrint('Pando queue: sent ${item['op']}');
      }
    } finally {
      _flushing = false;
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

  Future<void> _send(String op, Map payload) => switch (op) {
    saveHeightOp => _api.saveHeight((payload['heightM'] as num).toDouble()),
    saveSessionOp => _api.saveSession(
      SessionInput.fromJson(payload.cast<String, dynamic>()),
    ),
    _ => throw UnsupportedError('Unknown queued op $op'),
  };
}

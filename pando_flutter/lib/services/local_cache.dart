import 'dart:convert';

import 'package:pando_client/pando_client.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// What the phone remembers between launches, so Pando works offline and
/// starts fast. The server stays the source of truth.
class LocalCache {
  LocalCache(this._prefs);

  static const _heightKey = 'profile.heightM';
  static const _planKey = 'session.plan';
  static const _sessionsKey = 'session.list';

  final SharedPreferences _prefs;

  double? get heightMetres => _prefs.getDouble(_heightKey);

  Future<void> setHeightMetres(double metres) =>
      _prefs.setDouble(_heightKey, metres);

  /// The plan for the next activity (goal, stride, resume point, signs).
  ActivityPlan? get plan {
    final raw = _prefs.getString(_planKey);
    return raw == null ? null : ActivityPlan.fromJson(jsonDecode(raw));
  }

  Future<void> setPlan(ActivityPlan plan) =>
      _prefs.setString(_planKey, jsonEncode(plan.toJson()));

  /// The last session list from the server, newest first.
  List<ActivitySession> get sessions {
    final raw = _prefs.getString(_sessionsKey);
    if (raw == null) return [];
    return [
      for (final s in jsonDecode(raw) as List)
        ActivitySession.fromJson(s as Map<String, dynamic>),
    ];
  }

  Future<void> setSessions(List<ActivitySession> sessions) => _prefs.setString(
    _sessionsKey,
    jsonEncode([for (final s in sessions) s.toJson()]),
  );
}

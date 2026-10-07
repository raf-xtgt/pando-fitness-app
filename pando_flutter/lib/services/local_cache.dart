import 'package:shared_preferences/shared_preferences.dart';

/// What the phone remembers between launches, so Pando works offline and
/// starts fast. The server stays the source of truth.
class LocalCache {
  LocalCache(this._prefs);

  static const _heightKey = 'profile.heightM';

  final SharedPreferences _prefs;

  double? get heightMetres => _prefs.getDouble(_heightKey);

  Future<void> setHeightMetres(double metres) =>
      _prefs.setDouble(_heightKey, metres);
}

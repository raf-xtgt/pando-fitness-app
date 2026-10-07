import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_idp_server/core.dart' hide UserProfile;

import '../generated/protocol.dart';

/// The caller's own profile. Every call is scoped to the signed-in user.
class ProfileEndpoint extends Endpoint {
  @override
  bool get requireLogin => true;

  /// The caller's profile, or null before onboarding.
  Future<UserProfile?> get(Session session) =>
      _find(session, _authUserId(session));

  /// Saves the caller's height (metres), creating the profile if needed.
  Future<UserProfile> saveHeight(Session session, double heightM) async {
    if (heightM < 1.0 || heightM > 2.5) {
      throw ArgumentError.value(heightM, 'heightM', 'must be 1.0–2.5 m');
    }
    final authUserId = _authUserId(session);
    final existing = await _find(session, authUserId);
    if (existing == null) {
      return UserProfile.db.insertRow(
        session,
        UserProfile(authUserId: authUserId, heightM: heightM),
      );
    }
    return UserProfile.db.updateRow(
      session,
      existing.copyWith(heightM: heightM),
    );
  }

  static UuidValue _authUserId(Session session) =>
      session.authenticated!.authUserId;

  static Future<UserProfile?> _find(Session session, UuidValue authUserId) =>
      UserProfile.db.findFirstRow(
        session,
        where: (t) => t.authUserId.equals(authUserId),
      );
}

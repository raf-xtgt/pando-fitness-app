import 'package:serverpod/serverpod.dart';

import '../generated/protocol.dart';
import 'caller.dart';

/// The caller's own profile. Every call is scoped to the signed-in user.
class ProfileEndpoint extends Endpoint {
  @override
  bool get requireLogin => true;

  /// The caller's profile, or null before onboarding.
  Future<UserProfile?> get(Session session) => session.callerProfile();

  /// Saves the caller's height (metres), creating the profile if needed.
  Future<UserProfile> saveHeight(Session session, double heightM) async {
    if (heightM < 1.0 || heightM > 2.5) {
      throw ArgumentError.value(heightM, 'heightM', 'must be 1.0–2.5 m');
    }
    final existing = await session.callerProfile();
    if (existing == null) {
      return UserProfile.db.insertRow(
        session,
        UserProfile(authUserId: session.callerAuthUserId, heightM: heightM),
      );
    }
    return UserProfile.db.updateRow(
      session,
      existing.copyWith(heightM: heightM),
    );
  }
}

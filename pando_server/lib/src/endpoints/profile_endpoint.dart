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

  /// Saves the caller's safety check: their result from the official PAR-Q+
  /// and its edition ([version]). A retake overwrites it. Creates the
  /// profile if needed (the check can arrive before the height).
  Future<UserProfile> saveScreening(
    Session session,
    ScreeningResult result,
    String version,
  ) async {
    final edition = version.trim();
    if (edition.isEmpty || edition.length > 100) {
      throw ArgumentError.value(version, 'version', 'must be 1–100 chars');
    }
    final now = DateTime.now().toUtc();
    final existing = await session.callerProfile();
    if (existing == null) {
      return UserProfile.db.insertRow(
        session,
        UserProfile(
          authUserId: session.callerAuthUserId,
          screeningResult: result,
          screeningAt: now,
          screeningVersion: edition,
        ),
      );
    }
    return UserProfile.db.updateRow(
      session,
      existing.copyWith(
        screeningResult: result,
        screeningAt: now,
        screeningVersion: edition,
      ),
    );
  }

  /// Stores the phone's push token so the delayed report can reach it.
  Future<void> registerPushToken(Session session, String token) async {
    final existing = await session.callerProfile();
    if (existing == null) {
      await UserProfile.db.insertRow(
        session,
        UserProfile(authUserId: session.callerAuthUserId, fcmToken: token),
      );
    } else if (existing.fcmToken != token) {
      await UserProfile.db.updateRow(
        session,
        existing.copyWith(fcmToken: token),
      );
    }
  }
}

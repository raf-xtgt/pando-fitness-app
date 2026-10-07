import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_idp_server/core.dart' hide UserProfile;

import '../generated/protocol.dart';

/// Who is calling. Every endpoint scopes its data with these, so one user
/// can never reach another user's rows.
extension CallerSession on Session {
  UuidValue get callerAuthUserId => authenticated!.authUserId;

  Future<UserProfile?> callerProfile() => UserProfile.db.findFirstRow(
    this,
    where: (t) => t.authUserId.equals(callerAuthUserId),
  );

  /// The caller's profile; fails if onboarding hasn't saved it yet.
  Future<UserProfile> requireCallerProfile() async {
    final profile = await callerProfile();
    if (profile == null || profile.heightM == null) {
      throw StateError('No profile yet: save the height first');
    }
    return profile;
  }
}

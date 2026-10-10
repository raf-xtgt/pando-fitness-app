/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: implementation_imports
// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: type_literal_in_constant_pattern
// ignore_for_file: use_super_parameters
// ignore_for_file: invalid_use_of_internal_member

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod_client/serverpod_client.dart' as _isc;
import 'screening_result.dart' as _i2bmhkxi;

/// One person's Pando profile, tied to their anonymous sign-in.
abstract class UserProfile
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  UserProfile._({
    this.id,
    required this.authUserId,
    this.heightM,
    this.fcmToken,
    DateTime? createdAt,
    this.screeningResult,
    this.screeningAt,
    this.screeningVersion,
  }) : createdAt = createdAt ?? DateTime.now();

  factory UserProfile({
    int? id,
    required _isc.UuidValue authUserId,
    double? heightM,
    String? fcmToken,
    DateTime? createdAt,
    _i2bmhkxi.ScreeningResult? screeningResult,
    DateTime? screeningAt,
    String? screeningVersion,
  }) = _UserProfileImpl;

  factory UserProfile.fromJson(Map<String, dynamic> jsonSerialization) {
    return UserProfile(
      id: jsonSerialization['id'] as int?,
      authUserId: _isc.UuidValueJsonExtension.fromJson(
        jsonSerialization['authUserId'],
      ),
      heightM: (jsonSerialization['heightM'] as num?)?.toDouble(),
      fcmToken: jsonSerialization['fcmToken'] as String?,
      createdAt: jsonSerialization['createdAt'] == null
          ? null
          : _isc.DateTimeJsonExtension.fromJson(jsonSerialization['createdAt']),
      screeningResult: jsonSerialization['screeningResult'] == null
          ? null
          : _i2bmhkxi.ScreeningResult.fromJson(
              (jsonSerialization['screeningResult'] as String),
            ),
      screeningAt: jsonSerialization['screeningAt'] == null
          ? null
          : _isc.DateTimeJsonExtension.fromJson(
              jsonSerialization['screeningAt'],
            ),
      screeningVersion: jsonSerialization['screeningVersion'] as String?,
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  /// The anonymous auth user this profile belongs to (one phone = one user).
  _isc.UuidValue authUserId;

  /// Height in metres; null until onboarding is done.
  double? heightM;

  /// Firebase Cloud Messaging token for the delayed report (slice 4).
  String? fcmToken;

  DateTime createdAt;

  /// Safety check (Hackathon Round): the walker's PAR-Q+ result, when they
  /// gave it, and which PAR-Q+ edition. Null until answered. Pando links to
  /// the official form; it doesn't show the questions itself.
  _i2bmhkxi.ScreeningResult? screeningResult;

  DateTime? screeningAt;

  String? screeningVersion;

  /// Returns a shallow copy of this [UserProfile]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  UserProfile copyWith({
    int? id,
    _isc.UuidValue? authUserId,
    double? heightM,
    String? fcmToken,
    DateTime? createdAt,
    _i2bmhkxi.ScreeningResult? screeningResult,
    DateTime? screeningAt,
    String? screeningVersion,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'UserProfile',
      if (id != null) 'id': id,
      'authUserId': authUserId.toJson(),
      if (heightM != null) 'heightM': heightM,
      if (fcmToken != null) 'fcmToken': fcmToken,
      'createdAt': createdAt.toJson(),
      if (screeningResult != null) 'screeningResult': screeningResult?.toJson(),
      if (screeningAt != null) 'screeningAt': screeningAt?.toJson(),
      if (screeningVersion != null) 'screeningVersion': screeningVersion,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'UserProfile',
      if (id != null) 'id': id,
      'authUserId': authUserId.toJson(),
      if (heightM != null) 'heightM': heightM,
      if (fcmToken != null) 'fcmToken': fcmToken,
      'createdAt': createdAt.toJson(),
      if (screeningResult != null) 'screeningResult': screeningResult?.toJson(),
      if (screeningAt != null) 'screeningAt': screeningAt?.toJson(),
      if (screeningVersion != null) 'screeningVersion': screeningVersion,
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _UserProfileImpl extends UserProfile {
  _UserProfileImpl({
    int? id,
    required _isc.UuidValue authUserId,
    double? heightM,
    String? fcmToken,
    DateTime? createdAt,
    _i2bmhkxi.ScreeningResult? screeningResult,
    DateTime? screeningAt,
    String? screeningVersion,
  }) : super._(
         id: id,
         authUserId: authUserId,
         heightM: heightM,
         fcmToken: fcmToken,
         createdAt: createdAt,
         screeningResult: screeningResult,
         screeningAt: screeningAt,
         screeningVersion: screeningVersion,
       );

  /// Returns a shallow copy of this [UserProfile]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  UserProfile copyWith({
    Object? id = _Undefined,
    _isc.UuidValue? authUserId,
    Object? heightM = _Undefined,
    Object? fcmToken = _Undefined,
    DateTime? createdAt,
    Object? screeningResult = _Undefined,
    Object? screeningAt = _Undefined,
    Object? screeningVersion = _Undefined,
  }) {
    return UserProfile(
      id: id is int? ? id : this.id,
      authUserId: authUserId ?? this.authUserId,
      heightM: heightM is double? ? heightM : this.heightM,
      fcmToken: fcmToken is String? ? fcmToken : this.fcmToken,
      createdAt: createdAt ?? this.createdAt,
      screeningResult: screeningResult is _i2bmhkxi.ScreeningResult?
          ? screeningResult
          : this.screeningResult,
      screeningAt: screeningAt is DateTime? ? screeningAt : this.screeningAt,
      screeningVersion: screeningVersion is String?
          ? screeningVersion
          : this.screeningVersion,
    );
  }
}

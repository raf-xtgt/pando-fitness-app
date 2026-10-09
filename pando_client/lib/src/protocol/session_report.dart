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

/// The delayed report for one session (shown on the Report screen).
abstract class SessionReport
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  SessionReport._({
    required this.sessionId,
    required this.endedAt,
    required this.message,
    required this.distanceM,
    required this.totalDistanceAllM,
    required this.goalMet,
    required this.extraM,
    this.replayId,
  });

  factory SessionReport({
    required int sessionId,
    required DateTime endedAt,
    required String message,
    required double distanceM,
    required double totalDistanceAllM,
    required bool goalMet,
    required double extraM,
    _isc.UuidValue? replayId,
  }) = _SessionReportImpl;

  factory SessionReport.fromJson(Map<String, dynamic> jsonSerialization) {
    return SessionReport(
      sessionId: jsonSerialization['sessionId'] as int,
      endedAt: _isc.DateTimeJsonExtension.fromJson(
        jsonSerialization['endedAt'],
      ),
      message: jsonSerialization['message'] as String,
      distanceM: (jsonSerialization['distanceM'] as num).toDouble(),
      totalDistanceAllM: (jsonSerialization['totalDistanceAllM'] as num)
          .toDouble(),
      goalMet: _isc.BoolJsonExtension.fromJson(jsonSerialization['goalMet']),
      extraM: (jsonSerialization['extraM'] as num).toDouble(),
      replayId: jsonSerialization['replayId'] == null
          ? null
          : _isc.UuidValueJsonExtension.fromJson(jsonSerialization['replayId']),
    );
  }

  int sessionId;

  DateTime endedAt;

  String message;

  double distanceM;

  /// Distance across every session up to and including this one.
  double totalDistanceAllM;

  bool goalMet;

  double extraM;

  /// Null until the replay is built ("replay on its way").
  _isc.UuidValue? replayId;

  /// Returns a shallow copy of this [SessionReport]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  SessionReport copyWith({
    int? sessionId,
    DateTime? endedAt,
    String? message,
    double? distanceM,
    double? totalDistanceAllM,
    bool? goalMet,
    double? extraM,
    _isc.UuidValue? replayId,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'SessionReport',
      'sessionId': sessionId,
      'endedAt': endedAt.toJson(),
      'message': message,
      'distanceM': distanceM,
      'totalDistanceAllM': totalDistanceAllM,
      'goalMet': goalMet,
      'extraM': extraM,
      if (replayId != null) 'replayId': replayId?.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'SessionReport',
      'sessionId': sessionId,
      'endedAt': endedAt.toJson(),
      'message': message,
      'distanceM': distanceM,
      'totalDistanceAllM': totalDistanceAllM,
      'goalMet': goalMet,
      'extraM': extraM,
      if (replayId != null) 'replayId': replayId?.toJson(),
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _SessionReportImpl extends SessionReport {
  _SessionReportImpl({
    required int sessionId,
    required DateTime endedAt,
    required String message,
    required double distanceM,
    required double totalDistanceAllM,
    required bool goalMet,
    required double extraM,
    _isc.UuidValue? replayId,
  }) : super._(
         sessionId: sessionId,
         endedAt: endedAt,
         message: message,
         distanceM: distanceM,
         totalDistanceAllM: totalDistanceAllM,
         goalMet: goalMet,
         extraM: extraM,
         replayId: replayId,
       );

  /// Returns a shallow copy of this [SessionReport]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  SessionReport copyWith({
    int? sessionId,
    DateTime? endedAt,
    String? message,
    double? distanceM,
    double? totalDistanceAllM,
    bool? goalMet,
    double? extraM,
    Object? replayId = _Undefined,
  }) {
    return SessionReport(
      sessionId: sessionId ?? this.sessionId,
      endedAt: endedAt ?? this.endedAt,
      message: message ?? this.message,
      distanceM: distanceM ?? this.distanceM,
      totalDistanceAllM: totalDistanceAllM ?? this.totalDistanceAllM,
      goalMet: goalMet ?? this.goalMet,
      extraM: extraM ?? this.extraM,
      replayId: replayId is _isc.UuidValue? ? replayId : this.replayId,
    );
  }
}

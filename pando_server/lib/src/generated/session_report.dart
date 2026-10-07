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
import 'package:serverpod/serverpod.dart' as _is;

/// The delayed report for one session (shown on the Report screen).
abstract class SessionReport
    implements _is.SerializableModel, _is.ProtocolSerialization {
  SessionReport._({
    required this.sessionId,
    required this.endedAt,
    required this.message,
    required this.distanceM,
    required this.totalDistanceAllM,
    required this.goalMet,
    required this.extraM,
  });

  factory SessionReport({
    required int sessionId,
    required DateTime endedAt,
    required String message,
    required double distanceM,
    required double totalDistanceAllM,
    required bool goalMet,
    required double extraM,
  }) = _SessionReportImpl;

  factory SessionReport.fromJson(Map<String, dynamic> jsonSerialization) {
    return SessionReport(
      sessionId: jsonSerialization['sessionId'] as int,
      endedAt: _is.DateTimeJsonExtension.fromJson(jsonSerialization['endedAt']),
      message: jsonSerialization['message'] as String,
      distanceM: (jsonSerialization['distanceM'] as num).toDouble(),
      totalDistanceAllM: (jsonSerialization['totalDistanceAllM'] as num)
          .toDouble(),
      goalMet: _is.BoolJsonExtension.fromJson(jsonSerialization['goalMet']),
      extraM: (jsonSerialization['extraM'] as num).toDouble(),
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

  /// Returns a shallow copy of this [SessionReport]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  SessionReport copyWith({
    int? sessionId,
    DateTime? endedAt,
    String? message,
    double? distanceM,
    double? totalDistanceAllM,
    bool? goalMet,
    double? extraM,
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
    };
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _SessionReportImpl extends SessionReport {
  _SessionReportImpl({
    required int sessionId,
    required DateTime endedAt,
    required String message,
    required double distanceM,
    required double totalDistanceAllM,
    required bool goalMet,
    required double extraM,
  }) : super._(
         sessionId: sessionId,
         endedAt: endedAt,
         message: message,
         distanceM: distanceM,
         totalDistanceAllM: totalDistanceAllM,
         goalMet: goalMet,
         extraM: extraM,
       );

  /// Returns a shallow copy of this [SessionReport]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  SessionReport copyWith({
    int? sessionId,
    DateTime? endedAt,
    String? message,
    double? distanceM,
    double? totalDistanceAllM,
    bool? goalMet,
    double? extraM,
  }) {
    return SessionReport(
      sessionId: sessionId ?? this.sessionId,
      endedAt: endedAt ?? this.endedAt,
      message: message ?? this.message,
      distanceM: distanceM ?? this.distanceM,
      totalDistanceAllM: totalDistanceAllM ?? this.totalDistanceAllM,
      goalMet: goalMet ?? this.goalMet,
      extraM: extraM ?? this.extraM,
    );
  }
}

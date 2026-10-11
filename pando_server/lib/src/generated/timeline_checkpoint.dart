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

/// One wooden sign on the timeline: where a walk ended on the journey.
abstract class TimelineCheckpoint
    implements _is.SerializableModel, _is.ProtocolSerialization {
  TimelineCheckpoint._({
    required this.sessionId,
    required this.endedAt,
    required this.totalM,
    required this.distanceM,
    required this.steps,
    required this.durationS,
    required this.ran,
  });

  factory TimelineCheckpoint({
    required int sessionId,
    required DateTime endedAt,
    required double totalM,
    required double distanceM,
    required int steps,
    required double durationS,
    required bool ran,
  }) = _TimelineCheckpointImpl;

  factory TimelineCheckpoint.fromJson(Map<String, dynamic> jsonSerialization) {
    return TimelineCheckpoint(
      sessionId: jsonSerialization['sessionId'] as int,
      endedAt: _is.DateTimeJsonExtension.fromJson(jsonSerialization['endedAt']),
      totalM: (jsonSerialization['totalM'] as num).toDouble(),
      distanceM: (jsonSerialization['distanceM'] as num).toDouble(),
      steps: jsonSerialization['steps'] as int,
      durationS: (jsonSerialization['durationS'] as num).toDouble(),
      ran: _is.BoolJsonExtension.fromJson(jsonSerialization['ran']),
    );
  }

  int sessionId;

  DateTime endedAt;

  /// Journey total at this sign (the session's `endPathM`).
  double totalM;

  /// This walk alone.
  double distanceM;

  int steps;

  double durationS;

  /// The replay has a running stretch (orange footprints).
  bool ran;

  /// Returns a shallow copy of this [TimelineCheckpoint]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  TimelineCheckpoint copyWith({
    int? sessionId,
    DateTime? endedAt,
    double? totalM,
    double? distanceM,
    int? steps,
    double? durationS,
    bool? ran,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'TimelineCheckpoint',
      'sessionId': sessionId,
      'endedAt': endedAt.toJson(),
      'totalM': totalM,
      'distanceM': distanceM,
      'steps': steps,
      'durationS': durationS,
      'ran': ran,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'TimelineCheckpoint',
      'sessionId': sessionId,
      'endedAt': endedAt.toJson(),
      'totalM': totalM,
      'distanceM': distanceM,
      'steps': steps,
      'durationS': durationS,
      'ran': ran,
    };
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _TimelineCheckpointImpl extends TimelineCheckpoint {
  _TimelineCheckpointImpl({
    required int sessionId,
    required DateTime endedAt,
    required double totalM,
    required double distanceM,
    required int steps,
    required double durationS,
    required bool ran,
  }) : super._(
         sessionId: sessionId,
         endedAt: endedAt,
         totalM: totalM,
         distanceM: distanceM,
         steps: steps,
         durationS: durationS,
         ran: ran,
       );

  /// Returns a shallow copy of this [TimelineCheckpoint]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  TimelineCheckpoint copyWith({
    int? sessionId,
    DateTime? endedAt,
    double? totalM,
    double? distanceM,
    int? steps,
    double? durationS,
    bool? ran,
  }) {
    return TimelineCheckpoint(
      sessionId: sessionId ?? this.sessionId,
      endedAt: endedAt ?? this.endedAt,
      totalM: totalM ?? this.totalM,
      distanceM: distanceM ?? this.distanceM,
      steps: steps ?? this.steps,
      durationS: durationS ?? this.durationS,
      ran: ran ?? this.ran,
    );
  }
}

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

/// A walk that has started but isn't saved yet. Lives only in the phone's
/// SQLite, so a walk survives Pando being killed. Deleted once the session
/// is queued for the server.
abstract class WalkInProgress
    implements _is.SerializableModel, _is.ProtocolSerialization {
  WalkInProgress._({
    this.id,
    required this.clientSessionId,
    required this.startedAt,
    this.startCount,
    required this.goalSteps,
    required this.resumeMetres,
  });

  factory WalkInProgress({
    int? id,
    required String clientSessionId,
    required DateTime startedAt,
    int? startCount,
    required int goalSteps,
    required double resumeMetres,
  }) = _WalkInProgressImpl;

  factory WalkInProgress.fromJson(Map<String, dynamic> jsonSerialization) {
    return WalkInProgress(
      id: jsonSerialization['id'] as int?,
      clientSessionId: jsonSerialization['clientSessionId'] as String,
      startedAt: _is.DateTimeJsonExtension.fromJson(
        jsonSerialization['startedAt'],
      ),
      startCount: jsonSerialization['startCount'] as int?,
      goalSteps: jsonSerialization['goalSteps'] as int,
      resumeMetres: (jsonSerialization['resumeMetres'] as num).toDouble(),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  String clientSessionId;

  DateTime startedAt;

  /// The phone's step counter (steps since boot) at Start; null until the
  /// first sensor event. Fallback when the step history can't be read.
  int? startCount;

  /// The plan the walker saw at Start.
  int goalSteps;

  double resumeMetres;

  /// Returns a shallow copy of this [WalkInProgress]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  WalkInProgress copyWith({
    int? id,
    String? clientSessionId,
    DateTime? startedAt,
    int? startCount,
    int? goalSteps,
    double? resumeMetres,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'WalkInProgress',
      if (id != null) 'id': id,
      'clientSessionId': clientSessionId,
      'startedAt': startedAt.toJson(),
      if (startCount != null) 'startCount': startCount,
      'goalSteps': goalSteps,
      'resumeMetres': resumeMetres,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'WalkInProgress',
      if (id != null) 'id': id,
      'clientSessionId': clientSessionId,
      'startedAt': startedAt.toJson(),
      if (startCount != null) 'startCount': startCount,
      'goalSteps': goalSteps,
      'resumeMetres': resumeMetres,
    };
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _WalkInProgressImpl extends WalkInProgress {
  _WalkInProgressImpl({
    int? id,
    required String clientSessionId,
    required DateTime startedAt,
    int? startCount,
    required int goalSteps,
    required double resumeMetres,
  }) : super._(
         id: id,
         clientSessionId: clientSessionId,
         startedAt: startedAt,
         startCount: startCount,
         goalSteps: goalSteps,
         resumeMetres: resumeMetres,
       );

  /// Returns a shallow copy of this [WalkInProgress]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  WalkInProgress copyWith({
    Object? id = _Undefined,
    String? clientSessionId,
    DateTime? startedAt,
    Object? startCount = _Undefined,
    int? goalSteps,
    double? resumeMetres,
  }) {
    return WalkInProgress(
      id: id is int? ? id : this.id,
      clientSessionId: clientSessionId ?? this.clientSessionId,
      startedAt: startedAt ?? this.startedAt,
      startCount: startCount is int? ? startCount : this.startCount,
      goalSteps: goalSteps ?? this.goalSteps,
      resumeMetres: resumeMetres ?? this.resumeMetres,
    );
  }
}

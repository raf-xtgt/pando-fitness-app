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

/// Steps in one 30 s slice of a walk, from the phone's step history.
/// Written at Stop. Phone only for now; synced to the server in slice 8.
abstract class WalkSlice
    implements _is.SerializableModel, _is.ProtocolSerialization {
  WalkSlice._({
    this.id,
    required this.clientSessionId,
    required this.startAt,
    required this.endAt,
    required this.steps,
  });

  factory WalkSlice({
    int? id,
    required String clientSessionId,
    required DateTime startAt,
    required DateTime endAt,
    required int steps,
  }) = _WalkSliceImpl;

  factory WalkSlice.fromJson(Map<String, dynamic> jsonSerialization) {
    return WalkSlice(
      id: jsonSerialization['id'] as int?,
      clientSessionId: jsonSerialization['clientSessionId'] as String,
      startAt: _is.DateTimeJsonExtension.fromJson(jsonSerialization['startAt']),
      endAt: _is.DateTimeJsonExtension.fromJson(jsonSerialization['endAt']),
      steps: jsonSerialization['steps'] as int,
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  String clientSessionId;

  DateTime startAt;

  DateTime endAt;

  int steps;

  /// Returns a shallow copy of this [WalkSlice]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  WalkSlice copyWith({
    int? id,
    String? clientSessionId,
    DateTime? startAt,
    DateTime? endAt,
    int? steps,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'WalkSlice',
      if (id != null) 'id': id,
      'clientSessionId': clientSessionId,
      'startAt': startAt.toJson(),
      'endAt': endAt.toJson(),
      'steps': steps,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'WalkSlice',
      if (id != null) 'id': id,
      'clientSessionId': clientSessionId,
      'startAt': startAt.toJson(),
      'endAt': endAt.toJson(),
      'steps': steps,
    };
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _WalkSliceImpl extends WalkSlice {
  _WalkSliceImpl({
    int? id,
    required String clientSessionId,
    required DateTime startAt,
    required DateTime endAt,
    required int steps,
  }) : super._(
         id: id,
         clientSessionId: clientSessionId,
         startAt: startAt,
         endAt: endAt,
         steps: steps,
       );

  /// Returns a shallow copy of this [WalkSlice]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  WalkSlice copyWith({
    Object? id = _Undefined,
    String? clientSessionId,
    DateTime? startAt,
    DateTime? endAt,
    int? steps,
  }) {
    return WalkSlice(
      id: id is int? ? id : this.id,
      clientSessionId: clientSessionId ?? this.clientSessionId,
      startAt: startAt ?? this.startAt,
      endAt: endAt ?? this.endAt,
      steps: steps ?? this.steps,
    );
  }
}

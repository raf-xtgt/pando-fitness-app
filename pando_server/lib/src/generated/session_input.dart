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
import 'feel.dart' as _ifrvopus;

/// What the phone sends when a session ends.
abstract class SessionInput
    implements _is.SerializableModel, _is.ProtocolSerialization {
  SessionInput._({
    required this.clientSessionId,
    required this.startedAt,
    required this.endedAt,
    required this.steps,
    required this.goalSteps,
    this.feel,
    required this.paceDropped,
  });

  factory SessionInput({
    required String clientSessionId,
    required DateTime startedAt,
    required DateTime endedAt,
    required int steps,
    required int goalSteps,
    _ifrvopus.Feel? feel,
    required bool paceDropped,
  }) = _SessionInputImpl;

  factory SessionInput.fromJson(Map<String, dynamic> jsonSerialization) {
    return SessionInput(
      clientSessionId: jsonSerialization['clientSessionId'] as String,
      startedAt: _is.DateTimeJsonExtension.fromJson(
        jsonSerialization['startedAt'],
      ),
      endedAt: _is.DateTimeJsonExtension.fromJson(jsonSerialization['endedAt']),
      steps: jsonSerialization['steps'] as int,
      goalSteps: jsonSerialization['goalSteps'] as int,
      feel: jsonSerialization['feel'] == null
          ? null
          : _ifrvopus.Feel.fromJson((jsonSerialization['feel'] as String)),
      paceDropped: _is.BoolJsonExtension.fromJson(
        jsonSerialization['paceDropped'],
      ),
    );
  }

  String clientSessionId;

  DateTime startedAt;

  DateTime endedAt;

  int steps;

  /// The goal from the plan the phone used for this session.
  int goalSteps;

  _ifrvopus.Feel? feel;

  /// Passive signal from the step timeline (see passive_signals.dart).
  bool paceDropped;

  /// Returns a shallow copy of this [SessionInput]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  SessionInput copyWith({
    String? clientSessionId,
    DateTime? startedAt,
    DateTime? endedAt,
    int? steps,
    int? goalSteps,
    _ifrvopus.Feel? feel,
    bool? paceDropped,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'SessionInput',
      'clientSessionId': clientSessionId,
      'startedAt': startedAt.toJson(),
      'endedAt': endedAt.toJson(),
      'steps': steps,
      'goalSteps': goalSteps,
      if (feel != null) 'feel': feel?.toJson(),
      'paceDropped': paceDropped,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'SessionInput',
      'clientSessionId': clientSessionId,
      'startedAt': startedAt.toJson(),
      'endedAt': endedAt.toJson(),
      'steps': steps,
      'goalSteps': goalSteps,
      if (feel != null) 'feel': feel?.toJson(),
      'paceDropped': paceDropped,
    };
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _SessionInputImpl extends SessionInput {
  _SessionInputImpl({
    required String clientSessionId,
    required DateTime startedAt,
    required DateTime endedAt,
    required int steps,
    required int goalSteps,
    _ifrvopus.Feel? feel,
    required bool paceDropped,
  }) : super._(
         clientSessionId: clientSessionId,
         startedAt: startedAt,
         endedAt: endedAt,
         steps: steps,
         goalSteps: goalSteps,
         feel: feel,
         paceDropped: paceDropped,
       );

  /// Returns a shallow copy of this [SessionInput]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  SessionInput copyWith({
    String? clientSessionId,
    DateTime? startedAt,
    DateTime? endedAt,
    int? steps,
    int? goalSteps,
    Object? feel = _Undefined,
    bool? paceDropped,
  }) {
    return SessionInput(
      clientSessionId: clientSessionId ?? this.clientSessionId,
      startedAt: startedAt ?? this.startedAt,
      endedAt: endedAt ?? this.endedAt,
      steps: steps ?? this.steps,
      goalSteps: goalSteps ?? this.goalSteps,
      feel: feel is _ifrvopus.Feel? ? feel : this.feel,
      paceDropped: paceDropped ?? this.paceDropped,
    );
  }
}

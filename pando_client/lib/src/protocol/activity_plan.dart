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
import 'package:pando_client/src/protocol/protocol.dart' as _i1g0f8g9;
import 'package:serverpod_client/serverpod_client.dart' as _isc;

/// What the phone needs to start the next activity.
abstract class ActivityPlan
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  ActivityPlan._({
    required this.goalSteps,
    required this.goalM,
    required this.strideM,
    required this.resumeMetres,
    required this.signMetres,
  });

  factory ActivityPlan({
    required int goalSteps,
    required double goalM,
    required double strideM,
    required double resumeMetres,
    required List<double> signMetres,
  }) = _ActivityPlanImpl;

  factory ActivityPlan.fromJson(Map<String, dynamic> jsonSerialization) {
    return ActivityPlan(
      goalSteps: jsonSerialization['goalSteps'] as int,
      goalM: (jsonSerialization['goalM'] as num).toDouble(),
      strideM: (jsonSerialization['strideM'] as num).toDouble(),
      resumeMetres: (jsonSerialization['resumeMetres'] as num).toDouble(),
      signMetres: _i1g0f8g9.Protocol().deserialize<List<double>>(
        jsonSerialization['signMetres'],
      ),
    );
  }

  int goalSteps;

  double goalM;

  double strideM;

  /// Where the runner starts (the last session's end, or 0).
  double resumeMetres;

  /// Journey positions of every wooden sign: the start (0) and each session's end.
  List<double> signMetres;

  /// Returns a shallow copy of this [ActivityPlan]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  ActivityPlan copyWith({
    int? goalSteps,
    double? goalM,
    double? strideM,
    double? resumeMetres,
    List<double>? signMetres,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'ActivityPlan',
      'goalSteps': goalSteps,
      'goalM': goalM,
      'strideM': strideM,
      'resumeMetres': resumeMetres,
      'signMetres': signMetres.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'ActivityPlan',
      'goalSteps': goalSteps,
      'goalM': goalM,
      'strideM': strideM,
      'resumeMetres': resumeMetres,
      'signMetres': signMetres.toJson(),
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _ActivityPlanImpl extends ActivityPlan {
  _ActivityPlanImpl({
    required int goalSteps,
    required double goalM,
    required double strideM,
    required double resumeMetres,
    required List<double> signMetres,
  }) : super._(
         goalSteps: goalSteps,
         goalM: goalM,
         strideM: strideM,
         resumeMetres: resumeMetres,
         signMetres: signMetres,
       );

  /// Returns a shallow copy of this [ActivityPlan]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  ActivityPlan copyWith({
    int? goalSteps,
    double? goalM,
    double? strideM,
    double? resumeMetres,
    List<double>? signMetres,
  }) {
    return ActivityPlan(
      goalSteps: goalSteps ?? this.goalSteps,
      goalM: goalM ?? this.goalM,
      strideM: strideM ?? this.strideM,
      resumeMetres: resumeMetres ?? this.resumeMetres,
      signMetres: signMetres ?? this.signMetres.map((e0) => e0).toList(),
    );
  }
}

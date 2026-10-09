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
import 'package:pando_shared/pando_shared.dart' as _ip2bu2mq;
import 'package:serverpod_serialization/serverpod_serialization.dart' as _iss;

/// One stretch of a replay with one gait: from `fromM` to `toM` along the
/// journey path, `realS` seconds of the real walk, shown in `playS` seconds.
abstract class ReplaySegment
    implements _iss.SerializableModel, _iss.ProtocolSerialization {
  ReplaySegment._({
    required this.fromM,
    required this.toM,
    required this.gait,
    required this.realS,
    required this.playS,
  });

  factory ReplaySegment({
    required double fromM,
    required double toM,
    required _ip2bu2mq.Gait gait,
    required double realS,
    required double playS,
  }) = _ReplaySegmentImpl;

  factory ReplaySegment.fromJson(Map<String, dynamic> jsonSerialization) {
    return ReplaySegment(
      fromM: (jsonSerialization['fromM'] as num).toDouble(),
      toM: (jsonSerialization['toM'] as num).toDouble(),
      gait: _ip2bu2mq.Gait.fromJson((jsonSerialization['gait'] as String)),
      realS: (jsonSerialization['realS'] as num).toDouble(),
      playS: (jsonSerialization['playS'] as num).toDouble(),
    );
  }

  double fromM;

  double toM;

  _ip2bu2mq.Gait gait;

  double realS;

  double playS;

  /// Returns a shallow copy of this [ReplaySegment]
  /// with some or all fields replaced by the given arguments.
  @_iss.useResult
  ReplaySegment copyWith({
    double? fromM,
    double? toM,
    _ip2bu2mq.Gait? gait,
    double? realS,
    double? playS,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'ReplaySegment',
      'fromM': fromM,
      'toM': toM,
      'gait': gait.toJson(),
      'realS': realS,
      'playS': playS,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'ReplaySegment',
      'fromM': fromM,
      'toM': toM,
      'gait': gait.toJson(),
      'realS': realS,
      'playS': playS,
    };
  }

  @override
  String toString() {
    return _iss.SerializationManager.encode(this);
  }
}

class _ReplaySegmentImpl extends ReplaySegment {
  _ReplaySegmentImpl({
    required double fromM,
    required double toM,
    required _ip2bu2mq.Gait gait,
    required double realS,
    required double playS,
  }) : super._(fromM: fromM, toM: toM, gait: gait, realS: realS, playS: playS);

  /// Returns a shallow copy of this [ReplaySegment]
  /// with some or all fields replaced by the given arguments.
  @_iss.useResult
  @override
  ReplaySegment copyWith({
    double? fromM,
    double? toM,
    _ip2bu2mq.Gait? gait,
    double? realS,
    double? playS,
  }) {
    return ReplaySegment(
      fromM: fromM ?? this.fromM,
      toM: toM ?? this.toM,
      gait: gait ?? this.gait,
      realS: realS ?? this.realS,
      playS: playS ?? this.playS,
    );
  }
}

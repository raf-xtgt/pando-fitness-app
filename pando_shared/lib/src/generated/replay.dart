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

/// A walk as a short animation on the park: built on the server from the
/// synced walk slices, stored with the session, and played in the report
/// and on the public replay page. Holds nothing about the user.
abstract class Replay
    implements _iss.SerializableModel, _iss.ProtocolSerialization {
  Replay._({
    required this.startPathM,
    required this.endPathM,
    required this.distanceM,
    required this.realS,
    required this.durationS,
    required this.segments,
  });

  factory Replay({
    required double startPathM,
    required double endPathM,
    required double distanceM,
    required double realS,
    required double durationS,
    required List<_ip2bu2mq.ReplaySegment> segments,
  }) = _ReplayImpl;

  factory Replay.fromJson(Map<String, dynamic> jsonSerialization) {
    return Replay(
      startPathM: (jsonSerialization['startPathM'] as num).toDouble(),
      endPathM: (jsonSerialization['endPathM'] as num).toDouble(),
      distanceM: (jsonSerialization['distanceM'] as num).toDouble(),
      realS: (jsonSerialization['realS'] as num).toDouble(),
      durationS: (jsonSerialization['durationS'] as num).toDouble(),
      segments: _ip2bu2mq.Protocol().deserialize<List<_ip2bu2mq.ReplaySegment>>(
        jsonSerialization['segments'],
      ),
    );
  }

  /// Journey positions (metres along the endless path) of the start and end
  /// signs.
  double startPathM;

  double endPathM;

  double distanceM;

  /// Real length of the walk, and of the replay (1 s per minute, 15–90 s).
  double realS;

  double durationS;

  List<_ip2bu2mq.ReplaySegment> segments;

  /// Returns a shallow copy of this [Replay]
  /// with some or all fields replaced by the given arguments.
  @_iss.useResult
  Replay copyWith({
    double? startPathM,
    double? endPathM,
    double? distanceM,
    double? realS,
    double? durationS,
    List<_ip2bu2mq.ReplaySegment>? segments,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'Replay',
      'startPathM': startPathM,
      'endPathM': endPathM,
      'distanceM': distanceM,
      'realS': realS,
      'durationS': durationS,
      'segments': segments.toJson(valueToJson: (v) => v.toJson()),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'Replay',
      'startPathM': startPathM,
      'endPathM': endPathM,
      'distanceM': distanceM,
      'realS': realS,
      'durationS': durationS,
      'segments': segments.toJson(valueToJson: (v) => v.toJsonForProtocol()),
    };
  }

  @override
  String toString() {
    return _iss.SerializationManager.encode(this);
  }
}

class _ReplayImpl extends Replay {
  _ReplayImpl({
    required double startPathM,
    required double endPathM,
    required double distanceM,
    required double realS,
    required double durationS,
    required List<_ip2bu2mq.ReplaySegment> segments,
  }) : super._(
         startPathM: startPathM,
         endPathM: endPathM,
         distanceM: distanceM,
         realS: realS,
         durationS: durationS,
         segments: segments,
       );

  /// Returns a shallow copy of this [Replay]
  /// with some or all fields replaced by the given arguments.
  @_iss.useResult
  @override
  Replay copyWith({
    double? startPathM,
    double? endPathM,
    double? distanceM,
    double? realS,
    double? durationS,
    List<_ip2bu2mq.ReplaySegment>? segments,
  }) {
    return Replay(
      startPathM: startPathM ?? this.startPathM,
      endPathM: endPathM ?? this.endPathM,
      distanceM: distanceM ?? this.distanceM,
      realS: realS ?? this.realS,
      durationS: durationS ?? this.durationS,
      segments: segments ?? this.segments.map((e0) => e0.copyWith()).toList(),
    );
  }
}

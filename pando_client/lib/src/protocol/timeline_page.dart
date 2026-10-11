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
import 'timeline_checkpoint.dart' as _ihf7wrsf;

/// The journey timeline: totals over every walk, and one page of
/// checkpoints (newest first).
abstract class TimelinePage
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  TimelinePage._({
    required this.totalSteps,
    required this.totalM,
    required this.totalS,
    required this.walkCount,
    required this.checkpoints,
    required this.hasEarlier,
  });

  factory TimelinePage({
    required int totalSteps,
    required double totalM,
    required double totalS,
    required int walkCount,
    required List<_ihf7wrsf.TimelineCheckpoint> checkpoints,
    required bool hasEarlier,
  }) = _TimelinePageImpl;

  factory TimelinePage.fromJson(Map<String, dynamic> jsonSerialization) {
    return TimelinePage(
      totalSteps: jsonSerialization['totalSteps'] as int,
      totalM: (jsonSerialization['totalM'] as num).toDouble(),
      totalS: (jsonSerialization['totalS'] as num).toDouble(),
      walkCount: jsonSerialization['walkCount'] as int,
      checkpoints: _i1g0f8g9.Protocol()
          .deserialize<List<_ihf7wrsf.TimelineCheckpoint>>(
            jsonSerialization['checkpoints'],
          ),
      hasEarlier: _isc.BoolJsonExtension.fromJson(
        jsonSerialization['hasEarlier'],
      ),
    );
  }

  int totalSteps;

  double totalM;

  /// Sum of the walks' durations (start to stop).
  double totalS;

  int walkCount;

  List<_ihf7wrsf.TimelineCheckpoint> checkpoints;

  /// Older checkpoints exist (the next page).
  bool hasEarlier;

  /// Returns a shallow copy of this [TimelinePage]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  TimelinePage copyWith({
    int? totalSteps,
    double? totalM,
    double? totalS,
    int? walkCount,
    List<_ihf7wrsf.TimelineCheckpoint>? checkpoints,
    bool? hasEarlier,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'TimelinePage',
      'totalSteps': totalSteps,
      'totalM': totalM,
      'totalS': totalS,
      'walkCount': walkCount,
      'checkpoints': checkpoints.toJson(valueToJson: (v) => v.toJson()),
      'hasEarlier': hasEarlier,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'TimelinePage',
      'totalSteps': totalSteps,
      'totalM': totalM,
      'totalS': totalS,
      'walkCount': walkCount,
      'checkpoints': checkpoints.toJson(
        valueToJson: (v) => v.toJsonForProtocol(),
      ),
      'hasEarlier': hasEarlier,
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _TimelinePageImpl extends TimelinePage {
  _TimelinePageImpl({
    required int totalSteps,
    required double totalM,
    required double totalS,
    required int walkCount,
    required List<_ihf7wrsf.TimelineCheckpoint> checkpoints,
    required bool hasEarlier,
  }) : super._(
         totalSteps: totalSteps,
         totalM: totalM,
         totalS: totalS,
         walkCount: walkCount,
         checkpoints: checkpoints,
         hasEarlier: hasEarlier,
       );

  /// Returns a shallow copy of this [TimelinePage]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  TimelinePage copyWith({
    int? totalSteps,
    double? totalM,
    double? totalS,
    int? walkCount,
    List<_ihf7wrsf.TimelineCheckpoint>? checkpoints,
    bool? hasEarlier,
  }) {
    return TimelinePage(
      totalSteps: totalSteps ?? this.totalSteps,
      totalM: totalM ?? this.totalM,
      totalS: totalS ?? this.totalS,
      walkCount: walkCount ?? this.walkCount,
      checkpoints:
          checkpoints ?? this.checkpoints.map((e0) => e0.copyWith()).toList(),
      hasEarlier: hasEarlier ?? this.hasEarlier,
    );
  }
}

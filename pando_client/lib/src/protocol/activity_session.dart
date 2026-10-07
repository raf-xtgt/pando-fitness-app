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
import 'feel.dart' as _ifrvopus;

/// One walk or run, saved once after the feel question.
abstract class ActivitySession
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  ActivitySession._({
    this.id,
    required this.profileId,
    required this.clientSessionId,
    required this.startedAt,
    required this.endedAt,
    required this.steps,
    required this.strideM,
    required this.distanceM,
    required this.goalSteps,
    required this.goalM,
    required this.goalMet,
    required this.extraM,
    this.feel,
    required this.stoppedEarly,
    required this.paceDropped,
    required this.startPathM,
    required this.endPathM,
    this.reportMessage,
    required this.reportReadyAt,
    this.notificationSentAt,
    bool? isSeeded,
  }) : isSeeded = isSeeded ?? false;

  factory ActivitySession({
    int? id,
    required int profileId,
    required String clientSessionId,
    required DateTime startedAt,
    required DateTime endedAt,
    required int steps,
    required double strideM,
    required double distanceM,
    required int goalSteps,
    required double goalM,
    required bool goalMet,
    required double extraM,
    _ifrvopus.Feel? feel,
    required bool stoppedEarly,
    required bool paceDropped,
    required double startPathM,
    required double endPathM,
    String? reportMessage,
    required DateTime reportReadyAt,
    DateTime? notificationSentAt,
    bool? isSeeded,
  }) = _ActivitySessionImpl;

  factory ActivitySession.fromJson(Map<String, dynamic> jsonSerialization) {
    return ActivitySession(
      id: jsonSerialization['id'] as int?,
      profileId: jsonSerialization['profileId'] as int,
      clientSessionId: jsonSerialization['clientSessionId'] as String,
      startedAt: _isc.DateTimeJsonExtension.fromJson(
        jsonSerialization['startedAt'],
      ),
      endedAt: _isc.DateTimeJsonExtension.fromJson(
        jsonSerialization['endedAt'],
      ),
      steps: jsonSerialization['steps'] as int,
      strideM: (jsonSerialization['strideM'] as num).toDouble(),
      distanceM: (jsonSerialization['distanceM'] as num).toDouble(),
      goalSteps: jsonSerialization['goalSteps'] as int,
      goalM: (jsonSerialization['goalM'] as num).toDouble(),
      goalMet: _isc.BoolJsonExtension.fromJson(jsonSerialization['goalMet']),
      extraM: (jsonSerialization['extraM'] as num).toDouble(),
      feel: jsonSerialization['feel'] == null
          ? null
          : _ifrvopus.Feel.fromJson((jsonSerialization['feel'] as String)),
      stoppedEarly: _isc.BoolJsonExtension.fromJson(
        jsonSerialization['stoppedEarly'],
      ),
      paceDropped: _isc.BoolJsonExtension.fromJson(
        jsonSerialization['paceDropped'],
      ),
      startPathM: (jsonSerialization['startPathM'] as num).toDouble(),
      endPathM: (jsonSerialization['endPathM'] as num).toDouble(),
      reportMessage: jsonSerialization['reportMessage'] as String?,
      reportReadyAt: _isc.DateTimeJsonExtension.fromJson(
        jsonSerialization['reportReadyAt'],
      ),
      notificationSentAt: jsonSerialization['notificationSentAt'] == null
          ? null
          : _isc.DateTimeJsonExtension.fromJson(
              jsonSerialization['notificationSentAt'],
            ),
      isSeeded: jsonSerialization['isSeeded'] == null
          ? null
          : _isc.BoolJsonExtension.fromJson(jsonSerialization['isSeeded']),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  /// The owner's profile.
  int profileId;

  /// Made on the phone at Start; makes save() safe to retry.
  String clientSessionId;

  DateTime startedAt;

  DateTime endedAt;

  int steps;

  double strideM;

  double distanceM;

  /// The goal the walker saw during this session.
  int goalSteps;

  double goalM;

  bool goalMet;

  /// Distance past the goal (0 if the goal wasn't met).
  double extraM;

  _ifrvopus.Feel? feel;

  bool stoppedEarly;

  bool paceDropped;

  /// Journey position (metres along the endless path) at start and end.
  double startPathM;

  double endPathM;

  /// Filled in by the report builder (slice 4).
  String? reportMessage;

  /// Report and notification are due 5 minutes after the session ends.
  DateTime reportReadyAt;

  DateTime? notificationSentAt;

  /// Demo-only history (slice 5).
  bool isSeeded;

  /// Returns a shallow copy of this [ActivitySession]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  ActivitySession copyWith({
    int? id,
    int? profileId,
    String? clientSessionId,
    DateTime? startedAt,
    DateTime? endedAt,
    int? steps,
    double? strideM,
    double? distanceM,
    int? goalSteps,
    double? goalM,
    bool? goalMet,
    double? extraM,
    _ifrvopus.Feel? feel,
    bool? stoppedEarly,
    bool? paceDropped,
    double? startPathM,
    double? endPathM,
    String? reportMessage,
    DateTime? reportReadyAt,
    DateTime? notificationSentAt,
    bool? isSeeded,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'ActivitySession',
      if (id != null) 'id': id,
      'profileId': profileId,
      'clientSessionId': clientSessionId,
      'startedAt': startedAt.toJson(),
      'endedAt': endedAt.toJson(),
      'steps': steps,
      'strideM': strideM,
      'distanceM': distanceM,
      'goalSteps': goalSteps,
      'goalM': goalM,
      'goalMet': goalMet,
      'extraM': extraM,
      if (feel != null) 'feel': feel?.toJson(),
      'stoppedEarly': stoppedEarly,
      'paceDropped': paceDropped,
      'startPathM': startPathM,
      'endPathM': endPathM,
      if (reportMessage != null) 'reportMessage': reportMessage,
      'reportReadyAt': reportReadyAt.toJson(),
      if (notificationSentAt != null)
        'notificationSentAt': notificationSentAt?.toJson(),
      'isSeeded': isSeeded,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'ActivitySession',
      if (id != null) 'id': id,
      'profileId': profileId,
      'clientSessionId': clientSessionId,
      'startedAt': startedAt.toJson(),
      'endedAt': endedAt.toJson(),
      'steps': steps,
      'strideM': strideM,
      'distanceM': distanceM,
      'goalSteps': goalSteps,
      'goalM': goalM,
      'goalMet': goalMet,
      'extraM': extraM,
      if (feel != null) 'feel': feel?.toJson(),
      'stoppedEarly': stoppedEarly,
      'paceDropped': paceDropped,
      'startPathM': startPathM,
      'endPathM': endPathM,
      if (reportMessage != null) 'reportMessage': reportMessage,
      'reportReadyAt': reportReadyAt.toJson(),
      if (notificationSentAt != null)
        'notificationSentAt': notificationSentAt?.toJson(),
      'isSeeded': isSeeded,
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _ActivitySessionImpl extends ActivitySession {
  _ActivitySessionImpl({
    int? id,
    required int profileId,
    required String clientSessionId,
    required DateTime startedAt,
    required DateTime endedAt,
    required int steps,
    required double strideM,
    required double distanceM,
    required int goalSteps,
    required double goalM,
    required bool goalMet,
    required double extraM,
    _ifrvopus.Feel? feel,
    required bool stoppedEarly,
    required bool paceDropped,
    required double startPathM,
    required double endPathM,
    String? reportMessage,
    required DateTime reportReadyAt,
    DateTime? notificationSentAt,
    bool? isSeeded,
  }) : super._(
         id: id,
         profileId: profileId,
         clientSessionId: clientSessionId,
         startedAt: startedAt,
         endedAt: endedAt,
         steps: steps,
         strideM: strideM,
         distanceM: distanceM,
         goalSteps: goalSteps,
         goalM: goalM,
         goalMet: goalMet,
         extraM: extraM,
         feel: feel,
         stoppedEarly: stoppedEarly,
         paceDropped: paceDropped,
         startPathM: startPathM,
         endPathM: endPathM,
         reportMessage: reportMessage,
         reportReadyAt: reportReadyAt,
         notificationSentAt: notificationSentAt,
         isSeeded: isSeeded,
       );

  /// Returns a shallow copy of this [ActivitySession]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  ActivitySession copyWith({
    Object? id = _Undefined,
    int? profileId,
    String? clientSessionId,
    DateTime? startedAt,
    DateTime? endedAt,
    int? steps,
    double? strideM,
    double? distanceM,
    int? goalSteps,
    double? goalM,
    bool? goalMet,
    double? extraM,
    Object? feel = _Undefined,
    bool? stoppedEarly,
    bool? paceDropped,
    double? startPathM,
    double? endPathM,
    Object? reportMessage = _Undefined,
    DateTime? reportReadyAt,
    Object? notificationSentAt = _Undefined,
    bool? isSeeded,
  }) {
    return ActivitySession(
      id: id is int? ? id : this.id,
      profileId: profileId ?? this.profileId,
      clientSessionId: clientSessionId ?? this.clientSessionId,
      startedAt: startedAt ?? this.startedAt,
      endedAt: endedAt ?? this.endedAt,
      steps: steps ?? this.steps,
      strideM: strideM ?? this.strideM,
      distanceM: distanceM ?? this.distanceM,
      goalSteps: goalSteps ?? this.goalSteps,
      goalM: goalM ?? this.goalM,
      goalMet: goalMet ?? this.goalMet,
      extraM: extraM ?? this.extraM,
      feel: feel is _ifrvopus.Feel? ? feel : this.feel,
      stoppedEarly: stoppedEarly ?? this.stoppedEarly,
      paceDropped: paceDropped ?? this.paceDropped,
      startPathM: startPathM ?? this.startPathM,
      endPathM: endPathM ?? this.endPathM,
      reportMessage: reportMessage is String?
          ? reportMessage
          : this.reportMessage,
      reportReadyAt: reportReadyAt ?? this.reportReadyAt,
      notificationSentAt: notificationSentAt is DateTime?
          ? notificationSentAt
          : this.notificationSentAt,
      isSeeded: isSeeded ?? this.isSeeded,
    );
  }
}

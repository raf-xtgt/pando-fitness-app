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

/// One walk or run, saved once after the feel question.
abstract class ActivitySession
    implements _is.TableRow<int?>, _is.ProtocolSerialization {
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
      startedAt: _is.DateTimeJsonExtension.fromJson(
        jsonSerialization['startedAt'],
      ),
      endedAt: _is.DateTimeJsonExtension.fromJson(jsonSerialization['endedAt']),
      steps: jsonSerialization['steps'] as int,
      strideM: (jsonSerialization['strideM'] as num).toDouble(),
      distanceM: (jsonSerialization['distanceM'] as num).toDouble(),
      goalSteps: jsonSerialization['goalSteps'] as int,
      goalM: (jsonSerialization['goalM'] as num).toDouble(),
      goalMet: _is.BoolJsonExtension.fromJson(jsonSerialization['goalMet']),
      extraM: (jsonSerialization['extraM'] as num).toDouble(),
      feel: jsonSerialization['feel'] == null
          ? null
          : _ifrvopus.Feel.fromJson((jsonSerialization['feel'] as String)),
      stoppedEarly: _is.BoolJsonExtension.fromJson(
        jsonSerialization['stoppedEarly'],
      ),
      paceDropped: _is.BoolJsonExtension.fromJson(
        jsonSerialization['paceDropped'],
      ),
      startPathM: (jsonSerialization['startPathM'] as num).toDouble(),
      endPathM: (jsonSerialization['endPathM'] as num).toDouble(),
      reportMessage: jsonSerialization['reportMessage'] as String?,
      reportReadyAt: _is.DateTimeJsonExtension.fromJson(
        jsonSerialization['reportReadyAt'],
      ),
      notificationSentAt: jsonSerialization['notificationSentAt'] == null
          ? null
          : _is.DateTimeJsonExtension.fromJson(
              jsonSerialization['notificationSentAt'],
            ),
      isSeeded: jsonSerialization['isSeeded'] == null
          ? null
          : _is.BoolJsonExtension.fromJson(jsonSerialization['isSeeded']),
    );
  }

  static final t = ActivitySessionTable();

  static const db = ActivitySessionRepository._();

  @override
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

  @override
  _is.Table<int?> get table => t;

  /// Returns a shallow copy of this [ActivitySession]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
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

  static ActivitySessionInclude include() {
    return ActivitySessionInclude._();
  }

  static ActivitySessionIncludeList includeList({
    _is.WhereExpressionBuilder<ActivitySessionTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<ActivitySessionTable>? orderBy,
    _is.OrderByListBuilder<ActivitySessionTable>? orderByList,
    ActivitySessionInclude? include,
  }) {
    return ActivitySessionIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(ActivitySession.t),
      orderByList: orderByList?.call(ActivitySession.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
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
  @_is.useResult
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

class ActivitySessionUpdateTable extends _is.UpdateTable<ActivitySessionTable> {
  ActivitySessionUpdateTable(super.table);

  _is.ColumnValue<int, int> profileId(int value) => _is.ColumnValue(
    table.profileId,
    value,
  );

  _is.ColumnValue<String, String> clientSessionId(String value) =>
      _is.ColumnValue(
        table.clientSessionId,
        value,
      );

  _is.ColumnValue<DateTime, DateTime> startedAt(DateTime value) =>
      _is.ColumnValue(
        table.startedAt,
        value,
      );

  _is.ColumnValue<DateTime, DateTime> endedAt(DateTime value) =>
      _is.ColumnValue(
        table.endedAt,
        value,
      );

  _is.ColumnValue<int, int> steps(int value) => _is.ColumnValue(
    table.steps,
    value,
  );

  _is.ColumnValue<double, double> strideM(double value) => _is.ColumnValue(
    table.strideM,
    value,
  );

  _is.ColumnValue<double, double> distanceM(double value) => _is.ColumnValue(
    table.distanceM,
    value,
  );

  _is.ColumnValue<int, int> goalSteps(int value) => _is.ColumnValue(
    table.goalSteps,
    value,
  );

  _is.ColumnValue<double, double> goalM(double value) => _is.ColumnValue(
    table.goalM,
    value,
  );

  _is.ColumnValue<bool, bool> goalMet(bool value) => _is.ColumnValue(
    table.goalMet,
    value,
  );

  _is.ColumnValue<double, double> extraM(double value) => _is.ColumnValue(
    table.extraM,
    value,
  );

  _is.ColumnValue<_ifrvopus.Feel, _ifrvopus.Feel> feel(_ifrvopus.Feel? value) =>
      _is.ColumnValue(
        table.feel,
        value,
      );

  _is.ColumnValue<bool, bool> stoppedEarly(bool value) => _is.ColumnValue(
    table.stoppedEarly,
    value,
  );

  _is.ColumnValue<bool, bool> paceDropped(bool value) => _is.ColumnValue(
    table.paceDropped,
    value,
  );

  _is.ColumnValue<double, double> startPathM(double value) => _is.ColumnValue(
    table.startPathM,
    value,
  );

  _is.ColumnValue<double, double> endPathM(double value) => _is.ColumnValue(
    table.endPathM,
    value,
  );

  _is.ColumnValue<String, String> reportMessage(String? value) =>
      _is.ColumnValue(
        table.reportMessage,
        value,
      );

  _is.ColumnValue<DateTime, DateTime> reportReadyAt(DateTime value) =>
      _is.ColumnValue(
        table.reportReadyAt,
        value,
      );

  _is.ColumnValue<DateTime, DateTime> notificationSentAt(DateTime? value) =>
      _is.ColumnValue(
        table.notificationSentAt,
        value,
      );

  _is.ColumnValue<bool, bool> isSeeded(bool value) => _is.ColumnValue(
    table.isSeeded,
    value,
  );
}

class ActivitySessionTable extends _is.Table<int?> {
  ActivitySessionTable({super.tableRelation})
    : super(tableName: 'activity_session') {
    updateTable = ActivitySessionUpdateTable(this);
    profileId = _is.ColumnInt(
      'profileId',
      this,
    );
    clientSessionId = _is.ColumnString(
      'clientSessionId',
      this,
    );
    startedAt = _is.ColumnDateTime(
      'startedAt',
      this,
    );
    endedAt = _is.ColumnDateTime(
      'endedAt',
      this,
    );
    steps = _is.ColumnInt(
      'steps',
      this,
    );
    strideM = _is.ColumnDouble(
      'strideM',
      this,
    );
    distanceM = _is.ColumnDouble(
      'distanceM',
      this,
    );
    goalSteps = _is.ColumnInt(
      'goalSteps',
      this,
    );
    goalM = _is.ColumnDouble(
      'goalM',
      this,
    );
    goalMet = _is.ColumnBool(
      'goalMet',
      this,
    );
    extraM = _is.ColumnDouble(
      'extraM',
      this,
    );
    feel = _is.ColumnEnum(
      'feel',
      this,
      _is.EnumSerialization.byName,
    );
    stoppedEarly = _is.ColumnBool(
      'stoppedEarly',
      this,
    );
    paceDropped = _is.ColumnBool(
      'paceDropped',
      this,
    );
    startPathM = _is.ColumnDouble(
      'startPathM',
      this,
    );
    endPathM = _is.ColumnDouble(
      'endPathM',
      this,
    );
    reportMessage = _is.ColumnString(
      'reportMessage',
      this,
    );
    reportReadyAt = _is.ColumnDateTime(
      'reportReadyAt',
      this,
    );
    notificationSentAt = _is.ColumnDateTime(
      'notificationSentAt',
      this,
    );
    isSeeded = _is.ColumnBool(
      'isSeeded',
      this,
      hasDefault: true,
    );
  }

  late final ActivitySessionUpdateTable updateTable;

  /// The owner's profile.
  late final _is.ColumnInt profileId;

  /// Made on the phone at Start; makes save() safe to retry.
  late final _is.ColumnString clientSessionId;

  late final _is.ColumnDateTime startedAt;

  late final _is.ColumnDateTime endedAt;

  late final _is.ColumnInt steps;

  late final _is.ColumnDouble strideM;

  late final _is.ColumnDouble distanceM;

  /// The goal the walker saw during this session.
  late final _is.ColumnInt goalSteps;

  late final _is.ColumnDouble goalM;

  late final _is.ColumnBool goalMet;

  /// Distance past the goal (0 if the goal wasn't met).
  late final _is.ColumnDouble extraM;

  late final _is.ColumnEnum<_ifrvopus.Feel> feel;

  late final _is.ColumnBool stoppedEarly;

  late final _is.ColumnBool paceDropped;

  /// Journey position (metres along the endless path) at start and end.
  late final _is.ColumnDouble startPathM;

  late final _is.ColumnDouble endPathM;

  /// Filled in by the report builder (slice 4).
  late final _is.ColumnString reportMessage;

  /// Report and notification are due 5 minutes after the session ends.
  late final _is.ColumnDateTime reportReadyAt;

  late final _is.ColumnDateTime notificationSentAt;

  /// Demo-only history (slice 5).
  late final _is.ColumnBool isSeeded;

  @override
  List<_is.Column> get columns => [
    id,
    profileId,
    clientSessionId,
    startedAt,
    endedAt,
    steps,
    strideM,
    distanceM,
    goalSteps,
    goalM,
    goalMet,
    extraM,
    feel,
    stoppedEarly,
    paceDropped,
    startPathM,
    endPathM,
    reportMessage,
    reportReadyAt,
    notificationSentAt,
    isSeeded,
  ];
}

class ActivitySessionInclude extends _is.IncludeObject {
  ActivitySessionInclude._();

  @override
  Map<String, _is.Include?> get includes => {};

  @override
  _is.Table<int?> get table => ActivitySession.t;
}

class ActivitySessionIncludeList extends _is.IncludeList {
  ActivitySessionIncludeList._({
    _is.WhereExpressionBuilder<ActivitySessionTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(ActivitySession.t);
  }

  @override
  Map<String, _is.Include?> get includes => include?.includes ?? {};

  @override
  _is.Table<int?> get table => ActivitySession.t;
}

class ActivitySessionRepository {
  const ActivitySessionRepository._();

  /// Returns a list of [ActivitySession]s matching the given query parameters.
  ///
  /// Use [where] to specify which items to include in the return value.
  /// If none is specified, all items will be returned.
  ///
  /// To specify the order of the items use [orderBy] or [orderByList]
  /// when sorting by multiple columns.
  ///
  /// The maximum number of items can be set by [limit]. If no limit is set,
  /// all items matching the query will be returned.
  ///
  /// [offset] defines how many items to skip, after which [limit] (or all)
  /// items are read from the database.
  ///
  /// ```dart
  /// var persons = await Persons.db.find(
  ///   session,
  ///   where: (t) => t.lastName.equals('Jones'),
  ///   orderBy: (t) => t.firstName,
  ///   limit: 100,
  /// );
  /// ```
  Future<List<ActivitySession>> find(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<ActivitySessionTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<ActivitySessionTable>? orderBy,
    _is.OrderByListBuilder<ActivitySessionTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<ActivitySession>(
      where: where?.call(ActivitySession.t),
      orderBy: orderBy?.call(ActivitySession.t),
      orderByList: orderByList?.call(ActivitySession.t),
      limit: limit,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [ActivitySession] matching the given query parameters.
  ///
  /// Use [where] to specify which items to include in the return value.
  /// If none is specified, all items will be returned.
  ///
  /// To specify the order use [orderBy] or [orderByList]
  /// when sorting by multiple columns.
  ///
  /// [offset] defines how many items to skip, after which the next one will be picked.
  ///
  /// ```dart
  /// var youngestPerson = await Persons.db.findFirstRow(
  ///   session,
  ///   where: (t) => t.lastName.equals('Jones'),
  ///   orderBy: (t) => t.age,
  /// );
  /// ```
  Future<ActivitySession?> findFirstRow(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<ActivitySessionTable>? where,
    int? offset,
    _is.OrderByBuilder<ActivitySessionTable>? orderBy,
    _is.OrderByListBuilder<ActivitySessionTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<ActivitySession>(
      where: where?.call(ActivitySession.t),
      orderBy: orderBy?.call(ActivitySession.t),
      orderByList: orderByList?.call(ActivitySession.t),
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [ActivitySession] by its [id] or null if no such row exists.
  Future<ActivitySession?> findById(
    _is.DatabaseSession session,
    int id, {
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<ActivitySession>(
      id,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [ActivitySession]s in the list and returns the inserted rows.
  ///
  /// The returned [ActivitySession]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  ///
  /// If [ignoreConflicts] is set to `true`, rows that conflict with existing
  /// rows are silently skipped, and only the successfully inserted rows are
  /// returned.
  ///
  /// If [noReturn] is set to `true`, the inserted rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<ActivitySession>> insert(
    _is.DatabaseSession session,
    List<ActivitySession> rows, {
    _is.Transaction? transaction,
    bool ignoreConflicts = false,
    bool noReturn = false,
  }) async {
    return session.db.insert<ActivitySession>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
      noReturn: noReturn,
    );
  }

  /// Inserts a single [ActivitySession] and returns the inserted row.
  ///
  /// The returned [ActivitySession] will have its `id` field set.
  Future<ActivitySession> insertRow(
    _is.DatabaseSession session,
    ActivitySession row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.insertRow<ActivitySession>(
      row,
      transaction: transaction,
    );
  }

  /// Upserts all [ActivitySession]s in the list and returns the resulting rows.
  ///
  /// If a row conflicts on the given [conflictColumns], the existing row is
  /// updated with the new values. Otherwise, a new row is inserted.
  ///
  /// If [updateColumns] is provided, only those columns will be updated on
  /// conflict. If null, all non-conflict, non-id columns are updated.
  ///
  /// If [updateWhere] is provided, the update only applies to rows matching the
  /// given expression. Conflicting rows that don't match are skipped and not
  /// returned, so the resulting list may be shorter than [rows].
  ///
  /// The returned [ActivitySession]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails,
  /// none of the rows will be affected.
  ///
  /// If [noReturn] is set to `true`, the resulting rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<ActivitySession>> upsert(
    _is.DatabaseSession session,
    List<ActivitySession> rows, {
    required _is.ColumnSelections<ActivitySessionTable> conflictColumns,
    _is.ColumnSelections<ActivitySessionTable>? updateColumns,
    _is.WhereExpressionBuilder<ActivitySessionTable>? updateWhere,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.upsert<ActivitySession>(
      rows,
      conflictColumns: conflictColumns(ActivitySession.t),
      updateColumns: updateColumns?.call(ActivitySession.t),
      updateWhere: updateWhere?.call(ActivitySession.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Upserts a single [ActivitySession] and returns the resulting row.
  ///
  /// If the row conflicts on the given [conflictColumns], the existing row is
  /// updated. Otherwise, a new row is inserted.
  ///
  /// If [updateColumns] is provided, only those columns will be updated on
  /// conflict. If null, all non-conflict, non-id columns are updated.
  ///
  /// If [updateWhere] is provided, the update only applies when the existing
  /// row matches the expression. Returns `null` if no row was affected — for
  /// example when [updateWhere] does not match the conflicting row.
  ///
  /// The returned [ActivitySession] will have its `id` field set.
  Future<ActivitySession?> upsertRow(
    _is.DatabaseSession session,
    ActivitySession row, {
    required _is.ColumnSelections<ActivitySessionTable> conflictColumns,
    _is.ColumnSelections<ActivitySessionTable>? updateColumns,
    _is.WhereExpressionBuilder<ActivitySessionTable>? updateWhere,
    _is.Transaction? transaction,
  }) async {
    return session.db.upsertRow<ActivitySession>(
      row,
      conflictColumns: conflictColumns(ActivitySession.t),
      updateColumns: updateColumns?.call(ActivitySession.t),
      updateWhere: updateWhere?.call(ActivitySession.t),
      transaction: transaction,
    );
  }

  /// Updates all [ActivitySession]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<ActivitySession>> update(
    _is.DatabaseSession session,
    List<ActivitySession> rows, {
    _is.ColumnSelections<ActivitySessionTable>? columns,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.update<ActivitySession>(
      rows,
      columns: columns?.call(ActivitySession.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Updates a single [ActivitySession]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<ActivitySession> updateRow(
    _is.DatabaseSession session,
    ActivitySession row, {
    _is.ColumnSelections<ActivitySessionTable>? columns,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateRow<ActivitySession>(
      row,
      columns: columns?.call(ActivitySession.t),
      transaction: transaction,
    );
  }

  /// Updates a single [ActivitySession] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<ActivitySession?> updateById(
    _is.DatabaseSession session,
    int id, {
    required _is.ColumnValueListBuilder<ActivitySessionUpdateTable>
    columnValues,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateById<ActivitySession>(
      id,
      columnValues: columnValues(ActivitySession.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [ActivitySession]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<ActivitySession>> updateWhere(
    _is.DatabaseSession session, {
    required _is.ColumnValueListBuilder<ActivitySessionUpdateTable>
    columnValues,
    required _is.WhereExpressionBuilder<ActivitySessionTable> where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<ActivitySessionTable>? orderBy,
    _is.OrderByListBuilder<ActivitySessionTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.updateWhere<ActivitySession>(
      columnValues: columnValues(ActivitySession.t.updateTable),
      where: where(ActivitySession.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(ActivitySession.t),
      orderByList: orderByList?.call(ActivitySession.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes all [ActivitySession]s in the list and returns the deleted rows.
  ///
  /// To specify the order of the returned rows use [orderBy] or [orderByList]
  /// when sorting by multiple columns.
  ///
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  ///
  /// If [noReturn] is set to `true`, the deleted rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<ActivitySession>> delete(
    _is.DatabaseSession session,
    List<ActivitySession> rows, {
    _is.OrderByBuilder<ActivitySessionTable>? orderBy,
    _is.OrderByListBuilder<ActivitySessionTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.delete<ActivitySession>(
      rows,
      orderBy: orderBy?.call(ActivitySession.t),
      orderByList: orderByList?.call(ActivitySession.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes a single [ActivitySession].
  Future<ActivitySession> deleteRow(
    _is.DatabaseSession session,
    ActivitySession row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.deleteRow<ActivitySession>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  ///
  /// To specify the order of the returned rows use [orderBy] or [orderByList]
  /// when sorting by multiple columns.
  ///
  /// If [noReturn] is set to `true`, the deleted rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<ActivitySession>> deleteWhere(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<ActivitySessionTable> where,
    _is.OrderByBuilder<ActivitySessionTable>? orderBy,
    _is.OrderByListBuilder<ActivitySessionTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.deleteWhere<ActivitySession>(
      where: where(ActivitySession.t),
      orderBy: orderBy?.call(ActivitySession.t),
      orderByList: orderByList?.call(ActivitySession.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<ActivitySessionTable>? where,
    int? limit,
    _is.Transaction? transaction,
  }) async {
    return session.db.count<ActivitySession>(
      where: where?.call(ActivitySession.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [ActivitySession] rows matching the [where] expression.
  Future<void> lockRows(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<ActivitySessionTable> where,
    required _is.LockMode lockMode,
    required _is.Transaction transaction,
    _is.LockBehavior lockBehavior = _is.LockBehavior.wait,
  }) async {
    return session.db.lockRows<ActivitySession>(
      where: where(ActivitySession.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}

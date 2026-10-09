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
import 'package:serverpod_database/serverpod_database.dart' as _isd;

/// A walk that has started but isn't saved yet. Lives only in the phone's
/// SQLite, so a walk survives Pando being killed. Deleted once the session
/// is queued for the server.
abstract class WalkInProgress
    implements _isd.TableRow<int?>, _isc.ProtocolSerialization {
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
      startedAt: _isc.DateTimeJsonExtension.fromJson(
        jsonSerialization['startedAt'],
      ),
      startCount: jsonSerialization['startCount'] as int?,
      goalSteps: jsonSerialization['goalSteps'] as int,
      resumeMetres: (jsonSerialization['resumeMetres'] as num).toDouble(),
    );
  }

  static final t = WalkInProgressTable();

  static const db = WalkInProgressRepository._();

  @override
  int? id;

  String clientSessionId;

  DateTime startedAt;

  /// The phone's step counter (steps since boot) at Start; null until the
  /// first sensor event. Fallback when the step history can't be read.
  int? startCount;

  /// The plan the walker saw at Start.
  int goalSteps;

  double resumeMetres;

  @override
  _isd.Table<int?> get table => t;

  /// Returns a shallow copy of this [WalkInProgress]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
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

  static WalkInProgressInclude include() {
    return WalkInProgressInclude._();
  }

  static WalkInProgressIncludeList includeList({
    _isd.WhereExpressionBuilder<WalkInProgressTable>? where,
    int? limit,
    int? offset,
    _isd.OrderByBuilder<WalkInProgressTable>? orderBy,
    _isd.OrderByListBuilder<WalkInProgressTable>? orderByList,
    WalkInProgressInclude? include,
  }) {
    return WalkInProgressIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(WalkInProgress.t),
      orderByList: orderByList?.call(WalkInProgress.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
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
  @_isc.useResult
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

class WalkInProgressUpdateTable extends _isd.UpdateTable<WalkInProgressTable> {
  WalkInProgressUpdateTable(super.table);

  _isd.ColumnValue<String, String> clientSessionId(String value) =>
      _isd.ColumnValue(
        table.clientSessionId,
        value,
      );

  _isd.ColumnValue<DateTime, DateTime> startedAt(DateTime value) =>
      _isd.ColumnValue(
        table.startedAt,
        value,
      );

  _isd.ColumnValue<int, int> startCount(int? value) => _isd.ColumnValue(
    table.startCount,
    value,
  );

  _isd.ColumnValue<int, int> goalSteps(int value) => _isd.ColumnValue(
    table.goalSteps,
    value,
  );

  _isd.ColumnValue<double, double> resumeMetres(double value) =>
      _isd.ColumnValue(
        table.resumeMetres,
        value,
      );
}

class WalkInProgressTable extends _isd.Table<int?> {
  WalkInProgressTable({super.tableRelation})
    : super(tableName: 'walk_in_progress') {
    updateTable = WalkInProgressUpdateTable(this);
    clientSessionId = _isd.ColumnString(
      'clientSessionId',
      this,
    );
    startedAt = _isd.ColumnDateTime(
      'startedAt',
      this,
    );
    startCount = _isd.ColumnInt(
      'startCount',
      this,
    );
    goalSteps = _isd.ColumnInt(
      'goalSteps',
      this,
    );
    resumeMetres = _isd.ColumnDouble(
      'resumeMetres',
      this,
    );
  }

  late final WalkInProgressUpdateTable updateTable;

  late final _isd.ColumnString clientSessionId;

  late final _isd.ColumnDateTime startedAt;

  /// The phone's step counter (steps since boot) at Start; null until the
  /// first sensor event. Fallback when the step history can't be read.
  late final _isd.ColumnInt startCount;

  /// The plan the walker saw at Start.
  late final _isd.ColumnInt goalSteps;

  late final _isd.ColumnDouble resumeMetres;

  @override
  List<_isd.Column> get columns => [
    id,
    clientSessionId,
    startedAt,
    startCount,
    goalSteps,
    resumeMetres,
  ];
}

class WalkInProgressInclude extends _isd.IncludeObject {
  WalkInProgressInclude._();

  @override
  Map<String, _isd.Include?> get includes => {};

  @override
  _isd.Table<int?> get table => WalkInProgress.t;
}

class WalkInProgressIncludeList extends _isd.IncludeList {
  WalkInProgressIncludeList._({
    _isd.WhereExpressionBuilder<WalkInProgressTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(WalkInProgress.t);
  }

  @override
  Map<String, _isd.Include?> get includes => include?.includes ?? {};

  @override
  _isd.Table<int?> get table => WalkInProgress.t;
}

class WalkInProgressRepository {
  const WalkInProgressRepository._();

  /// Returns a list of [WalkInProgress]s matching the given query parameters.
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
  Future<List<WalkInProgress>> find(
    _isd.DatabaseSession session, {
    _isd.WhereExpressionBuilder<WalkInProgressTable>? where,
    int? limit,
    int? offset,
    _isd.OrderByBuilder<WalkInProgressTable>? orderBy,
    _isd.OrderByListBuilder<WalkInProgressTable>? orderByList,
    _isd.Transaction? transaction,
    _isd.LockMode? lockMode,
    _isd.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<WalkInProgress>(
      where: where?.call(WalkInProgress.t),
      orderBy: orderBy?.call(WalkInProgress.t),
      orderByList: orderByList?.call(WalkInProgress.t),
      limit: limit,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [WalkInProgress] matching the given query parameters.
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
  Future<WalkInProgress?> findFirstRow(
    _isd.DatabaseSession session, {
    _isd.WhereExpressionBuilder<WalkInProgressTable>? where,
    int? offset,
    _isd.OrderByBuilder<WalkInProgressTable>? orderBy,
    _isd.OrderByListBuilder<WalkInProgressTable>? orderByList,
    _isd.Transaction? transaction,
    _isd.LockMode? lockMode,
    _isd.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<WalkInProgress>(
      where: where?.call(WalkInProgress.t),
      orderBy: orderBy?.call(WalkInProgress.t),
      orderByList: orderByList?.call(WalkInProgress.t),
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [WalkInProgress] by its [id] or null if no such row exists.
  Future<WalkInProgress?> findById(
    _isd.DatabaseSession session,
    int id, {
    _isd.Transaction? transaction,
    _isd.LockMode? lockMode,
    _isd.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<WalkInProgress>(
      id,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [WalkInProgress]s in the list and returns the inserted rows.
  ///
  /// The returned [WalkInProgress]s will have their `id` fields set.
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
  Future<List<WalkInProgress>> insert(
    _isd.DatabaseSession session,
    List<WalkInProgress> rows, {
    _isd.Transaction? transaction,
    bool ignoreConflicts = false,
    bool noReturn = false,
  }) async {
    return session.db.insert<WalkInProgress>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
      noReturn: noReturn,
    );
  }

  /// Inserts a single [WalkInProgress] and returns the inserted row.
  ///
  /// The returned [WalkInProgress] will have its `id` field set.
  Future<WalkInProgress> insertRow(
    _isd.DatabaseSession session,
    WalkInProgress row, {
    _isd.Transaction? transaction,
  }) async {
    return session.db.insertRow<WalkInProgress>(
      row,
      transaction: transaction,
    );
  }

  /// Upserts all [WalkInProgress]s in the list and returns the resulting rows.
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
  /// The returned [WalkInProgress]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails,
  /// none of the rows will be affected.
  ///
  /// If [noReturn] is set to `true`, the resulting rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<WalkInProgress>> upsert(
    _isd.DatabaseSession session,
    List<WalkInProgress> rows, {
    required _isd.ColumnSelections<WalkInProgressTable> conflictColumns,
    _isd.ColumnSelections<WalkInProgressTable>? updateColumns,
    _isd.WhereExpressionBuilder<WalkInProgressTable>? updateWhere,
    _isd.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.upsert<WalkInProgress>(
      rows,
      conflictColumns: conflictColumns(WalkInProgress.t),
      updateColumns: updateColumns?.call(WalkInProgress.t),
      updateWhere: updateWhere?.call(WalkInProgress.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Upserts a single [WalkInProgress] and returns the resulting row.
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
  /// The returned [WalkInProgress] will have its `id` field set.
  Future<WalkInProgress?> upsertRow(
    _isd.DatabaseSession session,
    WalkInProgress row, {
    required _isd.ColumnSelections<WalkInProgressTable> conflictColumns,
    _isd.ColumnSelections<WalkInProgressTable>? updateColumns,
    _isd.WhereExpressionBuilder<WalkInProgressTable>? updateWhere,
    _isd.Transaction? transaction,
  }) async {
    return session.db.upsertRow<WalkInProgress>(
      row,
      conflictColumns: conflictColumns(WalkInProgress.t),
      updateColumns: updateColumns?.call(WalkInProgress.t),
      updateWhere: updateWhere?.call(WalkInProgress.t),
      transaction: transaction,
    );
  }

  /// Updates all [WalkInProgress]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<WalkInProgress>> update(
    _isd.DatabaseSession session,
    List<WalkInProgress> rows, {
    _isd.ColumnSelections<WalkInProgressTable>? columns,
    _isd.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.update<WalkInProgress>(
      rows,
      columns: columns?.call(WalkInProgress.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Updates a single [WalkInProgress]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<WalkInProgress> updateRow(
    _isd.DatabaseSession session,
    WalkInProgress row, {
    _isd.ColumnSelections<WalkInProgressTable>? columns,
    _isd.Transaction? transaction,
  }) async {
    return session.db.updateRow<WalkInProgress>(
      row,
      columns: columns?.call(WalkInProgress.t),
      transaction: transaction,
    );
  }

  /// Updates a single [WalkInProgress] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<WalkInProgress?> updateById(
    _isd.DatabaseSession session,
    int id, {
    required _isd.ColumnValueListBuilder<WalkInProgressUpdateTable>
    columnValues,
    _isd.Transaction? transaction,
  }) async {
    return session.db.updateById<WalkInProgress>(
      id,
      columnValues: columnValues(WalkInProgress.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [WalkInProgress]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<WalkInProgress>> updateWhere(
    _isd.DatabaseSession session, {
    required _isd.ColumnValueListBuilder<WalkInProgressUpdateTable>
    columnValues,
    required _isd.WhereExpressionBuilder<WalkInProgressTable> where,
    int? limit,
    int? offset,
    _isd.OrderByBuilder<WalkInProgressTable>? orderBy,
    _isd.OrderByListBuilder<WalkInProgressTable>? orderByList,
    _isd.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.updateWhere<WalkInProgress>(
      columnValues: columnValues(WalkInProgress.t.updateTable),
      where: where(WalkInProgress.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(WalkInProgress.t),
      orderByList: orderByList?.call(WalkInProgress.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes all [WalkInProgress]s in the list and returns the deleted rows.
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
  Future<List<WalkInProgress>> delete(
    _isd.DatabaseSession session,
    List<WalkInProgress> rows, {
    _isd.OrderByBuilder<WalkInProgressTable>? orderBy,
    _isd.OrderByListBuilder<WalkInProgressTable>? orderByList,
    _isd.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.delete<WalkInProgress>(
      rows,
      orderBy: orderBy?.call(WalkInProgress.t),
      orderByList: orderByList?.call(WalkInProgress.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes a single [WalkInProgress].
  Future<WalkInProgress> deleteRow(
    _isd.DatabaseSession session,
    WalkInProgress row, {
    _isd.Transaction? transaction,
  }) async {
    return session.db.deleteRow<WalkInProgress>(
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
  Future<List<WalkInProgress>> deleteWhere(
    _isd.DatabaseSession session, {
    required _isd.WhereExpressionBuilder<WalkInProgressTable> where,
    _isd.OrderByBuilder<WalkInProgressTable>? orderBy,
    _isd.OrderByListBuilder<WalkInProgressTable>? orderByList,
    _isd.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.deleteWhere<WalkInProgress>(
      where: where(WalkInProgress.t),
      orderBy: orderBy?.call(WalkInProgress.t),
      orderByList: orderByList?.call(WalkInProgress.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _isd.DatabaseSession session, {
    _isd.WhereExpressionBuilder<WalkInProgressTable>? where,
    int? limit,
    _isd.Transaction? transaction,
  }) async {
    return session.db.count<WalkInProgress>(
      where: where?.call(WalkInProgress.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [WalkInProgress] rows matching the [where] expression.
  Future<void> lockRows(
    _isd.DatabaseSession session, {
    required _isd.WhereExpressionBuilder<WalkInProgressTable> where,
    required _isd.LockMode lockMode,
    required _isd.Transaction transaction,
    _isd.LockBehavior lockBehavior = _isd.LockBehavior.wait,
  }) async {
    return session.db.lockRows<WalkInProgress>(
      where: where(WalkInProgress.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}

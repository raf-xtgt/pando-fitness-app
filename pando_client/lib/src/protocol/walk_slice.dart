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

/// Steps in one 30 s slice of a walk, from the phone's step history.
/// Written at Stop. Phone only for now; synced to the server in slice 8.
abstract class WalkSlice
    implements _isd.TableRow<int?>, _isc.ProtocolSerialization {
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
      startAt: _isc.DateTimeJsonExtension.fromJson(
        jsonSerialization['startAt'],
      ),
      endAt: _isc.DateTimeJsonExtension.fromJson(jsonSerialization['endAt']),
      steps: jsonSerialization['steps'] as int,
    );
  }

  static final t = WalkSliceTable();

  static const db = WalkSliceRepository._();

  @override
  int? id;

  String clientSessionId;

  DateTime startAt;

  DateTime endAt;

  int steps;

  @override
  _isd.Table<int?> get table => t;

  /// Returns a shallow copy of this [WalkSlice]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
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

  static WalkSliceInclude include() {
    return WalkSliceInclude._();
  }

  static WalkSliceIncludeList includeList({
    _isd.WhereExpressionBuilder<WalkSliceTable>? where,
    int? limit,
    int? offset,
    _isd.OrderByBuilder<WalkSliceTable>? orderBy,
    _isd.OrderByListBuilder<WalkSliceTable>? orderByList,
    WalkSliceInclude? include,
  }) {
    return WalkSliceIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(WalkSlice.t),
      orderByList: orderByList?.call(WalkSlice.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
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
  @_isc.useResult
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

class WalkSliceUpdateTable extends _isd.UpdateTable<WalkSliceTable> {
  WalkSliceUpdateTable(super.table);

  _isd.ColumnValue<String, String> clientSessionId(String value) =>
      _isd.ColumnValue(
        table.clientSessionId,
        value,
      );

  _isd.ColumnValue<DateTime, DateTime> startAt(DateTime value) =>
      _isd.ColumnValue(
        table.startAt,
        value,
      );

  _isd.ColumnValue<DateTime, DateTime> endAt(DateTime value) =>
      _isd.ColumnValue(
        table.endAt,
        value,
      );

  _isd.ColumnValue<int, int> steps(int value) => _isd.ColumnValue(
    table.steps,
    value,
  );
}

class WalkSliceTable extends _isd.Table<int?> {
  WalkSliceTable({super.tableRelation}) : super(tableName: 'walk_slice') {
    updateTable = WalkSliceUpdateTable(this);
    clientSessionId = _isd.ColumnString(
      'clientSessionId',
      this,
    );
    startAt = _isd.ColumnDateTime(
      'startAt',
      this,
    );
    endAt = _isd.ColumnDateTime(
      'endAt',
      this,
    );
    steps = _isd.ColumnInt(
      'steps',
      this,
    );
  }

  late final WalkSliceUpdateTable updateTable;

  late final _isd.ColumnString clientSessionId;

  late final _isd.ColumnDateTime startAt;

  late final _isd.ColumnDateTime endAt;

  late final _isd.ColumnInt steps;

  @override
  List<_isd.Column> get columns => [
    id,
    clientSessionId,
    startAt,
    endAt,
    steps,
  ];
}

class WalkSliceInclude extends _isd.IncludeObject {
  WalkSliceInclude._();

  @override
  Map<String, _isd.Include?> get includes => {};

  @override
  _isd.Table<int?> get table => WalkSlice.t;
}

class WalkSliceIncludeList extends _isd.IncludeList {
  WalkSliceIncludeList._({
    _isd.WhereExpressionBuilder<WalkSliceTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(WalkSlice.t);
  }

  @override
  Map<String, _isd.Include?> get includes => include?.includes ?? {};

  @override
  _isd.Table<int?> get table => WalkSlice.t;
}

class WalkSliceRepository {
  const WalkSliceRepository._();

  /// Returns a list of [WalkSlice]s matching the given query parameters.
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
  Future<List<WalkSlice>> find(
    _isd.DatabaseSession session, {
    _isd.WhereExpressionBuilder<WalkSliceTable>? where,
    int? limit,
    int? offset,
    _isd.OrderByBuilder<WalkSliceTable>? orderBy,
    _isd.OrderByListBuilder<WalkSliceTable>? orderByList,
    _isd.Transaction? transaction,
    _isd.LockMode? lockMode,
    _isd.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<WalkSlice>(
      where: where?.call(WalkSlice.t),
      orderBy: orderBy?.call(WalkSlice.t),
      orderByList: orderByList?.call(WalkSlice.t),
      limit: limit,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [WalkSlice] matching the given query parameters.
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
  Future<WalkSlice?> findFirstRow(
    _isd.DatabaseSession session, {
    _isd.WhereExpressionBuilder<WalkSliceTable>? where,
    int? offset,
    _isd.OrderByBuilder<WalkSliceTable>? orderBy,
    _isd.OrderByListBuilder<WalkSliceTable>? orderByList,
    _isd.Transaction? transaction,
    _isd.LockMode? lockMode,
    _isd.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<WalkSlice>(
      where: where?.call(WalkSlice.t),
      orderBy: orderBy?.call(WalkSlice.t),
      orderByList: orderByList?.call(WalkSlice.t),
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [WalkSlice] by its [id] or null if no such row exists.
  Future<WalkSlice?> findById(
    _isd.DatabaseSession session,
    int id, {
    _isd.Transaction? transaction,
    _isd.LockMode? lockMode,
    _isd.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<WalkSlice>(
      id,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [WalkSlice]s in the list and returns the inserted rows.
  ///
  /// The returned [WalkSlice]s will have their `id` fields set.
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
  Future<List<WalkSlice>> insert(
    _isd.DatabaseSession session,
    List<WalkSlice> rows, {
    _isd.Transaction? transaction,
    bool ignoreConflicts = false,
    bool noReturn = false,
  }) async {
    return session.db.insert<WalkSlice>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
      noReturn: noReturn,
    );
  }

  /// Inserts a single [WalkSlice] and returns the inserted row.
  ///
  /// The returned [WalkSlice] will have its `id` field set.
  Future<WalkSlice> insertRow(
    _isd.DatabaseSession session,
    WalkSlice row, {
    _isd.Transaction? transaction,
  }) async {
    return session.db.insertRow<WalkSlice>(
      row,
      transaction: transaction,
    );
  }

  /// Upserts all [WalkSlice]s in the list and returns the resulting rows.
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
  /// The returned [WalkSlice]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails,
  /// none of the rows will be affected.
  ///
  /// If [noReturn] is set to `true`, the resulting rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<WalkSlice>> upsert(
    _isd.DatabaseSession session,
    List<WalkSlice> rows, {
    required _isd.ColumnSelections<WalkSliceTable> conflictColumns,
    _isd.ColumnSelections<WalkSliceTable>? updateColumns,
    _isd.WhereExpressionBuilder<WalkSliceTable>? updateWhere,
    _isd.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.upsert<WalkSlice>(
      rows,
      conflictColumns: conflictColumns(WalkSlice.t),
      updateColumns: updateColumns?.call(WalkSlice.t),
      updateWhere: updateWhere?.call(WalkSlice.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Upserts a single [WalkSlice] and returns the resulting row.
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
  /// The returned [WalkSlice] will have its `id` field set.
  Future<WalkSlice?> upsertRow(
    _isd.DatabaseSession session,
    WalkSlice row, {
    required _isd.ColumnSelections<WalkSliceTable> conflictColumns,
    _isd.ColumnSelections<WalkSliceTable>? updateColumns,
    _isd.WhereExpressionBuilder<WalkSliceTable>? updateWhere,
    _isd.Transaction? transaction,
  }) async {
    return session.db.upsertRow<WalkSlice>(
      row,
      conflictColumns: conflictColumns(WalkSlice.t),
      updateColumns: updateColumns?.call(WalkSlice.t),
      updateWhere: updateWhere?.call(WalkSlice.t),
      transaction: transaction,
    );
  }

  /// Updates all [WalkSlice]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<WalkSlice>> update(
    _isd.DatabaseSession session,
    List<WalkSlice> rows, {
    _isd.ColumnSelections<WalkSliceTable>? columns,
    _isd.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.update<WalkSlice>(
      rows,
      columns: columns?.call(WalkSlice.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Updates a single [WalkSlice]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<WalkSlice> updateRow(
    _isd.DatabaseSession session,
    WalkSlice row, {
    _isd.ColumnSelections<WalkSliceTable>? columns,
    _isd.Transaction? transaction,
  }) async {
    return session.db.updateRow<WalkSlice>(
      row,
      columns: columns?.call(WalkSlice.t),
      transaction: transaction,
    );
  }

  /// Updates a single [WalkSlice] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<WalkSlice?> updateById(
    _isd.DatabaseSession session,
    int id, {
    required _isd.ColumnValueListBuilder<WalkSliceUpdateTable> columnValues,
    _isd.Transaction? transaction,
  }) async {
    return session.db.updateById<WalkSlice>(
      id,
      columnValues: columnValues(WalkSlice.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [WalkSlice]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<WalkSlice>> updateWhere(
    _isd.DatabaseSession session, {
    required _isd.ColumnValueListBuilder<WalkSliceUpdateTable> columnValues,
    required _isd.WhereExpressionBuilder<WalkSliceTable> where,
    int? limit,
    int? offset,
    _isd.OrderByBuilder<WalkSliceTable>? orderBy,
    _isd.OrderByListBuilder<WalkSliceTable>? orderByList,
    _isd.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.updateWhere<WalkSlice>(
      columnValues: columnValues(WalkSlice.t.updateTable),
      where: where(WalkSlice.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(WalkSlice.t),
      orderByList: orderByList?.call(WalkSlice.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes all [WalkSlice]s in the list and returns the deleted rows.
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
  Future<List<WalkSlice>> delete(
    _isd.DatabaseSession session,
    List<WalkSlice> rows, {
    _isd.OrderByBuilder<WalkSliceTable>? orderBy,
    _isd.OrderByListBuilder<WalkSliceTable>? orderByList,
    _isd.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.delete<WalkSlice>(
      rows,
      orderBy: orderBy?.call(WalkSlice.t),
      orderByList: orderByList?.call(WalkSlice.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes a single [WalkSlice].
  Future<WalkSlice> deleteRow(
    _isd.DatabaseSession session,
    WalkSlice row, {
    _isd.Transaction? transaction,
  }) async {
    return session.db.deleteRow<WalkSlice>(
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
  Future<List<WalkSlice>> deleteWhere(
    _isd.DatabaseSession session, {
    required _isd.WhereExpressionBuilder<WalkSliceTable> where,
    _isd.OrderByBuilder<WalkSliceTable>? orderBy,
    _isd.OrderByListBuilder<WalkSliceTable>? orderByList,
    _isd.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.deleteWhere<WalkSlice>(
      where: where(WalkSlice.t),
      orderBy: orderBy?.call(WalkSlice.t),
      orderByList: orderByList?.call(WalkSlice.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _isd.DatabaseSession session, {
    _isd.WhereExpressionBuilder<WalkSliceTable>? where,
    int? limit,
    _isd.Transaction? transaction,
  }) async {
    return session.db.count<WalkSlice>(
      where: where?.call(WalkSlice.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [WalkSlice] rows matching the [where] expression.
  Future<void> lockRows(
    _isd.DatabaseSession session, {
    required _isd.WhereExpressionBuilder<WalkSliceTable> where,
    required _isd.LockMode lockMode,
    required _isd.Transaction transaction,
    _isd.LockBehavior lockBehavior = _isd.LockBehavior.wait,
  }) async {
    return session.db.lockRows<WalkSlice>(
      where: where(WalkSlice.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}

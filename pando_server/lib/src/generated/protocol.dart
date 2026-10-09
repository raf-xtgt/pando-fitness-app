/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: implementation_imports
// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: type_literal_in_constant_pattern
// ignore_for_file: use_super_parameters
// ignore_for_file: invalid_use_of_internal_member
// ignore_for_file: dead_code, unnecessary_type_check

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:pando_server/src/generated/activity_session.dart' as _inhq2gcy;
import 'package:pando_shared/pando_shared.dart' as _ip2bu2mq;
import 'package:serverpod/protocol.dart' as _isp;
import 'package:serverpod/serverpod.dart' as _is;
import 'package:serverpod_auth_core_server/serverpod_auth_core_server.dart'
    as _iacs;
import 'package:serverpod_auth_idp_server/serverpod_auth_idp_server.dart'
    as _iais;
import 'package:serverpod_offline_sync_server/serverpod_offline_sync_server.dart'
    as _izehhkf5;
import 'activity_plan.dart' as _ic0xtzcg;
import 'activity_session.dart' as _ij0gynqy;
import 'feel.dart' as _ifrvopus;
import 'future_calls_generated_models/send_report_notification_future_call_send_model.dart'
    as _iz8uraq0;
import 'session_input.dart' as _ikrqxmzf;
import 'session_report.dart' as _iqhwxw5q;
import 'user_profile.dart' as _ir2mn8w1;
import 'walk_in_progress.dart' as _ie46f9by;
export 'activity_plan.dart';
export 'activity_session.dart';
export 'feel.dart';
export 'session_input.dart';
export 'session_report.dart';
export 'user_profile.dart';
export 'walk_in_progress.dart';
export 'sync_tables.dart';

class Protocol extends _is.DatabaseSerializationManager {
  Protocol._();

  factory Protocol() => _instance;

  static final Protocol _instance = Protocol._().._registerHostProtocols();

  static List<_isp.TableDefinition> get targetTableDefinitions => [
    _isp.TableDefinition(
      name: 'activity_session',
      dartName: 'ActivitySession',
      schema: 'public',
      module: 'pando',
      columns: [
        _isp.ColumnDefinition(
          name: 'id',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'serial',
        ),
        _isp.ColumnDefinition(
          name: 'profileId',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
        _isp.ColumnDefinition(
          name: 'clientSessionId',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _isp.ColumnDefinition(
          name: 'startedAt',
          columnType: _isp.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
        ),
        _isp.ColumnDefinition(
          name: 'endedAt',
          columnType: _isp.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
        ),
        _isp.ColumnDefinition(
          name: 'steps',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
        _isp.ColumnDefinition(
          name: 'strideM',
          columnType: _isp.ColumnType.doublePrecision,
          isNullable: false,
          dartType: 'double',
        ),
        _isp.ColumnDefinition(
          name: 'distanceM',
          columnType: _isp.ColumnType.doublePrecision,
          isNullable: false,
          dartType: 'double',
        ),
        _isp.ColumnDefinition(
          name: 'goalSteps',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
        _isp.ColumnDefinition(
          name: 'goalM',
          columnType: _isp.ColumnType.doublePrecision,
          isNullable: false,
          dartType: 'double',
        ),
        _isp.ColumnDefinition(
          name: 'goalMet',
          columnType: _isp.ColumnType.boolean,
          isNullable: false,
          dartType: 'bool',
        ),
        _isp.ColumnDefinition(
          name: 'extraM',
          columnType: _isp.ColumnType.doublePrecision,
          isNullable: false,
          dartType: 'double',
        ),
        _isp.ColumnDefinition(
          name: 'feel',
          columnType: _isp.ColumnType.text,
          isNullable: true,
          dartType: 'protocol:Feel?',
        ),
        _isp.ColumnDefinition(
          name: 'stoppedEarly',
          columnType: _isp.ColumnType.boolean,
          isNullable: false,
          dartType: 'bool',
        ),
        _isp.ColumnDefinition(
          name: 'paceDropped',
          columnType: _isp.ColumnType.boolean,
          isNullable: false,
          dartType: 'bool',
        ),
        _isp.ColumnDefinition(
          name: 'startPathM',
          columnType: _isp.ColumnType.doublePrecision,
          isNullable: false,
          dartType: 'double',
        ),
        _isp.ColumnDefinition(
          name: 'endPathM',
          columnType: _isp.ColumnType.doublePrecision,
          isNullable: false,
          dartType: 'double',
        ),
        _isp.ColumnDefinition(
          name: 'reportMessage',
          columnType: _isp.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _isp.ColumnDefinition(
          name: 'reportReadyAt',
          columnType: _isp.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
        ),
        _isp.ColumnDefinition(
          name: 'notificationSentAt',
          columnType: _isp.ColumnType.timestampWithoutTimeZone,
          isNullable: true,
          dartType: 'DateTime?',
        ),
        _isp.ColumnDefinition(
          name: 'isSeeded',
          columnType: _isp.ColumnType.boolean,
          isNullable: false,
          dartType: 'bool',
          columnDefault: 'false',
        ),
        _isp.ColumnDefinition(
          name: 'replayId',
          columnType: _isp.ColumnType.uuid,
          isNullable: true,
          dartType: 'UuidValue?',
        ),
        _isp.ColumnDefinition(
          name: 'replay',
          columnType: _isp.ColumnType.json,
          isNullable: true,
          dartType: 'pando_shared:Replay?',
        ),
      ],
      foreignKeys: [
        _isp.ForeignKeyDefinition(
          constraintName: 'activity_session_fk_0',
          columns: ['profileId'],
          referenceTable: 'user_profile',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _isp.ForeignKeyAction.noAction,
          onDelete: _isp.ForeignKeyAction.noAction,
          matchType: null,
        ),
      ],
      indexes: [
        _isp.IndexDefinition(
          indexName: 'activity_session_client_id_idx',
          tableSpace: null,
          elements: [
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'clientSessionId',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: false,
        ),
        _isp.IndexDefinition(
          indexName: 'activity_session_replay_id_idx',
          tableSpace: null,
          elements: [
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'replayId',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: false,
        ),
        _isp.IndexDefinition(
          indexName: 'activity_session_profile_idx',
          tableSpace: null,
          elements: [
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'profileId',
            ),
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'endedAt',
            ),
          ],
          type: 'btree',
          isUnique: false,
          isPrimary: false,
        ),
      ],
      managed: true,
    ),
    _isp.TableDefinition(
      name: 'user_profile',
      dartName: 'UserProfile',
      schema: 'public',
      module: 'pando',
      columns: [
        _isp.ColumnDefinition(
          name: 'id',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'serial',
        ),
        _isp.ColumnDefinition(
          name: 'authUserId',
          columnType: _isp.ColumnType.uuid,
          isNullable: false,
          dartType: 'UuidValue',
        ),
        _isp.ColumnDefinition(
          name: 'heightM',
          columnType: _isp.ColumnType.doublePrecision,
          isNullable: true,
          dartType: 'double?',
        ),
        _isp.ColumnDefinition(
          name: 'fcmToken',
          columnType: _isp.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _isp.ColumnDefinition(
          name: 'createdAt',
          columnType: _isp.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
          columnDefault: 'now',
        ),
      ],
      foreignKeys: [],
      indexes: [
        _isp.IndexDefinition(
          indexName: 'user_profile_auth_user_idx',
          tableSpace: null,
          elements: [
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'authUserId',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: false,
        ),
      ],
      managed: true,
    ),
    ..._iais.Protocol.targetTableDefinitions,
    ..._izehhkf5.Protocol.targetTableDefinitions,
    ..._iacs.Protocol.targetTableDefinitions,
    ..._ip2bu2mq.Protocol() is _is.DatabaseSerializationManager
        ? (_ip2bu2mq.Protocol() as _is.DatabaseSerializationManager)
              .getTargetTableDefinitions()
        : [],
    ..._isp.Protocol.targetTableDefinitions,
  ];

  static String? getClassNameFromObjectJson(dynamic data) {
    if (data is! Map) return null;
    final className = data['__className__'] as String?;
    return className;
  }

  @override
  T deserialize<T>(
    dynamic data, [
    Type? t,
  ]) {
    t ??= T;

    final dataClassName = getClassNameFromObjectJson(data);
    if (dataClassName != null && dataClassName != getClassNameForType(t)) {
      try {
        return deserializeByClassName({
          'className': dataClassName,
          'data': data,
        });
      } on _is.DeserializationClassNameNotFoundException catch (_) {
        // If the className is not recognized (e.g., older client receiving
        // data with a new subtype), fall back to deserializing without the
        // className, using the expected type T.
      }
    }

    if (t == _ic0xtzcg.ActivityPlan) {
      return _ic0xtzcg.ActivityPlan.fromJson(data) as T;
    }
    if (t == _ij0gynqy.ActivitySession) {
      return _ij0gynqy.ActivitySession.fromJson(data) as T;
    }
    if (t == _ifrvopus.Feel) {
      return _ifrvopus.Feel.fromJson(data) as T;
    }
    if (t == _iz8uraq0.SendReportNotificationFutureCallSendModel) {
      return _iz8uraq0.SendReportNotificationFutureCallSendModel.fromJson(data)
          as T;
    }
    if (t == _ikrqxmzf.SessionInput) {
      return _ikrqxmzf.SessionInput.fromJson(data) as T;
    }
    if (t == _iqhwxw5q.SessionReport) {
      return _iqhwxw5q.SessionReport.fromJson(data) as T;
    }
    if (t == _ir2mn8w1.UserProfile) {
      return _ir2mn8w1.UserProfile.fromJson(data) as T;
    }
    if (t == _ie46f9by.WalkInProgress) {
      return _ie46f9by.WalkInProgress.fromJson(data) as T;
    }
    if (t == _is.getType<_ic0xtzcg.ActivityPlan?>()) {
      return (data != null ? _ic0xtzcg.ActivityPlan.fromJson(data) : null) as T;
    }
    if (t == _is.getType<_ij0gynqy.ActivitySession?>()) {
      return (data != null ? _ij0gynqy.ActivitySession.fromJson(data) : null)
          as T;
    }
    if (t == _is.getType<_ifrvopus.Feel?>()) {
      return (data != null ? _ifrvopus.Feel.fromJson(data) : null) as T;
    }
    if (t ==
        _is.getType<_iz8uraq0.SendReportNotificationFutureCallSendModel?>()) {
      return (data != null
              ? _iz8uraq0.SendReportNotificationFutureCallSendModel.fromJson(
                  data,
                )
              : null)
          as T;
    }
    if (t == _is.getType<_ikrqxmzf.SessionInput?>()) {
      return (data != null ? _ikrqxmzf.SessionInput.fromJson(data) : null) as T;
    }
    if (t == _is.getType<_iqhwxw5q.SessionReport?>()) {
      return (data != null ? _iqhwxw5q.SessionReport.fromJson(data) : null)
          as T;
    }
    if (t == _is.getType<_ir2mn8w1.UserProfile?>()) {
      return (data != null ? _ir2mn8w1.UserProfile.fromJson(data) : null) as T;
    }
    if (t == _is.getType<_ie46f9by.WalkInProgress?>()) {
      return (data != null ? _ie46f9by.WalkInProgress.fromJson(data) : null)
          as T;
    }
    if (t == List<double>) {
      return (data as List).map((e) => deserialize<double>(e)).toList() as T;
    }
    if (t == List<_inhq2gcy.ActivitySession>) {
      return (data as List)
              .map((e) => deserialize<_inhq2gcy.ActivitySession>(e))
              .toList()
          as T;
    }
    try {
      return _iais.Protocol().deserialize<T>(data, t);
    } on _is.DeserializationTypeNotFoundException catch (_) {}
    try {
      return _izehhkf5.Protocol().deserialize<T>(data, t);
    } on _is.DeserializationTypeNotFoundException catch (_) {}
    try {
      return _iacs.Protocol().deserialize<T>(data, t);
    } on _is.DeserializationTypeNotFoundException catch (_) {}
    try {
      return _ip2bu2mq.Protocol().deserialize<T>(data, t);
    } on _is.DeserializationTypeNotFoundException catch (_) {}
    try {
      return _isp.Protocol().deserialize<T>(data, t);
    } on _is.DeserializationTypeNotFoundException catch (_) {}
    return super.deserialize<T>(data, t);
  }

  static String? getClassNameForType(Type type) {
    return switch (type) {
      _ic0xtzcg.ActivityPlan => 'ActivityPlan',
      _ij0gynqy.ActivitySession => 'ActivitySession',
      _ifrvopus.Feel => 'Feel',
      _iz8uraq0.SendReportNotificationFutureCallSendModel =>
        'SendReportNotificationFutureCallSendModel',
      _ikrqxmzf.SessionInput => 'SessionInput',
      _iqhwxw5q.SessionReport => 'SessionReport',
      _ir2mn8w1.UserProfile => 'UserProfile',
      _ie46f9by.WalkInProgress => 'WalkInProgress',
      _ => null,
    };
  }

  @override
  String? getClassNameForObject(Object? data) {
    String? className = super.getClassNameForObject(data);
    if (className != null) return className;

    if (data is Map<String, dynamic> && data['__className__'] is String) {
      return (data['__className__'] as String).replaceFirst('pando.', '');
    }

    switch (data) {
      case _ic0xtzcg.ActivityPlan():
        return 'ActivityPlan';
      case _ij0gynqy.ActivitySession():
        return 'ActivitySession';
      case _ifrvopus.Feel():
        return 'Feel';
      case _iz8uraq0.SendReportNotificationFutureCallSendModel():
        return 'SendReportNotificationFutureCallSendModel';
      case _ikrqxmzf.SessionInput():
        return 'SessionInput';
      case _iqhwxw5q.SessionReport():
        return 'SessionReport';
      case _ir2mn8w1.UserProfile():
        return 'UserProfile';
      case _ie46f9by.WalkInProgress():
        return 'WalkInProgress';
    }
    className = _iais.Protocol().getClassNameForObject(data);
    if (className != null) {
      return className.contains('.')
          ? className
          : 'serverpod_auth_idp.$className';
    }
    className = _izehhkf5.Protocol().getClassNameForObject(data);
    if (className != null) {
      return className.contains('.')
          ? className
          : 'serverpod_offline_sync.$className';
    }
    className = _iacs.Protocol().getClassNameForObject(data);
    if (className != null) {
      return className.contains('.')
          ? className
          : 'serverpod_auth_core.$className';
    }
    className = _ip2bu2mq.Protocol().getClassNameForObject(data);
    if (className != null) {
      return className.contains('.') ? className : 'pando_shared.$className';
    }
    className = _isp.Protocol().getClassNameForObject(data);
    if (className != null) {
      return className.contains('.') ? className : 'serverpod.$className';
    }
    return null;
  }

  @override
  dynamic deserializeByClassName(Map<String, dynamic> data) {
    var dataClassName = data['className'];
    if (dataClassName is! String) {
      return super.deserializeByClassName(data);
    }
    if (dataClassName == 'ActivityPlan') {
      return deserialize<_ic0xtzcg.ActivityPlan>(data['data']);
    }
    if (dataClassName == 'ActivitySession') {
      return deserialize<_ij0gynqy.ActivitySession>(data['data']);
    }
    if (dataClassName == 'Feel') {
      return deserialize<_ifrvopus.Feel>(data['data']);
    }
    if (dataClassName == 'SendReportNotificationFutureCallSendModel') {
      return deserialize<_iz8uraq0.SendReportNotificationFutureCallSendModel>(
        data['data'],
      );
    }
    if (dataClassName == 'SessionInput') {
      return deserialize<_ikrqxmzf.SessionInput>(data['data']);
    }
    if (dataClassName == 'SessionReport') {
      return deserialize<_iqhwxw5q.SessionReport>(data['data']);
    }
    if (dataClassName == 'UserProfile') {
      return deserialize<_ir2mn8w1.UserProfile>(data['data']);
    }
    if (dataClassName == 'WalkInProgress') {
      return deserialize<_ie46f9by.WalkInProgress>(data['data']);
    }
    if (dataClassName.startsWith('serverpod_auth_idp.')) {
      data['className'] = dataClassName.substring(19);
      return _iais.Protocol().deserializeByClassName(data);
    }
    if (dataClassName.startsWith('serverpod_offline_sync.')) {
      data['className'] = dataClassName.substring(23);
      return _izehhkf5.Protocol().deserializeByClassName(data);
    }
    if (dataClassName.startsWith('serverpod_auth_core.')) {
      data['className'] = dataClassName.substring(20);
      return _iacs.Protocol().deserializeByClassName(data);
    }
    if (dataClassName.startsWith('pando_shared.')) {
      data['className'] = dataClassName.substring(13);
      return _ip2bu2mq.Protocol().deserializeByClassName(data);
    }
    if (dataClassName.startsWith('serverpod.')) {
      data['className'] = dataClassName.substring(10);
      return _isp.Protocol().deserializeByClassName(data);
    }
    return super.deserializeByClassName(data);
  }

  void _registerHostProtocols() {
    _iais.Protocol().registerHostProtocol('pando', this);
    _izehhkf5.Protocol().registerHostProtocol('pando', this);
    _iacs.Protocol().registerHostProtocol('pando', this);
    _ip2bu2mq.Protocol().registerHostProtocol('pando', this);
  }

  @override
  _is.Table? getTableForType(Type t) {
    {
      var table = _iais.Protocol().getTableForType(t);
      if (table != null) {
        return table;
      }
    }
    {
      var table = _izehhkf5.Protocol().getTableForType(t);
      if (table != null) {
        return table;
      }
    }
    {
      var table = _iacs.Protocol().getTableForType(t);
      if (table != null) {
        return table;
      }
    }
    {
      var protocol = _ip2bu2mq.Protocol();
      var table = protocol is _is.DatabaseSerializationManager
          ? (protocol as _is.DatabaseSerializationManager).getTableForType(t)
          : null;
      if (table != null) {
        return table;
      }
    }
    {
      var table = _isp.Protocol().getTableForType(t);
      if (table != null) {
        return table;
      }
    }
    switch (t) {
      case _ij0gynqy.ActivitySession:
        return _ij0gynqy.ActivitySession.t;
      case _ir2mn8w1.UserProfile:
        return _ir2mn8w1.UserProfile.t;
    }
    return null;
  }

  @override
  List<_isp.TableDefinition> getTargetTableDefinitions() =>
      targetTableDefinitions;

  @override
  String getModuleName() => 'pando';

  /// Maps any `Record`s known to this [Protocol] to their JSON representation
  ///
  /// Throws in case the record type is not known.
  ///
  /// This method will return `null` (only) for `null` inputs.
  Map<String, dynamic>? mapRecordToJson(Record? record) {
    if (record == null) {
      return null;
    }
    try {
      return _iais.Protocol().mapRecordToJson(record);
    } catch (_) {}
    try {
      return _izehhkf5.Protocol().mapRecordToJson(record);
    } catch (_) {}
    try {
      return _iacs.Protocol().mapRecordToJson(record);
    } catch (_) {}
    throw Exception('Unsupported record type ${record.runtimeType}');
  }
}

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
import 'package:pando_client/src/protocol/activity_session.dart' as _itsbeekw;
import 'package:pando_shared/pando_shared.dart' as _ip2bu2mq;
import 'package:serverpod_auth_core_client/serverpod_auth_core_client.dart'
    as _iacc;
import 'package:serverpod_auth_idp_client/serverpod_auth_idp_client.dart'
    as _iaic;
import 'package:serverpod_client/serverpod_client.dart' as _isc;
import 'package:serverpod_database/serverpod_database.dart' as _isd;
import 'package:serverpod_offline_sync_client/serverpod_offline_sync_client.dart'
    as _ipulbpi2;
import 'activity_plan.dart' as _ic0xtzcg;
import 'activity_session.dart' as _ij0gynqy;
import 'feel.dart' as _ifrvopus;
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
export 'client.dart';
export 'sync_tables.dart';

class Protocol extends _isd.DatabaseSerializationManager {
  Protocol._();

  factory Protocol() => _instance;

  static final Protocol _instance = Protocol._().._registerHostProtocols();

  static List<_isd.TableDefinition> get targetTableDefinitions => [
    _isd.TableDefinition(
      name: 'walk_in_progress',
      dartName: 'WalkInProgress',
      schema: 'public',
      module: 'pando',
      columns: [
        _isd.ColumnDefinition(
          name: 'id',
          columnType: _isd.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'serial',
        ),
        _isd.ColumnDefinition(
          name: 'clientSessionId',
          columnType: _isd.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _isd.ColumnDefinition(
          name: 'startedAt',
          columnType: _isd.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
        ),
        _isd.ColumnDefinition(
          name: 'startCount',
          columnType: _isd.ColumnType.bigint,
          isNullable: true,
          dartType: 'int?',
        ),
        _isd.ColumnDefinition(
          name: 'goalSteps',
          columnType: _isd.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
        _isd.ColumnDefinition(
          name: 'resumeMetres',
          columnType: _isd.ColumnType.doublePrecision,
          isNullable: false,
          dartType: 'double',
        ),
      ],
      foreignKeys: [],
      indexes: [
        _isd.IndexDefinition(
          indexName: 'walk_in_progress_client_id_idx',
          tableSpace: null,
          elements: [
            _isd.IndexElementDefinition(
              type: _isd.IndexElementDefinitionType.column,
              definition: 'clientSessionId',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: false,
        ),
      ],
      managed: true,
    ),
    ..._iaic.Protocol() is _isd.DatabaseSerializationManager
        ? (_iaic.Protocol() as _isd.DatabaseSerializationManager)
              .getTargetTableDefinitions()
        : [],
    ..._ipulbpi2.Protocol() is _isd.DatabaseSerializationManager
        ? (_ipulbpi2.Protocol() as _isd.DatabaseSerializationManager)
              .getTargetTableDefinitions()
        : [],
    ..._iacc.Protocol() is _isd.DatabaseSerializationManager
        ? (_iacc.Protocol() as _isd.DatabaseSerializationManager)
              .getTargetTableDefinitions()
        : [],
    ..._ip2bu2mq.Protocol() is _isd.DatabaseSerializationManager
        ? (_ip2bu2mq.Protocol() as _isd.DatabaseSerializationManager)
              .getTargetTableDefinitions()
        : [],
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
      } on _isc.DeserializationClassNameNotFoundException catch (_) {
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
    if (t == _isc.getType<_ic0xtzcg.ActivityPlan?>()) {
      return (data != null ? _ic0xtzcg.ActivityPlan.fromJson(data) : null) as T;
    }
    if (t == _isc.getType<_ij0gynqy.ActivitySession?>()) {
      return (data != null ? _ij0gynqy.ActivitySession.fromJson(data) : null)
          as T;
    }
    if (t == _isc.getType<_ifrvopus.Feel?>()) {
      return (data != null ? _ifrvopus.Feel.fromJson(data) : null) as T;
    }
    if (t == _isc.getType<_ikrqxmzf.SessionInput?>()) {
      return (data != null ? _ikrqxmzf.SessionInput.fromJson(data) : null) as T;
    }
    if (t == _isc.getType<_iqhwxw5q.SessionReport?>()) {
      return (data != null ? _iqhwxw5q.SessionReport.fromJson(data) : null)
          as T;
    }
    if (t == _isc.getType<_ir2mn8w1.UserProfile?>()) {
      return (data != null ? _ir2mn8w1.UserProfile.fromJson(data) : null) as T;
    }
    if (t == _isc.getType<_ie46f9by.WalkInProgress?>()) {
      return (data != null ? _ie46f9by.WalkInProgress.fromJson(data) : null)
          as T;
    }
    if (t == List<double>) {
      return (data as List).map((e) => deserialize<double>(e)).toList() as T;
    }
    if (t == List<_itsbeekw.ActivitySession>) {
      return (data as List)
              .map((e) => deserialize<_itsbeekw.ActivitySession>(e))
              .toList()
          as T;
    }
    try {
      return _iaic.Protocol().deserialize<T>(data, t);
    } on _isc.DeserializationTypeNotFoundException catch (_) {}
    try {
      return _ipulbpi2.Protocol().deserialize<T>(data, t);
    } on _isc.DeserializationTypeNotFoundException catch (_) {}
    try {
      return _iacc.Protocol().deserialize<T>(data, t);
    } on _isc.DeserializationTypeNotFoundException catch (_) {}
    try {
      return _ip2bu2mq.Protocol().deserialize<T>(data, t);
    } on _isc.DeserializationTypeNotFoundException catch (_) {}
    return super.deserialize<T>(data, t);
  }

  static String? getClassNameForType(Type type) {
    return switch (type) {
      _ic0xtzcg.ActivityPlan => 'ActivityPlan',
      _ij0gynqy.ActivitySession => 'ActivitySession',
      _ifrvopus.Feel => 'Feel',
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
      case _ikrqxmzf.SessionInput():
        return 'SessionInput';
      case _iqhwxw5q.SessionReport():
        return 'SessionReport';
      case _ir2mn8w1.UserProfile():
        return 'UserProfile';
      case _ie46f9by.WalkInProgress():
        return 'WalkInProgress';
    }
    className = _iaic.Protocol().getClassNameForObject(data);
    if (className != null) {
      return className.contains('.')
          ? className
          : 'serverpod_auth_idp.$className';
    }
    className = _ipulbpi2.Protocol().getClassNameForObject(data);
    if (className != null) {
      return className.contains('.')
          ? className
          : 'serverpod_offline_sync.$className';
    }
    className = _iacc.Protocol().getClassNameForObject(data);
    if (className != null) {
      return className.contains('.')
          ? className
          : 'serverpod_auth_core.$className';
    }
    className = _ip2bu2mq.Protocol().getClassNameForObject(data);
    if (className != null) {
      return className.contains('.') ? className : 'pando_shared.$className';
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
      return _iaic.Protocol().deserializeByClassName(data);
    }
    if (dataClassName.startsWith('serverpod_offline_sync.')) {
      data['className'] = dataClassName.substring(23);
      return _ipulbpi2.Protocol().deserializeByClassName(data);
    }
    if (dataClassName.startsWith('serverpod_auth_core.')) {
      data['className'] = dataClassName.substring(20);
      return _iacc.Protocol().deserializeByClassName(data);
    }
    if (dataClassName.startsWith('pando_shared.')) {
      data['className'] = dataClassName.substring(13);
      return _ip2bu2mq.Protocol().deserializeByClassName(data);
    }
    return super.deserializeByClassName(data);
  }

  void _registerHostProtocols() {
    _iaic.Protocol().registerHostProtocol('pando', this);
    _ipulbpi2.Protocol().registerHostProtocol('pando', this);
    _iacc.Protocol().registerHostProtocol('pando', this);
    _ip2bu2mq.Protocol().registerHostProtocol('pando', this);
  }

  @override
  _isd.Table? getTableForType(Type t) {
    {
      var protocol = _iaic.Protocol();
      var table = protocol is _isd.DatabaseSerializationManager
          ? (protocol as _isd.DatabaseSerializationManager).getTableForType(t)
          : null;
      if (table != null) {
        return table;
      }
    }
    {
      var protocol = _ipulbpi2.Protocol();
      var table = protocol is _isd.DatabaseSerializationManager
          ? (protocol as _isd.DatabaseSerializationManager).getTableForType(t)
          : null;
      if (table != null) {
        return table;
      }
    }
    {
      var protocol = _iacc.Protocol();
      var table = protocol is _isd.DatabaseSerializationManager
          ? (protocol as _isd.DatabaseSerializationManager).getTableForType(t)
          : null;
      if (table != null) {
        return table;
      }
    }
    {
      var protocol = _ip2bu2mq.Protocol();
      var table = protocol is _isd.DatabaseSerializationManager
          ? (protocol as _isd.DatabaseSerializationManager).getTableForType(t)
          : null;
      if (table != null) {
        return table;
      }
    }
    switch (t) {
      case _ie46f9by.WalkInProgress:
        return _ie46f9by.WalkInProgress.t;
    }
    return null;
  }

  @override
  List<_isd.TableDefinition> getTargetTableDefinitions() =>
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
      return _iaic.Protocol().mapRecordToJson(record);
    } catch (_) {}
    try {
      return _ipulbpi2.Protocol().mapRecordToJson(record);
    } catch (_) {}
    try {
      return _iacc.Protocol().mapRecordToJson(record);
    } catch (_) {}
    throw Exception('Unsupported record type ${record.runtimeType}');
  }
}

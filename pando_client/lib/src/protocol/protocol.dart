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
import 'package:serverpod_auth_core_client/serverpod_auth_core_client.dart'
    as _iacc;
import 'package:serverpod_auth_idp_client/serverpod_auth_idp_client.dart'
    as _iaic;
import 'package:serverpod_client/serverpod_client.dart' as _isc;
import 'activity_plan.dart' as _ic0xtzcg;
import 'activity_session.dart' as _ij0gynqy;
import 'feel.dart' as _ifrvopus;
import 'session_input.dart' as _ikrqxmzf;
import 'user_profile.dart' as _ir2mn8w1;
export 'activity_plan.dart';
export 'activity_session.dart';
export 'feel.dart';
export 'session_input.dart';
export 'user_profile.dart';
export 'client.dart';

class Protocol extends _isc.SerializationManager {
  Protocol._();

  factory Protocol() => _instance;

  static final Protocol _instance = Protocol._().._registerHostProtocols();

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
    if (t == _ir2mn8w1.UserProfile) {
      return _ir2mn8w1.UserProfile.fromJson(data) as T;
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
    if (t == _isc.getType<_ir2mn8w1.UserProfile?>()) {
      return (data != null ? _ir2mn8w1.UserProfile.fromJson(data) : null) as T;
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
      return _iacc.Protocol().deserialize<T>(data, t);
    } on _isc.DeserializationTypeNotFoundException catch (_) {}
    return super.deserialize<T>(data, t);
  }

  static String? getClassNameForType(Type type) {
    return switch (type) {
      _ic0xtzcg.ActivityPlan => 'ActivityPlan',
      _ij0gynqy.ActivitySession => 'ActivitySession',
      _ifrvopus.Feel => 'Feel',
      _ikrqxmzf.SessionInput => 'SessionInput',
      _ir2mn8w1.UserProfile => 'UserProfile',
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
      case _ir2mn8w1.UserProfile():
        return 'UserProfile';
    }
    className = _iaic.Protocol().getClassNameForObject(data);
    if (className != null) {
      return className.contains('.')
          ? className
          : 'serverpod_auth_idp.$className';
    }
    className = _iacc.Protocol().getClassNameForObject(data);
    if (className != null) {
      return className.contains('.')
          ? className
          : 'serverpod_auth_core.$className';
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
    if (dataClassName == 'UserProfile') {
      return deserialize<_ir2mn8w1.UserProfile>(data['data']);
    }
    if (dataClassName.startsWith('serverpod_auth_idp.')) {
      data['className'] = dataClassName.substring(19);
      return _iaic.Protocol().deserializeByClassName(data);
    }
    if (dataClassName.startsWith('serverpod_auth_core.')) {
      data['className'] = dataClassName.substring(20);
      return _iacc.Protocol().deserializeByClassName(data);
    }
    return super.deserializeByClassName(data);
  }

  void _registerHostProtocols() {
    _iaic.Protocol().registerHostProtocol('pando', this);
    _iacc.Protocol().registerHostProtocol('pando', this);
  }

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
      return _iacc.Protocol().mapRecordToJson(record);
    } catch (_) {}
    throw Exception('Unsupported record type ${record.runtimeType}');
  }
}

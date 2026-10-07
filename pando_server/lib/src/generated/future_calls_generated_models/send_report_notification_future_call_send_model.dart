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

abstract class SendReportNotificationFutureCallSendModel
    implements _is.SerializableModel, _is.ProtocolSerialization {
  SendReportNotificationFutureCallSendModel._({required this.sessionId});

  factory SendReportNotificationFutureCallSendModel({required int sessionId}) =
      _SendReportNotificationFutureCallSendModelImpl;

  factory SendReportNotificationFutureCallSendModel.fromJson(
    Map<String, dynamic> jsonSerialization,
  ) {
    return SendReportNotificationFutureCallSendModel(
      sessionId: jsonSerialization['sessionId'] as int,
    );
  }

  int sessionId;

  /// Returns a shallow copy of this [SendReportNotificationFutureCallSendModel]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  SendReportNotificationFutureCallSendModel copyWith({int? sessionId});
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'SendReportNotificationFutureCallSendModel',
      'sessionId': sessionId,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {};
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _SendReportNotificationFutureCallSendModelImpl
    extends SendReportNotificationFutureCallSendModel {
  _SendReportNotificationFutureCallSendModelImpl({required int sessionId})
    : super._(sessionId: sessionId);

  /// Returns a shallow copy of this [SendReportNotificationFutureCallSendModel]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  SendReportNotificationFutureCallSendModel copyWith({int? sessionId}) {
    return SendReportNotificationFutureCallSendModel(
      sessionId: sessionId ?? this.sessionId,
    );
  }
}

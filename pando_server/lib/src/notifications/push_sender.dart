/// Sends one push notification to one phone.
abstract interface class PushSender {
  /// Returns true when the push service accepted the message.
  Future<bool> send({
    required String token,
    required String title,
    required String body,
    required Map<String, String> data,
  });
}

/// Used when no Google credentials are set up: logs instead of sending, so
/// the rest of the report flow still works (the Home row fallback).
class LogPushSender implements PushSender {
  const LogPushSender(this._log);

  final void Function(String) _log;

  @override
  Future<bool> send({
    required String token,
    required String title,
    required String body,
    required Map<String, String> data,
  }) async {
    _log('Push not sent (no FCM credentials): $title / $body $data');
    return false;
  }
}

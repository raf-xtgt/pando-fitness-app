import 'dart:convert';
import 'dart:io';

import 'package:googleapis_auth/auth_io.dart';

import 'push_sender.dart';

/// Firebase Cloud Messaging, HTTP v1 API. Signs in as the `pando-server`
/// service account to get an OAuth access token.
class FcmSender implements PushSender {
  FcmSender._(this._projectId, this._client);

  static const _scope = 'https://www.googleapis.com/auth/firebase.messaging';

  final String _projectId;
  final AutoRefreshingAuthClient _client;

  /// Local development: the service account key file (gitignored).
  static Future<FcmSender> fromKeyFile(String path) async {
    final json = jsonDecode(await File(path).readAsString());
    final credentials = ServiceAccountCredentials.fromJson(json);
    final client = await clientViaServiceAccount(credentials, [_scope]);
    return FcmSender._(json['project_id'] as String, client);
  }

  /// Cloud Run: the service's own identity, from the metadata server.
  static Future<FcmSender> fromMetadataServer(String projectId) async =>
      FcmSender._(projectId, await clientViaMetadataServer());

  @override
  Future<bool> send({
    required String token,
    required String title,
    required String body,
    required Map<String, String> data,
  }) async {
    final response = await _client.post(
      Uri.parse(
        'https://fcm.googleapis.com/v1/projects/$_projectId/messages:send',
      ),
      headers: {'content-type': 'application/json'},
      body: jsonEncode({
        'message': {
          'token': token,
          'notification': {'title': title, 'body': body},
          'data': data,
          'android': {
            'priority': 'high',
            'notification': {'channel_id': 'reports'},
          },
        },
      }),
    );
    if (response.statusCode != 200) {
      throw HttpException('FCM ${response.statusCode}: ${response.body}');
    }
    return true;
  }
}

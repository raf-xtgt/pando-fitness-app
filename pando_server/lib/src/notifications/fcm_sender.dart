import 'dart:convert';
import 'dart:io';

import 'package:googleapis_auth/auth_io.dart';
import 'package:http/http.dart' as http;

import 'push_sender.dart';

/// Firebase Cloud Messaging, HTTP v1 API, as the `pando-server` service
/// account: from its key file locally, or Cloud Run's own identity (pass
/// a metadata-server client to the constructor).
class FcmSender implements PushSender {
  FcmSender(this._projectId, this._client);

  static const _scope = 'https://www.googleapis.com/auth/firebase.messaging';

  final String _projectId;
  final http.Client _client;

  /// Local development: the service account key file (gitignored).
  static Future<FcmSender> fromKeyFile(String path) async {
    final json = jsonDecode(await File(path).readAsString());
    final credentials = ServiceAccountCredentials.fromJson(json);
    final client = await clientViaServiceAccount(credentials, [_scope]);
    return FcmSender(json['project_id'] as String, client);
  }

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

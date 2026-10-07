import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

import 'maintenance_alarm.dart';

/// Production: on Cloud Run the serverless service only schedules future
/// calls. This alarm creates a Cloud Task that starts the
/// `pando-maintenance` job at [ringAt]'s time; the job runs every due
/// future call and exits.
class CloudTasksAlarm implements MaintenanceAlarm {
  CloudTasksAlarm({
    required this.client,
    required this.project,
    required this.region,
    required this.queue,
    required this.job,
    required this.serviceAccount,
  });

  /// Adds an OAuth token (cloud-platform scope) to each request.
  final http.Client client;
  final String project;
  final String region;
  final String queue;
  final String job;

  /// The task starts the job as this account (needs Cloud Run Invoker).
  final String serviceAccount;

  @override
  Future<void> ringAt(DateTime time) async {
    final response = await client.post(
      Uri.parse(
        'https://cloudtasks.googleapis.com/v2/projects/$project'
        '/locations/$region/queues/$queue/tasks',
      ),
      headers: {'content-type': 'application/json'},
      body: jsonEncode({
        'task': {
          'scheduleTime': time.toUtc().toIso8601String(),
          'httpRequest': {
            'url':
                'https://run.googleapis.com/v2/projects/$project'
                '/locations/$region/jobs/$job:run',
            'httpMethod': 'POST',
            'headers': {'Content-Type': 'application/json'},
            'body': base64Encode(utf8.encode('{}')),
            'oauthToken': {
              'serviceAccountEmail': serviceAccount,
              'scope': 'https://www.googleapis.com/auth/cloud-platform',
            },
          },
        },
      }),
    );
    if (response.statusCode != 200) {
      throw HttpException(
        'Cloud Tasks ${response.statusCode}: ${response.body}',
      );
    }
  }
}

import 'package:serverpod_auth_idp_server/core.dart';
import 'package:serverpod_auth_idp_server/providers/anonymous.dart';
import 'package:serverpod_cloud_storage/serverpod_cloud_storage.dart';

import 'dart:io';

import 'package:yaml/yaml.dart';

import 'src/generated/serverpod.dart';
import 'package:googleapis_auth/auth_io.dart';

import 'src/notifications/cloud_tasks_alarm.dart';
import 'src/notifications/fcm_sender.dart';
import 'src/pando_services.dart';
import 'src/replays/replay_route.dart';

/// The starting point of the Serverpod server.
void run(List<String> args) async {
  // Initialize Serverpod. The generated Serverpod class is already connected
  // with your project's generated code.
  final pod = Serverpod(args);

  // Initialize authentication services for the server.
  // Token managers will be used to validate and issue authentication keys,
  // and the identity providers will be the authentication options available for users.
  pod.initializeAuthServices(
    tokenManagerBuilders: [
      // Use JWT for authentication keys towards the server.
      JwtConfigFromPasswords(),
    ],
    identityProviderBuilders: [
      // Anonymous sign-in: no account screen, one phone = one user. It can be
      // upgraded to Google sign-in later by linking the anonymous account.
      const AnonymousIdpConfig(),
    ],
  );

  // Configure cloud storage.
  // This setup works with Serverpod Cloud without extra configuration.
  // If you want to use a custom provider for cloud storage, replace these
  // with your preferred provider.
  pod.addCloudStorage(
    await ServerpodCloudProvider.private(
      fallback: () => DatabaseCloudStorage('private'),
    ),
  );
  pod.addCloudStorage(
    await ServerpodCloudProvider.public(
      fallback: () => DatabaseCloudStorage('public'),
    ),
  );

  await _setUpPando(pod);
  addReplayPage(pod);

  // Start the server.
  await pod.start();
}

/// Pando's own settings in `config/<run mode>.yaml` (Serverpod ignores
/// keys it doesn't know), and the report parts they select:
/// - local: FCM with the service account key file, `NoopAlarm` (the
///   always-on server runs future calls itself);
/// - Cloud Run (a `cloud:` block, no key file in the image): FCM and the
///   [CloudTasksAlarm] with the service's own identity.
Future<void> _setUpPando(Serverpod pod) async {
  final file = File('config/${pod.runMode}.yaml');
  final yaml = file.existsSync() ? loadYaml(file.readAsStringSync()) : null;
  final config = yaml is YamlMap ? yaml : YamlMap();

  PandoServices.allowDemoSeed = config['allowDemoSeed'] == true;
  stdout.writeln('Demo seed: ${PandoServices.allowDemoSeed ? 'on' : 'off'}');

  const keyFile = 'config/service-account.json';
  final cloud = config['cloud'];
  if (File(keyFile).existsSync()) {
    PandoServices.push = await FcmSender.fromKeyFile(keyFile);
    stdout.writeln('Report push: FCM via $keyFile');
  } else if (cloud is YamlMap) {
    final google = await clientViaMetadataServer();
    final project = cloud['project'] as String;
    PandoServices.push = FcmSender(project, google);
    PandoServices.alarm = CloudTasksAlarm(
      client: google,
      project: project,
      region: cloud['region'] as String,
      queue: cloud['alarmQueue'] as String,
      job: cloud['maintenanceJob'] as String,
      serviceAccount: cloud['serviceAccount'] as String,
    );
    stdout.writeln('Report push: FCM + Cloud Tasks alarm (Cloud Run identity)');
  } else {
    stdout.writeln('Report push: no $keyFile, pushes are only logged');
  }
}

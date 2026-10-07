import 'package:serverpod_auth_idp_server/core.dart';
import 'package:serverpod_auth_idp_server/providers/anonymous.dart';
import 'package:serverpod_cloud_storage/serverpod_cloud_storage.dart';

import 'dart:io';

import 'package:yaml/yaml.dart';

import 'src/generated/serverpod.dart';
import 'src/notifications/fcm_sender.dart';
import 'src/pando_services.dart';

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

  await _setUpReports();
  _readPandoConfig(pod);

  // Start the server.
  await pod.start();
}

/// Picks the real push sender when Google credentials are available. The
/// maintenance alarm stays [NoopAlarm] until the cloud round (slice 6).
Future<void> _setUpReports() async {
  const keyFile = 'config/service-account.json';
  if (File(keyFile).existsSync()) {
    PandoServices.push = await FcmSender.fromKeyFile(keyFile);
    stdout.writeln('Report push: FCM via $keyFile');
  } else {
    stdout.writeln('Report push: no $keyFile, pushes are only logged');
  }
}

/// Pando's own settings in `config/<run mode>.yaml` (Serverpod ignores
/// keys it doesn't know).
void _readPandoConfig(Serverpod pod) {
  final file = File('config/${pod.runMode}.yaml');
  if (!file.existsSync()) return;
  final yaml = loadYaml(file.readAsStringSync());
  PandoServices.allowDemoSeed =
      yaml is YamlMap && yaml['allowDemoSeed'] == true;
  stdout.writeln('Demo seed: ${PandoServices.allowDemoSeed ? 'on' : 'off'}');
}

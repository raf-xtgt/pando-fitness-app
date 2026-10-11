import 'package:flutter/material.dart';
import 'package:pando_client/pando_client.dart';

import 'app/theme.dart';
import 'features/replay/replay_page.dart';

/// Entry point of the replay web page, served by the Pando server at
/// `/replay/<replayId>` (`flutter build web -t lib/main_replay.dart`).
/// Only the park and the replay: no step counter, Firebase or sign-in.
void main() {
  final base = Uri.base;
  runApp(
    MaterialApp(
      title: 'Pando replay',
      debugShowCheckedModeBanner: false,
      theme: buildPandoTheme(),
      home: ReplayPage(
        // The page and the API are on the same server.
        client: Client('${base.origin}/'),
        replayId: replayIdFrom(base),
        embedded: base.queryParameters['embed'] == '1',
      ),
    ),
  );
}

/// The id in `/replay/<replayId>`, or null.
UuidValue? replayIdFrom(Uri uri) {
  final segments = uri.pathSegments;
  final i = segments.indexOf('replay');
  if (i < 0 || i + 1 >= segments.length) return null;
  try {
    return UuidValue.withValidation(segments[i + 1]);
  } on FormatException {
    return null;
  }
}

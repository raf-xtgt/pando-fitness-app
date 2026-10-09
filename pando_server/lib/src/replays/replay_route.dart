import 'dart:async';
import 'dart:io';

import 'package:serverpod/serverpod.dart';

/// Where `flutter build web -t lib/main_replay.dart` puts the replay page
/// (gitignored: it contains the licensed art).
const replayWebDirectory = 'web/replay';

/// Serves the replay page (a Flutter web build) at `/replay/` on the API
/// server's port: `/replay/<replayId>` gets `index.html` (the page then calls
/// `replay.get`), and `/replay/<file>` gets the build's files.
///
/// Why not Serverpod's web server and `FlutterRoute`: the web server needs a
/// second port, Cloud Run gives a service only one, and `FlutterRoute` only
/// runs inside the web server (it needs its request session). So this uses
/// the same static file handler `FlutterRoute` uses, as middleware in front
/// of the API. Only GET and HEAD are taken: endpoint calls are POSTs (the
/// `replay` endpoint lives at `/replay` too), and they go on to the API.
void addReplayPage(Serverpod pod) {
  final directory = Directory(replayWebDirectory);
  if (!directory.existsSync()) {
    stdout.writeln('Replay page: no $replayWebDirectory build, not served');
    return;
  }
  // Each new build must show at once, so the browser always revalidates.
  final files = StaticHandler.directory(
    directory,
    cacheControl: StaticRoute.privateNoCache(),
  ).asHandler;
  final index = StaticHandler.file(
    File('${directory.path}/index.html'),
    cacheControl: StaticRoute.privateNoCache(),
  ).asHandler;

  /// A file of the build, else the page itself (`/replay/<replayId>`).
  Future<Result> page(Request request) async {
    final result = await files(request);
    if (result is Response && result.statusCode == HttpStatus.notFound) {
      return index(request);
    }
    return result;
  }

  final pages = RelicRouter()..anyOf({Method.get, Method.head}, '/**', page);
  final replay = RelicRouter()..attach('/replay', pages);

  pod.server.addMiddleware((next) {
    replay.fallback = next;
    return (request) =>
        request.method == Method.get || request.method == Method.head
        ? replay.asHandler(request)
        : next(request);
  });
  stdout.writeln('Replay page: /replay/ from $replayWebDirectory');
}

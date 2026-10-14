# Pando: Flutter & Serverpod project

Pando is a walking and running app for Android. The phone's step sensor counts real steps (no GPS), and a runner moves along an endless park drawn with Flame. Five minutes after an activity, a Serverpod future call sends a report with a replay of the activity. See `README.md` for the product and architecture.

This project is a Flutter app (frontend) backed by a Serverpod server (backend). Always build the app's backend with Serverpod.
Build for multiple users. Auth is Serverpod's anonymous sign-in (one phone = one user), set up in `pando_server/lib/server.dart`.

## Packages

| Folder | What |
|---|---|
| `pando_flutter/` | The Android app (Flutter + Flame). |
| `pando_server/` | The Serverpod server: endpoints, models (`lib/src/models/`, including the phone-only `WalkInProgress`), migrations, future calls. |
| `pando_shared/` | Dart models and logic shared by the app, server and web replay (`WalkSlice`, `Gait`, `Replay`, `buildReplay`). |
| `pando_client/` | Generated client. Never edit. |

## Things to know

- The licensed art in `pando_flutter/assets/art/` and the replay web build in `pando_server/web/replay/` are gitignored. Never commit them. Art file names are listed in `pando_flutter/lib/game/asset_manifest.dart`.
- `WalkSlice` syncs from the phone to Postgres with Serverpod offline sync (experimental, `database: sync`). `WalkInProgress` lives only on the phone (`database: client`).
- The stride rule (height × 0.39) exists in both `pando_server/lib/src/goals/goal_calculator.dart` and `pando_flutter/lib/app/config.dart`. Keep them equal.
- Production runs on Google Cloud Run as one Docker image in two roles: `serverless` (the API) and `maintenance` (a job that runs due future calls). Secrets come from env vars, never from files in the repo.

## Working with Serverpod

The user starts the server and Flutter app with `serverpod start`. There is no need to check if the server is running: make the changes and call the `serverpod` MCP tools as needed. If the server is not running, an informative error message will be received from the MCP server. Then STOP and ask the user to start it. NEVER start the server yourself. The Flutter app is started along with it, or can be launched from the MCP tool `spawn_flutter_app`.

While running, `serverpod start` watches for file changes to run incremental code generation and hot reload both the server and the Flutter app.

Calling `serverpod generate` directly is not needed, but might be useful to troubleshoot when an incremental generation fails.

ALWAYS use the MCP server instead of the command line. Use the MCP server to:

- `create_migration` and `apply_migrations` for database (after you change data models).
- `create_repair_migration` if the database has drifted out of sync with the migrations.
- `tail_server_logs` to read logs from the server.
- `tail_flutter_logs` to read the raw stdout/stderr of the Flutter app.
- `hot_reload` / `hot_restart` to reload or restart the server and the Flutter app. ALWAYS call `hot_restart` after doing changes in the Flutter app that may not work with normal hot reload (which is automatically applied).
- `spawn_flutter_app` to start a Flutter app declared under `serverpod: flutter_apps:` in the server `pubspec.yaml`.
- `get_flutter_app_dtd` (Dart tooling daemon) for connecting to the app through the `dart` MCP.

NEVER edit generated code. The server's `lib/src/generated/` directory and the whole `pando_client` package are rewritten by the code generator. Change the `.spy.yaml` models, the endpoints, or `lib/server.dart` instead.

Migrations are a narrow exception: the `migration.sql` of a generated migration MAY be edited by hand when the generated SQL would lose data — to add a data transformation, or to reach a destructive change through non-destructive steps. Never touch the other files in the migration directory, and keep the schema the SQL ends up with identical to `definition.sql` — new databases are created from that file and never run `migration.sql`.

Only when the server cannot be started at all, fall back to the CLI in the server package:

- `serverpod generate` to regenerate the client and the generated server code.
- `serverpod create-migration` after changing a model with a `table` (add `--force` for destructive changes). It only writes the migration; `serverpod start` applies pending migrations when it boots the server.

Tests need no Docker. `config/test.yaml` sets `database.dataPath`, so Serverpod starts and manages the test database (an embedded PostgreSQL) itself, and the project's `docker-compose.yaml` is not used for it. Just run `dart test` in the server package.

Checklist after doing changes, in this order:

- `dart analyze` (CLI)
- `dart format` (CLI)
- `create_migration` and `apply_migrations` (MCP - only if necessary)
- Do `serverpod` MCP `hot_restart` if required (hot reload is done automatically). Will also hot restart Flutter app
- Run tests, if applicable (`dart test` in the server package)
- Check `serverpod` MCP `tail_server_logs` and `tail_flutter_logs` for any issues.

If the user asks you to test the app:

1. Use `get_flutter_app_dtd` (`serverpod` MCP) to get the Flutter app's DTD
2. Pass the DTD to `connect_dart_tooling_daemon` (`dart` MCP) to connect to the app
3. Use `flutter_driver` (`dart` MCP) to navigate through the app

The app is launched from `pando_flutter/lib/driver.dart`, which starts the Flutter driver extension with text entry emulation turned off so the app stays usable by hand. To let the driver type, set `enableTextEntryEmulation: true` there and `hot_restart` the app.

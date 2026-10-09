import 'package:firebase_core/firebase_core.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../firebase_options.dart';
import 'api_client.dart';
import 'local_cache.dart';
import 'local_db.dart';
import 'pending_queue.dart';
import 'push_service.dart';
import 'recording_api_step_history.dart';
import 'step_history.dart';
import 'walk_recorder.dart';

/// The app's long-lived services, created once at startup.
class AppServices {
  AppServices._(
    this.api,
    this.cache,
    this.queue,
    this.push,
    this.history,
    this.recorder,
  );

  static late final AppServices instance;

  final ApiClient api;
  final LocalCache cache;
  final PendingQueue queue;
  final PushService push;
  final StepHistory history;
  final WalkRecorder recorder;

  /// Local pieces only; nothing here waits on the Pando server.
  static Future<void> init() async {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    final prefs = await SharedPreferences.getInstance();
    final api = ApiClient();
    await api.init();
    final localDb = LocalDb(api);
    final queue = PendingQueue(prefs, api, syncWalks: localDb.syncOnce);
    final push = PushService(prefs, queue);
    await push.init();
    final history = RecordingApiStepHistory();
    final recorder = WalkRecorder(() => localDb.session, history);
    instance = AppServices._(
      api,
      LocalCache(prefs),
      queue,
      push,
      history,
      recorder,
    );
  }
}

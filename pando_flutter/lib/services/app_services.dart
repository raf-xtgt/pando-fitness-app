import 'package:firebase_core/firebase_core.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../firebase_options.dart';
import 'api_client.dart';
import 'local_cache.dart';
import 'pending_queue.dart';
import 'push_service.dart';

/// The app's long-lived services, created once at startup.
class AppServices {
  AppServices._(this.api, this.cache, this.queue, this.push);

  static late final AppServices instance;

  final ApiClient api;
  final LocalCache cache;
  final PendingQueue queue;
  final PushService push;

  /// Local pieces only; nothing here waits on the Pando server.
  static Future<void> init() async {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    final prefs = await SharedPreferences.getInstance();
    final api = ApiClient();
    await api.init();
    final queue = PendingQueue(prefs, api);
    final push = PushService(prefs, queue);
    await push.init();
    instance = AppServices._(api, LocalCache(prefs), queue, push);
  }
}

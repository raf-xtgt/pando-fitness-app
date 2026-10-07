import 'package:shared_preferences/shared_preferences.dart';

import 'api_client.dart';
import 'local_cache.dart';
import 'pending_queue.dart';

/// The app's long-lived services, created once at startup.
class AppServices {
  AppServices._(this.api, this.cache, this.queue);

  static late final AppServices instance;

  final ApiClient api;
  final LocalCache cache;
  final PendingQueue queue;

  /// Local pieces only; nothing here touches the network.
  static Future<void> init() async {
    final prefs = await SharedPreferences.getInstance();
    final api = ApiClient();
    await api.init();
    instance = AppServices._(api, LocalCache(prefs), PendingQueue(prefs, api));
  }
}

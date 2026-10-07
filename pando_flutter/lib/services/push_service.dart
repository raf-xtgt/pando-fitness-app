import 'dart:async';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'pending_queue.dart';

/// The delayed report's push notification: registers this phone with the
/// server, asks for permission after the first Stop, and turns a tap on a
/// notification into "open the report for session N".
class PushService {
  PushService(this._prefs, this._queue);

  static const _tokenKey = 'push.registeredToken';
  static const _askedKey = 'push.askedPermission';

  /// Same id as the server's FCM message and the Android manifest.
  static const channel = AndroidNotificationChannel(
    'reports',
    'Reports',
    description: 'Your walk report, 5 minutes after you stop',
    importance: Importance.high,
  );

  final SharedPreferences _prefs;
  final PendingQueue _queue;
  final _local = FlutterLocalNotificationsPlugin();
  final _messaging = FirebaseMessaging.instance;

  /// Opens the report screen. Set by the app shell once it can navigate.
  void Function(int sessionId)? onOpenReport;

  /// A tap that started the app (Pando was closed). Home opens it.
  int? _launchSessionId;

  Future<void> init() async {
    await _local.initialize(
      settings: const InitializationSettings(
        android: AndroidInitializationSettings('@mipmap/ic_launcher'),
      ),
      onDidReceiveNotificationResponse: (r) => _open(r.payload),
    );
    await _local
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.createNotificationChannel(channel);

    // App was closed: the tap that started it.
    final initial = await _messaging.getInitialMessage();
    final localLaunch = await _local.getNotificationAppLaunchDetails();
    _launchSessionId =
        _idOf(initial?.data['sessionId']) ??
        (localLaunch?.didNotificationLaunchApp ?? false
            ? _idOf(localLaunch!.notificationResponse?.payload)
            : null);

    // App was in the background.
    FirebaseMessaging.onMessageOpenedApp.listen(
      (m) => _open(m.data['sessionId']),
    );
    // App is open: Android doesn't show FCM notifications, so show it here.
    FirebaseMessaging.onMessage.listen(_showWhileOpen);
    _messaging.onTokenRefresh.listen(_register);
  }

  /// The session whose notification started the app, once.
  int? takeLaunchSessionId() {
    final id = _launchSessionId;
    _launchSessionId = null;
    return id;
  }

  /// Sends this phone's token to the server if it changed. Safe offline:
  /// the pending queue sends it later.
  Future<void> registerToken() async {
    try {
      final token = await _messaging.getToken();
      if (token != null) await _register(token);
    } catch (e) {
      debugPrint('Pando push: no token yet ($e)');
    }
  }

  /// Asks for the notification permission once, after the first Stop, when
  /// "report on its way" explains why. If denied, Home rows still open the
  /// report after 5 minutes.
  Future<void> askPermissionOnce() async {
    if (_prefs.getBool(_askedKey) ?? false) return;
    await _prefs.setBool(_askedKey, true);
    final settings = await _messaging.requestPermission();
    debugPrint('Pando push: permission ${settings.authorizationStatus.name}');
  }

  Future<void> _register(String token) async {
    if (_prefs.getString(_tokenKey) == token) return;
    await _prefs.setString(_tokenKey, token);
    await _queue.add(PendingQueue.registerPushTokenOp, {'token': token});
  }

  Future<void> _showWhileOpen(RemoteMessage message) async {
    final id = message.data['sessionId'];
    await _local.show(
      id: _idOf(id) ?? 0,
      title: message.notification?.title ?? 'Your report is ready',
      body: message.notification?.body,
      notificationDetails: NotificationDetails(
        android: AndroidNotificationDetails(
          channel.id,
          channel.name,
          channelDescription: channel.description,
          importance: Importance.high,
          priority: Priority.high,
        ),
      ),
      payload: id,
    );
  }

  void _open(String? rawId) {
    final id = _idOf(rawId);
    if (id == null) return;
    final open = onOpenReport;
    if (open == null) {
      _launchSessionId = id;
    } else {
      open(id);
    }
  }

  static int? _idOf(String? raw) => raw == null ? null : int.tryParse(raw);
}

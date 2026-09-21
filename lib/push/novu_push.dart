import 'dart:async';
import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:flutter_novu/push/background_handler.dart';
import 'package:flutter_novu/push/types.dart';

/// OneSignal-like push facade on top of FCM, synced to Novu via your backend.
///
/// Typical usage:
/// ```dart
/// await NovuPush.initialize(
///   firebaseOptions: DefaultFirebaseOptions.currentPlatform,
///   tokenRegistrar: httpRegistrar.register,
///   tokenUnregistrar: httpRegistrar.unregister,
/// );
///
/// await NovuPush.login(subscriberId: userId);
/// NovuPush.onForegroundMessage.listen(...);
/// NovuPush.onNotificationOpened.listen(...);
/// await NovuPush.logout();
/// ```
class NovuPush {
  NovuPush._();

  static const _prefsTokenKey = 'novu_push_fcm_token';
  static const _prefsSubscriberKey = 'novu_push_subscriber_id';

  static final SharedPreferencesAsync _prefs = SharedPreferencesAsync();
  static final StreamController<RemoteMessage> _foregroundController =
      StreamController<RemoteMessage>.broadcast();
  static final StreamController<RemoteMessage> _openedController =
      StreamController<RemoteMessage>.broadcast();

  static TokenRegistrar? _tokenRegistrar;
  static TokenUnregistrar? _tokenUnregistrar;
  static StreamSubscription<String>? _tokenRefreshSub;
  static StreamSubscription<RemoteMessage>? _foregroundSub;
  static StreamSubscription<RemoteMessage>? _openedSub;
  static bool _initialized = false;
  static String? _subscriberId;
  static String? _token;

  /// Whether [initialize] has completed successfully.
  static bool get isInitialized => _initialized;

  /// Current Novu subscriber id after [login], if any.
  static String? get currentSubscriberId => _subscriberId;

  /// Last known FCM token (may be null before [login] / permission grant).
  static String? get currentToken => _token;

  /// Stream of messages received while the app is in the foreground.
  static Stream<RemoteMessage> get onForegroundMessage =>
      _foregroundController.stream;

  /// Stream of messages that opened the app from background/terminated.
  static Stream<RemoteMessage> get onNotificationOpened =>
      _openedController.stream;

  /// Initialize Firebase Messaging and wire listeners.
  ///
  /// [tokenRegistrar] must call your backend, which updates Novu credentials
  /// with the secret key. Do not put `NOVU_SECRET_KEY` in the app.
  static Future<void> initialize({
    FirebaseOptions? firebaseOptions,
    required TokenRegistrar tokenRegistrar,
    TokenUnregistrar? tokenUnregistrar,
    Future<void> Function(RemoteMessage message)? onBackgroundMessage,
    bool requestPermissionOnInit = false,
  }) async {
    if (_initialized) {
      return;
    }

    if (Firebase.apps.isEmpty) {
      if (firebaseOptions != null) {
        await Firebase.initializeApp(options: firebaseOptions);
      } else {
        await Firebase.initializeApp();
      }
    }

    _tokenRegistrar = tokenRegistrar;
    _tokenUnregistrar = tokenUnregistrar;

    FirebaseMessaging.onBackgroundMessage(
      onBackgroundMessage ?? novuPushDefaultBackgroundHandler,
    );

    _foregroundSub = FirebaseMessaging.onMessage.listen(_foregroundController.add);
    _openedSub =
        FirebaseMessaging.onMessageOpenedApp.listen(_openedController.add);

    final initial = await FirebaseMessaging.instance.getInitialMessage();
    if (initial != null) {
      _openedController.add(initial);
    }

    _tokenRefreshSub =
        FirebaseMessaging.instance.onTokenRefresh.listen((token) async {
      _token = token;
      await _prefs.setString(_prefsTokenKey, token);
      if (_subscriberId != null) {
        await _syncToken(token);
      }
    });

    _subscriberId = await _prefs.getString(_prefsSubscriberKey);
    _token = await _prefs.getString(_prefsTokenKey);

    if (requestPermissionOnInit) {
      await requestPermission();
    }

    _initialized = true;
  }

  /// Request notification permission (required on iOS / Android 13+).
  static Future<NotificationSettings> requestPermission({
    bool alert = true,
    bool announcement = false,
    bool badge = true,
    bool carPlay = false,
    bool criticalAlert = false,
    bool provisional = false,
    bool sound = true,
  }) {
    _ensureInitialized();
    return FirebaseMessaging.instance.requestPermission(
      alert: alert,
      announcement: announcement,
      badge: badge,
      carPlay: carPlay,
      criticalAlert: criticalAlert,
      provisional: provisional,
      sound: sound,
    );
  }

  /// Bind this device to a Novu subscriber: get FCM token and sync via registrar.
  ///
  /// Returns the FCM token, or null if unavailable.
  static Future<String?> login({required String subscriberId}) async {
    _ensureInitialized();
    await requestPermission();

    final token = await FirebaseMessaging.instance.getToken();
    _subscriberId = subscriberId;
    await _prefs.setString(_prefsSubscriberKey, subscriberId);

    if (token != null) {
      _token = token;
      await _prefs.setString(_prefsTokenKey, token);
      await _syncToken(token);
    }

    return token;
  }

  /// Unregister this device token from the backend and clear local state.
  static Future<void> logout() async {
    _ensureInitialized();
    final subscriberId = _subscriberId;
    final token = _token ?? await FirebaseMessaging.instance.getToken();

    if (subscriberId != null &&
        token != null &&
        _tokenUnregistrar != null) {
      await _tokenUnregistrar!(PushTokenRegistration(
        subscriberId: subscriberId,
        token: token,
        platform: _platformLabel(),
      ));
    }

    _subscriberId = null;
    _token = null;
    await _prefs.remove(_prefsSubscriberKey);
    await _prefs.remove(_prefsTokenKey);
  }

  /// Force a token refresh and re-sync if logged in.
  static Future<String?> refreshToken() async {
    _ensureInitialized();
    await FirebaseMessaging.instance.deleteToken();
    final token = await FirebaseMessaging.instance.getToken();
    if (token != null) {
      _token = token;
      await _prefs.setString(_prefsTokenKey, token);
      if (_subscriberId != null) {
        await _syncToken(token);
      }
    }
    return token;
  }

  /// Tear down listeners (e.g. in tests). Call [initialize] again to reuse.
  static Future<void> dispose() async {
    await _tokenRefreshSub?.cancel();
    await _foregroundSub?.cancel();
    await _openedSub?.cancel();
    _tokenRefreshSub = null;
    _foregroundSub = null;
    _openedSub = null;
    _tokenRegistrar = null;
    _tokenUnregistrar = null;
    _initialized = false;
  }

  static Future<void> _syncToken(String token) async {
    final subscriberId = _subscriberId;
    final registrar = _tokenRegistrar;
    if (subscriberId == null || registrar == null) {
      return;
    }
    await registrar(PushTokenRegistration(
      subscriberId: subscriberId,
      token: token,
      platform: _platformLabel(),
    ));
  }

  static String _platformLabel() {
    if (kIsWeb) {
      return 'web';
    }
    if (Platform.isAndroid) {
      return 'android';
    }
    if (Platform.isIOS) {
      return 'ios';
    }
    return 'other';
  }

  static void _ensureInitialized() {
    if (!_initialized) {
      throw StateError(
        'NovuPush.initialize() must be called before using NovuPush.',
      );
    }
  }
}

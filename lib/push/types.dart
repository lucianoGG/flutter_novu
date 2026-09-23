/// Payload sent to your backend when registering or unregistering a device token.
///
/// Your backend should call Novu `PUT /v1/subscribers/{subscriberId}/credentials`
/// with the Novu secret key. Never embed that key in the mobile app.
///
/// Token meaning depends on [platform] / [provider]:
/// - Android (`platform: android`, `provider: fcm`): FCM registration token
/// - iOS (`platform: ios`, `provider: apns`): APNs device token (**hex**).
///   Do **not** store iOS FCM tokens (`APA91…`) as APNs credentials.
///
/// Default JSON body (VMIX backend) uses [deviceToken] / [deviceOs]:
/// ```json
/// { "deviceToken": "<token>", "deviceOs": "ios" }
/// ```
class PushTokenRegistration {
  /// Novu external subscriber id (usually your user id).
  ///
  /// Often inferred from the auth token on the backend; still useful for
  /// custom [TokenRegistrar] implementations.
  final String subscriberId;

  /// Device push token (FCM on Android, APNs hex on iOS).
  final String token;

  /// Platform / OS label sent as `deviceOs`: `android`, `ios`, or `other`.
  final String platform;

  /// Novu provider id hint: `fcm` or `apns`.
  final String provider;

  const PushTokenRegistration({
    required this.subscriberId,
    required this.token,
    required this.platform,
    required this.provider,
  });

  /// Alias for [token] — matches backend field `deviceToken`.
  String get deviceToken => token;

  /// Alias for [platform] — matches backend field `deviceOs`.
  String get deviceOs => platform;

  /// True when [token] looks like an FCM registration token (e.g. contains `APA91`).
  bool get fcmLike => looksLikeFcmToken(token);

  static bool looksLikeFcmToken(String token) =>
      token.contains('APA91') || token.contains('APA91b');

  /// Body aligned with the app backend (`deviceToken` / `deviceOs`).
  Map<String, dynamic> toJson() => {
        'deviceToken': token,
        'deviceOs': platform,
      };

  /// Extended payload (subscriber + provider) for custom registrars / debugging.
  Map<String, dynamic> toJsonFull() => {
        'deviceToken': token,
        'deviceOs': platform,
        'subscriberId': subscriberId,
        'provider': provider,
      };
}

/// Registers the device token with your backend (which syncs to Novu).
typedef TokenRegistrar = Future<void> Function(PushTokenRegistration registration);

/// Unregisters the device token with your backend (logout / uninstall).
typedef TokenUnregistrar = Future<void> Function(PushTokenRegistration registration);

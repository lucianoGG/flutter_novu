/// Payload sent to your backend when registering or unregistering an FCM token.
///
/// Your backend should call Novu `PUT /v1/subscribers/{subscriberId}/credentials`
/// with the Novu secret key. Never embed that key in the mobile app.
class PushTokenRegistration {
  /// Novu external subscriber id (usually your user id).
  final String subscriberId;

  /// FCM registration token for this device.
  final String token;

  /// Platform label: `android`, `ios`, or `other`.
  final String platform;

  const PushTokenRegistration({
    required this.subscriberId,
    required this.token,
    required this.platform,
  });

  Map<String, dynamic> toJson() => {
        'subscriberId': subscriberId,
        'token': token,
        'platform': platform,
      };
}

/// Registers the device token with your backend (which syncs to Novu).
typedef TokenRegistrar = Future<void> Function(PushTokenRegistration registration);

/// Unregisters the device token with your backend (logout / uninstall).
typedef TokenUnregistrar = Future<void> Function(PushTokenRegistration registration);

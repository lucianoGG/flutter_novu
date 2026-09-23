import 'package:dio/dio.dart';
import 'package:flutter_novu/push/types.dart';

/// Builds [TokenRegistrar] / [TokenUnregistrar] that call your app backend.
///
/// Expected backend contract (see `docs/PUSH_SETUP.md`):
/// - `POST {baseUrl}/push/register` with body `{ "deviceToken", "deviceOs" }`
/// - `DELETE {baseUrl}/push/register` with body `{ "deviceToken", "deviceOs" }`
///
/// - Android: `deviceToken` = FCM, `deviceOs` = `android`
/// - iOS: `deviceToken` = APNs hex (not FCM/`APA91…`), `deviceOs` = `ios`
///
/// Subscriber is typically taken from the auth header on the backend.
class HttpTokenRegistrar {
  final Dio _client;
  final String registerPath;
  final String unregisterPath;

  HttpTokenRegistrar({
    required String baseUrl,
    this.registerPath = '/push/register',
    this.unregisterPath = '/push/register',
    Map<String, String>? headers,
    Dio? dio,
  }) : _client = dio ??
            Dio(BaseOptions(
              baseUrl: baseUrl.endsWith('/')
                  ? baseUrl.substring(0, baseUrl.length - 1)
                  : baseUrl,
              headers: headers,
            ));

  TokenRegistrar get register => (PushTokenRegistration registration) async {
        await _client.post(registerPath, data: registration.toJson());
      };

  TokenUnregistrar get unregister => (PushTokenRegistration registration) async {
        await _client.delete(unregisterPath, data: registration.toJson());
      };
}

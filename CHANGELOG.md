## 1.2.1

* Fix: On iOS, sync APNs hex via `getAPNSToken()` only; ignore FCM `onTokenRefresh` / `getToken()` so `APA91…` tokens are not stored as APNs.
* Add: `provider` (`fcm` | `apns`) on `PushTokenRegistration`; HTTP body uses `deviceToken` / `deviceOs`.

## 1.2.0

* Add: `NovuPush` (FCM) with OneSignal-like `initialize` / `login` / `logout` and message streams.
* Add: `SubscriberApi` credentials helpers (`updateCredentials`, `addDeviceToken`, `removeDeviceToken`, `clearCredentials`).
* Add: `HttpTokenRegistrar` for backend `POST/DELETE /push/register` contract.
* Add: Push setup guide in `docs/PUSH_SETUP.md`.

## 1.1.0

* Fix: Add null-safety fallbacks for `SNovu.of(context)` to prevent runtime crashes when localization is unavailable.
* Add: Add callbacks to customize rendering of a notification or part of it.
* Add: Add parameter to handle context

## 1.0.1

* Fix: Update pubspec to fix repository
* Fix: replace withOpacity with withValues in the example code

## 1.0.0

* Project initialization

# Push setup (Novu + FCM, OneSignal-like DX)

This guide covers what lives in **Novu**, what lives in **Firebase**, and what the **Flutter app** must still configure so background push works on Android and iOS.

## Mental model

| Responsibility | Where |
| --- | --- |
| Service account JSON (send push) | Novu Dashboard → Integration Store → FCM |
| Workflows / triggers | Novu |
| FCM project + `google-services` / APNs | Firebase + host Flutter app |
| Get token, permissions, background handlers | `package:flutter_novu/push.dart` (`NovuPush`) |
| Persist token on subscriber | **Your backend** → Novu credentials API |

Novu does **not** replace FCM on the device. It orchestrates delivery after you store device tokens on the subscriber.

**Never put `NOVU_SECRET_KEY` in the mobile app.** Use your backend (same pattern as OneSignal’s server side).

Official references:

- [Novu FCM integration](https://docs.novu.co/platform/integrations/push/fcm)
- [Novu push overview](https://docs.novu.co/platform/integrations/push)
- [FCM + Flutter + Novu guide](https://novu-v2-docs.mintlify.app/guides/fcm-flutter-novu/how-to-send-push-notifications-to-flutter-apps-with-fcm-using-Novu)

---

## Phase 0 — Novu + Firebase (ops)

### 1. Firebase service account

1. Open [Firebase Console](https://console.firebase.google.com/) → Project settings → Service accounts.
2. Generate a new private key (JSON).
3. Keep the file private; it is only for Novu (or your server), not for the app binary.

### 2. Connect FCM in Novu

1. Novu Dashboard → Integration Store → Push → **Firebase Cloud Messaging (FCM)**.
2. Paste the entire service account JSON into the Service Account field.
3. Create / enable the integration.
4. Add a **Push** step to your workflows.

### 3. Firebase in the host Flutter app

1. Add Firebase to the app (`flutterfire configure` recommended).
2. Android: place `google-services.json`, apply the Google Services Gradle plugin.
3. iOS: place `GoogleService-Info.plist`, enable Push Notifications + Background Modes → Remote notifications, upload APNs key/cert to Firebase.
4. Depend on `firebase_core` / `firebase_messaging` (already pulled by `flutter_novu` when you import push).

---

## Backend contract (token sync)

`NovuPush` never talks to Novu with a secret key. It calls **your** API via `TokenRegistrar` / `TokenUnregistrar`.

### Recommended endpoints

#### Register

`POST /push/register`

```json
{
  "deviceToken": "<fcm-or-apns-hex>",
  "deviceOs": "android"
}
```

On **iOS**, `NovuPush` sends the **APNs hex** token with `deviceOs: "ios"` (never the FCM `APA91…` token). On Android it sends FCM with `deviceOs: "android"`.

`HttpTokenRegistrar` posts exactly that body (`deviceToken` / `deviceOs`). The subscriber is usually resolved from the auth header.

Internally the registration also knows `provider` (`fcm` | `apns`) for custom registrars via `toJsonFull()`.

Backend should:

1. Authenticate the user (resolve `subscriberId`).
2. Route by `deviceOs` / token shape:
   - `android` → Novu credentials `providerId: "fcm"`
   - `ios` → Novu credentials `providerId: "apns"` (hex token, not `APA91…`)
3. Merge the token into that provider’s `deviceTokens` (Novu **replaces** the whole array on update).
4. Call Novu:

```http
PUT https://api.novu.co/v1/subscribers/{subscriberId}/credentials
Authorization: ApiKey <NOVU_SECRET_KEY>
Content-Type: application/json

{
  "providerId": "fcm",
  "credentials": {
    "deviceTokens": ["existing-token", "<device-token>"]
  }
}
```

Use `"providerId": "apns"` when `deviceOs` is `ios`.

If iOS logs show `fcmLike=false` but Novu still has `APA91…`, another backend path (e.g. `/devices`) is overwriting credentials — fix that path, not the app.

#### Unregister (logout)

`DELETE /push/register`

```json
{
  "subscriberId": "user-123",
  "token": "<fcm-device-token>",
  "platform": "android"
}
```

Backend removes that token from the list (or clears all for the user) and updates Novu credentials.

### Flutter wiring

```dart
import 'package:flutter_novu/push.dart';

final registrar = HttpTokenRegistrar(
  baseUrl: 'https://api.myapp.com',
  headers: {'Authorization': 'Bearer $userJwt'},
);

await NovuPush.initialize(
  firebaseOptions: DefaultFirebaseOptions.currentPlatform,
  tokenRegistrar: registrar.register,
  tokenUnregistrar: registrar.unregister,
);

await NovuPush.login(subscriberId: userId);
```

Server-side helper in this package (for backends / scripts only):

```dart
final api = SubscriberApi('https://api.novu.co', novuSecretKey);
await api.addDeviceToken(subscriberId, ProviderId.fcm, token);
await api.removeDeviceToken(subscriberId, ProviderId.fcm, token);
await api.clearCredentials(subscriberId, ProviderId.fcm);
```

---

## Platform checklist (background delivery)

### Android

- [ ] `google-services.json` present and plugin applied
- [ ] App built with a real device / emulator that has Google Play services
- [ ] Notification channel created if you customize Android 8+ channels
- [ ] Prefer **notification** payloads (title/body) so the system tray shows messages when backgrounded; data-only needs extra native work
- [ ] After force-stop from system settings, user must open the app once before push works again

### iOS

- [ ] Push Notifications capability enabled
- [ ] Background Modes → Remote notifications
- [ ] APNs key uploaded to Firebase
- [ ] Method swizzling left enabled (required by FCM Flutter plugin)
- [ ] User granted notification permission
- [ ] If the user swipes the app away from the app switcher, they may need to reopen it before background delivery resumes
- [ ] After toggling notification permission, logs should show `[NovuPush] iOS APNs OK … fcmLike=false` (hex token, not `APA91…`)
- [ ] Novu subscriber credentials for APNs must be hex; if `fcmLike=false` in logs but Novu still has `APA91…`, the backend is overwriting

### Flutter / FCM handlers

- [ ] Call `NovuPush.initialize` before `runApp` (or as early as possible)
- [ ] Background handler is top-level / static and annotated with `@pragma('vm:entry-point')` if you override the default
- [ ] Handle taps via `NovuPush.onNotificationOpened` (covers cold start + background)

Custom background handler example:

```dart
@pragma('vm:entry-point')
Future<void> myBackgroundHandler(RemoteMessage message) async {
  // analytics, local DB, etc.
}

await NovuPush.initialize(
  tokenRegistrar: registrar.register,
  onBackgroundMessage: myBackgroundHandler,
);
```

---

## End-to-end test

1. Run the app, accept permissions, call `NovuPush.login`.
2. Confirm your backend received `POST /push/register` and Novu subscriber shows the FCM token.
3. Trigger a Novu workflow with a Push step to that `subscriberId`.
4. Verify: foreground (`onForegroundMessage`), background (system tray), terminated (tap opens app → `onNotificationOpened`).

---

## White-label migration (OneSignal → Novu) — Option 1

Goal: **one Firebase project**, **one Novu FCM integration** (service account), **N brand flavors** — each with its own Android `applicationId` / iOS bundle id.

You still have one `google-services.json` **per flavor** (or one JSON with many `client` entries). That is expected. You do **not** need one Firebase *project* per brand.

### Architecture

```text
Brand flavor (applicationId / bundleId)
    → same Firebase project (N Android/iOS apps registered)
    → FCM token
    → your backend POST /push/register
    → Novu subscriber credentials (providerId: fcm)
    → Novu workflow Push step
    → FCM delivery (service account in Novu)
```

### Step A — Firebase (once)

1. Create **one** Firebase project for the white-label platform (or reuse the one already behind OneSignal, if you have access).
2. For **each brand**:
   - Android: Add app with that flavor’s `applicationId` → download `google-services.json`.
   - iOS: Add app with that flavor’s bundle id → download `GoogleService-Info.plist`.
3. Generate **one** service account JSON → paste into Novu Integration Store → FCM.
4. Upload **one** APNs key to Firebase (works for all iOS apps in that project if they share the same Apple team / key setup).

### Step B — Flutter flavors

Typical layout:

```text
android/app/src/brandA/google-services.json
android/app/src/brandB/google-services.json
ios/flavors/brandA/GoogleService-Info.plist
ios/flavors/brandB/GoogleService-Info.plist
```

- `--flavor brandA` picks the matching `google-services.json`.
- Use `flutterfire` / per-flavor `FirebaseOptions` if options differ; often `DefaultFirebaseOptions` is generated per flavor or selected at runtime from flavor config.

`NovuPush` usage is the **same** for every brand:

```dart
await NovuPush.initialize(
  firebaseOptions: DefaultFirebaseOptions.currentPlatform, // or flavor-specific options
  tokenRegistrar: registrar.register,
  tokenUnregistrar: registrar.unregister,
);
await NovuPush.login(subscriberId: userId); // same user id you used as Novu subscriberId
```

No OneSignal App ID in the client anymore.

### Step C — Backend

| Before (OneSignal) | After (Novu) |
| --- | --- |
| OneSignal REST / dashboard send | `novu.trigger` / workflow with Push step |
| Device registered by OneSignal SDK | `POST /push/register` → Novu credentials |
| OneSignal App ID per brand (optional) | Same Novu env; brand is flavor + your tenant data |

Suggested subscriber id: keep the same external user id you already use (`subscriberId == userId`). Optionally store `brandId` in Novu subscriber `data` for segmentation.

On login: register FCM token. On logout: `DELETE /push/register` (and `NovuPush.logout()`).

### Step D — Cutover checklist (per brand)

1. [ ] Flavor builds with correct `google-services` / plist.
2. [ ] `NovuPush.login` → backend → token visible on Novu subscriber.
3. [ ] Test workflow Push → foreground / background / killed.
4. [ ] Remove `onesignal_flutter` and OneSignal native init from that flavor.
5. [ ] Stop sending from OneSignal for that brand (or dual-run briefly, then disable).

### Step E — Dual-run (recommended)

For a few releases:

1. Keep OneSignal sending for production.
2. Wire Novu Push in parallel; register FCM tokens to Novu.
3. Send test / % traffic via Novu.
4. When stable, remove OneSignal SDK and dashboard sends.

Do **not** register the same user only on OneSignal if you already cut sends to Novu — tokens must exist on the Novu subscriber.

### What you no longer manage per brand in Novu

- Service account JSON → **once** in Novu (same Firebase project).
- Push provider wiring → **once**.

### What you still manage per brand

- `applicationId` / bundle id
- `google-services.json` / `GoogleService-Info.plist` (flavor files)
- Store listing / signing / APNs app ids as today

That is the white-label cost of leaving OneSignal’s App ID abstraction: Firebase must know each package name. One project + flavors keeps it operable at dozens of brands.

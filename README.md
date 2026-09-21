# Novu's Flutter SDK for building custom inbox notification experiences

flutter_novu a Flutter library that helps to add a fully functioning Inbox to your web application in minutes. 
Let's do a quick recap on how you can easily use it in your application.


## Features

- Seamless integration with the Novu notification platform.
- Support for in-app notifications.
- Push notifications via FCM with a OneSignal-like API (`NovuPush`).
- Flexible configurations for custom notification needs.
- Easy-to-use APIs for sending, managing, and receiving notifications.

## Installation

```bash
flutter pub add flutter_novu
```

## Getting Started

Before you start using the Novu Flutter SDK, ensure you have a [Novu account](https://dashboard.novu.co/auth/sign-up) and have created a project. 

Follow these steps to integrate the SDK into your Flutter application:

### Import the Package

```dart
import 'package:flutter_novu/flutter_novu.dart';
```

### Connect to real subscribers

To connect the Inbox component with your Novu environment and real subscribers, set the `applicationIdentifier` and `subscriberId` in the `Inbox` widget.

```dart
import 'package:flutter_novu/flutter_novu.dart';

Inbox(
  applicationIdentifier: 'APPLICATION_IDENTIFIER',
  subscriberId: 'SUBSCRIBER_ID',
)
```

### Use your own backend and socket URL

By default, Novu's hosted services for API and socket are used. 
If you want, you can override them and configure your own.

```dart
import 'package:flutter_novu/flutter_novu.dart';

Inbox(
  backendUrl: 'YOUR_BACKEND_URL',
  socketUrl: 'YOUR_SOCKET_URL',
  applicationIdentifier: 'APPLICATION_IDENTIFIER',
  subscriberId: 'SUBSCRIBER_ID',
)
```

### Localization (Inbox UI)

The Inbox screens use `SNovu` localizations (`en`, `fr`, `pt`, `pt_BR`). Register the delegate in the host `MaterialApp` / `CupertinoApp`:

```dart
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_novu/generated/app_localizations.dart';

MaterialApp(
  localizationsDelegates: const [
    SNovu.delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
  ],
  supportedLocales: SNovu.supportedLocales, // en, fr, pt, pt_BR
  // locale: Locale('pt', 'BR'), // optional override
  // ...
);
```

## Push notifications (FCM)

Inbox covers **in-app**. Mobile push (background/foreground) uses Firebase Cloud Messaging, orchestrated by Novu.

1. Paste your Firebase **service account JSON** into Novu → Integration Store → FCM (same idea as OneSignal’s dashboard).
2. Configure Firebase in the host app (`google-services.json` / `GoogleService-Info.plist`, iOS Push capability).
3. Use `NovuPush` so the app gets the FCM token and syncs it through **your backend** (never ship `NOVU_SECRET_KEY` in the app).

```dart
import 'package:flutter_novu/push.dart';

final registrar = HttpTokenRegistrar(
  baseUrl: 'https://api.myapp.com',
  headers: {'Authorization': 'Bearer $jwt'},
);

await NovuPush.initialize(
  firebaseOptions: DefaultFirebaseOptions.currentPlatform,
  tokenRegistrar: registrar.register,
  tokenUnregistrar: registrar.unregister,
);

await NovuPush.login(subscriberId: userId);

NovuPush.onForegroundMessage.listen((message) { /* ... */ });
NovuPush.onNotificationOpened.listen((message) { /* deep link */ });

await NovuPush.logout();
```

Full setup, backend contract (`POST/DELETE /push/register`), and Android/iOS background checklist: **[docs/PUSH_SETUP.md](docs/PUSH_SETUP.md)**.

Also see: [Novu FCM docs](https://docs.novu.co/platform/integrations/push/fcm) · [onesignal_flutter](https://pub.dev/packages/onesignal_flutter) (reference DX).

## Contributing

Contributions are welcome! If you’d like to improve the package or add new features:
1.	Fork the repository.
2.	Create a new branch.
3.	Make your changes and test them.
4.	Submit a pull request.

## Resources

- Novu Documentation: https://docs.novu.co
- Flutter Documentation: https://flutter.dev/docs
- Push setup guide: [docs/PUSH_SETUP.md](docs/PUSH_SETUP.md)

## License

This project is licensed under the MIT License.

Let’s Connect!

import 'package:firebase_messaging/firebase_messaging.dart';

/// Default no-op background handler.
///
/// Apps that need custom background work should pass their own top-level
/// function to [NovuPush.initialize] via `onBackgroundMessage`.
///
/// Any custom handler **must** be a top-level or static function annotated with
/// `@pragma('vm:entry-point')`.
@pragma('vm:entry-point')
Future<void> novuPushDefaultBackgroundHandler(RemoteMessage message) async {
  // Intentionally empty: system tray still shows notification payloads.
  // Override to handle data-only messages or analytics.
}

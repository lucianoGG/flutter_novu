import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_novu/flutter_novu.dart';
import 'package:flutter_novu/generated/app_localizations.dart';
import 'package:flutter_novu/push.dart';

/// In-memory registrar for the example (replace with [HttpTokenRegistrar] in production).
class _MockTokenRegistrar {
  final List<PushTokenRegistration> registered = [];

  Future<void> register(PushTokenRegistration registration) async {
    registered.removeWhere((r) =>
        r.subscriberId == registration.subscriberId &&
        r.token == registration.token);
    registered.add(registration);
    debugPrint('Mock register: ${registration.toJson()}');
  }

  Future<void> unregister(PushTokenRegistration registration) async {
    registered.removeWhere((r) =>
        r.subscriberId == registration.subscriberId &&
        r.token == registration.token);
    debugPrint('Mock unregister: ${registration.toJson()}');
  }
}

final _mockRegistrar = _MockTokenRegistrar();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Real apps: pass DefaultFirebaseOptions.currentPlatform from flutterfire.
  // This example uses a mock registrar and tolerates missing Firebase config.
  try {
    await NovuPush.initialize(
      tokenRegistrar: _mockRegistrar.register,
      tokenUnregistrar: _mockRegistrar.unregister,
    );
  } catch (e, st) {
    debugPrint(
      'NovuPush.initialize failed (configure Firebase for real push):\n$e\n$st',
    );
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Novu Example',
      locale: const Locale('pt', 'BR'),
      localizationsDelegates: const [
        SNovu.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: SNovu.supportedLocales,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Novu Example'),
        actions: [
          Inbox(
            applicationIdentifier: 'applicationIdentifier',
            subscriberId: 'subscriberId',
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(
            'Inbox + Push',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(height: 8),
          const Text(
            'Inbox uses the in-app channel. Push uses FCM via NovuPush '
            '(see docs/PUSH_SETUP.md).',
          ),
          const SizedBox(height: 24),
          FilledButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute<void>(
                  builder: (_) => const PushDemoScreen(),
                ),
              );
            },
            child: const Text('Open Push demo'),
          ),
        ],
      ),
    );
  }
}

class PushDemoScreen extends StatefulWidget {
  const PushDemoScreen({super.key});

  @override
  State<PushDemoScreen> createState() => _PushDemoScreenState();
}

class _PushDemoScreenState extends State<PushDemoScreen> {
  final _subscriberController = TextEditingController(text: 'subscriberId');
  String? _status;
  String? _lastForeground;
  String? _lastOpened;

  @override
  void initState() {
    super.initState();
    if (NovuPush.isInitialized) {
      NovuPush.onForegroundMessage.listen((message) {
        if (!mounted) return;
        setState(() {
          _lastForeground =
              message.notification?.title ?? message.data.toString();
        });
      });
      NovuPush.onNotificationOpened.listen((message) {
        if (!mounted) return;
        setState(() {
          _lastOpened =
              message.notification?.title ?? message.data.toString();
        });
      });
    }
  }

  @override
  void dispose() {
    _subscriberController.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    if (!NovuPush.isInitialized) {
      setState(() {
        _status =
            'NovuPush not initialized. Add Firebase (flutterfire configure) and restart.';
      });
      return;
    }
    setState(() => _status = 'Logging in...');
    try {
      final token = await NovuPush.login(
        subscriberId: _subscriberController.text.trim(),
      );
      setState(() {
        _status = token == null
            ? 'Login finished but FCM token is null (check permissions / Firebase).'
            : 'Logged in. Token: ${token.substring(0, token.length.clamp(0, 24))}...';
      });
    } catch (e) {
      setState(() => _status = 'Login error: $e');
    }
  }

  Future<void> _logout() async {
    if (!NovuPush.isInitialized) {
      setState(() => _status = 'NovuPush not initialized.');
      return;
    }
    await NovuPush.logout();
    setState(() => _status = 'Logged out (token unregistered via mock).');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Push demo')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          TextField(
            controller: _subscriberController,
            decoration: const InputDecoration(
              labelText: 'subscriberId',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 16),
          FilledButton(onPressed: _login, child: const Text('NovuPush.login')),
          const SizedBox(height: 8),
          OutlinedButton(
            onPressed: _logout,
            child: const Text('NovuPush.logout'),
          ),
          const SizedBox(height: 24),
          Text('Status', style: Theme.of(context).textTheme.titleMedium),
          Text(_status ?? '—'),
          const SizedBox(height: 16),
          Text(
            'Initialized: ${NovuPush.isInitialized}',
          ),
          Text('Subscriber: ${NovuPush.currentSubscriberId ?? '—'}'),
          Text('Token: ${NovuPush.currentToken ?? '—'}'),
          const SizedBox(height: 16),
          Text('Last foreground: ${_lastForeground ?? '—'}'),
          Text('Last opened: ${_lastOpened ?? '—'}'),
          const SizedBox(height: 16),
          Text(
            'Mock registrations: ${_mockRegistrar.registered.length}',
          ),
          const SizedBox(height: 24),
          const Text(
            'Production: use HttpTokenRegistrar(baseUrl: your API) so the '
            'backend calls Novu PUT .../credentials with the secret key.',
          ),
        ],
      ),
    );
  }
}

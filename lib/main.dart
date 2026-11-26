import 'package:firefly/Pages/SettingsAppearance.dart';
import 'package:firefly/Screens/buttonscreen.dart';
import 'package:firefly/Screens/chatscreen.dart';
import 'package:firefly/Screens/homescreen.dart';
import 'package:firefly/Screens/welcomescreen.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/services.dart';
import 'theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await SystemChrome.setPreferredOrientations(
    [
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]
  );

  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends ConsumerStatefulWidget {
  const MyApp({super.key});

  @override
  ConsumerState<MyApp> createState() => _MyAppState();
}

class _MyAppState extends ConsumerState<MyApp> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      requestPermissions();
    });
  }

  Future<void> requestPermissions() async {
    final androidInfo = await DeviceInfoPlugin().androidInfo;
    final sdkVersion = androidInfo.version.sdkInt;

    if (sdkVersion >= 33) {
      final status = await Permission.nearbyWifiDevices.request();
      debugPrint('Nearby WiFi: $status');
    } else {
      final status = await Permission.locationWhenInUse.request();
      debugPrint('Location: $status');
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeMode = ref.watch(themeNotifierProvider);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Firefly",
      theme: FlylorsTheme.light,
      darkTheme: FlylorsTheme.dark,
      themeMode: themeMode,
      themeAnimationDuration: Duration(milliseconds: 25),
      home: SafeArea(child: Homescreen()),
    );
  }
}
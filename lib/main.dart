import 'package:firefly/Pages/SettingsAppearance.dart';
import 'package:firefly/Screens/buttonscreen.dart';
import 'package:firefly/Screens/chatscreen.dart';
import 'package:firefly/Screens/homescreen.dart';
import 'package:firefly/Screens/welcomescreen.dart';
import 'package:material_ui/material_ui.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/services.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await SystemChrome.setPreferredOrientations(
    [
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]
  );

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
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
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Firefly",
      theme: ThemeData.dark().copyWith(
        // jak chcesz zmienic srodek tego pola na tekst to , fillColor: Colors.red
        inputDecorationTheme: InputDecorationTheme(filled: true, hintStyle: TextStyle(color: Color.fromRGBO(220, 221, 225, 0.3, ), fontSize: 18),
          contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),),
        primaryColor: Color.fromRGBO(25, 42, 86, 1),
        scaffoldBackgroundColor: Color.fromRGBO(67, 67, 67, 1),
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            backgroundColor: Color.fromRGBO(25, 42, 86, 1),
            foregroundColor: Color.fromRGBO(220, 221, 225, 1),
            padding: EdgeInsets.all(20),
          ),
        ),
      ),
      home: SafeArea(child: Homescreen()),
      // routes: {
      //   '/appearance':(context) => const SettingsAppearance(),
      // }, - alternatywa, laguje apke
    );
  }
}
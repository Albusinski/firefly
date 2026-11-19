import 'package:firefly/Screens/buttonscreen.dart';
import 'package:firefly/Screens/chatscreen.dart';
import 'package:firefly/Screens/homescreen.dart';
import 'package:material_ui/material_ui.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:device_info_plus/device_info_plus.dart';

void main() {
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
      theme: ThemeData.dark().copyWith(
        primaryColor: Color.fromRGBO(25, 42, 86, 1),
        scaffoldBackgroundColor: Color.fromRGBO(245, 240, 250, 1),
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            backgroundColor: Color.fromRGBO(25, 42, 86, 1),
            foregroundColor: Color.fromRGBO(220, 221, 225, 1),
            padding: EdgeInsets.all(20),
          ),
        ),
      ),
      home: SafeArea(child: ButtonScreen()),
    );
  }
}
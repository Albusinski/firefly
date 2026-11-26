// lib/Services/settings_service.dart
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsService extends ChangeNotifier {
  late SharedPreferences _p;

  bool get readReceipts => _p.getBool('readReceipts') ?? true;
  bool get shareProfile => _p.getBool('shareProfile') ?? true;
  bool get discoverable => _p.getBool('discoverable') ?? true;
  bool get banners => _p.getBool('banners') ?? true;
  bool get haptics => _p.getBool('haptics') ?? true;
  bool get autoReconnect => _p.getBool('autoReconnect') ?? true;

  Future<void> init() async => _p = await SharedPreferences.getInstance();

  Future<void> set(String key, bool value) async {
    await _p.setBool(key, value);
    notifyListeners();
  }
}

final settings = SettingsService(); // prosty singleton na start
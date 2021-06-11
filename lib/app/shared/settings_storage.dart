import 'package:shared_preferences/shared_preferences.dart';

class SettingsStorage {
  SettingsStorage();

  Future<SharedPreferences> get _storage async =>
      await SharedPreferences.getInstance();

  String get _prefix => 'com.spruceid.app.credible.settings';

  Future<bool> get isCloudBackupEnabled async {
    final prefs = await _storage;
    return prefs.getBool('$_prefix.isCloudBackupEnabled') ?? false;
  }

  Future<void> setIsCloudBackupEnabled(bool enabled) async {
    final prefs = await _storage;
    await prefs.setBool('$_prefix.isCloudBackupEnabled', enabled);
  }
}

library secure_storage;

import 'package:credible/app/shared/settings_storage.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'secure_storage.dart';

SecureStorageProvider getProvider() => SecureStorageIO();

class SecureStorageIO extends SecureStorageProvider {
  final _settings = SettingsStorage();

  FlutterSecureStorage get _storage => FlutterSecureStorage();

  Future<IOSOptions> get _defaultIOSOptions async {
    final isCloudBackupEnabled = await _settings.isCloudBackupEnabled;
    return IOSOptions(
        groupId: 'com.spruceid.app.credible',
        accessibility: isCloudBackupEnabled
            ? IOSAccessibility.unlocked
            : IOSAccessibility.unlocked_this_device);
  }

  @override
  Future<String?> get(String key) async {
    return _storage.read(key: key, iOptions: await _defaultIOSOptions);
  }

  @override
  Future<void> set(String key, String val) async {
    return _storage.write(
        key: key, value: val, iOptions: await _defaultIOSOptions);
  }

  @override
  Future<void> delete(String key) async {
    return _storage.delete(key: key, iOptions: await _defaultIOSOptions);
  }
}

library secure_storage;

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'secure_storage.dart';

SecureStorageProvider getProvider() => SecureStorageIO();

class SecureStorageIO extends SecureStorageProvider {
  FlutterSecureStorage get _storage => FlutterSecureStorage();

  IOSOptions get _defaultIOSOptions => IOSOptions(
        accessibility: IOSAccessibility.passcode,
      );

  @override
  Future<String?> get(String key) async {
    return _storage.read(
      key: key,
      iOptions: _defaultIOSOptions,
    );
  }

  @override
  Future<void> set(String key, String val) async {
    return _storage.write(
      key: key,
      value: val,
      iOptions: _defaultIOSOptions,
    );
  }

  @override
  Future<void> delete(String key) async {
    return _storage.delete(
      key: key,
      iOptions: _defaultIOSOptions,
    );
  }
}

library secure_storage;

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'secure_storage.dart';

SecureStorageProvider getProvider() => SecureStorageIO();

class SecureStorageIO extends SecureStorageProvider {
  @override
  Future<String?> get(String key) async {
    final storage = await FlutterSecureStorage();
    return storage.read(key: key);
  }

  @override
  Future<void> set(String key, String val) async {
    final storage = await FlutterSecureStorage();
    return storage.write(key: key, value: val);
  }

  @override
  Future<void> delete(String key) async {
    final storage = await FlutterSecureStorage();
    return storage.delete(key: key);
  }
}

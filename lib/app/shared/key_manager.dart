import 'package:flutter/services.dart';

class EncryptedData {
  final Uint8List iv;
  final Uint8List data;

  EncryptedData(this.iv, this.data);
}

class KeyManager {
  static final MethodChannel _channel = MethodChannel('com.security.keyman');

  static Future<bool> keyExists(
    String id,
  ) async {
    return await _channel.invokeMethod('keyExists', {
      'alias': id,
    });
  }

  static Future<String?> getJwk(
    String id,
  ) async {
    return await _channel.invokeMethod('getJwk', {
      'alias': id,
    });
  }

  static Future<void> generateSigningKey(
    String id,
  ) async {
    await _channel.invokeMethod('generateSigningKey', {
      'alias': id,
    });
  }

  static Future<Uint8List?> signPayload(
    String id,
    Uint8List payload,
  ) async {
    return await _channel.invokeMethod('signPayload', {
      'alias': id,
      'payload': payload,
    });
  }

  static Future<void> generateEncryptionKey(
    String id,
  ) async {
    await _channel.invokeMethod('generateEncryptionKey', {
      'alias': id,
    });
  }

  static Future<EncryptedData?> encryptPayload(
    String id,
    Uint8List payload,
  ) async {
    final ret = await _channel.invokeMethod('encryptPayload', {
      'alias': id,
      'payload': payload,
    });
    return EncryptedData(ret[0], ret[1]);
  }

  static Future<Uint8List?> decryptPayload(
    String id,
    Uint8List iv,
    Uint8List payload,
  ) async {
    return await _channel.invokeMethod('decryptPayload', {
      'alias': id,
      'iv': iv,
      'payload': payload,
    });
  }
}

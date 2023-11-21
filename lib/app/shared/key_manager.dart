import 'package:credible/app/shared/der_decoder.dart';
import 'package:flutter/services.dart';

class EncryptedData {
  final Uint8List iv;
  final Uint8List data;

  EncryptedData(this.iv, this.data);
}

class KeyManager {
  static const MethodChannel _channel = MethodChannel('com.security.keyman');

  static Future<bool?> reset() async {
    final result = await _channel.invokeMethod<bool>('reset');

    return result ?? false;
  }

  static Future<bool> keyExists(
    String id,
  ) async {
    final result = await _channel.invokeMethod<bool>('keyExists', {
      'alias': id,
    });

    return result ?? false;
  }

  static Future<String?> getJwk(
    String id,
  ) async {
    return await _channel.invokeMethod<String>('getJwk', {
      'alias': id,
    });
  }

  static Future<bool> generateSigningKey(
    String id,
  ) async {
    final result = await _channel.invokeMethod<bool>('generateSigningKey', {
      'alias': id,
    });

    return result ?? false;
  }

  static Future<Uint8List?> signPayload(
    String id,
    Uint8List payload,
  ) async {
    return DERDecoder.decodeECDSA(await _channel.invokeMethod('signPayload', {
      'alias': id,
      'payload': payload,
    }));
  }

  static Future<bool> generateEncryptionKey(
    String id,
  ) async {
    final result = await _channel.invokeMethod<bool>('generateEncryptionKey', {
      'alias': id,
    });

    return result ?? false;
  }

  static Future<EncryptedData?> encryptPayload(
    String id,
    Uint8List payload,
  ) async {
    final maybeRet =
        await _channel.invokeMethod<List<Object?>>('encryptPayload', {
      'alias': id,
      'payload': payload,
    });

    if (maybeRet == null) {
      return null;
    } else {
      final ret = maybeRet.map((element) => element as Uint8List).toList();
      return EncryptedData(ret[0], ret[1]);
    }
  }

  static Future<Uint8List?> decryptPayload(
    String id,
    Uint8List iv,
    Uint8List payload,
  ) async {
    return await _channel.invokeMethod<Uint8List>('decryptPayload', {
      'alias': id,
      'iv': iv,
      'payload': payload,
    });
  }
}

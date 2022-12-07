import 'dart:convert';
import 'dart:typed_data';

import 'package:credible/app/interop/didkit/didkit.dart';
import 'package:credible/app/shared/key_manager.dart';
import 'package:flutter/cupertino.dart';

class KeyManagerTest {
  static Future<void> _assertKey(
    String alias,
    Future<void> Function(String) generator,
  ) async {
    final exists = await KeyManager.keyExists(alias);

    if (!exists) {
      try {
        await generator.call(alias);
        print('--- GENERATED $alias');
      } catch (e) {
        print('--- Failed to create $alias key: $e');
        return;
      }
    } else {
      print('--- EXISTS $alias');
    }
  }

  static Future<String> _testSign(String alias) async {
    final key = (await KeyManager.getJwk(alias))!;
    final did = DIDKitProvider.instance.keyToDID('jwk', key);
    final vm =
        await DIDKitProvider.instance.keyToVerificationMethod('jwk', key);

    final credential = jsonEncode({
      '@context': 'https://www.w3.org/2018/credentials/v1',
      'id': 'http://example.org/credentials/3731',
      'type': ['VerifiableCredential'],
      'issuer': did,
      'issuanceDate': '2020-08-19T21:41:50Z',
      'credentialSubject': {
        'id': did,
      },
    });
    final options = jsonEncode({
      'proofPurpose': 'assertionMethod',
      'verificationMethod': vm,
    });
    print('--- GET-JWK $key');
    final prepare = await DIDKitProvider.instance.prepareIssueCredential(
      credential,
      options,
      key,
    );
    final signed = await KeyManager.signPayload(
      alias,
      Uint8List.fromList(prepare.codeUnits),
    );
    final complete = await DIDKitProvider.instance.completeIssueCredential(
      credential,
      prepare,
      base64UrlEncode(signed!),
    );

    final map = jsonDecode(complete);
    final encoder = JsonEncoder.withIndent('  ');
    final json = encoder.convert(map);
    debugPrint('--- SIGNED: LEN(${complete.length}) $json');

    return complete;
  }

  static Future<void> _testEncrypt(String alias, String data) async {
    final ret = (await KeyManager.encryptPayload(
      alias,
      Uint8List.fromList(data.codeUnits),
    ))!;

    final iv = base64UrlEncode(ret.iv);
    final encrypted = base64UrlEncode(ret.data);
    print('--- ENCRYPTED: [$iv, $encrypted]');

    final bytes = await KeyManager.decryptPayload(alias, ret.iv, ret.data);
    final decrypted = utf8.decode(bytes!);

    final map = jsonDecode(decrypted);
    final encoder = JsonEncoder.withIndent('  ');
    final json = encoder.convert(map);
    print('--- DECRYPTED: LEN(${decrypted.length}) $json');
  }

  static Future<void> test() async {
    final signAlias = 'testSign';
    final encryptAlias = 'testEncrypt';

    await _assertKey(signAlias, KeyManager.generateSigningKey);
    await _assertKey(encryptAlias, KeyManager.generateEncryptionKey);

    final signed = await _testSign(signAlias);
    await _testEncrypt(encryptAlias, signed);
  }
}

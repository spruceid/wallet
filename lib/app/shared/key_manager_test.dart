import 'dart:convert';
import 'dart:typed_data';

import 'package:credible/app/interop/didkit/didkit.dart';
import 'package:credible/app/shared/key_manager.dart';
import 'package:flutter/foundation.dart';

class KeyManagerTest {
  static Future<void> _assertKey(
    String alias,
    Future<void> Function(String) generator,
  ) async {
    final exists = await KeyManager.keyExists(alias);

    if (!exists) {
      try {
        await generator.call(alias);
        debugPrint('--- GENERATED $alias');
      } catch (e) {
        debugPrint('--- Failed to create $alias key: $e');
        return;
      }
    } else {
      debugPrint('--- EXISTS $alias');
    }
  }

  static Future<String> _signCredential(String alias) async {
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

    final prepare = await DIDKitProvider.instance.prepareIssueCredential(
      credential,
      options,
      key,
    );

    final proofObject = jsonDecode(prepare);
    final signingInput64 = proofObject['signingInput'];
    final signingInput = base64Url.decode(base64.normalize(signingInput64));

    final signed = await KeyManager.signPayload(
      alias,
      signingInput,
    );

    final signaturePadded = base64UrlEncode(signed!);
    final signature = signaturePadded.replaceAll('=', '');

    debugPrint('--- SIGNATURE: $signature');
    final complete = await DIDKitProvider.instance.completeIssueCredential(
      credential,
      prepare,
      signature,
    );

    const encoder = JsonEncoder.withIndent('  ');
    final map = jsonDecode(complete);
    final json = encoder.convert(map);
    debugPrint('--- SIGNED: LEN(${complete.length}) $json');

    final verify =
        await DIDKitProvider.instance.verifyCredential(complete, options);
    debugPrint('--- VERIFY: $verify');

    return complete;
  }

  static Future<String> _signPresentation(
    String alias,
    String credential,
  ) async {
    try {
      final key = (await KeyManager.getJwk(alias))!;
      final did = DIDKitProvider.instance.keyToDID('jwk', key);
      final vm =
          await DIDKitProvider.instance.keyToVerificationMethod('jwk', key);

      final presentation = jsonEncode({
        '@context': 'https://www.w3.org/2018/credentials/v1',
        'id': 'http://example.org/credentials/3731',
        'type': ['VerifiablePresentation'],
        'holder': did,
        'verifiableCredential': [jsonDecode(credential)],
      });
      final options = jsonEncode({
        'proofPurpose': 'assertionMethod',
        'verificationMethod': vm,
      });

      debugPrint('1: $presentation');
      debugPrint('2: $options');
      debugPrint('3: $key');

      final prepare = await DIDKitProvider.instance.prepareIssuePresentation(
        presentation,
        options,
        key,
      );

      final proofObject = jsonDecode(prepare);
      final signingInput64 = proofObject['signingInput'];
      final signingInput = base64Url.decode(base64.normalize(signingInput64));

      final signed = await KeyManager.signPayload(
        alias,
        signingInput,
      );

      final signaturePadded = base64UrlEncode(signed!);
      final signature = signaturePadded.replaceAll('=', '');

      debugPrint('--- SIGNATURE: $signature');
      final complete = await DIDKitProvider.instance.completeIssuePresentation(
        presentation,
        prepare,
        signature,
      );

      const encoder = JsonEncoder.withIndent('  ');
      final map = jsonDecode(complete);
      final json = encoder.convert(map);
      debugPrint('--- SIGNED: LEN(${complete.length}) $json');

      final verify =
          await DIDKitProvider.instance.verifyPresentation(complete, options);
      debugPrint('--- VERIFY: $verify');

      return complete;
    } catch (e) {
      debugPrint('++ FAILED PRESENTATION: $e');
    }
    return '';
  }

  static Future<String> _testSign(String alias) async {
    final credential = await _signCredential(alias);
    final presentation = await _signPresentation(alias, credential);

    return presentation;
  }

  static Future<void> _testEncrypt(String alias, String data) async {
    final ret = (await KeyManager.encryptPayload(
      alias,
      Uint8List.fromList(data.codeUnits),
    ))!;

    final iv = base64UrlEncode(ret.iv);
    final encrypted = base64UrlEncode(ret.data);
    debugPrint('--- ENCRYPTED: [$iv, $encrypted]');

    final bytes = await KeyManager.decryptPayload(alias, ret.iv, ret.data);
    final decrypted = utf8.decode(bytes!);

    final map = jsonDecode(decrypted);
    const encoder = JsonEncoder.withIndent('  ');
    final json = encoder.convert(map);
    debugPrint('--- DECRYPTED: LEN(${decrypted.length}) $json');
  }

  static Future<void> test() async {
    const signAlias = 'testSign';
    const encryptAlias = 'testEncrypt';

    await _assertKey(signAlias, KeyManager.generateSigningKey);
    await _assertKey(encryptAlias, KeyManager.generateEncryptionKey);

    final signed = await _testSign(signAlias);
    await _testEncrypt(encryptAlias, signed);
  }
}

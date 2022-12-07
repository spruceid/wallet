import 'dart:convert';

import 'package:credible/app/interop/didkit/didkit.dart';
import 'package:credible/app/interop/secure_storage/secure_storage.dart';
import 'package:credible/app/shared/issuance_request_protocol.dart';
import 'package:oidc4ci/oidc4ci.dart';

class NGIOIDC4VCI {
  static Future<String> getTokenRequestQueryParams(
    IssuanceRequest issuanceRequest,
  ) async {
    final tokenRequest = await OIDC4CI.generateTokenRequest({
      'grant_type': 'urn:ietf:params:oauth:grant-type:pre-authorized_code',
      'pre-authorized_code': issuanceRequest.preAuthzCode,
    });

    return tokenRequest!;
  }

  static Future<Map<String, dynamic>> getCredentialRequestBody(
    IssuanceRequest issuanceRequest, [
    String preferredFormat = 'jwt_vc',
  ]) async {
    final keyType = (await SecureStorageProvider.instance.get('key_type'))!;
    final key = (await SecureStorageProvider.instance.get('key/$keyType/0'))!;
    final didMethod = (await SecureStorageProvider.instance.get('did_method'))!;
    final did = DIDKitProvider.instance.keyToDID(didMethod, key);
    final vm =
        await DIDKitProvider.instance.keyToVerificationMethod(didMethod, key);

    final keyJson = jsonDecode(key);
    keyJson['kid'] = vm;
    final keyWithKeyId = jsonEncode(keyJson);

    final alg;
    switch (keyJson['crv']) {
      case 'Ed25519':
        alg = 'EdDSA';
        break;
      case 'P-256':
        alg = 'ES256';
        break;
      case 'secp256k1':
        alg = 'ES256K';
        break;
      case 'P-384':
        alg = 'ES384';
        break;
      default:
        alg = 'None';
        break;
    }

    final credentialRequest = await OIDC4CI.generateCredentialRequest(
      issuanceRequest.credentialType,
      preferredFormat,
      'credible://$did',
      issuanceRequest.issuer,
      keyWithKeyId,
      alg,
    );

    return jsonDecode(credentialRequest!);
  }
}

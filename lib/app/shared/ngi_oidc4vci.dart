import 'dart:convert';

import 'package:credible/app/interop/didkit/didkit.dart';
import 'package:credible/app/shared/constants.dart';
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
    IssuanceRequest issuanceRequest,
    String key, [
    String preferredFormat = 'jwt_vc',
  ]) async {
    final did =
        DIDKitProvider.instance.keyToDID(Constants.defaultDIDMethod, key);
    final vm = await DIDKitProvider.instance
        .keyToVerificationMethod(Constants.defaultDIDMethod, key);

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

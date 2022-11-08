import 'dart:async';
import 'dart:convert';

import 'package:credible/app/interop/secure_storage/secure_storage.dart';
import 'package:credible/app/pages/credentials/blocs/scan.dart';
import 'package:credible/app/pages/credentials/models/credential.dart';
import 'package:credible/app/pages/credentials/repositories/credential.dart';
import 'package:credible/app/pages/qr_code/bloc/qrcode.dart';
import 'package:credible/app/shared/model/message.dart';
import 'package:credible/app/shared/ngi_oidc4vci.dart';
import 'package:credible/app/shared/qr_code_protocol.dart';
import 'package:dio/dio.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:logging/logging.dart';

class IssuanceRequest implements QRCodeProtocol {
  final String preAuthzCode;
  final String credentialType;
  final String issuer;
  final bool userPinRequired;

  IssuanceRequest({
    required this.preAuthzCode,
    required this.credentialType,
    required this.issuer,
    required this.userPinRequired,
  });

  factory IssuanceRequest.fromString(String request) {
    try {
      print('IssuanceRequest: $request');
      final initiateIssuance = Uri.parse(request);
      final queryParams = initiateIssuance.queryParameters;

      final preAuthzCode = queryParams['pre-authorized_code']!;
      final credentialType = queryParams['credential_type']!;
      final issuer = queryParams['issuer']!;
      final userPinRequired = queryParams.containsKey('user_pin_required')
          ? queryParams['user_pin_required'] == 'true'
          : false;

      return IssuanceRequest(
        preAuthzCode: preAuthzCode,
        credentialType: credentialType,
        issuer: issuer,
        userPinRequired: userPinRequired,
      );
    } catch (_) {
      throw FormatException('Failed to parse Issuance Request');
    }
  }

  String get issuerWithoutSlash =>
      issuer.endsWith('/') ? issuer.substring(0, issuer.length - 1) : issuer;

  @override
  Stream<QRCodeState> onAccept(
    Dio client,
    ScanBloc scanBloc,
  ) async* {
    yield QRCodeStateWorking();

    final log = Logger('credible/qrcode/accept#IssuanceRequest');

    final key = (await SecureStorageProvider.instance.get('key'))!;

    final oidcConfig;
    try {
      final url = '$issuerWithoutSlash/.well-known/openid-credential-issuer';
      final response = await client.get(url);
      oidcConfig = response.data;
    } catch (e) {
      log.severe('An error occurred while obtaining OIDC configuration.', e);
      yield QRCodeStateMessage(StateMessage.error(
        'An error occurred while obtaining OIDC configuration. '
        'Check the logs for more information.',
      ));
      return;
    }

    final authorizationServerConfig;
    if (!oidcConfig.containsKey('token_endpoint')) {
      if (!oidcConfig.containsKey('authorization_server')) {
        log.severe('Failed to obtain OIDC authorization configuration.');
        yield QRCodeStateMessage(StateMessage.error(
          'Failed to obtain OIDC authorization configuration. '
          'Check the logs for more information.',
        ));
        return;
      }

      try {
        final authorizationServer = oidcConfig['authorization_server'];
        final authorizationServerWithoutSlash = authorizationServer
                .endsWith('/')
            ? authorizationServer.substring(0, authorizationServer.length - 1)
            : authorizationServer;
        final url =
            '$authorizationServerWithoutSlash/.well-known/oauth-authorization-server';
        final response = await client.get(url);
        authorizationServerConfig = response.data;
      } catch (e) {
        log.severe(
            'An error occurred while obtaining OIDC authorization configuration.',
            e);
        yield QRCodeStateMessage(StateMessage.error(
          'An error occurred while obtaining OIDC authorization configuration. '
          'Check the logs for more information.',
        ));
        return;
      }
    } else {
      authorizationServerConfig = oidcConfig;
    }

    final String? pin;
    if (userPinRequired) {
      try {
        final value = Completer<String>();
        yield QRCodeStateInput('PIN', value);
        pin = await value.future;
      } catch (e) {
        log.severe('Failed to get PIN from user.', e);
        yield QRCodeStateMessage(StateMessage.error(
          'Failed to get PIN from user. '
          'Check the logs for more information.',
        ));
        return;
      }
    } else {
      pin = null;
    }
    yield QRCodeStateWorking();

    final authorization;
    try {
      final url = authorizationServerConfig['token_endpoint'];
      final uri = Uri.parse(url);
      final response = await client.postUri(
        uri,
        options: Options(
          contentType: Headers.formUrlEncodedContentType,
        ),
        data: {
          'grant_type': 'urn:ietf:params:oauth:grant-type:pre-authorized_code',
          'pre-authorized_code': preAuthzCode,
          if (pin != null) 'user_pin': pin,
        },
      );
      authorization = response.data;
    } catch (e) {
      log.severe('An error occurred while obtaining the access token.', e);
      yield QRCodeStateMessage(StateMessage.error(
        'An error occurred while obtaining the access token. '
        'Check the logs for more information.',
      ));
      return;
    }

    final preferredFormat;
    try {
      final formats = (oidcConfig['credentials_supported'][credentialType]
          ['formats'] as Map<String, dynamic>);
      final formatKeys = formats.keys;

      if (formatKeys.contains('jwt_vc')) {
        preferredFormat = 'jwt_vc';
      } else if (formatKeys.contains('ldp_vc')) {
        preferredFormat = 'ldp_vc';
      } else {
        throw Exception('No supported formats were found in configuration.');
      }
    } catch (e) {
      log.severe('Failed to select a supported credential format.', e);
      yield QRCodeStateMessage(StateMessage.error(
        'Failed to select a supported credential format. '
        'Check the logs for more information.',
      ));
      return;
    }

    final credential;
    final format;
    try {
      final url = oidcConfig['credential_endpoint'];
      final uri = Uri.parse(url);
      final token = authorization['access_token'];
      final data = await NGIOIDC4VCI.getCredentialRequestBody(
        this,
        key,
        preferredFormat,
      );
      final response = await client.postUri(
        uri,
        options: Options(
          contentType: Headers.jsonContentType,
          headers: {'Authorization': 'Bearer $token'},
        ),
        data: data,
      );

      final encoder = JsonEncoder.withIndent('  ');
      log.info(encoder.convert(response.data));

      format = response.data['format'];
      credential = response.data['credential'];
    } catch (e) {
      log.severe('An error occurred while obtaining the credential.', e);
      yield QRCodeStateMessage(StateMessage.error(
        'An error occurred while obtaining the credential. '
        'Check the logs for more information.',
      ));
      return;
    }

    // final jwks;
    // try {
    //   final url = oidcConfig['jwks_uri'];
    //   final uri = Uri.parse(url);
    //   final response = await client.getUri(uri);
    //   jwks = response.data;
    // } catch (e) {
    //   log.severe('An error occurred while obtaining JWKs.', e);
    //   yield QRCodeStateMessage(StateMessage.error(
    //     'An error occurred while obtaining JWKs. '
    //     'Check the logs for more information.',
    //   ));
    //   return;
    // }

    // final verified;
    // try {
    //   final vms = await Future.wait(jwks['keys'].map((jwk) async =>
    //       await DIDKitProvider.instance
    //           .keyToVerificationMethod('key', jsonEncode(jwk))));
    //   print(vms);
    //
    //   final results = await Future.wait(vms.map((vm) async {
    //     return await DIDKitProvider.instance.verifyCredential(
    //       credential,
    //       jsonEncode({
    //         'proofPurpose': 'assertionMethod',
    //         'verificationMethod': vm,
    //         'format': 'jwt',
    //       }),
    //     );
    //   }).toList());
    //   print(results);
    //
    //   verified = results
    //       .map((res) => jsonDecode(res))
    //       .any((res) => res['errors'].isEmpty);
    // } catch (e) {
    //   print(e);
    //   log.severe('An error occurred while verifying the credential.', e);
    //   yield QRCodeStateMessage(StateMessage.error(
    //     'An error occurred while verifying the credential. '
    //     'Check the logs for more information.',
    //   ));
    //   return;
    // }
    //
    // print(verified);

    final vc;
    switch (format) {
      case 'w3cvc-jsonld':
      case 'ldp_vc':
        vc = credential;
        break;

      case 'jwt_vc':
        final parts = credential.split('.');
        final jwtVc = jsonDecode(
            utf8.decode(base64Url.decode(base64.normalize(parts[1]))));
        vc = jwtVc['vc'];
        break;

      default:
        log.severe('Unsupported format received $format.');
        yield QRCodeStateMessage(StateMessage.error(
          'Unsupported format received $format.'
          'Check the logs for more information.',
        ));
        return;
    }

    final repository = Modular.get<CredentialsRepository>();
    await repository.insert(CredentialModel.fromMap({'data': vc}));

    yield QRCodeStateSuccess('/credentials/list');

    yield QRCodeStateInitial();
  }
}

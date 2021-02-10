import 'dart:convert';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:credible/app/pages/credentials/blocs/wallet.dart';
import 'package:credible/app/pages/credentials/models/credential.dart';
import 'package:credible/app/pages/credentials/repositories/credential.dart';
import 'package:credible/app/shared/constants.dart';
import 'package:credible/app/shared/model/message.dart';
import 'package:didkit/didkit.dart';
import 'package:dio/dio.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:uuid/uuid.dart';

abstract class ScanEvent {}

class ScanEventShowPreview extends ScanEvent {
  final Map<String, dynamic> preview;

  ScanEventShowPreview(this.preview);
}

class ScanEventCredentialOffer extends ScanEvent {
  final String url;
  final String key;

  ScanEventCredentialOffer(
    this.url,
    this.key,
  );
}

class ScanEventVerifiablePresentationRequest extends ScanEvent {
  final String url;
  final String key;
  final CredentialModel credential;
  final String? challenge;
  final String? domain;

  ScanEventVerifiablePresentationRequest({
    required this.url,
    required this.key,
    required this.credential,
    this.challenge,
    this.domain,
  });
}

abstract class ScanState {}

class ScanStateIdle extends ScanState {}

class ScanStateWorking extends ScanState {}

class ScanStateMessage extends ScanState {
  final StateMessage message;

  ScanStateMessage(this.message);
}

class ScanStatePreview extends ScanState {
  final Map<String, dynamic> preview;

  ScanStatePreview({
    required this.preview,
  });
}

class ScanStateSuccess extends ScanState {}

class ScanBloc extends Bloc<ScanEvent, ScanState> {
  final Dio client;

  ScanBloc(this.client) : super(ScanStateIdle());

  @override
  Stream<ScanState> mapEventToState(ScanEvent event) async* {
    if (event is ScanEventShowPreview) {
      yield ScanStatePreview(preview: event.preview);
    } else if (event is ScanEventCredentialOffer) {
      yield* _credentialOffer(event);
    } else if (event is ScanEventVerifiablePresentationRequest) {
      yield* _verifiablePresentationRequest(event);
    }
  }

  Stream<ScanState> _credentialOffer(
    ScanEventCredentialOffer event,
  ) async* {
    yield ScanStateWorking();

    final url = event.url;
    final keyId = event.key;

    try {
      final storage = FlutterSecureStorage();
      final key = await storage.read(key: keyId);
      final didKey = await DIDKit.keyToDID(Constants.defaultDIDMethod, key);

      final credential = await client.post(
        url,
        data: FormData.fromMap(<String, dynamic>{'subject_id': didKey}),
      );

      final jsonCredential = credential.data is String
          ? jsonDecode(credential.data)
          : credential.data;

      final vcStr = jsonEncode(jsonCredential);
      final optStr = jsonEncode({'proofPurpose': 'assertionMethod'});
      await Future.delayed(Duration(seconds: 1));
      // TODO [bug] verification fails here for unknown reason
      final verification = await DIDKit.verifyCredential(vcStr, optStr);

      print('[credible/credential-offer/verify/vc] $vcStr');
      print('[credible/credential-offer/verify/options] $optStr');
      print('[credible/credential-offer/verify/result] $verification');

      final jsonVerification = jsonDecode(verification);

      if (jsonVerification['warnings'].isNotEmpty) {
        log(
          'credential verification return warnings',
          name: 'credible/scan/credential-offer',
          error: jsonVerification['warnings'],
        );

        yield ScanStateMessage(StateMessage.warning(
            'Credential verification returned some warnings. '
            'Check the logs for more information.'));
      }

      if (jsonVerification['errors'].isNotEmpty) {
        log(
          'failed to verify credential',
          name: 'credible/scan/credential-offer',
          error: jsonVerification['errors'],
        );

        yield ScanStateMessage(
            StateMessage.error('Failed to verify credential. '
                'Check the logs for more information.'));
      }

      final repository = Modular.get<CredentialsRepository>();
      await repository.insert(jsonCredential);

      yield ScanStateMessage(StateMessage.success(
          'A new credential has been successfully added!'));
    } catch (e) {
      log(
        'something went wrong',
        name: 'credible/scan/credential-offer',
        error: e,
      );

      yield ScanStateMessage(
          StateMessage.error('Something went wrong, please try again later. '
              'Check the logs for more information.'));
    }

    await Modular.get<WalletBloc>().findAll();

    await Future.delayed(Duration(milliseconds: 100));
    yield ScanStateSuccess();

    await Future.delayed(Duration(milliseconds: 100));
    yield ScanStateIdle();
  }

  Stream<ScanState> _verifiablePresentationRequest(
    ScanEventVerifiablePresentationRequest event,
  ) async* {
    yield ScanStateWorking();

    final url = event.url;
    final keyId = event.key;
    final credential = event.credential;

    try {
      final storage = FlutterSecureStorage();
      final key = await storage.read(key: keyId);
      final didKey = await DIDKit.keyToDID(Constants.defaultDIDMethod, key);
      final verificationMethod =
          await DIDKit.keyToVerificationMethod(Constants.defaultDIDMethod, key);

      final presentationId = 'urn:uuid:' + Uuid().v4();
      final presentation = await DIDKit.issuePresentation(
          jsonEncode({
            '@context': ['https://www.w3.org/2018/credentials/v1'],
            'type': ['VerifiablePresentation'],
            'id': presentationId,
            'holder': didKey,
            'verifiableCredential': credential.toJson(),
          }),
          jsonEncode({
            'verificationMethod': verificationMethod,
            'proofPurpose': 'authentication',
            'challenge': event.challenge,
            'domain': event.domain,
          }),
          key);

      await client.post(
        url,
        data: FormData.fromMap(<String, dynamic>{
          'presentation': presentation,
        }),
      );

      yield ScanStateMessage(
          StateMessage.success('Successfully presented your credential!'));
    } catch (e) {
      log(
        'something went wrong',
        name: 'credible/scan/verifiable-presentation-request',
        error: e,
      );

      yield ScanStateMessage(
          StateMessage.error('Something went wrong, please try again later. '
              'Check the logs for more information.'));
    }

    await Future.delayed(Duration(milliseconds: 100));
    yield ScanStateSuccess();

    await Future.delayed(Duration(milliseconds: 100));
    yield ScanStateIdle();
  }
}

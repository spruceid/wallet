import 'dart:convert';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:credible/app/pages/credentials/blocs/wallet.dart';
import 'package:credible/app/pages/credentials/repositories/credential.dart';
import 'package:didkit/didkit.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
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
  final String challenge;
  final String domain;

  ScanEventVerifiablePresentationRequest(
    this.url,
    this.key,
    this.challenge,
    this.domain,
  );
}

abstract class ScanState {}

class ScanStateIdle extends ScanState {}

class ScanStateWorking extends ScanState {}

enum MessageType {
  error,
  warning,
  info,
  success,
}

extension MessageColor on MessageType {}

class ScanStateMessage extends ScanState {
  final MessageType type;
  final String message;

  ScanStateMessage.error(this.message) : type = MessageType.error;

  ScanStateMessage.warning(this.message) : type = MessageType.warning;

  ScanStateMessage.info(this.message) : type = MessageType.info;

  ScanStateMessage.success(this.message) : type = MessageType.success;

  Color get color {
    switch (type) {
      case MessageType.error:
        return Colors.red;
      case MessageType.warning:
        return Colors.yellow;
      case MessageType.info:
        return Colors.cyan;
      case MessageType.success:
        return Colors.green;
      default:
        return null;
    }
  }
}

class ScanStatePreview extends ScanState {
  final Map<String, dynamic> preview;

  ScanStatePreview({
    @required this.preview,
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
      final didTezos = await DIDKit.keyToDIDTezos(key);

      final credential = await client.post(
        url,
        data: FormData.fromMap(<String, dynamic>{'subject_id': didTezos}),
      );

      final jsonCredential = credential.data is String
          ? jsonDecode(credential.data)
          : credential.data;

      final verification = await DIDKit.verifyCredential(
        jsonEncode(jsonCredential),
        jsonEncode({
          'verificationMethod': didTezos,
          'proofPurpose': 'assertionMethod',
        }),
      );

      final jsonVerification = jsonDecode(verification);

      if (jsonVerification['warnings'].isNotEmpty) {
        log(
          'credential verification return warnings',
          name: 'credible/scan/credential-offer',
          error: jsonVerification['warnings'],
        );

        yield ScanStateMessage.warning(
            'Credential verification returned some warnings. '
            'Check the logs for more information.');
      }

      if (jsonVerification['errors'].isNotEmpty) {
        log(
          'failed to verify credential',
          name: 'credible/scan/credential-offer',
          error: jsonVerification['errors'],
        );

        yield ScanStateMessage.error('Failed to verify credential. '
            'Check the logs for more information.');
      } else {
        final repository = Modular.get<CredentialsRepository>();
        await repository.insert(jsonCredential);

        yield ScanStateMessage.success(
            'A new credential has been successfully added!');
      }
    } catch (e) {
      log(
        'something went wrong',
        name: 'credible/scan/credential-offer',
        error: e.message,
      );

      yield ScanStateMessage.error(
          'Something went wrong, please try again later. '
          'Check the logs for more information.');
    }

    await Modular.get<WalletBloc>().findAll();

    yield ScanStateSuccess();

    yield ScanStateIdle();
  }

  Stream<ScanState> _verifiablePresentationRequest(
    ScanEventVerifiablePresentationRequest event,
  ) async* {
    yield ScanStateWorking();

    final url = event.url;
    final keyId = event.key;

    try {
      final storage = FlutterSecureStorage();
      final key = await storage.read(key: keyId);
      final didTezos = await DIDKit.keyToDIDTezos(key);

      final repository = Modular.get<CredentialsRepository>();
      final credentials = await repository.rawFindAll();

      final presentationId = 'urn:uuid:' + Uuid().v4();
      final presentation = await DIDKit.issuePresentation(
          jsonEncode({
            '@context': ['https://www.w3.org/2018/credentials/v1'],
            'type': ['VerifiablePresentation'],
            'id': presentationId,
            'holder': didTezos,
            'verifiableCredential': credentials.first,
          }),
          jsonEncode({
            'verificationMethod': didTezos,
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

      yield ScanStateMessage.success('Successfully presented your credential!');
    } catch (e) {
      log(
        'something went wrong',
        name: 'credible/scan/verifiable-presentation-request',
        error: e.message,
      );

      yield ScanStateMessage.error(
          'Something went wrong, please try again later. '
          'Check the logs for more information.');
    }

    yield ScanStateSuccess();

    yield ScanStateIdle();
  }
}

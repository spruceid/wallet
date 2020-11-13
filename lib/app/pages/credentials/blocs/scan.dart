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
      yield ScanStateWorking();

      final url = event.url;
      final keyId = event.key;

      try {
        final storage = FlutterSecureStorage();
        final key = await storage.read(key: keyId);
        final didKey = await DIDKit.keyToDIDKey(key);

        final credential = await client.post(
          url,
          data: FormData.fromMap(<String, dynamic>{'subject_id': didKey}),
        );

        final repository = Modular.get<CredentialsRepository>();
        await repository.insert(credential.data is String
            ? jsonDecode(credential.data)
            : credential.data);

        yield ScanStateMessage.success(
            'A new credential has been successfully added!');
      } catch (e) {
        yield ScanStateMessage.error(
            'Something went wrong, please try again later.');
      }

      await Modular.get<WalletBloc>().findAll();

      yield ScanStateSuccess();

      yield ScanStateIdle();
    } else if (event is ScanEventVerifiablePresentationRequest) {
      yield ScanStateWorking();

      final url = event.url;
      final keyId = event.key;

      try {
        final storage = FlutterSecureStorage();
        final key = await storage.read(key: keyId);
        final didKey = await DIDKit.keyToDIDKey(key);

        final repository = Modular.get<CredentialsRepository>();
        final credentials = await repository.rawFindAll();

        final presentation = await DIDKit.issuePresentation(
            jsonEncode({
              '@context': ['https://www.w3.org/2018/credentials/v1'],
              'id': 'http://example.org/presentations/3731',
              'type': ['VerifiablePresentation'],
              'holder': didKey,
              'verifiableCredential': credentials.first,
              'verificationMethod': 'didKey',
              'proofPurpose': 'authentication',
              'challenge': event.challenge,
              'domain': event.domain,
            }),
            '{}',
            key);

        await client.post(
          url,
          data: FormData.fromMap(<String, dynamic>{
            'presentation': presentation,
          }),
        );

        yield ScanStateMessage.success(
            'Successfully presented your credential!');
      } catch (e) {
        yield ScanStateMessage.error(
            'Something went wrong, please try again later.');
      }

      yield ScanStateSuccess();

      yield ScanStateIdle();
    }
  }
}

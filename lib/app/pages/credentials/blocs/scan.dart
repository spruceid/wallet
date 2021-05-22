import 'dart:convert';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:credible/app/interop/didkit/didkit.dart';
import 'package:credible/app/interop/secure_storage/secure_storage.dart';
import 'package:credible/app/pages/credentials/blocs/wallet.dart';
import 'package:credible/app/pages/credentials/models/credential.dart';
import 'package:credible/app/pages/credentials/repositories/credential.dart';
import 'package:credible/app/shared/constants.dart';
import 'package:credible/app/shared/model/message.dart';
import 'package:dio/dio.dart';
import 'package:flutter_modular/flutter_modular.dart';
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
  final List<CredentialModel> credentials;
  final String? challenge;
  final String? domain;

  ScanEventVerifiablePresentationRequest({
    required this.url,
    required this.key,
    required this.credentials,
    this.challenge,
    this.domain,
  });
}

class ScanEventCHAPIStore extends ScanEvent {
  final Map<String, dynamic> data;
  final void Function(String) done;

  ScanEventCHAPIStore(
    this.data,
    this.done,
  );
}

class ScanEventCHAPIGetDIDAuth extends ScanEvent {
  final String keyId;
  final String? challenge;
  final String? domain;
  final void Function(String) done;

  ScanEventCHAPIGetDIDAuth(
    this.keyId,
    this.done, {
    this.challenge,
    this.domain,
  });
}

class ScanEventCHAPIGetQueryByExample extends ScanEvent {
  final String keyId;
  final List<CredentialModel> credentials;
  final String? challenge;
  final String? domain;
  final void Function(String) done;

  ScanEventCHAPIGetQueryByExample(
    this.keyId,
    this.credentials,
    this.done, {
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
    } else if (event is ScanEventCHAPIStore) {
      yield* _CHAPIStore(event);
    } else if (event is ScanEventCHAPIGetDIDAuth) {
      yield* _CHAPIGetDIDAuth(event);
    } else if (event is ScanEventCHAPIGetQueryByExample) {
      yield* _CHAPIGetQueryByExample(event);
    }
  }

  Stream<ScanState> _credentialOffer(
    ScanEventCredentialOffer event,
  ) async* {
    yield ScanStateWorking();

    final url = event.url;
    final keyId = event.key;

    try {
      final key = (await SecureStorageProvider.instance.get(keyId))!;
      final did =
          DIDKitProvider.instance.keyToDID(Constants.defaultDIDMethod, key);

      final credential = await client.post(
        url,
        data: FormData.fromMap(<String, dynamic>{'subject_id': did}),
      );

      final jsonCredential = credential.data is String
          ? jsonDecode(credential.data)
          : credential.data;

      final vcStr = jsonEncode(jsonCredential);
      final optStr = jsonEncode({'proofPurpose': 'assertionMethod'});
      await Future.delayed(Duration(seconds: 1));
      // TODO [bug] verification fails here for unknown reason
      final verification =
          await DIDKitProvider.instance.verifyCredential(vcStr, optStr);

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
      await repository
          .insert(CredentialModel.fromMap({'data': jsonCredential}));

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
    final challenge = event.challenge;
    final domain = event.domain;
    final credentials = event.credentials;

    try {
      final key = (await SecureStorageProvider.instance.get(keyId))!;
      final did =
          DIDKitProvider.instance.keyToDID(Constants.defaultDIDMethod, key);
      final verificationMethod = await DIDKitProvider.instance
          .keyToVerificationMethod(Constants.defaultDIDMethod, key);

      final presentationId = 'urn:uuid:' + Uuid().v4();
      final presentation = await DIDKitProvider.instance.issuePresentation(
        jsonEncode({
          '@context': ['https://www.w3.org/2018/credentials/v1'],
          'type': ['VerifiablePresentation'],
          'id': presentationId,
          'holder': did,
          'verifiableCredential': credentials.length == 1
              ? credentials.first.toMap()
              : credentials.map((c) => c.toMap()).toList(),
        }),
        jsonEncode({
          'verificationMethod': verificationMethod,
          'proofPurpose': 'authentication',
          'challenge': challenge,
          'domain': domain,
        }),
        key,
      );

      await client.post(
        url.toString(),
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

  Stream<ScanState> _CHAPIStore(
    ScanEventCHAPIStore event,
  ) async* {
    yield ScanStateWorking();

    final data = event.data;
    final done = event.done;

    try {
      late final type;

      if (data['type'] is List<dynamic>) {
        type = data['type'].first;
      } else {
        type = data['type'];
      }

      late final vc;

      switch (type) {
        case 'VerifiablePresentation':
          vc = data['verifiableCredential'];
          break;

        case 'VerifiableCredential':
          vc = data;
          break;

        default:
          throw UnimplementedError('Unsupported dataType: $type');
      }

      final vcStr = jsonEncode(vc);
      final optStr = jsonEncode({'proofPurpose': 'assertionMethod'});
      await Future.delayed(Duration(seconds: 1));
      // TODO [bug] verification fails here for unknown reason
      final verification =
          await DIDKitProvider.instance.verifyCredential(vcStr, optStr);

      print('[credible/chapi-store/verify/vc] $vcStr');
      print('[credible/chapi-store/verify/options] $optStr');
      print('[credible/chapi-store/verify/result] $verification');

      final jsonVerification = jsonDecode(verification);

      if (jsonVerification['warnings'].isNotEmpty) {
        log(
          'credential verification return warnings',
          name: 'credible/scan/chapi-store',
          error: jsonVerification['warnings'],
        );

        yield ScanStateMessage(StateMessage.warning(
            'Credential verification returned some warnings. '
            'Check the logs for more information.'));
      }

      if (jsonVerification['errors'].isNotEmpty) {
        log(
          'failed to verify credential',
          name: 'credible/scan/chapi-store',
          error: jsonVerification['errors'],
        );

        // done(jsonEncode(jsonVerification['errors']));

        yield ScanStateMessage(
            StateMessage.error('Failed to verify credential. '
                'Check the logs for more information.'));
      }

      final repository = Modular.get<CredentialsRepository>();
      await repository.insert(vc);

      done(vcStr);

      yield ScanStateMessage(StateMessage.success(
          'A new credential has been successfully added!'));
    } catch (e) {
      log(
        'something went wrong',
        name: 'credible/scan/chapi-store',
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

  Stream<ScanState> _CHAPIGetDIDAuth(
    ScanEventCHAPIGetDIDAuth event,
  ) async* {
    yield ScanStateWorking();

    final keyId = event.keyId;
    final challenge = event.challenge;
    final domain = event.domain;
    final done = event.done;

    try {
      final key = (await SecureStorageProvider.instance.get(keyId))!;
      final did =
          DIDKitProvider.instance.keyToDID(Constants.defaultDIDMethod, key);
      final verificationMethod = await DIDKitProvider.instance
          .keyToVerificationMethod(Constants.defaultDIDMethod, key);

      final presentation = await DIDKitProvider.instance.DIDAuth(
        did,
        jsonEncode({
          'verificationMethod': verificationMethod,
          'proofPurpose': 'authentication',
          'challenge': challenge,
          'domain': domain,
        }),
        key,
      );

      done(presentation);

      yield ScanStateMessage(
          StateMessage.success('Successfully presented your DID!'));
    } catch (e) {
      log(
        'something went wrong',
        name: 'credible/scan/chapi-get-didauth',
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

  Stream<ScanState> _CHAPIGetQueryByExample(
    ScanEventCHAPIGetQueryByExample event,
  ) async* {
    yield ScanStateWorking();

    final keyId = event.keyId;
    final challenge = event.challenge;
    final domain = event.domain;
    final credentials = event.credentials;
    final done = event.done;

    try {
      final key = (await SecureStorageProvider.instance.get(keyId))!;
      final did =
          DIDKitProvider.instance.keyToDID(Constants.defaultDIDMethod, key);
      final verificationMethod = await DIDKitProvider.instance
          .keyToVerificationMethod(Constants.defaultDIDMethod, key);

      final presentationId = 'urn:uuid:' + Uuid().v4();
      final presentation = await DIDKitProvider.instance.issuePresentation(
        jsonEncode({
          '@context': ['https://www.w3.org/2018/credentials/v1'],
          'type': ['VerifiablePresentation'],
          'id': presentationId,
          'holder': did,
          'verifiableCredential': credentials.length == 1
              ? credentials.first.toMap()
              : credentials.map((c) => c.toMap()).toList(),
        }),
        jsonEncode({
          'verificationMethod': verificationMethod,
          'proofPurpose': 'authentication',
          'challenge': challenge,
          'domain': domain,
        }),
        key,
      );

      done(presentation);

      yield ScanStateMessage(
          StateMessage.success('Successfully presented your credential(s)!'));
    } catch (e) {
      log(
        'something went wrong',
        name: 'credible/scan/chapi-get-querybyexample',
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

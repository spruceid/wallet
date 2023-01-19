import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:credible/app/interop/didkit/didkit.dart';
import 'package:credible/app/interop/secure_storage/secure_storage.dart';
import 'package:credible/app/pages/credentials/blocs/wallet.dart';
import 'package:credible/app/pages/credentials/models/credential.dart';
import 'package:credible/app/pages/credentials/repositories/credential.dart';
import 'package:credible/app/shared/constants.dart';
import 'package:credible/app/shared/model/message.dart';
import 'package:dio/dio.dart';
import 'package:dio_logging_interceptor/dio_logging_interceptor.dart' as diolog;
import 'package:flutter_modular/flutter_modular.dart';
import 'package:logging/logging.dart';
import 'package:uuid/uuid.dart';
import 'package:http/http.dart' as http;

abstract class ScanEvent {}

class ScanEventShowPreview extends ScanEvent {
  final Map<String, dynamic> preview;

  ScanEventShowPreview(this.preview);
}

class ScanEventCredentialOffer extends ScanEvent {
  final String url;
  final String? alias;
  final String key;

  ScanEventCredentialOffer(
    this.url,
    this.alias,
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

  ScanBloc(this.client) : super(ScanStateIdle()) {
    on<ScanEventShowPreview>(
      (event, emit) => emit(ScanStatePreview(preview: event.preview)),
    );
    on<ScanEventCredentialOffer>(
      (event, emit) => _credentialOffer(event).forEach(emit),
    );
    on<ScanEventVerifiablePresentationRequest>(
      (event, emit) => _verifiablePresentationRequest(event).forEach(emit),
    );
    on<ScanEventCHAPIStore>(
      (event, emit) => _CHAPIStore(event).forEach(emit),
    );
    on<ScanEventCHAPIGetDIDAuth>(
      (event, emit) => _CHAPIGetDIDAuth(event).forEach(emit),
    );
    on<ScanEventCHAPIGetQueryByExample>(
      (event, emit) => _CHAPIGetQueryByExample(event).forEach(emit),
    );
  }

  Stream<ScanState> _credentialOffer(
    ScanEventCredentialOffer event,
  ) async* {
    final log = Logger('credible/scan/credential-offer');

    yield ScanStateWorking();

    final url = event.url;
    final alias = event.alias;
    final keyId = event.key;

    try {
      final key = (await SecureStorageProvider.instance.get(keyId))!;
      log.severe('1');
      final did =
          DIDKitProvider.instance.keyToDID(Constants.defaultDIDMethod, key);
      log.severe('2');
      log.severe(url);
      log.severe(did);
      // ignore: todo
      // TODO [TC]: Implement a response from backend server
      // Log the form data to be sent with post
      log.severe(FormData.fromMap(<String, dynamic>{'subject_id': did}).fields);

      // ignore: todo
      // TODO [TC]: this client.post request fails despite curl functioning.
      //
      // final try_a_get = await client.get(url);
      // log.severe(try_a_get);

      client.interceptors.add(
        diolog.DioLoggingInterceptor(
          level: diolog.Level.body,
          compact: false,
        ),
      );
      log.severe('Added interceptor');
      // ignore: todo
      // TODO [TC]: Debugging
      final credential = await client.post(url,
          // Send POST as "form data", currently fails with our backend
          // data: FormData.fromMap(<String, dynamic>{'subject_id': did}));

          // Send POST as "JSON data", currently works but stops at step 5
          data: {'subject_id': did});

      log.severe('Data');
      log.severe(credential.data);
      log.severe('Extra');
      log.severe(credential.extra);
      log.severe('Headers');
      log.severe(credential.headers);

      log.severe('3');
      final jsonCredential = credential.data is String
          ? jsonDecode(credential.data)
          : credential.data;

      // --------------------------------------------------------------
      // Try a post request with a different package
      // final credential =
      //     await http.post(Uri.http(url), body: {'subject_id': did});
      // // data: FormData.fromMap(<String, dynamic>{'subject_id': did}));
      // log.severe(credential);

      // // ignore: unnecessary_type_check
      // final jsonCredential = credential.body is String
      //     ? jsonDecode(credential.body)
      //     : credential.body;
      // --------------------------------------------------------------

      log.severe('4');
      final vcStr = jsonEncode(jsonCredential);
      final optStr = jsonEncode({'proofPurpose': 'assertionMethod'});
      log.severe('5');
      await Future.delayed(Duration(seconds: 1));
      // ignore: todo
      // TODO [bug] verification fails here for unknown reason
      // ignore: todo
      // TODO [TC]: This is where `trustchain-cli vc verify` could be called
      // once FFI is implemented

      // final verification =
      //     await DIDKitProvider.instance.verifyCredential(vcStr, optStr);
      log.severe('6');
      print('[credible/credential-offer/verify/vc] $vcStr');
      print('[credible/credential-offer/verify/options] $optStr');
      // print('[credible/credential-offer/verify/result] $verification');
      log.severe('7');
      // final jsonVerification = jsonDecode(verification);

      // if (jsonVerification['warnings'].isNotEmpty) {
      //   log.warning('credential verification return warnings',
      //       jsonVerification['warnings']);

      //   yield ScanStateMessage(StateMessage.warning(
      //       'Credential verification returned some warnings. '
      //       'Check the logs for more information.'));
      // }

      // if (jsonVerification['errors'].isNotEmpty) {
      //   log.severe('failed to verify credential', jsonVerification['errors']);

      //   yield ScanStateMessage(
      //       StateMessage.error('Failed to verify credential. '
      //           'Check the logs for more information.'));
      // }

      final repository = Modular.get<CredentialsRepository>();
      await repository.insert(
          CredentialModel.fromMap({'alias': alias, 'data': jsonCredential}));

      yield ScanStateMessage(StateMessage.success(
          'A new credential has been successfully added!'));

      await Modular.get<WalletBloc>().findAll();

      await Future.delayed(Duration(milliseconds: 100));
      yield ScanStateSuccess();
    } catch (e) {
      log.severe('something went wrong', e);

      yield ScanStateMessage(
          StateMessage.error('Something went wrong, please try again later. '
              'Check the logs for more information.'));
    }

    await Future.delayed(Duration(milliseconds: 100));
    yield ScanStateIdle();
  }

  Stream<ScanState> _verifiablePresentationRequest(
    ScanEventVerifiablePresentationRequest event,
  ) async* {
    final log = Logger('credible/scan/verifiable-presentation-request');
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

      log.severe('Debugging presentation process.');
      log.severe(key);
      log.severe(verificationMethod);
      final pres = jsonEncode({
        '@context': ['https://www.w3.org/2018/credentials/v1'],
        'type': ['VerifiablePresentation'],
        'id': presentationId,
        'holder': did,
        'verifiableCredential': credentials.length == 1
            ? credentials.first.data
            : credentials.map((c) => c.data).toList(),
      });
      log.severe(pres);
      final opts = jsonEncode({
        'verificationMethod': verificationMethod,
        'proofPurpose': 'authentication',
        'challenge': challenge,
        'domain': domain,
      });
      log.severe(opts);

      // ignore: todo
      // TODO: currently failing, replace with only credential for now
      // final presentation = await DIDKitProvider.instance.issuePresentation(
      //   cred,
      //   opts,
      //   key,
      // );
      final credential = jsonEncode(credentials.first.data);

      // ignore: todo
      // TODO: currently failing with form data as for issuer, use JSON instead
      // await client.post(
      //   url.toString(),
      //   data: FormData.fromMap(<String, dynamic>{
      //     'presentation': presentation,
      //   }),
      // );
      await client.post(url.toString(), data: credential);

      yield ScanStateMessage(
          StateMessage.success('Successfully presented your credential!'));

      await Future.delayed(Duration(milliseconds: 100));
      yield ScanStateSuccess();
    } catch (e) {
      log.severe('something went wrong', e);

      yield ScanStateMessage(
          StateMessage.error('Something went wrong, please try again later. '
              'Check the logs for more information.'));
    }

    await Future.delayed(Duration(milliseconds: 100));
    yield ScanStateIdle();
  }

  Stream<ScanState> _CHAPIStore(
    ScanEventCHAPIStore event,
  ) async* {
    final log = Logger('credible/scan/chapi-store');

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
        log.warning('credential verification return warnings',
            jsonVerification['warnings']);

        yield ScanStateMessage(StateMessage.warning(
            'Credential verification returned some warnings. '
            'Check the logs for more information.'));
      }

      if (jsonVerification['errors'].isNotEmpty) {
        log.severe('failed to verify credential', jsonVerification['errors']);

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
      log.severe('something went wrong', e);

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
    final log = Logger('credible/scan/chapi-get-didauth');
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
      log.severe('something went wrong', e);

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
    final log = Logger('credible/scan/chapi-get-querybyexample');
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
      log.severe('something went wrong', e);

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

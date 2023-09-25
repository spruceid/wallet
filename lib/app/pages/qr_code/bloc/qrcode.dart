import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:credible/app/interop/trustchain/trustchain.dart';
import 'package:credible/app/pages/credentials/blocs/scan.dart';
import 'package:credible/app/pages/did/models/did.dart';
import 'package:credible/app/shared/config.dart';
import 'package:credible/app/shared/model/message.dart';
import 'package:dio/dio.dart';
import 'package:flutter_rust_bridge/flutter_rust_bridge.dart';
import 'package:logging/logging.dart';

abstract class QRCodeEvent {}

class QRCodeEventHost extends QRCodeEvent {
  final String data;

  QRCodeEventHost(this.data);
}

class QRCodeEventAccept extends QRCodeEvent {
  final Uri uri;

  QRCodeEventAccept(this.uri);
}

abstract class QRCodeState {}

class QRCodeStateWorking extends QRCodeState {}

class QRCodeStateHost extends QRCodeState {
  final Uri uri;
  final bool verified;

  QRCodeStateHost(this.uri, this.verified);
}

class QRCodeStateSuccess extends QRCodeState {
  final String route;
  final Uri uri;

  QRCodeStateSuccess(this.route, this.uri);
}

class QRCodeStateUnknown extends QRCodeState {}

class QRCodeStateMessage extends QRCodeState {
  final StateMessage message;

  QRCodeStateMessage(this.message);
}

class QRCodeBloc extends Bloc<QRCodeEvent, QRCodeState> {
  final Dio client;
  final ScanBloc scanBloc;

  QRCodeBloc(
    this.client,
    this.scanBloc,
  ) : super(QRCodeStateWorking()) {
    on<QRCodeEventHost>((event, emit) => _host(event).forEach(emit));
    on<QRCodeEventAccept>((event, emit) => _accept(event).forEach(emit));
  }

  Stream<QRCodeState> _host(
    QRCodeEventHost event,
  ) async* {
    late final uri;

    try {
      // Decode JSON string
      final didCode = jsonDecode(event.data);
      final did = didCode['did'];
      final route = didCode['route'];
      final uuid = didCode['uuid'];
      // Verify DID first with FFI call
      final ffiConfig = await ffi_config_instance.get_ffi_config();
      try {
        await trustchain_ffi.didVerify(did: did, opts: jsonEncode(ffiConfig));
      } on FfiException {
        yield QRCodeStateMessage(
            StateMessage.error('Failed verification of $did'));
      }
      // Resolve DID
      final resolverUri = Uri.parse(
          (await ffi_config_instance.get_trustchain_endpoint()) +
              '/did/' +
              did);
      final response = await client.getUri(resolverUri);
      final endpoint =
          extractEndpoint(response.data['didDocument'], '#TrustchainHTTP');
      // TODO: Uncomment to alternatively use config endpoint
      // final endpoint = (await ffi_config_instance.get_trustchain_endpoint());
      uri = Uri.parse(endpoint + route + uuid);
      yield QRCodeStateHost(uri, true);
    } on FormatException catch (e) {
      try {
        print(e.message);
        uri = Uri.parse(event.data);
      } on FormatException catch (e) {
        print(e.message);
        yield QRCodeStateMessage(StateMessage.error(
            'This QRCode does not contain a valid message.'));
      }
    }

    yield QRCodeStateHost(uri, false);
  }

  Stream<QRCodeState> _accept(
    QRCodeEventAccept event,
  ) async* {
    final log = Logger('credible/qrcode/accept');

    late final data;

    try {
      final url = event.uri.toString();
      final response = await client.get(url);
      data =
          response.data is String ? jsonDecode(response.data) : response.data;
    } on DioError catch (e) {
      log.severe('An error occurred while connecting to the server.', e);

      yield QRCodeStateMessage(StateMessage.error(
          'An error occurred while connecting to the server. '
          'Check the logs for more information.'));
    }

    scanBloc.add(ScanEventShowPreview(data));

    switch (data['type']) {
      case 'CredentialOffer':
        yield QRCodeStateSuccess('/credentials/receive', event.uri);
        break;

      case 'VerifiablePresentationRequest':
        yield QRCodeStateSuccess('/credentials/present', event.uri);
        break;

      default:
        yield QRCodeStateUnknown();
        break;
    }

    yield QRCodeStateWorking();
  }
}

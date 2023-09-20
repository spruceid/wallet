import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:credible/app/pages/credentials/blocs/scan.dart';
import 'package:credible/app/pages/did/models/did.dart';
import 'package:credible/app/shared/config.dart';
import 'package:credible/app/shared/model/message.dart';
import 'package:dio/dio.dart';
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

  QRCodeStateHost(this.uri);
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

    // try {
    // TODO: add inability to parse the encoding, then try block can be uncommented.
    // uri = Uri.parse(event.data);
    // print(uri);
    // throw FormatException;
    // } on FormatException catch (e) {
    // print(e.message);
    try {
      // Decode possible base64url string
      final did_offer_uuid =
          jsonDecode(utf8.decode(base64Url.decode(event.data)));
      final did = did_offer_uuid['did'];
      final route = did_offer_uuid['route'];
      final uuid = did_offer_uuid['uuid'];
      print(did_offer_uuid);
      // TODO: Verify DID

      // Resolve DID
      final resolver_uri = 'http://' +
          (await ffi_config_instance.get_trustchain_endpoint()) +
          '/did/' +
          did;
      print(resolver_uri);
      final response = await client.get(resolver_uri);
      print(response);
      final data = response.data;
      print(data);
      // Extract endpoint
      // final endpoint =
      //     extractEndpoint(data['didDocument'], 'TrustchainIssuer');
      final endpoint = did_offer_uuid['endpoint'];
      print(endpoint);
      // Make final URI
      uri = Uri.parse(endpoint + route + uuid);
      print(uri);
    } on FormatException catch (e) {
      print(e.message);
      yield QRCodeStateMessage(
          StateMessage.error('This QRCode does not contain a valid message.'));
    }
    // }

    yield QRCodeStateHost(uri);
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

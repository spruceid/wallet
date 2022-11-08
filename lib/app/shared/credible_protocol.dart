import 'dart:convert';

import 'package:credible/app/pages/credentials/blocs/scan.dart';
import 'package:credible/app/pages/qr_code/bloc/qrcode.dart';
import 'package:credible/app/shared/model/message.dart';
import 'package:credible/app/shared/qr_code_protocol.dart';
import 'package:dio/dio.dart';
import 'package:logging/logging.dart';

class CredibleProtocol implements QRCodeProtocol {
  final Uri uri;

  CredibleProtocol({
    required this.uri,
  });

  @override
  Stream<QRCodeState> onAccept(
    Dio client,
    ScanBloc scanBloc,
  ) async* {
    final log = Logger('credible/qrcode/accept#CredibleProtocol');

    late final data;

    try {
      final url = uri.toString();
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
        yield QRCodeStateSuccess.withArgs('/credentials/receive', uri);
        break;

      case 'VerifiablePresentationRequest':
        yield QRCodeStateSuccess.withArgs('/credentials/present', uri);
        break;

      default:
        yield QRCodeStateUnknown();
        break;
    }

    yield QRCodeStateWorking();
  }
}

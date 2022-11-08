import 'package:credible/app/pages/credentials/blocs/scan.dart';
import 'package:credible/app/pages/qr_code/bloc/qrcode.dart';
import 'package:dio/dio.dart';

abstract class QRCodeProtocol {
  Stream<QRCodeState> onAccept(
    Dio client,
    ScanBloc scanBloc,
  ) async* {
    throw UnimplementedError('onAccept is not implemented');
  }
}

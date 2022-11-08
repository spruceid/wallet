import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:credible/app/pages/credentials/blocs/scan.dart';
import 'package:credible/app/shared/credible_protocol.dart';
import 'package:credible/app/shared/issuance_request_protocol.dart';
import 'package:credible/app/shared/model/message.dart';
import 'package:credible/app/shared/qr_code_protocol.dart';
import 'package:dio/dio.dart';

abstract class QRCodeEvent {}

class QRCodeEventHost extends QRCodeEvent {
  final String data;

  QRCodeEventHost(this.data);
}

class QRCodeEventAccept<T extends QRCodeProtocol> extends QRCodeEvent {
  final T protocol;

  QRCodeEventAccept(this.protocol);
}

abstract class QRCodeState {}

class QRCodeStateInitial extends QRCodeState {}

class QRCodeStateWorking extends QRCodeState {}

class QRCodeStateHost<T extends QRCodeProtocol> extends QRCodeState {
  final T protocol;

  QRCodeStateHost(this.protocol);
}

class QRCodeStateSuccess extends QRCodeState {
  final String route;
  final dynamic args;

  QRCodeStateSuccess(this.route) : args = null;

  QRCodeStateSuccess.withArgs(this.route, this.args);
}

class QRCodeStateInput extends QRCodeState {
  final String prompt;
  final Completer<String> value;

  QRCodeStateInput(this.prompt, this.value);
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
  ) : super(QRCodeStateInitial()) {
    on<QRCodeEventHost>((event, emit) => _host(event).forEach(emit));
    on<QRCodeEventAccept>((event, emit) => _accept(event).forEach(emit));
  }

  Stream<QRCodeState> _host(
    QRCodeEventHost event,
  ) async* {
    yield QRCodeStateWorking();

    final Uri uri;

    try {
      uri = Uri.parse(event.data);
    } on FormatException catch (e) {
      print(e.message);

      yield QRCodeStateMessage(StateMessage.error(
        'This QRCode does not contain a valid message.',
      ));
      return;
    }

    if (!uri.hasScheme) {
      yield QRCodeStateMessage(StateMessage.error(
        'This QRCode does not contain a valid message.',
      ));
      return;
    }

    if (uri.scheme == 'openid-initiate-issuance') {
      final request;

      try {
        request = IssuanceRequest.fromString(event.data);
      } catch (_) {
        yield QRCodeStateMessage(StateMessage.error(
          'Could not parse OpenID issuance request.',
        ));
        return;
      }

      yield QRCodeStateHost<IssuanceRequest>(request);
    } else if (uri.scheme.startsWith('http://') ||
        uri.scheme.startsWith('https://')) {
      yield QRCodeStateHost<CredibleProtocol>(CredibleProtocol(uri: uri));
    } else {
      yield QRCodeStateMessage(StateMessage.error(
        'This QRCode does not contain a valid message.',
      ));
    }
    yield QRCodeStateInitial();
  }

  Stream<QRCodeState> _accept(
    QRCodeEventAccept event,
  ) async* {
    yield* event.protocol.onAccept(
      client,
      scanBloc,
    );
  }
}

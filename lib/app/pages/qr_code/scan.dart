import 'dart:async';
import 'dart:io';

import 'package:credible/app/pages/qr_code/bloc/qrcode.dart';
import 'package:credible/app/shared/credible_protocol.dart';
import 'package:credible/app/shared/issuance_request_protocol.dart';
import 'package:credible/app/shared/widget/base/page.dart';
import 'package:credible/app/shared/widget/confirm_dialog.dart';
import 'package:credible/app/shared/widget/navigation_bar.dart';
import 'package:credible/app/shared/widget/pin_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

class QrCodeScanPage extends StatefulWidget {
  @override
  _QrCodeScanPageState createState() => _QrCodeScanPageState();
}

class _QrCodeScanPageState extends State<QrCodeScanPage> {
  final qrKey = GlobalKey(debugLabel: 'QR');
  late QRViewController qrController;

  late bool flash;
  bool promptActive = false;

  @override
  void initState() {
    super.initState();
    flash = false;
  }

  @override
  void dispose() {
    super.dispose();
    qrController.dispose();
  }

  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      qrController.pauseCamera();
    } else if (Platform.isIOS) {
      qrController.resumeCamera();
    }
  }

  void onQRViewCreated(QRViewController controller) {
    qrController = controller;

    controller.scannedDataStream.listen((scanData) {
      controller.pauseCamera();

      Modular.get<QRCodeBloc>().add(QRCodeEventHost(scanData.code ?? ''));
    });
  }

  void promptHost(String title, VoidCallback onAccept) async {
    // TODO [bug] find out why the camera sometimes sends a code twice
    if (!promptActive) {
      setState(() {
        promptActive = true;
      });

      final localizations = AppLocalizations.of(context)!;
      final acceptHost = await showDialog<bool>(
            context: context,
            builder: (BuildContext context) {
              return ConfirmDialog(
                title: localizations.scanPromptHost,
                subtitle: title,
                yes: localizations.communicationHostAllow,
                no: localizations.communicationHostDeny,
              );
            },
          ) ??
          false;

      if (acceptHost) {
        onAccept.call();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(localizations.scanRefuseHost),
        ));
      }

      setState(() {
        promptActive = false;
      });
    }
  }

  void promptInput(String title, Completer<String> onConfirm) async {
    if (!promptActive) {
      setState(() {
        promptActive = true;
      });

      final pin = await showDialog<String>(
        context: context,
        builder: (BuildContext context) {
          return PinDialog(
            title: title,
          );
        },
      );

      if (pin != null) {
        onConfirm.complete(pin);
      } else {
        onConfirm.completeError(Exception("PIN wasn't provided."));
      }

      setState(() {
        promptActive = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    return BlocConsumer(
      bloc: Modular.get<QRCodeBloc>(),
      listener: (context, state) {
        if (state is QRCodeStateMessage) {
          qrController.resumeCamera();

          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            backgroundColor: state.message.color,
            content: Text(state.message.message),
          ));
        }
        if (state is QRCodeStateHost) {
          final protocol = state.protocol;
          switch (protocol.runtimeType) {
            case CredibleProtocol:
              final uri = (protocol as CredibleProtocol).uri;
              promptHost(uri.host, () {
                Modular.get<QRCodeBloc>().add(QRCodeEventAccept(protocol));
              });
              break;

            case IssuanceRequest:
              final request = protocol as IssuanceRequest;
              promptHost(request.issuer, () {
                Modular.get<QRCodeBloc>().add(QRCodeEventAccept(protocol));
              });
              break;

            default:
              break;
          }
        }
        if (state is QRCodeStateInput) {
          promptInput(state.prompt, state.value);
        }
        if (state is QRCodeStateUnknown) {
          qrController.resumeCamera();

          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(localizations.scanUnsupportedMessage),
          ));
        }
        if (state is QRCodeStateSuccess) {
          qrController.stopCamera();

          Modular.to.pushReplacementNamed(
            state.route,
            arguments: state.args,
          );
        }
      },
      builder: (context, state) => Stack(
        children: [
          BasePage(
            padding: EdgeInsets.zero,
            title: localizations.scanTitle,
            scrollView: false,
            navigation: CustomNavBar(index: 1),
            extendBelow: true,
            body: SafeArea(
              child: Container(
                padding: const EdgeInsets.all(8.0),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16.0),
                  child: QRView(
                    key: qrKey,
                    overlay: QrScannerOverlayShape(
                      borderColor: Colors.white70,
                    ),
                    onQRViewCreated: onQRViewCreated,
                  ),
                ),
              ),
            ),
          ),
          if (state is QRCodeStateWorking)
            SafeArea(
              child: Container(
                color: Colors.black54,
                alignment: Alignment.center,
                child: SizedBox(
                  width: MediaQuery.of(context).size.width * 0.44,
                  height: MediaQuery.of(context).size.width * 0.44,
                  child: CircularProgressIndicator(
                    color: Colors.white,
                    strokeWidth: 8.0,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

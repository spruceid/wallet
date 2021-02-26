import 'dart:io';

import 'package:credible/app/pages/qr_code/bloc/qrcode.dart';
import 'package:credible/app/shared/widget/base/page.dart';
import 'package:credible/app/shared/widget/confirm_dialog.dart';
import 'package:credible/app/shared/widget/navigation_bar.dart';
import 'package:credible/localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

class QrCodeScanPage extends StatefulWidget {
  @override
  _QrCodeScanPageState createState() => _QrCodeScanPageState();
}

class _QrCodeScanPageState extends ModularState<QrCodeScanPage, QRCodeBloc> {
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
      store.add(QRCodeEventHost(scanData.code));
    });
  }

  void promptHost(Uri uri) async {
    // TODO [bug] find out why the camera sometimes sends a code twice
    if (!promptActive) {
      setState(() {
        promptActive = true;
      });

      final acceptHost = await showDialog<bool>(
            context: context,
            builder: (BuildContext context) {
              final localizations = AppLocalizations.of(context)!;

              return ConfirmDialog(
                title: 'Do you trust this host?',
                subtitle: uri.host,
                yes: localizations.communicationHostAllow,
                no: localizations.communicationHostDeny,
              );
            },
          ) ??
          false;

      if (acceptHost) {
        store.add(QRCodeEventAccept(uri));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('The communication request was denied.'),
        ));
      }

      setState(() {
        promptActive = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener(
      bloc: store,
      listener: (context, state) {
        if (state is QRCodeStateMessage) {
          qrController.resumeCamera();

          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            backgroundColor: state.message.color,
            content: Text(state.message.message),
          ));
        }
        if (state is QRCodeStateHost) {
          promptHost(state.uri);
        }
        if (state is QRCodeStateUnknown) {
          qrController.resumeCamera();

          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text('Unsupported message received.'),
          ));
        }
        if (state is QRCodeStateSuccess) {
          qrController.stopCamera();

          Modular.to.pushReplacementNamed(
            state.route,
            arguments: state.uri,
          );
        }
      },
      child: BasePage(
        padding: EdgeInsets.zero,
        title: 'Scan',
        // floatingActionButton: FloatingActionButton(
        //   onPressed: () {
        //     controller.toggleFlash();
        //     setState(() {
        //       flash = !flash;
        //     });
        //   },
        //   tooltip: 'Toggle Flash',
        //   child: Icon(flash ? Icons.flash_on : Icons.flash_off),
        // ),
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
    );
  }
}

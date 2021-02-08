import 'dart:convert';

import 'package:credible/app/pages/credentials/blocs/scan.dart';
import 'package:credible/app/shared/palette.dart';
import 'package:credible/app/shared/widget/base/button.dart';
import 'package:credible/app/shared/widget/base/page.dart';
import 'package:credible/app/shared/widget/navigation_bar.dart';
import 'package:credible/localizations.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

class QrCodeScanPage extends StatefulWidget {
  @override
  _QrCodeScanPageState createState() => _QrCodeScanPageState();
}

class _QrCodeScanPageState extends State<QrCodeScanPage> {
  final qrKey = GlobalKey(debugLabel: 'QR');
  QRViewController controller;

  String qrText = '';
  bool flash = false;

  void Function(QRViewController) _onQRViewCreated(
    BuildContext context,
    AppLocalizations localizations,
  ) =>
      (QRViewController controller) {
        this.controller = controller;

        final showSnackBarAndResumeScan = (String message) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(message),
          ));

          Future.delayed(Duration(seconds: 1), () async {
            await controller.resumeCamera();
          });
        };

        controller.scannedDataStream.listen((scanData) async {
          await controller.pauseCamera();
          print(scanData);

          try {
            final uri = Uri.parse(scanData.code);

            final acceptHost = await showDialog<bool>(
                  context: context,
                  builder: (BuildContext context) => AlertDialog(
                    title: Text(
                      'Do you trust this host?',
                      style: Theme.of(context).textTheme.subtitle1,
                    ),
                    content: Text(
                      uri.host,
                      style: Theme.of(context).textTheme.subtitle2,
                    ),
                    actions: [
                      BaseButton.transparent(
                        borderColor: Palette.blue,
                        onPressed: () {
                          Modular.to.pop(true);
                        },
                        child: Text(localizations.communicationHostAllow),
                      ),
                      BaseButton.blue(
                        onPressed: () {
                          Modular.to.pop(false);
                        },
                        child: Text(localizations.communicationHostDeny),
                      ),
                    ],
                  ),
                ) ??
                false;

            if (!acceptHost) {
              showSnackBarAndResumeScan(
                  'The communication request was denied.');
              return;
            }

            final dio = Modular.get<Dio>();
            final bloc = Modular.get<ScanBloc>();

            try {
              final url = uri.toString();
              final response = await dio.get(url);
              final data = response.data is String
                  ? jsonDecode(response.data)
                  : response.data;
              final type = data['type'];

              bloc.add(ScanEventShowPreview(data));

              switch (type) {
                case 'CredentialOffer':
                  await Modular.to.pushReplacementNamed(
                    '/credentials/receive',
                    arguments: uri,
                  );
                  return;

                case 'VerifiablePresentationRequest':
                  await Modular.to.pushReplacementNamed(
                    '/credentials/present',
                    arguments: uri,
                  );
                  return;

                default:
                  showSnackBarAndResumeScan('Unsupported message received.');
                  return;
              }
            } on DioError catch (e) {
              print(e.message);

              showSnackBarAndResumeScan(
                  'An error occurred while connecting to the server:' +
                      e.message);
            }
          } on FormatException catch (e) {
            print(e.message);

            showSnackBarAndResumeScan(
                'This QRCode does not contain a valid message.');
          }
        });
      };

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);

    return BasePage(
      backgroundColor: Palette.background,
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
      body: QRView(
        key: qrKey,
        overlay: QrScannerOverlayShape(
          borderColor: Colors.white70,
        ),
        onQRViewCreated: _onQRViewCreated(context, localizations),
      ),
    );
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}

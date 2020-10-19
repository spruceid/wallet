import 'package:credible/app/pages/credentials/models/credential.dart';
import 'package:credible/app/pages/credentials/models/credential_status.dart';
import 'package:credible/app/shared/ssi_mock.dart';
import 'package:credible/app/shared/widget/app_bar.dart';
import 'package:credible/app/shared/widget/navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

class QrCodeScanPage extends StatefulWidget {
  @override
  _QrCodeScanPageState createState() => _QrCodeScanPageState();
}

class _QrCodeScanPageState extends State<QrCodeScanPage> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final qrKey = GlobalKey(debugLabel: 'QR');
  QRViewController controller;

  String qrText = '';
  bool flash = false;

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) async {
      controller.pauseCamera();
      print(scanData);

      // TODO: mock code flow after qr-code is read
      try {
        final parsed = await Ssi.parse(scanData);

        if (parsed is SsiCredential) {
          await Modular.to.pushReplacementNamed(
            '/credentials/receive',
            arguments: CredentialModel(
              id: 'ab98-xyzw',
              issuer: 'Doximity',
              image: 'abcd12',
              status: CredentialStatus.active,
            ),
          );
        } else if (parsed is SsiPresentation) {
          await Modular.to.pushReplacementNamed(
            '/credentials/present',
            arguments: CredentialModel(
              id: 'ab98-xyzw',
              issuer: 'Doximity',
              image: 'abcd12',
              status: CredentialStatus.active,
            ),
          );
        }
      } on SsiFormatException catch (e) {
        scaffoldKey.currentState.showSnackBar(SnackBar(
          content: Text(e.message),
        ));
      }
    });
  }

  @override
  Widget build(BuildContext context) => SafeArea(
        child: Scaffold(
          appBar: CustomAppBar(
            title: 'Scan',
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              controller.toggleFlash();
              setState(() {
                flash = !flash;
              });
            },
            tooltip: 'Toggle Flash',
            child: Icon(flash ? Icons.flash_on : Icons.flash_off),
          ),
          bottomNavigationBar: CustomNavBar(index: 1),
          body: QRView(
            key: qrKey,
            overlay: QrScannerOverlayShape(
              borderColor: Colors.white70,
            ),
            onQRViewCreated: _onQRViewCreated,
          ),
        ),
      );

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}

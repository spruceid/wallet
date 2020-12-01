import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

class QrCodeDisplayPage extends StatelessWidget {
  final String data;

  const QrCodeDisplayPage({
    Key key,
    this.data,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => SafeArea(
        child: Scaffold(
          body: Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.all(32.0),
            child: QrImage(
              data: data,
              version: QrVersions.auto,
            ),
          ),
        ),
      );
}

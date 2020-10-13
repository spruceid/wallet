import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

class QrCodePage extends StatelessWidget {
  final String data;

  const QrCodePage({
    Key key,
    this.data,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => SafeArea(
        child: Scaffold(
          body: Center(
            child: QrImage(
              data: data,
              version: QrVersions.auto,
              size: MediaQuery.of(context).size.width * 0.5,
            ),
          ),
        ),
      );
}

import 'package:credible/app/shared/widget/back_leading_button.dart';
import 'package:credible/app/shared/widget/base/page.dart';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

class QrCodeDisplayPage extends StatelessWidget {
  final String data;

  const QrCodeDisplayPage({
    Key? key,
    required this.data,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => BasePage(
        title: '',
        titleTrailing: BackLeadingButton(),
        body: Scaffold(
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

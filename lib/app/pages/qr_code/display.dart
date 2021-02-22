import 'package:credible/app/shared/widget/back_leading_button.dart';
import 'package:credible/app/shared/widget/base/page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

class QrCodeDisplayPage extends StatelessWidget {
  final String name;
  final String data;

  const QrCodeDisplayPage({
    Key? key,
    required this.name,
    required this.data,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => BasePage(
        title: ' ',
        titleLeading: BackLeadingButton(),
        scrollView: false,
        body: Column(
          children: [
            Expanded(
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'You are now sharing',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodyText1,
                    ),
                    const SizedBox(height: 4.0),
                    Text(
                      name,
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.caption,
                    ),
                    Container(
                      alignment: Alignment.center,
                      padding: const EdgeInsets.all(32.0),
                      child: QrImage(
                        data: data,
                        version: QrVersions.auto,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      );
}

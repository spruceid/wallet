import 'package:credible/app/shared/ui/ui.dart';
import 'package:credible/app/shared/widget/back_leading_button.dart';
import 'package:credible/app/shared/widget/base/page.dart';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

// TODO: implement the page for displaying a chain
class ChainDisplayPage extends StatelessWidget {
  final String name;
  final String data;

  const ChainDisplayPage({
    Key? key,
    required this.name,
    required this.data,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    return BasePage(
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
                    localizations.qrCodeSharing,
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
                      foregroundColor: UiKit.palette.icon,
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
}

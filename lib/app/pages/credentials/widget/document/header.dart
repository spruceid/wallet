import 'package:credible/app/pages/credentials/models/credential.dart';
import 'package:credible/app/pages/credentials/widget/document/item.dart';
import 'package:credible/app/shared/ui/ui.dart';
import 'package:credible/app/shared/widget/tooltip_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DocumentHeader extends StatelessWidget {
  final CredentialModel item;

  const DocumentHeader({
    Key? key,
    required this.item,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  TooltipText(
                    text: 'John Doe',
                    style: Theme.of(context)
                        .textTheme
                        .subtitle1!
                        .apply(color: UiKit.palette.credentialText),
                  ),
                  const SizedBox(height: 4.0),
                  TooltipText(
                    text: 'Crypto Trader',
                    style: Theme.of(context).textTheme.bodyText1!.apply(
                        color: UiKit.palette.credentialText.withOpacity(0.6)),
                  ),
                ],
              ),
            ),
            DocumentItemWidget(
              label: 'Status:',
              value: 'Valid',
            ),
          ],
        ),
      );
}

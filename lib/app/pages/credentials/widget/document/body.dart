import 'package:credible/app/pages/credentials/models/credential.dart';
import 'package:credible/app/pages/credentials/widget/document/item.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DocumentBody extends StatelessWidget {
  final CredentialModel item;
  final Widget? trailing;

  const DocumentBody({
    Key? key,
    required this.item,
    this.trailing,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => Container(
        margin: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Row(
              children: <Widget>[
                Expanded(
                  child: DocumentItemWidget(
                    label: 'NPI:',
                    value: '4876hTG97',
                  ),
                ),
                const SizedBox(width: 8.0),
                Expanded(
                  child: DocumentItemWidget(
                    label: 'Issued by:',
                    value: item.issuer,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20.0),
            DocumentItemWidget(
              label: 'E-mail:',
              value: 'richard@doximity.com',
            ),
            const SizedBox(height: 20.0),
            DocumentItemWidget(
              label: 'Issued at:',
              value: 'San Francisco, CA',
            ),
            const SizedBox(height: 20.0),
            if (trailing != null) trailing!,
          ],
        ),
      );
}

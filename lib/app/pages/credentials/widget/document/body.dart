import 'package:credible/app/pages/credentials/models/credential.dart';
import 'package:credible/app/pages/credentials/widget/document/item.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class DocumentBodyWidgetModel {
  final String issuedBy;
  final String email;
  final String npi;
  final String issuedAt;

  final Map<String, dynamic> rawData;

  const DocumentBodyWidgetModel(
      this.issuedBy, this.email, this.npi, this.issuedAt, this.rawData);

  factory DocumentBodyWidgetModel.fromCredentialModel(CredentialModel model) =>
      DocumentBodyWidgetModel(
          model.issuer, 'email', 'npi', 'issuedAt', model.data);
}

class DocumentBody extends StatelessWidget {
  final DocumentBodyWidgetModel model;
  final Widget? trailing;

  const DocumentBody({
    Key? key,
    required this.model,
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
                    value: model.npi,
                  ),
                ),
                const SizedBox(width: 8.0),
                Expanded(
                  child: DocumentItemWidget(
                    label: 'Issued by:',
                    value: model.issuedBy,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20.0),
            DocumentItemWidget(
              label: 'Email:',
              value: model.email,
            ),
            const SizedBox(height: 20.0),
            DocumentItemWidget(label: 'Issued at:', value: model.issuedAt),
            if (trailing != null) const SizedBox(height: 20.0),
            if (trailing != null) trailing!,
          ],
        ),
      );
}

import 'package:credible/app/pages/credentials/models/credential.dart';
import 'package:credible/app/pages/credentials/models/credential_status.dart';
import 'package:credible/app/pages/credentials/widget/document/item.dart';
import 'package:credible/app/shared/ui/ui.dart';
import 'package:credible/app/shared/widget/tooltip_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class DocumentHeaderWidgetModel {
  final String? title;
  final String? subtitle;
  final String status;

  const DocumentHeaderWidgetModel(this.title, this.subtitle, this.status);

  factory DocumentHeaderWidgetModel.fromCredentialModel(CredentialModel model) {
    late String status;

    switch (model.status) {
      case CredentialStatus.active:
        status = 'Active';
        break;
      case CredentialStatus.expired:
        status = 'Expired';
        break;
      case CredentialStatus.revoked:
        status = 'Revoked';
        break;
    }

    return DocumentHeaderWidgetModel(null, null, status);
  }
}

class DocumentHeader extends StatelessWidget {
  final DocumentHeaderWidgetModel model;

  const DocumentHeader({
    Key? key,
    required this.model,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    return Container(
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
if (model.title != null)
                TooltipText(
                  text: localizations.documentHeaderTooltipName,
                  style: Theme.of(context)
                      .textTheme
                      .subtitle1!
                      .apply(color: UiKit.palette.credentialText),
                ),
                const SizedBox(height: 4.0),
if (model.subtitle != null)
                TooltipText(
                  text: localizations.documentHeaderTooltipJob,
                  style: Theme.of(context).textTheme.bodyText1!.apply(
                      color: UiKit.palette.credentialText.withOpacity(0.6)),
                ),
              ],
            ),
          ),
          DocumentItemWidget(
            label: localizations.documentHeaderTooltipLabel,
            value: localizations.documentHeaderTooltipValue,
          ),
        ],
      ),
    );
  }
}

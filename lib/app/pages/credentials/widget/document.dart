import 'package:credible/app/pages/credentials/models/credential.dart';
import 'package:credible/app/pages/credentials/models/credential_status.dart';
import 'package:credible/app/pages/credentials/widget/document/item.dart';
import 'package:credible/app/shared/ui/ui.dart';
import 'package:credible/app/shared/widget/base/box_decoration.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DocumentWidgetModel {
  final String issuedBy;
  final String status;

  const DocumentWidgetModel(this.issuedBy, this.status);

  factory DocumentWidgetModel.fromCredentialModel(CredentialModel model) {
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

    return DocumentWidgetModel(model.issuer, status);
  }
}

class DocumentWidget extends StatelessWidget {
  final DocumentWidgetModel model;
  final Widget? trailing;

  const DocumentWidget({
    Key? key,
    required this.model,
    this.trailing,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => Container(
        decoration: BaseBoxDecoration(
          color: UiKit.palette.credentialBackground,
          shapeColor: UiKit.palette.credentialDetail.withOpacity(0.2),
          value: 0.0,
          shapeSize: 256.0,
          anchors: <Alignment>[
            Alignment.topRight,
            Alignment.bottomCenter,
          ],
          // value: animation.value,
          borderRadius: BorderRadius.circular(20.0),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              DocumentItemWidget(
                label: 'Issued by:',
                value: model.issuedBy,
              ),
              const SizedBox(height: 24.0),
              DocumentItemWidget(label: 'Status:', value: model.status),
              // DocumentHeader(
              //     model: DocumentHeaderWidgetModel.fromCredentialModel(item)),

              // // const DocumentTicketSeparator(),
              // DocumentBody(
              //   model: DocumentBodyWidgetModel.fromCredentialModel(item),
              //   trailing: trailing,
              // ),
            ],
          ),
        ),
      );
}

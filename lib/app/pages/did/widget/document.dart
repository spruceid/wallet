import 'package:credible/app/pages/did/models/did.dart';
import 'package:credible/app/pages/did/widget/item.dart';
import 'package:credible/app/shared/ui/ui.dart';
import 'package:credible/app/shared/widget/base/box_decoration.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DIDDocumentWidgetModel {
  final String did;
  final String endpoint;
  final int? level;
  final String? alias;

  const DIDDocumentWidgetModel(this.did, this.endpoint, this.level, this.alias);

  factory DIDDocumentWidgetModel.fromDIDModel(DIDModel model) {
    // late String status;
    // switch (model.status) {
    //   case CredentialStatus.active:
    //     status = 'Active';
    //     break;
    //   case CredentialStatus.expired:
    //     status = 'Expired';
    //     break;
    //   case CredentialStatus.revoked:
    //     status = 'Revoked';
    //     break;
    // }

    return DIDDocumentWidgetModel(
        model.did, model.endpoint, model.level, model.alias);
  }
}

// TODO: design distinct presentation of a DID relative to credential
class DIDDocumentWidget extends StatelessWidget {
  final DIDDocumentWidgetModel model;
  final Widget? trailing;

  const DIDDocumentWidget({
    Key? key,
    required this.model,
    this.trailing,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => Container(
        decoration: BaseBoxDecoration(
          // TODO: update with different palette for DIDs
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
                label: 'DID:',
                value: model.did,
              ),
              const SizedBox(height: 12.0),
              if (model.level != null)
                DocumentItemWidget(
                    label: 'Alias:', value: model.alias.toString())
              else
                DocumentItemWidget(label: 'Level:', value: 'No alias present'),
              const SizedBox(height: 12.0),
              DocumentItemWidget(label: 'Endpoint:', value: model.endpoint),
              const SizedBox(height: 12.0),
              if (model.level != null)
                DocumentItemWidget(
                    label: 'Level:', value: model.level.toString())
              else
                DocumentItemWidget(label: 'Level:', value: 'No level present'),
            ],
          ),
        ),
      );
}

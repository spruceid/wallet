import 'package:credible/app/pages/credentials/models/credential.dart';
import 'package:credible/app/pages/credentials/widget/document/body.dart';
import 'package:credible/app/pages/credentials/widget/document/header.dart';
import 'package:credible/app/shared/ui/ui.dart';
import 'package:credible/app/shared/widget/base/box_decoration.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DocumentWidget extends StatelessWidget {
  final CredentialModel item;
  final Widget? trailing;

  const DocumentWidget({
    Key? key,
    required this.item,
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
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 24.0),
            DocumentHeader(item: item),
            const SizedBox(height: 48.0),
            // const DocumentTicketSeparator(),
            DocumentBody(
              item: item,
              trailing: trailing,
            ),
            const SizedBox(height: 48.0),
          ],
        ),
      );
}

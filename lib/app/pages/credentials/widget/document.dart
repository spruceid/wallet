import 'package:credible/app/pages/credentials/models/credential.dart';
import 'package:credible/app/pages/credentials/widget/document_item.dart';
import 'package:credible/app/shared/palette.dart';
import 'package:credible/app/shared/widget/base/box_decoration.dart';
import 'package:credible/app/shared/widget/tooltip_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DocumentHeader extends StatelessWidget {
  final GlobalKey<ScaffoldState> scaffoldKey;
  final CredentialModel item;

  const DocumentHeader({
    Key key,
    @required this.scaffoldKey,
    @required this.item,
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
                    text: 'Richard Hooper, MD',
                    style: Theme.of(context)
                        .textTheme
                        .subtitle1
                        .apply(color: Palette.lightGrey),
                  ),
                  const SizedBox(height: 4.0),
                  TooltipText(
                    text: 'Internal Medicine',
                    style: Theme.of(context)
                        .textTheme
                        .bodyText1
                        .apply(color: Palette.lightGrey.withOpacity(0.6)),
                  ),
                ],
              ),
            ),
            DocumentItemWidget(
              scaffoldKey: scaffoldKey,
              label: 'Status:',
              value: 'Valid',
            ),
          ],
        ),
      );
}

class DocumentBody extends StatelessWidget {
  final GlobalKey<ScaffoldState> scaffoldKey;
  final CredentialModel item;
  final Widget trailing;

  const DocumentBody({
    Key key,
    @required this.scaffoldKey,
    @required this.item,
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
                    scaffoldKey: scaffoldKey,
                    label: 'NPI:',
                    value: '4876hTG97',
                  ),
                ),
                const SizedBox(width: 8.0),
                Expanded(
                  child: DocumentItemWidget(
                    scaffoldKey: scaffoldKey,
                    label: 'Issued by:',
                    value: item.issuer,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20.0),
            DocumentItemWidget(
              scaffoldKey: scaffoldKey,
              label: 'E-mail:',
              value: 'richard@doximity.com',
            ),
            const SizedBox(height: 20.0),
            DocumentItemWidget(
              scaffoldKey: scaffoldKey,
              label: 'Issued at:',
              value: 'San Francisco, CA',
            ),
            const SizedBox(height: 20.0),
            if (trailing != null) trailing,
          ],
        ),
  );
}

class DocumentTicketSeparator extends StatelessWidget {
  const DocumentTicketSeparator();

  @override
  Widget build(BuildContext context) =>
      SizedBox(
        height: 48.0,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Transform.translate(
              offset: Offset(-8.0, 0.0),
              child: Container(
                width: 16.0,
                height: 16.0,
                decoration: BoxDecoration(
                  color: Palette.background,
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(16.0),
                    bottomRight: Radius.circular(16.0),
                  ),
                ),
              ),
            ),
            Transform.translate(
              offset: Offset(8.0, 0.0),
              child: Container(
                width: 16.0,
                height: 16.0,
                decoration: BoxDecoration(
                  color: Palette.background,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(16.0),
                    bottomLeft: Radius.circular(16.0),
                  ),
                ),
              ),
            ),
          ],
        ),
      );
}

class DocumentWidget extends StatelessWidget {
  final GlobalKey<ScaffoldState> scaffoldKey;
  final CredentialModel item;
  final Widget trailing;

  const DocumentWidget({
    Key key,
    @required this.scaffoldKey,
    @required this.item,
    this.trailing,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) =>
      Container(
        decoration: BaseBoxDecoration(
          color: Palette.darkGreen,
          shapeColor: Palette.gradientLightGreen.withOpacity(0.2),
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
            DocumentHeader(
              scaffoldKey: scaffoldKey,
              item: item,
            ),
            const DocumentTicketSeparator(),
            DocumentBody(
              scaffoldKey: scaffoldKey,
              item: item,
              trailing: trailing,
            ),
            const SizedBox(height: 48.0),
          ],
        ),
      );
}

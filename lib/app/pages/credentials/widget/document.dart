import 'package:credible/app/pages/credentials/models/credential.dart';
import 'package:credible/app/pages/credentials/widget/document_item.dart';
import 'package:credible/app/shared/palette.dart';
import 'package:credible/app/shared/widget/tooltip_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DocumentHeader extends StatelessWidget {
  final CredentialModel item;

  const DocumentHeader({
    Key key,
    @required this.item,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => Container(
        margin: const EdgeInsets.symmetric(horizontal: 16.0),
        padding: const EdgeInsets.symmetric(vertical: 20.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(24.0),
            topRight: Radius.circular(24.0),
          ),
          boxShadow: <BoxShadow>[
            BoxShadow(
              offset: Offset(0.0, 2.0),
              blurRadius: 2.0,
              color: Palette.shadow,
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 24.0,
            vertical: 8.0,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Container(
                width: MediaQuery.of(context).size.width * 0.2,
                height: MediaQuery.of(context).size.width * 0.2,
                decoration: BoxDecoration(
                  color: Colors.pinkAccent,
                  borderRadius: BorderRadius.circular(16.0),
                ),
              ),
              const SizedBox(height: 16.0),
              TooltipText(
                text: 'Richard Hooper, MD',
                style: Theme.of(context)
                    .textTheme
                    .subtitle1
                    .apply(color: Colors.black),
              ),
              const SizedBox(height: 4.0),
              TooltipText(
                text: 'Internal Medicine',
                style: Theme.of(context)
                    .textTheme
                    .bodyText1
                    .apply(color: Colors.black),
              ),
            ],
          ),
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
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(24.0),
            bottomRight: Radius.circular(24.0),
          ),
          boxShadow: <BoxShadow>[
            BoxShadow(
              offset: Offset(0.0, 2.0),
              blurRadius: 2.0,
              color: Palette.shadow,
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            DocumentItemWidget(
              scaffoldKey: scaffoldKey,
              label: 'NPI:',
              value: '4876hTG97',
            ),
            const SizedBox(height: 8.0),
            DocumentItemWidget(
              scaffoldKey: scaffoldKey,
              label: 'E-MAIL:',
              value: 'richard@doximity.com',
            ),
            const SizedBox(height: 8.0),
            DocumentItemWidget(
              scaffoldKey: scaffoldKey,
              label: 'ISSUED BY:',
              value: item.issuer,
            ),
            const SizedBox(height: 8.0),
            DocumentItemWidget(
              scaffoldKey: scaffoldKey,
              label: 'ISSUED AT:',
              value: 'San Francisco, CA',
            ),
            const SizedBox(height: 8.0),
            Row(
              children: <Widget>[
                Expanded(
                  child: DocumentItemWidget(
                    scaffoldKey: scaffoldKey,
                    label: 'EXPIRATION:',
                    value: '10/2021',
                  ),
                ),
                Expanded(
                  child: DocumentItemWidget(
                    scaffoldKey: scaffoldKey,
                    label: 'STATUS:',
                    value: 'VALID',
                  ),
                ),
              ],
            ),
            if (trailing != null) trailing,
            const SizedBox(height: 24.0),
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
  Widget build(BuildContext context) => Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          DocumentHeader(item: item),
          DocumentBody(
            scaffoldKey: scaffoldKey,
            item: item,
            trailing: trailing,
          ),
        ],
      );
}

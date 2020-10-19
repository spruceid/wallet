import 'package:credible/app/pages/credentials/models/credential.dart';
import 'package:credible/app/pages/credentials/widget/document.dart';
import 'package:credible/app/shared/palette.dart';
import 'package:credible/app/shared/widget/app_bar.dart';
import 'package:credible/app/shared/widget/hero_workaround.dart';
import 'package:credible/app/shared/widget/navigation_bar.dart';
import 'package:credible/app/shared/widget/tooltip_text.dart';
import 'package:credible/localizations.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class CredentialsDetail extends StatefulWidget {
  final CredentialModel item;

  const CredentialsDetail({
    Key key,
    @required this.item,
  }) : super(key: key);

  @override
  _CredentialsDetailState createState() => _CredentialsDetailState();
}

class _CredentialsDetailState extends State<CredentialsDetail> {
  bool showShareMenu = false;

  @override
  Widget build(BuildContext context) {
    // TODO: Add proper localization
    final localizations = AppLocalizations.of(context);
    final scaffoldKey = GlobalKey<ScaffoldState>();

    return SafeArea(
      child: Scaffold(
        key: scaffoldKey,
        appBar: CustomAppBar(
          tag: 'credential/${widget.item.id}/issuer',
          title: widget.item.issuer,
          leading: IconButton(
            onPressed: () {
              Modular.to.pop();
            },
            icon: Icon(
              Icons.arrow_back,
              color: Palette.text,
            ),
          ),
        ),
        bottomNavigationBar: CustomNavBar(index: 0),
        body: SingleChildScrollView(
          padding: EdgeInsets.zero,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Container(
                color: Palette.text,
                padding: const EdgeInsets.all(32.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    HeroFix(
                      tag: 'credential/${widget.item.id}/icon',
                      child: Icon(
                        Icons.domain,
                        size: 24.0,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 8.0),
                    TooltipText(
                      tag: 'credential/${widget.item.id}/id',
                      text: widget.item.id,
                      textAlign: TextAlign.center,
                      style: Theme.of(context)
                          .textTheme
                          .bodyText1
                          .apply(color: Colors.white),
                    ),
                    const SizedBox(height: 64.0),
                  ],
                ),
              ),
              Transform.translate(
                offset: Offset(0.0, -64.0),
                child: DocumentWidget(
                  scaffoldKey: scaffoldKey,
                  item: widget.item,
                  trailing: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const SizedBox(height: 24.0),
                      Material(
                        color: Colors.transparent,
                        child: Tooltip(
                          message: localizations.credentialDetailShare,
                          child: InkWell(
                            onTap: () {
                              Modular.to.pushNamed(
                                '/qr-code/display',
                                arguments: 'schema://domain.tld/receive',
                              );
                            },
                            child: Container(
                              alignment: Alignment.center,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16.0,
                                vertical: 16.0,
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  FaIcon(
                                    FontAwesomeIcons.qrcode,
                                    size: 24.0,
                                    color: Palette.text,
                                  ),
                                  const SizedBox(width: 16.0),
                                  Text(
                                    localizations.credentialDetailShare,
                                    style:
                                        Theme.of(context).textTheme.bodyText1,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              FlatButton(
                padding: const EdgeInsets.symmetric(
                  horizontal: 32.0,
                  vertical: 16.0,
                ),
                onPressed: () {},
                child: Text(localizations.credentialDetailDelete),
              ),
              const SizedBox(height: 32.0),
            ],
          ),
        ),
      ),
    );
  }
}

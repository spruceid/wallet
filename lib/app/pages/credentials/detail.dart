import 'package:credible/app/pages/credentials/models/credential.dart';
import 'package:credible/app/pages/credentials/widget/labeled_value.dart';
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
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 16.0),
                  padding: const EdgeInsets.symmetric(vertical: 20.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24.0),
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
                      Padding(
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
                      const SizedBox(height: 16.0),
                      DetailLabeledValue(
                        scaffoldKey: scaffoldKey,
                        label: 'NPI:',
                        value: '4876hTG97',
                      ),
                      const SizedBox(height: 8.0),
                      DetailLabeledValue(
                        scaffoldKey: scaffoldKey,
                        label: 'E-MAIL:',
                        value: 'richard@doximity.com',
                      ),
                      const SizedBox(height: 8.0),
                      DetailLabeledValue(
                        scaffoldKey: scaffoldKey,
                        label: 'ISSUED BY:',
                        value: widget.item.issuer,
                      ),
                      const SizedBox(height: 8.0),
                      DetailLabeledValue(
                        scaffoldKey: scaffoldKey,
                        label: 'ISSUED AT:',
                        value: 'San Francisco, CA',
                      ),
                      const SizedBox(height: 8.0),
                      Row(
                        children: <Widget>[
                          Expanded(
                            child: DetailLabeledValue(
                              scaffoldKey: scaffoldKey,
                              label: 'EXPIRATION:',
                              value: '10/2021',
                            ),
                          ),
                          Expanded(
                            child: DetailLabeledValue(
                              scaffoldKey: scaffoldKey,
                              label: 'STATUS:',
                              value: 'VALID',
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24.0),
                      Material(
                        color: Colors.transparent,
                        child: Tooltip(
                          message: 'Share by QR code',
                          child: InkWell(
                            onTap: () {
                              Modular.to.pushNamed(
                                "/qr-code",
                                arguments: widget.item.id,
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
                                    'Share by QR code',
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
                child: Text('Delete credential'),
              ),
              const SizedBox(height: 32.0),
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:credible/app/pages/credentials/models/credential.dart';
import 'package:credible/app/pages/credentials/widget/document.dart';
import 'package:credible/app/shared/palette.dart';
import 'package:credible/app/shared/widget/button.dart';
import 'package:credible/app/shared/widget/hero_workaround.dart';
import 'package:credible/app/shared/widget/navigation_bar.dart';
import 'package:credible/app/shared/widget/tooltip_text.dart';
import 'package:credible/localizations.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

class CredentialsPresentPage extends StatefulWidget {
  final CredentialModel item;

  const CredentialsPresentPage({
    Key key,
    @required this.item,
  }) : super(key: key);

  @override
  _CredentialsPresentPageState createState() => _CredentialsPresentPageState();
}

class _CredentialsPresentPageState extends State<CredentialsPresentPage> {
  @override
  Widget build(BuildContext context) {
    // TODO: Add proper localization
    final localizations = AppLocalizations.of(context);
    final scaffoldKey = GlobalKey<ScaffoldState>();

    return SafeArea(
      child: Scaffold(
        key: scaffoldKey,
        bottomNavigationBar: CustomNavBar(index: 0),
        body: SingleChildScrollView(
          padding: EdgeInsets.zero,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: <Color>[
                      Palette.gradientDarkPurple,
                      Palette.darkPurple,
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    const SizedBox(height: 72.0),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 32.0,
                      ),
                      child: HeroFix(
                        tag: 'credential/${widget.item.id}/icon',
                        child: Icon(
                          Icons.domain,
                          size: 48.0,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16.0),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 32.0,
                      ),
                      child: TooltipText(
                        text:
                            'NYC Health is asking  for your Medical credential from Doximity.',
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        style: Theme.of(context)
                            .textTheme
                            .bodyText1
                            .apply(color: Colors.white),
                      ),
                    ),
                    const SizedBox(height: 32.0),
                    DocumentHeader(item: widget.item),
                  ],
                ),
              ),
              DocumentBody(
                scaffoldKey: scaffoldKey,
                item: widget.item,
              ),
              const SizedBox(height: 24.0),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16.0,
                ),
                child: Text(
                  'Ready to share your credentials?',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyText1,
                ),
              ),
              const SizedBox(height: 24.0),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16.0,
                ),
                child: CustomButton(
                  borderColor: Palette.navyBlue,
                  onPressed: () {
                    // TODO: code flow to confirm presentation
                    Modular.to.pop();
                  },
                  child: Text(
                    localizations.credentialPresentConfirm,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.button,
                  ),
                ),
              ),
              const SizedBox(height: 8.0),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16.0,
                ),
                child: CustomButton(
                  color: Palette.navyBlue,
                  onPressed: () {
                    Modular.to.pop();
                  },
                  child: Text(
                    localizations.credentialPresentCancel,
                    textAlign: TextAlign.center,
                    style: Theme.of(context)
                        .textTheme
                        .button
                        .apply(color: Colors.white),
                  ),
                ),
              ),
              const SizedBox(height: 16.0),
            ],
          ),
        ),
      ),
    );
  }
}

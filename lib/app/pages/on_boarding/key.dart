import 'package:credible/app/shared/widget/base/button.dart';
import 'package:credible/app/shared/widget/base/page.dart';
import 'package:credible/app/shared/widget/info_dialog.dart';
import 'package:credible/localizations.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

class OnBoardingKeyPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    return BasePage(
      title: localizations.onBoardingKeyTitle,
      scrollView: false,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 48.0,
            ),
            child: Text(
              'Choose how you want to add your key',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.subtitle1,
            ),
          ),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 48.0,
                  ),
                  child: Text(
                    'If you have previously used a wallet and have a recovery phrase, press "Recover"',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyText1,
                  ),
                ),
                const SizedBox(height: 32.0),
                BaseButton.blue(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) => InfoDialog(
                        title: 'Unavailable Feature',
                        subtitle: "This feature isn't supported yet",
                      ),
                    );
                  },
                  child: Text(localizations.onBoardingKeyRecover),
                ),
              ],
            ),
          ),
          const SizedBox(height: 64.0),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 48.0,
                  ),
                  child: Text(
                    'Otherwise you can generate your first identifier by pressing "Generate"',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyText1,
                  ),
                ),
                const SizedBox(height: 32.0),
                BaseButton.blue(
                  onPressed: () {
                    Modular.to.pushNamed('/on-boarding/gen');
                  },
                  child: Text(localizations.onBoardingKeyGenerate),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:credible/app/shared/widget/base/button.dart';
import 'package:credible/app/shared/widget/base/page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Text(
                  localizations.keyRecoveryTitle,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.subtitle1,
                ),
                const SizedBox(height: 32.0),
                Text(
                  localizations.keyRecoveryText,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyText1,
                ),
                const SizedBox(height: 20.0),
                BaseButton.primary(
                  onPressed: () {
                    Modular.to.pushNamed('/on-boarding/recovery');
                  },
                  child: Text(localizations.onBoardingKeyRecover),
                ),
              ],
            ),
          ),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Text(
                  localizations.keyGenerateTitle,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.subtitle1,
                ),
                const SizedBox(height: 32.0),
                Text(
                  localizations.keyGenerateText,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyText1,
                ),
                const SizedBox(height: 20.0),
                BaseButton.primary(
                  onPressed: () {
                    Modular.to.pushNamed('/on-boarding/gen-phrase');
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

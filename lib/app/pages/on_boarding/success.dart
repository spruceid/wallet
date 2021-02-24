import 'package:credible/app/shared/widget/base/button.dart';
import 'package:credible/app/shared/widget/base/page.dart';
import 'package:credible/app/shared/widget/hero_workaround.dart';
import 'package:credible/localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_svg/flutter_svg.dart';

class OnBoardingSuccessPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    return BasePage(
      scrollView: false,
      body: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Flexible(flex: 1, child: Container()),
          HeroFix(
            tag: 'splash/icon',
            child: Container(
              width: MediaQuery.of(context).size.width * 0.2,
              height: MediaQuery.of(context).size.width * 0.2,
              child: SvgPicture.asset('assets/brand/logo-circular.svg'),
            ),
          ),
          const SizedBox(height: 32.0),
          Center(
            child: Text(
              localizations.onBoardingSuccessTitle,
              style: Theme.of(context).textTheme.subtitle1,
            ),
          ),
          Flexible(flex: 3, child: Container()),
          BaseButton.blue(
            onPressed: () {
              Modular.to.pushReplacementNamed('/credentials');
            },
            child: Text(localizations.onBoardingSuccessButton),
          ),
        ],
      ),
    );
  }
}

import 'package:credible/app/shared/widget/base/button.dart';
import 'package:credible/app/shared/widget/base/page.dart';
import 'package:credible/app/shared/widget/brand.dart';
import 'package:credible/localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

class OnBoardingStartPage extends StatelessWidget {
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
          Brand(),
          Flexible(flex: 3, child: Container()),
          BaseButton.primary(
            onPressed: () {
              Modular.to.pushReplacementNamed('/on-boarding/tos');
            },
            child: Text(localizations.onBoardingStartButton),
          ),
        ],
      ),
    );
  }
}

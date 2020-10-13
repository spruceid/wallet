import 'package:credible/app/shared/palette.dart';
import 'package:credible/app/shared/widget/brand.dart';
import 'package:credible/app/shared/widget/tooltip_text.dart';
import 'package:credible/localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

import 'file:///E:/999-spruceid/credible/lib/app/shared/widget/button.dart';

class OnBoardingStartPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);

    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 24.0,
            vertical: 32.0,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Flexible(flex: 1, child: Container()),
              Brand(),
              const SizedBox(height: 48.0),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32.0),
                child: TooltipText(
                  text: localizations.onBoardingStartSubtitle,
                  textAlign: TextAlign.center,
                  maxLines: 3,
                  style: Theme.of(context).textTheme.bodyText1,
                ),
              ),
              Flexible(flex: 3, child: Container()),
              CustomButton(
                borderColor: Palette.text,
                onPressed: () {
                  Modular.to.pushReplacementNamed('/on-boarding/tos');
                },
                child: Text(
                  localizations.onBoardingStartButton,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.button,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

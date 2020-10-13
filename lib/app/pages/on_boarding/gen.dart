import 'package:credible/app/shared/palette.dart';
import 'package:credible/app/shared/widget/button.dart';
import 'package:credible/localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

class OnBoardingGenPage extends StatelessWidget {
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
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Text(
                localizations.onBoardingGenTitle,
                style: Theme.of(context).textTheme.subtitle1,
              ),
              const SizedBox(height: 24.0),
              Expanded(
                child: Container(),
              ),
              const SizedBox(height: 48.0),
              CustomButton(
                borderColor: Palette.text,
                onPressed: () {
                  Modular.to.pushReplacementNamed('/on-boarding/success');
                },
                child: Text(
                  localizations.onBoardingGenButton,
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

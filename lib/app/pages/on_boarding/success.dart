import 'package:credible/app/shared/palette.dart';
import 'package:credible/app/shared/widget/button.dart';
import 'package:credible/localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

class OnBoardingSuccessPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);

    return SafeArea(
      child: Scaffold(
        backgroundColor: Palette.background,
        body: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 24.0,
            vertical: 32.0,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              const SizedBox(height: 24.0),
              Expanded(
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Icon(
                        Icons.check_circle,
                        color: Palette.primary,
                        size: MediaQuery.of(context).size.width * 0.33,
                      ),
                      const SizedBox(height: 16.0),
                      Text(
                        localizations.onBoardingSuccessTitle,
                        style: Theme.of(context).textTheme.subtitle1,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 48.0),
              CustomButton(
                borderColor: Palette.text,
                onPressed: () {
                  Modular.to.pushReplacementNamed('/credentials');
                },
                child: Text(
                  localizations.onBoardingSuccessButton,
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

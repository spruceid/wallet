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
        backgroundColor: Colors.white,
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
                      Container(
                        width: MediaQuery.of(context).size.width * 0.66,
                        height: MediaQuery.of(context).size.width * 0.66,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage('assets/image/success.png'),
                          ),
                        ),
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
                color: Palette.navyBlue,
                onPressed: () {
                  Modular.to.pushReplacementNamed('/credentials');
                },
                child: Text(
                  localizations.onBoardingSuccessButton,
                  textAlign: TextAlign.center,
                  style: Theme
                      .of(context)
                      .textTheme
                      .button
                      .apply(color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

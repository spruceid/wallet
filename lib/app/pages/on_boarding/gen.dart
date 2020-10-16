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
        backgroundColor: Colors.white,
        body: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 24.0,
            vertical: 32.0,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Expanded(
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.66,
                  height: MediaQuery.of(context).size.width * 0.66,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/image/gen.png'),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 48.0),
              CustomButton(
                color: Palette.navyBlue,
                onPressed: () {
                  Modular.to.pushReplacementNamed('/on-boarding/success');
                },
                child: Text(
                  localizations.onBoardingGenButton,
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

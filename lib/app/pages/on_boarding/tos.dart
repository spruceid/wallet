import 'package:credible/app/shared/palette.dart';
import 'package:credible/app/shared/widget/button.dart';
import 'package:credible/localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

class OnBoardingTosPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    final scrollController = ScrollController();

    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 32.0,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24.0,
                ),
                child: Text(
                  localizations.onBoardingTosTitle,
                  style: Theme.of(context).textTheme.subtitle1,
                ),
              ),
              const SizedBox(height: 24.0),
              Expanded(
                child: Scrollbar(
                  isAlwaysShown: true,
                  controller: scrollController,
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24.0,
                      vertical: 16.0,
                    ),
                    controller: scrollController,
                    child: SelectableText(
                      List.generate(
                        32,
                        (index) => localizations.onBoardingStartSubtitle,
                      ).join('\n'),
                      style: Theme.of(context).textTheme.bodyText2,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 32.0),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24.0,
                ),
                child: CustomButton(
                  borderColor: Palette.text,
                  onPressed: () {
                    Modular.to.pushReplacementNamed('/on-boarding/gen');
                  },
                  child: Text(
                    localizations.onBoardingTosButton,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.button,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

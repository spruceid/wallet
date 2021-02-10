import 'package:credible/app/shared/palette.dart';
import 'package:credible/app/shared/widget/base/illustration_page.dart';
import 'package:credible/localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

class OnBoardingSuccessPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    return BaseIllustrationPage(
      asset: 'assets/image/gen.svg',
      description: localizations.onBoardingSuccessTitle,
      action: localizations.onBoardingSuccessButton,
      backgroundColor: Palette.blue,
      onPressed: () {
        Modular.to.pushReplacementNamed('/credentials');
      },
    );
  }
}

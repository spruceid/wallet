import 'package:credible/app/shared/palette.dart';
import 'package:credible/app/shared/widget/base/illustration_page.dart';
import 'package:credible/localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

class OnBoardingGenPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);

    return BaseIllustrationPage(
      asset: 'assets/image/gen.svg',
      description: localizations.onBoardingGenTitle,
      action: localizations.onBoardingGenButton,
      backgroundColor: Palette.blue,
      onPressed: () {
        Modular.to.pushReplacementNamed('/on-boarding/success');
      },
    );
  }
}

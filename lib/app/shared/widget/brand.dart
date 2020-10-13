import 'package:credible/app/shared/palette.dart';
import 'package:credible/app/shared/widget/hero_workaround.dart';
import 'package:credible/app/shared/widget/tooltip_text.dart';
import 'package:credible/localizations.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Brand extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          HeroFix(
            tag: 'splash/icon',
            child: Container(
              width: MediaQuery.of(context).size.width * 0.2,
              height: MediaQuery.of(context).size.width * 0.2,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Palette.brand,
              ),
            ),
          ),
          const SizedBox(height: 16.0),
          HeroFix(
            tag: 'splash/title',
            child: TooltipText(
              text: AppLocalizations.of(context).appTitle,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      );
}

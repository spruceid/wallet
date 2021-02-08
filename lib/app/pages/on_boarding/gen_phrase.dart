import 'package:credible/app/pages/on_boarding/widget/word.dart';
import 'package:credible/app/shared/palette.dart';
import 'package:credible/app/shared/widget/base/button.dart';
import 'package:credible/app/shared/widget/base/page.dart';
import 'package:credible/localizations.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

class OnBoardingGenPhrasePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);

    return BasePage(
      title: localizations.onBoardingGenPhraseTitle,
      scrollView: false,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 48.0,
            ),
            child: Column(
              children: [
                Text(
                  'Write down these words in the right order and save them somewhere safe',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.subtitle2,
                ),
                const SizedBox(height: 8.0),
                Text(
                  'It is the only way to recover your key later if you lose access to this wallet',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyText1,
                ),
              ],
            ),
          ),
          const SizedBox(height: 32.0),
          Expanded(
            child: Wrap(
              spacing: 16.0,
              runSpacing: 8.0,
              alignment: WrapAlignment.center,
              runAlignment: WrapAlignment.center,
              children: <Widget>[
                const PhraseWord(order: 1, word: 'this'),
                const PhraseWord(order: 2, word: 'is'),
                const PhraseWord(order: 3, word: 'not'),
                const PhraseWord(order: 4, word: 'a'),
                const PhraseWord(order: 5, word: 'real'),
                const PhraseWord(order: 6, word: 'recovery'),
                const PhraseWord(order: 7, word: 'phrase'),
                const PhraseWord(order: 8, word: 'this'),
                const PhraseWord(order: 9, word: 'is'),
                const PhraseWord(order: 10, word: 'just'),
                const PhraseWord(order: 11, word: 'an'),
                const PhraseWord(order: 12, word: 'example'),
              ],
            ),
          ),
          const SizedBox(height: 32.0),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              children: <Widget>[
                Icon(
                  Icons.privacy_tip_outlined,
                  color: Palette.text.withOpacity(0.6),
                ),
                const SizedBox(width: 16.0),
                Expanded(
                  child: Text(
                    'You can view your recovery phrase again later in the settings menu',
                    style: Theme.of(context)
                        .textTheme
                        .caption
                        .apply(color: Palette.text.withOpacity(0.6)),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 48.0),
          BaseButton.blue(
            onPressed: () {
              Modular.to.pushReplacementNamed('/on-boarding/gen');
            },
            child: Text(localizations.onBoardingGenPhraseButton),
          ),
        ],
      ),
    );
  }
}

import 'package:bip39/bip39.dart' as bip39;
import 'package:credible/app/interop/secure_storage/secure_storage.dart';
import 'package:credible/app/pages/on_boarding/widget/word.dart';
import 'package:credible/app/shared/palette.dart';
import 'package:credible/app/shared/widget/back_leading_button.dart';
import 'package:credible/app/shared/widget/base/button.dart';
import 'package:credible/app/shared/widget/base/page.dart';
import 'package:credible/localizations.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

class OnBoardingGenPhrasePage extends StatefulWidget {
  @override
  _OnBoardingGenPhrasePageState createState() =>
      _OnBoardingGenPhrasePageState();
}

class _OnBoardingGenPhrasePageState extends State<OnBoardingGenPhrasePage> {
  late List<String> mnemonic;

  @override
  void initState() {
    super.initState();

    mnemonic = bip39.generateMnemonic().split(' ');
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    return BasePage(
      title: localizations.onBoardingGenPhraseTitle,
      titleLeading: BackLeadingButton(),
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
          Expanded(
            child: Wrap(
              spacing: 16.0,
              runSpacing: 8.0,
              alignment: WrapAlignment.center,
              runAlignment: WrapAlignment.center,
              children: List.generate(
                mnemonic.length,
                (i) => PhraseWord(order: i + 1, word: mnemonic[i]),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 24.0,
            ),
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
                        .caption!
                        .apply(color: Palette.text.withOpacity(0.6)),
                  ),
                ),
              ],
            ),
          ),
          BaseButton.blue(
            onPressed: () async {
              await SecureStorageProvider.instance.set(
                'mnemonic',
                mnemonic.join(' '),
              );

              await Modular.to.pushNamedAndRemoveUntil(
                '/on-boarding/gen',
                ModalRoute.withName('/on-boarding/key'),
              );
            },
            child: Text(localizations.onBoardingGenPhraseButton),
          ),
        ],
      ),
    );
  }
}

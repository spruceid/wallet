import 'package:bip39/bip39.dart' as bip39;
import 'package:credible/app/interop/secure_storage/secure_storage.dart';
import 'package:credible/app/shared/ui/ui.dart';
import 'package:credible/app/shared/widget/back_leading_button.dart';
import 'package:credible/app/shared/widget/base/button.dart';
import 'package:credible/app/shared/widget/base/page.dart';
import 'package:credible/app/shared/widget/mnemonic.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:logging/logging.dart';

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
    final log = Logger('credible/on-boarding/gen-phrase');

    return BasePage(
      title: localizations.onBoardingGenPhraseTitle,
      titleLeading: BackLeadingButton(),
      scrollView: true,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Column(
            children: [
              Text(
                localizations.genPhraseInstruction,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.subtitle2,
              ),
              const SizedBox(height: 8.0),
              Text(
                localizations.genPhraseExplanation,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyText1,
              ),
            ],
          ),
          const SizedBox(height: 32.0),
          MnemonicDisplay(mnemonic: mnemonic),
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 24.0,
            ),
            child: Row(
              children: <Widget>[
                Icon(
                  Icons.privacy_tip_outlined,
                  color: UiKit.palette.icon.withOpacity(0.6),
                ),
                const SizedBox(width: 16.0),
                Expanded(
                  child: Text(
                    localizations.genPhraseViewLatterText,
                    style: Theme.of(context).textTheme.caption!.apply(
                        color: UiKit.text.colorTextCaption.withOpacity(0.6)),
                  ),
                ),
              ],
            ),
          ),
          BaseButton.primary(
            onPressed: () async {
              try {
                log.info('will save mnemonic to secure storage');
                await SecureStorageProvider.instance.set(
                  'mnemonic',
                  mnemonic.join(' '),
                );
                log.info('mnemonic saved');

                await Modular.to.pushReplacementNamed('/on-boarding/gen');
              } catch (error) {
                log.severe(
                    'error ocurred setting mnemonic to secure storate', error);

                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  backgroundColor: Colors.red,
                  content: Text('Failed to save mnemonic, please try again'),
                ));
              }
            },
            child: Text(localizations.onBoardingGenPhraseButton),
          ),
        ],
      ),
    );
  }
}

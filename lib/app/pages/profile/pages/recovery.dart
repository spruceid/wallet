import 'package:credible/app/interop/secure_storage/secure_storage.dart';
import 'package:credible/app/shared/widget/back_leading_button.dart';
import 'package:credible/app/shared/widget/base/page.dart';
import 'package:credible/app/shared/widget/mnemonic.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class RecoveryPage extends StatefulWidget {
  @override
  _RecoveryPageState createState() => _RecoveryPageState();
}

class _RecoveryPageState extends State<RecoveryPage> {
  List<String>? _mnemonic;

  @override
  void initState() {
    super.initState();
    loadMnemonic();
  }

  Future<void> loadMnemonic() async {
    final phrase = (await SecureStorageProvider.instance.get('mnemonic'))!;
    setState(() {
      _mnemonic = phrase.split(' ');
    });
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    return BasePage(
      title: localizations.onBoardingGenPhraseTitle,
      titleLeading: BackLeadingButton(),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          const SizedBox(height: 16.0),
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
          const SizedBox(height: 48.0),
          if (_mnemonic != null && _mnemonic!.isNotEmpty)
            MnemonicDisplay(mnemonic: _mnemonic!),
        ],
      ),
    );
  }
}

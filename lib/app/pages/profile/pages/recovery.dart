import 'package:credible/app/pages/on_boarding/widget/word.dart';
import 'package:credible/app/shared/widget/back_leading_button.dart';
import 'package:credible/app/shared/widget/base/page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class RecoveryPage extends StatefulWidget {
  @override
  _RecoveryPageState createState() => _RecoveryPageState();
}

class _RecoveryPageState extends State<RecoveryPage> {
  late List<String> mnemonic;

  @override
  void initState() {
    super.initState();
    mnemonic = [];
    loadMnemonic();
  }

  Future<void> loadMnemonic() async {
    final storage = FlutterSecureStorage();
    final phrase = await storage.read(key: 'mnemonic');
    setState(() {
      mnemonic = phrase.split(' ');
    });
  }

  @override
  Widget build(BuildContext context) {
    return BasePage(
      title: 'Recovery Phrase',
      titleLeading: BackLeadingButton(),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          const SizedBox(height: 16.0),
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
          const SizedBox(height: 48.0),
          Wrap(
            spacing: 16.0,
            runSpacing: 8.0,
            alignment: WrapAlignment.center,
            runAlignment: WrapAlignment.center,
            children: List.generate(
              mnemonic.length,
              (i) => PhraseWord(order: i + 1, word: mnemonic[i]),
            ),
          ),
        ],
      ),
    );
  }
}

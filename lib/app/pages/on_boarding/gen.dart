import 'package:credible/app/shared/palette.dart';
import 'package:credible/app/shared/widget/base/page.dart';
import 'package:credible/localizations.dart';
import 'package:didkit/didkit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class OnBoardingGenPage extends StatefulWidget {
  @override
  _OnBoardingGenPageState createState() => _OnBoardingGenPageState();
}

class _OnBoardingGenPageState extends State<OnBoardingGenPage> {
  @override
  void initState() {
    super.initState();

    generateKey();
  }

  Future<void> generateKey() async {
    final storage = FlutterSecureStorage();
    // final mnemonic = await storage.read(key: 'mnemonic');
    // final entropy = bip39.mnemonicToSeedHex(mnemonic);
    // final key = await DIDKit.generateEd25519KeyFromSecret(entropy.substring(0, 32));

    // final mnemonic = await storage.read(key: 'mnemonic');
    // final entropy = bip39.mnemonicToSeedHex(mnemonic);
    // final key = await DIDKit.generateEd25519KeyFromSecret(entropy.substring(0, 32));

    final key = await DIDKit.generateEd25519Key();

    await storage.write(key: 'key', value: key);
    await Modular.to.pushReplacementNamed('/on-boarding/success');
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    return BasePage(
      title: localizations.onBoardingGenTitle,
      body: Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.all(16.0),
        child: CircularProgressIndicator(),
      ),
      backgroundColor: Palette.background,
    );
  }
}

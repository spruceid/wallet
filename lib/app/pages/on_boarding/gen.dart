import 'package:credible/app/interop/didkit/didkit.dart';
import 'package:credible/app/interop/secure_storage/secure_storage.dart';
import 'package:credible/app/shared/palette.dart';
import 'package:credible/app/shared/widget/base/page.dart';
import 'package:credible/localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

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
    // final mnemonic = (await SecureStorageProvider.instance.get(key: 'mnemonic'))!;
    // final entropy = bip39.mnemonicToSeedHex(mnemonic);
    // final key = await DIDKitProvider.instance.generateEd25519KeyFromSecret(entropy.substring(0, 32));

    final key = await DIDKitProvider.instance.generateEd25519Key();

    await SecureStorageProvider.instance.set('key', key);
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

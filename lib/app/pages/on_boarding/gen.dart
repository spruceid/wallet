import 'dart:convert';
import 'dart:typed_data';

import 'package:bip39/bip39.dart' as bip39;
import 'package:credible/app/interop/secure_storage/secure_storage.dart';
import 'package:credible/app/shared/widget/base/page.dart';
import 'package:credible/app/shared/widget/spinner.dart';
import 'package:credible/localizations.dart';
import 'package:ed25519_hd_key/ed25519_hd_key.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:logging/logging.dart';

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
    final log = Logger('credible/on-boarding/key-generation');

    try {
      final mnemonic = (await SecureStorageProvider.instance.get('mnemonic'))!;
      final seed = bip39.mnemonicToSeed(mnemonic);

      final child = await ED25519_HD_KEY.derivePath("m/0'/0'", seed);
      final bytes = Uint8List.fromList(child.key);
      final public = await ED25519_HD_KEY.getPublicKey(bytes);

      final sk = base64Url.encode(bytes);
      final pk = base64Url.encode(public);
      final key = {
        'kty': 'OKP',
        'crv': 'Ed25519',
        'd': sk,
        'x': pk,
      };

      await SecureStorageProvider.instance.set('key', jsonEncode(key));
      await Modular.to.pushReplacementNamed('/on-boarding/success');
    } catch (error) {
      log.severe('something went wrong when generating a key', error);

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        backgroundColor: Colors.red,
        content: Text('Failed to generate key, please try again'),
      ));

      await Modular.to.pushReplacementNamed('/on-boarding/key');
    }
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    return BasePage(
      title: localizations.onBoardingGenTitle,
      body: Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.all(16.0),
        child: Spinner(),
      ),
    );
  }
}

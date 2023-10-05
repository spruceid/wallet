import 'package:credible/app/interop/secure_storage/secure_storage.dart';
import 'package:credible/app/shared/key_generation.dart';
import 'package:credible/app/shared/widget/base/page.dart';
import 'package:credible/app/shared/widget/spinner.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:credible/app/shared/logger/logger.dart';

class OnBoardingGenPage extends StatefulWidget {
  @override
  _OnBoardingGenPageState createState() => _OnBoardingGenPageState();
}

class _OnBoardingGenPageState extends State<OnBoardingGenPage> {
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      generateKey(context);
    });
  }

  Future<void> generateKey(BuildContext context) async {
    final localizations = AppLocalizations.of(context)!;
    try {
      final mnemonic = (await SecureStorageProvider.instance.get('mnemonic'))!;
      final key = await KeyGeneration.privateKey(mnemonic);

      await SecureStorageProvider.instance.set('key', key);
      await Modular.to.pushReplacementNamed('/on-boarding/success');
    } catch (error) {
      log.err(#keygen, 'something went wrong when generating a key: $error');

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        backgroundColor: Colors.red,
        content: Text(localizations.errorGeneratingKey),
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

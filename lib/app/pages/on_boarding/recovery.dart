import 'package:bip39/bip39.dart' as bip39;
import 'package:credible/app/interop/secure_storage/secure_storage.dart';
import 'package:credible/app/shared/widget/back_leading_button.dart';
import 'package:credible/app/shared/widget/base/button.dart';
import 'package:credible/app/shared/widget/base/page.dart';
import 'package:credible/app/shared/widget/base/text_field.dart';
import 'package:credible/localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

class OnBoardingRecoveryPage extends StatefulWidget {
  static const _padding = EdgeInsets.symmetric(
    horizontal: 16.0,
  );

  static Widget _padHorizontal(Widget child) => Padding(
        padding: _padding,
        child: child,
      );

  @override
  _OnBoardingRecoveryPageState createState() => _OnBoardingRecoveryPageState();
}

class _OnBoardingRecoveryPageState extends State<OnBoardingRecoveryPage> {
  late TextEditingController mnemonicController;
  late bool buttonEnabled;

  @override
  void initState() {
    super.initState();

    mnemonicController = TextEditingController();
    mnemonicController.addListener(() {
      setState(() {
        buttonEnabled = bip39.validateMnemonic(mnemonicController.text);
      });
    });

    buttonEnabled = false;
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    return BasePage(
      title: localizations.onBoardingRecoveryTitle,
      titleLeading: BackLeadingButton(),
      scrollView: false,
      padding: EdgeInsets.zero,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          const SizedBox(height: 32.0),
          OnBoardingRecoveryPage._padHorizontal(Text(
            'Write the recovery phrase in the given order',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.subtitle1,
          )),
          const SizedBox(height: 24.0),
          Expanded(
            child: Center(
              child: BaseTextField(
                label: 'Mnemonic Phrase',
                controller: mnemonicController,
                error: !buttonEnabled
                    ? 'Please enter a valid mnemonic phrase'
                    : null,
              ),
            ),
          ),
          const SizedBox(height: 24.0),
          OnBoardingRecoveryPage._padHorizontal(BaseButton.blue(
            onPressed: buttonEnabled
                ? () async {
                    await SecureStorageProvider.instance.set(
                      'mnemonic',
                      mnemonicController.text,
                    );

                    await Modular.to.pushNamedAndRemoveUntil(
                      '/on-boarding/gen',
                      ModalRoute.withName('/on-boarding/key'),
                    );
                  }
                : null,
            child: Text(localizations.onBoardingRecoveryButton),
          )),
          const SizedBox(height: 32.0),
        ],
      ),
    );
  }
}

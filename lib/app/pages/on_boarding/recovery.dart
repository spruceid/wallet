import 'package:credible/app/shared/widget/base/button.dart';
import 'package:credible/app/shared/widget/base/page.dart';
import 'package:credible/app/shared/widget/base/text_field.dart';
import 'package:credible/localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

class OnBoardingRecoveryPage extends StatelessWidget {
  static const _padding = EdgeInsets.symmetric(
    horizontal: 16.0,
  );

  static Widget _padHorizontal(Widget child) => Padding(
        padding: _padding,
        child: child,
      );

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    final scrollController = ScrollController();

    return BasePage(
      title: localizations.onBoardingRecoveryTitle,
      scrollView: false,
      padding: EdgeInsets.zero,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          const SizedBox(height: 32.0),
          _padHorizontal(Text(
            'Write the recovery phrase in the given order',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.subtitle1,
          )),
          const SizedBox(height: 24.0),
          Expanded(
            child: Scrollbar(
              isAlwaysShown: true,
              controller: scrollController,
              child: SingleChildScrollView(
                controller: scrollController,
                child: Column(
                  children: <Widget>[
                    const SizedBox(height: 16.0),
                    BaseTextField(
                      label: '1',
                      controller: TextEditingController(),
                    ),
                    const SizedBox(height: 8.0),
                    BaseTextField(
                      label: '2',
                      controller: TextEditingController(),
                    ),
                    const SizedBox(height: 8.0),
                    BaseTextField(
                      label: '3',
                      controller: TextEditingController(),
                    ),
                    const SizedBox(height: 8.0),
                    BaseTextField(
                      label: '4',
                      controller: TextEditingController(),
                    ),
                    const SizedBox(height: 8.0),
                    BaseTextField(
                      label: '5',
                      controller: TextEditingController(),
                    ),
                    const SizedBox(height: 8.0),
                    BaseTextField(
                      label: '6',
                      controller: TextEditingController(),
                    ),
                    const SizedBox(height: 8.0),
                    BaseTextField(
                      label: '7',
                      controller: TextEditingController(),
                    ),
                    const SizedBox(height: 8.0),
                    BaseTextField(
                      label: '8',
                      controller: TextEditingController(),
                    ),
                    const SizedBox(height: 8.0),
                    BaseTextField(
                      label: '9',
                      controller: TextEditingController(),
                    ),
                    const SizedBox(height: 8.0),
                    BaseTextField(
                      label: '10',
                      controller: TextEditingController(),
                    ),
                    const SizedBox(height: 8.0),
                    BaseTextField(
                      label: '11',
                      controller: TextEditingController(),
                    ),
                    const SizedBox(height: 8.0),
                    BaseTextField(
                      label: '12',
                      controller: TextEditingController(),
                    ),
                    const SizedBox(height: 16.0),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 24.0),
          _padHorizontal(BaseButton.blue(
            onPressed: () {
              Modular.to.pushReplacementNamed('/on-boarding/gen');
            },
            child: Text(localizations.onBoardingRecoveryButton),
          )),
          const SizedBox(height: 32.0),
        ],
      ),
    );
  }
}

import 'package:credible/app/shared/palette.dart';
import 'package:credible/app/shared/widget/base/button.dart';
import 'package:credible/app/shared/widget/base/page.dart';
import 'package:credible/localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

class OnBoardingTosPage extends StatelessWidget {
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
      title: localizations.onBoardingTosTitle,
      scrollView: false,
      padding: EdgeInsets.zero,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          const SizedBox(height: 8.0),
          _padHorizontal(Text(
            'Credible v0.1',
            textAlign: TextAlign.center,
            style: Theme.of(context)
                .textTheme
                .overline
                .apply(color: Palette.text.withOpacity(0.4)),
          )),
          const SizedBox(height: 8.0),
          Expanded(
            child: Scrollbar(
              isAlwaysShown: true,
              controller: scrollController,
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16.0,
                  vertical: 16.0,
                ),
                controller: scrollController,
                child: SelectableText(
                  List.generate(
                    32,
                    (index) => localizations.onBoardingStartSubtitle,
                  ).join('\n'),
                  style: Theme.of(context).textTheme.bodyText2,
                ),
              ),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: <BoxShadow>[
                BoxShadow(
                  color: Palette.shadow,
                  offset: Offset(-1.0, -1.0),
                  blurRadius: 4.0,
                ),
              ],
            ),
            padding: const EdgeInsets.symmetric(
              vertical: 12.0,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _padHorizontal(Text(
                  'By tapping accept  “I  agree to the terms and condition as well as the disclosure of this information',
                  style: Theme.of(context)
                      .textTheme
                      .bodyText2
                      .apply(fontSizeFactor: 0.85),
                )),
                const SizedBox(height: 20.0),
                _padHorizontal(BaseButton.blue(
                  onPressed: () {
                    Modular.to.pushReplacementNamed('/on-boarding/key');
                  },
                  child: Text(localizations.onBoardingTosButton),
                )),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

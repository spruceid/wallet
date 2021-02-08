import 'package:credible/app/shared/widget/back_leading_button.dart';
import 'package:credible/app/shared/widget/base/page.dart';
import 'package:credible/localizations.dart';
import 'package:flutter/material.dart';

class SupportPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);

    return BasePage(
      title: 'Support',
      titleLeading: BackLeadingButton(),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Center(
            child: Text('Here we should add links to Github Issues, IRC, etc.'),
          ),
        ],
      ),
    );
  }
}

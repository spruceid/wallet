import 'package:credible/app/shared/palette.dart';
import 'package:credible/app/shared/widget/back_leading_button.dart';
import 'package:credible/app/shared/widget/base/page.dart';
import 'package:credible/localizations.dart';
import 'package:flutter/material.dart';

class NoticesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);

    return BasePage(
      backgroundColor: Palette.background,
      title: 'Notices',
      titleLeading: BackLeadingButton(),
      padding: const EdgeInsets.symmetric(
        vertical: 24.0,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Center(
            child: Text('Here we should add OSS notices and licenses.'),
          ),
        ],
      ),
    );
  }
}

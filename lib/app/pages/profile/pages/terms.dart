import 'package:credible/app/shared/widget/base/markdown_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class TermsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    return MarkdownPage(
        title: localizations.onBoardingTosTitle,
        file: 'assets/terms_conditions.md');
  }
}

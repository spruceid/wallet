import 'package:credible/app/shared/widget/base/markdown_page.dart';
import 'package:flutter/material.dart';

class TermsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MarkdownPage(
        title: 'Terms & Conditions', file: 'assets/terms_conditions.md');
  }
}

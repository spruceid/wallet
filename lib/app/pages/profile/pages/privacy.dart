import 'package:credible/app/shared/widget/base/markdown_page.dart';
import 'package:flutter/material.dart';

class PrivacyPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MarkdownPage(title: 'Privacy & Security', file: 'assets/privacy.md');
  }
}

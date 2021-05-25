import 'package:credible/app/shared/widget/base/markdown_page.dart';
import 'package:flutter/material.dart';

class NoticesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MarkdownPage(title: 'Notices', file: 'assets/notices.md');
  }
}

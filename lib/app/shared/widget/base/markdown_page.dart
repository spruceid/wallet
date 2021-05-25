import 'package:credible/app/shared/widget/back_leading_button.dart';
import 'package:credible/app/shared/widget/base/page.dart';
import 'package:credible/app/shared/widget/spinner.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:url_launcher/url_launcher.dart';

class MarkdownPage extends StatelessWidget {
  final String title;
  final String file;

  const MarkdownPage({Key? key, required this.title, required this.file})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BasePage(
      title: title,
      titleLeading: BackLeadingButton(),
      scrollView: false,
      padding: const EdgeInsets.all(0.0),
      body: FutureBuilder<String>(
          future: _loadFile(),
          builder: (context, snapshot) {
            if (snapshot.data != null) {
              return Markdown(
                data: snapshot.data!,
                onTapLink: (text, href, title) => _onTapLink(href),
              );
            }

            if (snapshot.error != null) {
              return Text('oops');
            }

            return Spinner();
          }),
    );
  }

  Future<String> _loadFile() async {
    return await rootBundle.loadString(file);
  }

  void _onTapLink(String? href) async {
    if (href == null) return;

    if (await canLaunch(href)) {
      await launch(href);
    }
  }
}

import 'package:credible/app/shared/palette.dart';
import 'package:credible/app/shared/widget/app_bar.dart';
import 'package:flutter/material.dart';

class BasePage extends StatelessWidget {
  final String title;

  final Widget body;
  final bool scrollView;

  final EdgeInsets padding;
  final Color backgroundColor;

  final String titleTag;
  final Widget titleLeading;
  final Widget titleTrailing;

  final Widget navigation;

  const BasePage({
    Key key,
    this.backgroundColor = Palette.lightGrey,
    this.title,
    this.titleTag,
    this.titleLeading,
    this.titleTrailing,
    this.padding = const EdgeInsets.symmetric(
      horizontal: 24.0,
      vertical: 32.0,
    ),
    this.scrollView = true,
    this.navigation,
    this.body,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: backgroundColor,
        appBar: title != null && title.isNotEmpty
            ? CustomAppBar(
                title: title,
                tag: titleTag,
                leading: titleLeading,
                trailing: titleTrailing,
              )
            : null,
        bottomNavigationBar: navigation,
        body: scrollView
            ? SingleChildScrollView(
                padding: padding,
                child: body,
              )
            : Padding(
                padding: padding,
                child: body,
              ),
      ),
    );
  }
}

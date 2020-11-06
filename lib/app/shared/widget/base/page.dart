import 'package:credible/app/shared/palette.dart';
import 'package:credible/app/shared/widget/app_bar.dart';
import 'package:flutter/material.dart';

class BasePage extends StatelessWidget {
  final String title;

  final Widget body;
  final bool scrollView;

  final EdgeInsets padding;
  final Color backgroundColor;

  final GlobalKey<ScaffoldState> scaffoldKey;

  final Widget leadingTitle;
  final Widget trailingTitle;

  const BasePage({
    Key key,
    this.title,
    this.body,
    this.scrollView = true,
    this.padding = const EdgeInsets.symmetric(
      horizontal: 24.0,
      vertical: 32.0,
    ),
    this.backgroundColor = Palette.lightGrey,
    this.scaffoldKey,
    this.leadingTitle,
    this.trailingTitle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: backgroundColor,
        appBar: title != null && title.isNotEmpty
            ? CustomAppBar(
                title: title,
                leading: leadingTitle,
                trailing: trailingTitle,
              )
            : null,
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

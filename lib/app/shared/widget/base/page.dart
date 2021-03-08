import 'package:credible/app/shared/ui/ui.dart';
import 'package:credible/app/shared/widget/app_bar.dart';
import 'package:flutter/material.dart';

class BasePage extends StatelessWidget {
  final String? title;

  final Widget body;
  final bool scrollView;

  final EdgeInsets padding;
  final Color? backgroundColor;
  final Gradient? backgroundGradient;

  final String? titleTag;
  final Widget? titleLeading;
  final Widget? titleTrailing;

  final Widget? navigation;

  final bool? extendBelow;

  const BasePage({
    Key? key,
    this.backgroundColor,
    this.backgroundGradient,
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
    this.extendBelow,
    required this.body,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final backgroundGradient = this.backgroundGradient != null
        ? this.backgroundGradient!
        : backgroundColor != null
            ? LinearGradient(colors: [backgroundColor!])
            : UiKit.palette.pageBackground;

    return SafeArea(
      child: Container(
        decoration: BoxDecoration(
          gradient: backgroundGradient,
        ),
        child: Scaffold(
          extendBody: extendBelow ?? false,
          backgroundColor: Colors.transparent,
          appBar: title != null && title!.isNotEmpty
              ? CustomAppBar(
                  title: title!,
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
      ),
    );
  }
}

import 'package:credible/app/shared/palette.dart';
import 'package:credible/app/shared/widget/tooltip_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomAppBar extends PreferredSize {
  final String? tag;
  final String title;
  final Widget? leading;
  final Widget? trailing;

  CustomAppBar({
    this.tag,
    required this.title,
    this.leading,
    this.trailing,
  }) : super(
          child: Container(),
          preferredSize: Size.fromHeight(80.0),
        );

  @override
  Widget build(BuildContext context) => Stack(
        children: <Widget>[
          Container(
            alignment: Alignment.bottomCenter,
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: <BoxShadow>[
                BoxShadow(
                  color: Palette.shadow,
                  offset: Offset(0.0, 2.0),
                  blurRadius: 2.0,
                ),
              ],
            ),
            padding: const EdgeInsets.only(
              top: 12.0,
              bottom: 16.0,
              left: 8.0,
              right: 8.0,
            ),
            child: TooltipText(
              tag: tag,
              text: title,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.subtitle1,
            ),
          ),
          Material(
            color: Colors.transparent,
            child: Container(
              alignment: Alignment.bottomCenter,
              padding: const EdgeInsets.only(
                top: 12.0,
                bottom: 8.0,
                left: 8.0,
                right: 8.0,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  leading ?? Container(width: 16.0, height: 16.0),
                  trailing ?? Container(width: 16.0, height: 16.0),
                ],
              ),
            ),
          ),
        ],
      );
}

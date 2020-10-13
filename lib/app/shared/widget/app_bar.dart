import 'package:credible/app/shared/widget/tooltip_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomAppBar extends PreferredSize {
  final String tag;
  final String title;
  final Widget leading;
  final Widget trailing;

  CustomAppBar({
    this.tag,
    @required this.title,
    this.leading,
    this.trailing,
  }) : super(
          child: null,
          preferredSize: Size.fromHeight(96.0),
        );

  @override
  Widget build(BuildContext context) => Stack(
        children: <Widget>[
          Container(
            alignment: Alignment.bottomCenter,
            color: Colors.white,
            padding: const EdgeInsets.only(
              top: 16.0,
              bottom: 24.0,
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
          Container(
            alignment: Alignment.bottomCenter,
            padding: const EdgeInsets.only(
              top: 16.0,
              bottom: 12.0,
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
        ],
      );
}

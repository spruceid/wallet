import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TooltipText extends StatelessWidget {
  final String tag;
  final String text;
  final String tooltip;

  final int maxLines;
  final TextStyle style;
  final TextAlign textAlign;

  const TooltipText({
    Key key,
    this.tag,
    this.text,
    this.tooltip,
    this.maxLines = 1,
    this.style,
    this.textAlign = TextAlign.start,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final child = Tooltip(
      message: tooltip ?? text,
      child: Text(
        text,
        textAlign: textAlign,
        overflow: TextOverflow.ellipsis,
        maxLines: maxLines,
        softWrap: false,
        style: style,
      ),
    );

    if (tag != null && tag.isNotEmpty) {
      return Hero(
        tag: tag,
        child: child,
        flightShuttleBuilder: (
          BuildContext flightContext,
          Animation<double> animation,
          HeroFlightDirection flightDirection,
          BuildContext fromHeroContext,
          BuildContext toHeroContext,
        ) =>
            Material(
          color: Colors.transparent,
          child: toHeroContext.widget,
        ),
      );
    }

    return child;
  }
}

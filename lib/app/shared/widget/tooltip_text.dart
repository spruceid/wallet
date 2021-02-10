import 'package:credible/app/shared/widget/hero_workaround.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TooltipText extends StatelessWidget {
  final String? tag;
  final String text;
  final String? tooltip;

  final int maxLines;
  final TextStyle? style;
  final TextAlign textAlign;

  const TooltipText({
    Key? key,
    this.tag,
    required this.text,
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

    if (tag != null) {
      if (tag!.isNotEmpty) {
        return HeroFix(
          tag: tag!,
          child: child,
        );
      }
    }

    return child;
  }
}

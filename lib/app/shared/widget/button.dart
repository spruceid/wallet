import 'package:credible/app/shared/palette.dart';
import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final Widget child;
  final Function onPressed;

  final Color borderColor;
  final Color backgroundColor;

  final EdgeInsets padding;

  final bool enabled;

  CustomButton({
    @required this.child,
    this.onPressed,
    this.padding = const EdgeInsets.symmetric(
      horizontal: 32.0,
      vertical: 16.0,
    ),
    this.borderColor,
    this.backgroundColor = Palette.transparent,
    this.enabled = true,
  });

  double get disabledOpacity => enabled ? 1.0 : 0.33;

  BorderSide get effectiveBorderSide => BorderSide(
        width: 1.0,
        color: borderColor.withOpacity(disabledOpacity),
      );

  @override
  Widget build(BuildContext context) => Container(
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(2.0),
          border: Border.fromBorderSide(effectiveBorderSide),
        ),
        child: Material(
          color: Palette.transparent,
          child: InkWell(
            onTap: enabled ? onPressed : null,
            child: Container(
              padding: padding,
              child: child,
            ),
          ),
        ),
      );
}

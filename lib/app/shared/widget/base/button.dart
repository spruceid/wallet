import 'package:credible/app/shared/ui/ui.dart';
import 'package:flutter/material.dart';

class BaseButton extends StatelessWidget {
  final Widget child;
  final VoidCallback? onPressed;
  final Gradient? gradient;
  final Color? textColor;
  final Color? borderColor;

  const BaseButton({
    required this.child,
    this.onPressed,
    this.gradient,
    this.textColor,
    this.borderColor,
  });

  BaseButton.white({
    required Widget child,
    VoidCallback? onPressed,
    Color? borderColor,
  }) : this(
          child: child,
          onPressed: onPressed,
          gradient: LinearGradient(
            colors: [Colors.white, Colors.white],
          ),
          textColor: UiKit.palette.primary,
          borderColor: borderColor,
        );

  BaseButton.primary({
    required Widget child,
    VoidCallback? onPressed,
    Color? borderColor,
  }) : this(
          child: child,
          onPressed: onPressed,
          gradient: UiKit.palette.buttonBackground,
          textColor: Colors.white,
          borderColor: borderColor,
        );

  BaseButton.transparent({
    required Widget child,
    VoidCallback? onPressed,
    Color? borderColor,
  }) : this(
          child: child,
          onPressed: onPressed,
          gradient: LinearGradient(
            colors: [Colors.transparent, Colors.transparent],
          ),
          textColor: UiKit.palette.primary,
          borderColor: borderColor,
        );

  @override
  Widget build(BuildContext context) {
    final gradient = this.gradient ?? UiKit.palette.buttonBackground;
    final textColor = this.textColor ?? UiKit.text.colorTextButton;

    return Container(
      decoration: BoxDecoration(
        gradient: gradient,
        borderRadius: UiKit.constraints.buttonRadius,
        border: borderColor != null
            ? Border.all(
                width: 2.0,
                color: borderColor!,
              )
            : null,
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: UiKit.constraints.buttonRadius,
        child: InkWell(
          onTap: onPressed,
          borderRadius: UiKit.constraints.buttonRadius,
          child: Container(
            alignment: Alignment.center,
            padding: UiKit.constraints.buttonPadding,
            child: DefaultTextStyle(
              child: child,
              style:
                  Theme.of(context).textTheme.button!.apply(color: textColor),
            ),
          ),
        ),
      ),
    );
  }
}

import 'package:credible/app/shared/palette.dart';
import 'package:flutter/material.dart';

class BaseButton extends StatelessWidget {
  final Widget child;
  final VoidCallback? onPressed;
  final Color color;
  final Color textColor;
  final Color? borderColor;

  const BaseButton({
    required this.child,
    this.onPressed,
    this.color = Colors.transparent,
    this.textColor = Palette.text,
    this.borderColor,
  });

  BaseButton.white({
    required Widget child,
    VoidCallback? onPressed,
    Color? borderColor,
  }) : this(
          child: child,
          onPressed: onPressed,
          color: Colors.white,
          textColor: Palette.blue,
          borderColor: borderColor,
        );

  BaseButton.blue({
    required Widget child,
    VoidCallback? onPressed,
    Color? borderColor,
  }) : this(
          child: child,
          onPressed: onPressed,
          color: Palette.blue,
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
          color: Colors.transparent,
          textColor: Palette.blue,
          borderColor: borderColor,
        );

  @override
  Widget build(BuildContext context) {
    if (borderColor != null) {
      return OutlinedButton(
        style: OutlinedButton.styleFrom(
          padding: const EdgeInsets.symmetric(
            horizontal: 32.0,
            vertical: 12.0,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24.0),
          ),
          side: BorderSide(
            width: 2.0,
            color: borderColor!,
          ),
          primary: textColor,
          backgroundColor: color,
          textStyle:
              Theme.of(context).textTheme.button!.apply(color: textColor),
        ),
        onPressed: onPressed,
        child: child,
      );
    }

    return TextButton(
      style: TextButton.styleFrom(
        padding: const EdgeInsets.symmetric(
          horizontal: 32.0,
          vertical: 12.0,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24.0),
        ),
        primary: textColor,
        backgroundColor: color,
        textStyle: Theme.of(context).textTheme.button!.apply(color: textColor),
      ),
      onPressed: onPressed,
      child: child,
    );
  }
}

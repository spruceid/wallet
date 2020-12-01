import 'package:credible/app/shared/palette.dart';
import 'package:flutter/material.dart';

class BaseButton extends FlatButton {
  BaseButton({
    Widget child,
    VoidCallback onPressed,
    Color color = Colors.transparent,
    Color textColor = Palette.text,
    Color borderColor,
  }) : super(
          color: color,
          textColor: textColor,
          shape: RoundedRectangleBorder(
            side: borderColor != null
                ? BorderSide(
                    width: 2.0,
                    color: borderColor,
                  )
                : BorderSide.none,
            borderRadius: BorderRadius.circular(24.0),
          ),
          padding: const EdgeInsets.symmetric(
            horizontal: 32.0,
            vertical: 12.0,
          ),
          onPressed: onPressed,
          child: child,
        );

  BaseButton.white({
    Widget child,
    VoidCallback onPressed,
    Color borderColor,
  }) : this(
          color: Colors.white,
          child: child,
          onPressed: onPressed,
          borderColor: borderColor,
          textColor: Palette.blue,
        );

  BaseButton.blue({
    Widget child,
    VoidCallback onPressed,
    Color borderColor,
  }) : this(
          color: Palette.blue,
          child: child,
          onPressed: onPressed,
          borderColor: borderColor,
          textColor: Colors.white,
        );

  BaseButton.transparent({
    Widget child,
    VoidCallback onPressed,
    Color borderColor,
  }) : this(
          color: Colors.transparent,
          child: child,
          onPressed: onPressed,
          borderColor: borderColor,
          textColor: Palette.blue,
        );
}

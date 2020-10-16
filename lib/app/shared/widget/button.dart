import 'package:flutter/material.dart';

class CustomButton extends FlatButton {
  CustomButton({
    Widget child,
    VoidCallback onPressed,
    Color color = Colors.transparent,
    Color borderColor,
  }) : super(
          color: color,
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
}

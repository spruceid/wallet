import 'package:flutter/material.dart';

abstract class UiPalette {
  const UiPalette();

  Color get primary;

  Color get accent;

  Color get background;

  Gradient get pageBackground;

  Gradient get splashBackground;

  Gradient get buttonBackground;

  Color get shadow;

  Color get credentialText;

  Color get credentialBackground;

  Color get credentialDetail;

  Color get icon;

  Color get lightBorder;

  Color get appBarBackground;

  Color get navBarBackground;

  Color get navBarIcon;

  Color get wordBorder;

  Color get textFieldBackground;

  Color get textFieldBorder => Color(0xff1E1693);
}

import 'package:credible/app/shared/ui/base/palette.dart';
import 'package:flutter/material.dart';

class DegenPalette extends UiPalette {
  const DegenPalette();

  static const Color text = Color(0xffFFFFFF);
  static const Color purple = Color(0xff4136F1);
  static const Color violet = Color(0xff8743FF);

  static const Color backgroundTopLeft = Color(0xff020736);
  static const Color backgroundBottomRight = Color(0xff300E92);

  static const Color backgroundTextField = Color(0xff020523);

  @override
  Color get primary => Colors.purple;

  @override
  Color get accent => Colors.purpleAccent;

  @override
  Color get background => Color(0xffF6F7F8);

  @override
  Gradient get pageBackground => LinearGradient(
        colors: [
          backgroundTopLeft,
          backgroundBottomRight,
        ],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      );

  @override
  Gradient get splashBackground => LinearGradient(
        colors: [
          backgroundTopLeft,
          backgroundBottomRight,
        ],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      );

  @override
  Gradient get buttonBackground => LinearGradient(
        colors: [
          purple,
          violet,
        ],
        begin: Alignment.centerLeft,
        end: Alignment.centerRight,
      );

  @override
  Color get shadow => Color(0x0d000000);

  @override
  Color get credentialText => text;

  @override
  Color get credentialBackground => Color(0xff000425);

  @override
  Color get credentialDetail => Colors.transparent;

  @override
  Color get icon => text;

  @override
  Color get lightBorder => Colors.black;

  @override
  Color get appBarBackground => backgroundTopLeft;

  @override
  Color get navBarBackground => Color(0xff000425);

  @override
  Color get navBarIcon => violet;

  @override
  Color get wordBorder => Color(0xff594EF3);

  @override
  Color get textFieldBackground => Color(0xff020523);

  @override
  Color get textFieldBorder => Color(0xff1E1693);
}

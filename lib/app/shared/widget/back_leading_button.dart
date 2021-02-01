import 'package:credible/app/shared/palette.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

class BackLeadingButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () {
        Modular.to.pop();
      },
      icon: Icon(
        Icons.arrow_back,
        color: Palette.text,
      ),
    );
  }
}

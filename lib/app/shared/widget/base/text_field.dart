import 'package:credible/app/shared/palette.dart';
import 'package:flutter/material.dart';

class BaseTextField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final IconData icon;
  final TextInputType type;

  const BaseTextField({
    Key key,
    @required this.label,
    @required this.controller,
    this.icon = Icons.edit,
    this.type = TextInputType.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 24.0,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          top: BorderSide(color: Palette.greyPurple),
          bottom: BorderSide(color: Palette.greyPurple),
        ),
      ),
      child: TextField(
        controller: controller,
        cursorColor: Palette.text,
        keyboardType: type,
        maxLines: 1,
        decoration: InputDecoration(
          border: InputBorder.none,
          enabledBorder: InputBorder.none,
          disabledBorder: InputBorder.none,
          errorBorder: InputBorder.none,
          focusedBorder: InputBorder.none,
          focusedErrorBorder: InputBorder.none,
          fillColor: Palette.text,
          hoverColor: Palette.text,
          focusColor: Palette.text,
          hintText: label,
          hintStyle:
              Theme.of(context).textTheme.bodyText1.apply(color: Palette.text),
          labelText: label,
          labelStyle:
              Theme.of(context).textTheme.bodyText1.apply(color: Palette.text),
          suffixIcon: Icon(
            icon,
            color: Palette.text.withOpacity(0.4),
          ),
        ),
      ),
    );
  }
}

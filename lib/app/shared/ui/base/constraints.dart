import 'package:flutter/material.dart';

abstract class UiConstraints {
  const UiConstraints();

  EdgeInsets get buttonPadding;

  BorderRadius get buttonRadius;

  EdgeInsets get navBarPadding;

  BorderRadius get navBarRadius;

  EdgeInsets get textFieldPadding;

  BorderRadius get textFieldRadius;
}

import 'package:credible/app/shared/ui/base/constraints.dart';
import 'package:flutter/material.dart';

class DegenConstraints extends UiConstraints {
  const DegenConstraints();

  @override
  EdgeInsets get buttonPadding => const EdgeInsets.symmetric(
        horizontal: 12.0,
        vertical: 20.0,
      );

  @override
  BorderRadius get buttonRadius => BorderRadius.circular(16.0);

  @override
  EdgeInsets get navBarPadding => const EdgeInsets.symmetric(
        vertical: 16.0,
      );

  @override
  BorderRadius get navBarRadius => BorderRadius.only(
        topLeft: Radius.circular(32.0),
        topRight: Radius.circular(32.0),
      );

  @override
  EdgeInsets get textFieldPadding => const EdgeInsets.symmetric(
        horizontal: 16.0,
      );

  @override
  BorderRadius get textFieldRadius => BorderRadius.circular(16.0);
}

import 'package:credible/app/shared/ui/base/constraints.dart';
import 'package:flutter/material.dart';

class CredibleConstraints extends UiConstraints {
  const CredibleConstraints();

  @override
  EdgeInsets get buttonPadding => const EdgeInsets.symmetric(
        horizontal: 32.0,
        vertical: 12.0,
      );

  @override
  BorderRadius get buttonRadius => BorderRadius.circular(24.0);

  @override
  EdgeInsets get navBarPadding => EdgeInsets.zero;

  @override
  BorderRadius get navBarRadius => BorderRadius.zero;

  @override
  EdgeInsets get textFieldPadding => EdgeInsets.zero;

  @override
  BorderRadius get textFieldRadius => BorderRadius.zero;
}

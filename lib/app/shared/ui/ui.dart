import 'base/constraints.dart';
import 'base/palette.dart';
import 'base/text.dart';
import 'credible/constraints.dart';
import 'credible/palette.dart';
import 'credible/text.dart';
import 'degen/constraints.dart';
import 'degen/palette.dart';
import 'degen/text.dart';

const UiKit = Ui._credible();

class Ui {
  final UiPalette palette;
  final UiConstraints constraints;
  final UiText text;

  // ignore: unused_element
  const Ui._credible({
    this.palette = const CrediblePalette(),
    this.constraints = const CredibleConstraints(),
    this.text = const CredibleText(),
  });

  // ignore: unused_element
  const Ui._degen({
    this.palette = const DegenPalette(),
    this.constraints = const DegenConstraints(),
    this.text = const DegenText(),
  });
}

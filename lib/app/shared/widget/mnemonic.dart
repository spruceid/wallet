import 'package:credible/app/shared/widget/word.dart';
import 'package:flutter/cupertino.dart';

class MnemonicDisplay extends StatelessWidget {
  final List<String> mnemonic;

  const MnemonicDisplay({
    Key? key,
    required this.mnemonic,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(
        4,
        (i) {
          final j = 3 * i;
          return Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 8.0,
            ),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: PhraseWord(
                    order: j + 1,
                    word: mnemonic[j],
                  ),
                ),
                const SizedBox(width: 8.0),
                Expanded(
                  child: PhraseWord(
                    order: j + 2,
                    word: mnemonic[j + 1],
                  ),
                ),
                const SizedBox(width: 8.0),
                Expanded(
                  child: PhraseWord(
                    order: j + 3,
                    word: mnemonic[j + 2],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

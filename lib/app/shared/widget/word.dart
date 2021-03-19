import 'package:credible/app/shared/ui/ui.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PhraseWord extends StatelessWidget {
  final int order;
  final String word;

  const PhraseWord({
    Key? key,
    required this.order,
    required this.word,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 12.0,
          vertical: 12.0,
        ),
        decoration: BoxDecoration(
          color: Colors.transparent,
          border: Border.all(
            width: 1.5,
            color: UiKit.palette.wordBorder,
          ),
          borderRadius: BorderRadius.circular(128.0),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '$order',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.caption,
            ),
            const SizedBox(width: 8.0),
            Text(
              '$word',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.caption,
            ),
          ],
        ),
      );
}

import 'package:credible/app/shared/palette.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PhraseWord extends StatelessWidget {
  final int order;
  final String word;

  const PhraseWord({
    Key key,
    @required this.order,
    @required this.word,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 12.0,
          vertical: 4.0,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(
            width: 1.5,
            color: Palette.text,
          ),
          borderRadius: BorderRadius.circular(128.0),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
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

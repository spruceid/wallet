import 'package:credible/app/shared/ui/ui.dart';
import 'package:credible/app/shared/widget/tooltip_text.dart';
import 'package:flutter/material.dart';

class DocumentItemWidget extends StatelessWidget {
  final String label;
  final String value;

  const DocumentItemWidget({
    Key? key,
    required this.label,
    required this.value,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          TooltipText(
            text: label,
            style: Theme.of(context)
                .textTheme
                .overline!
                .apply(color: UiKit.palette.credentialText.withOpacity(0.6)),
          ),
          const SizedBox(height: 2.0),
          TooltipText(
            text: value,
            style: Theme.of(context)
                .textTheme
                .caption!
                .apply(color: UiKit.palette.credentialText),
            maxLines: null,
            softWrap: true,
          ),
        ],
      );
}

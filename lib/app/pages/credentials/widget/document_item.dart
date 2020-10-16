import 'package:credible/app/shared/palette.dart';
import 'package:credible/app/shared/widget/tooltip_text.dart';
import 'package:credible/localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class DocumentItemWidget extends StatelessWidget {
  final GlobalKey<ScaffoldState> scaffoldKey;
  final String label;
  final String value;

  const DocumentItemWidget({
    Key key,
    this.scaffoldKey,
    this.label,
    this.value,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => Material(
        color: Palette.background,
        child: InkWell(
          onLongPress: () {
            Clipboard.setData(ClipboardData(text: value));
            scaffoldKey.currentState.showSnackBar(SnackBar(
              content: Text(
                AppLocalizations.of(context).credentialDetailCopyFieldValue,
              ),
            ));
          },
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 24.0,
              vertical: 16.0,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                TooltipText(
                  text: label,
                  style: Theme.of(context).textTheme.overline,
                ),
                const SizedBox(height: 8.0),
                TooltipText(
                  text: value,
                  style: Theme.of(context).textTheme.caption,
                ),
              ],
            ),
          ),
        ),
      );
}

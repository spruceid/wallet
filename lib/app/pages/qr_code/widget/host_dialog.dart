import 'package:credible/app/shared/palette.dart';
import 'package:credible/app/shared/widget/base/button.dart';
import 'package:credible/localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

class HostDialog extends StatelessWidget {
  final String host;

  const HostDialog({
    Key? key,
    required this.host,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    return AlertDialog(
      title: Text(
        'Do you trust this host?',
        style: Theme.of(context).textTheme.subtitle1,
      ),
      content: Text(
        host,
        style: Theme.of(context).textTheme.subtitle2,
      ),
      actions: [
        BaseButton.transparent(
          borderColor: Palette.blue,
          onPressed: () {
            Modular.to.pop(true);
          },
          child: Text(localizations.communicationHostAllow),
        ),
        BaseButton.blue(
          onPressed: () {
            Modular.to.pop(false);
          },
          child: Text(localizations.communicationHostDeny),
        ),
      ],
    );
  }
}

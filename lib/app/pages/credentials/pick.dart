import 'package:credible/app/pages/credentials/models/credential.dart';
import 'package:credible/app/pages/credentials/widget/list_item.dart';
import 'package:credible/app/shared/ui/ui.dart';
import 'package:credible/app/shared/widget/base/button.dart';
import 'package:credible/app/shared/widget/base/page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class CredentialsPickPage extends StatefulWidget {
  final List<CredentialModel> items;
  final void Function(List<CredentialModel>) onSubmit;

  const CredentialsPickPage({
    Key? key,
    required this.items,
    required this.onSubmit,
  }) : super(key: key);

  @override
  _CredentialsPickPageState createState() => _CredentialsPickPageState();
}

class _CredentialsPickPageState extends State<CredentialsPickPage> {
  final selection = <int>{};

  void toggle(int index) {
    if (selection.contains(index)) {
      selection.remove(index);
    } else {
      selection.add(index);
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    return BasePage(
      title: 'Present credentials',
      titleTrailing: IconButton(
        onPressed: () {
          Modular.to.pushReplacementNamed('/credentials/list');
        },
        icon: Icon(
          Icons.close,
          color: UiKit.palette.icon,
        ),
      ),
      padding: const EdgeInsets.symmetric(
        vertical: 24.0,
        horizontal: 16.0,
      ),
      navigation: SafeArea(
        child: Container(
          padding: const EdgeInsets.all(16.0),
          height: kBottomNavigationBarHeight * 1.75,
          child: Tooltip(
            message: localizations.credentialPickPresent,
            child: BaseButton.primary(
              onPressed: () {
                if (selection.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    backgroundColor: Colors.red,
                    content: Text('localizations.credentialPickSelect'),
                  ));
                } else {
                  widget
                      .onSubmit(selection.map((i) => widget.items[i]).toList());
                  Modular.to.pushReplacementNamed('/credentials/list');
                }
              },
              child: Text(localizations.credentialPickPresent),
            ),
          ),
        ),
      ),
      body: Column(
        children: <Widget>[
          Text(
            localizations.credentialPickSelect,
            style: Theme.of(context).textTheme.bodyText1,
          ),
          const SizedBox(height: 32.0),
          ...List.generate(
            widget.items.length,
            (index) => CredentialsListItem(
              item: widget.items[index],
              selected: selection.contains(index),
              onTap: () => toggle(index),
            ),
          ),
        ],
      ),
    );
  }
}

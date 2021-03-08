import 'package:credible/app/pages/credentials/models/credential.dart';
import 'package:credible/app/pages/credentials/widget/list_item.dart';
import 'package:credible/app/shared/palette.dart';
import 'package:credible/app/shared/widget/base/page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

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
    return BasePage(
      title: 'Present credentials',
      titleTrailing: IconButton(
        onPressed: () {
          Modular.to.pushReplacementNamed('/credentials/list');
        },
        icon: Icon(
          Icons.close,
          color: Palette.text,
        ),
      ),
      padding: const EdgeInsets.symmetric(
        vertical: 24.0,
        horizontal: 16.0,
      ),
      navigation: Container(
        padding: const EdgeInsets.all(16.0),
        height: kBottomNavigationBarHeight * 1.75,
        child: Tooltip(
          message: 'Present',
          child: BaseButton.primary(
            onPressed: () {
              if (selection.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  backgroundColor: Colors.red,
                  content: Text('Select at least one credential'),
                ));
              } else {
                widget.onSubmit(selection.map((i) => widget.items[i]).toList());
                Modular.to.pushReplacementNamed('/credentials/list');
              }
            },
            child: Text('Present'),
          ),
        ),
      ),
      body: Column(
        children: <Widget>[
          Text(
            'Choose one or more credentials from your wallet to present',
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

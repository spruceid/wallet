import 'package:credible/app/pages/credentials/list_item.dart';
import 'package:credible/app/pages/credentials/models/credential.dart';
import 'package:credible/localizations.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

class CredentialsList extends StatelessWidget {
  final List<CredentialModel> items;

  const CredentialsList({
    Key key,
    this.items,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text(localizations.credentialListTitle),
          actions: [
            IconButton(
              tooltip: localizations.listActionViewGrid,
              icon: Icon(Icons.view_module),
              onPressed: () =>
                  Modular.to.pushReplacementNamed('/credentials/grid'),
            ),
            IconButton(
              tooltip: localizations.listActionFilter,
              icon: Icon(Icons.filter_list),
              onPressed: () {},
            ),
            IconButton(
              tooltip: localizations.listActionSort,
              icon: Icon(Icons.sort),
              onPressed: () {},
            ),
          ],
        ),
        body: ListView.builder(
          shrinkWrap: true,
          padding: EdgeInsets.zero,
          itemCount: items.length,
          itemBuilder: (_context, index) =>
              CredentialsListItem(item: items[index]),
        ),
      ),
    );
  }
}

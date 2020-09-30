import 'package:credible/app/pages/credentials/grid_item.dart';
import 'package:credible/app/pages/credentials/models/credential.dart';
import 'package:credible/localizations.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

class CredentialsGrid extends StatelessWidget {
  final List<CredentialModel> items;

  const CredentialsGrid({
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
          actions: <Widget>[
            IconButton(
              tooltip: localizations.listActionViewList,
              icon: Icon(Icons.view_list),
              onPressed: () =>
                  Modular.to.pushReplacementNamed('/credentials/list'),
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
        body: GridView.count(
          shrinkWrap: true,
          crossAxisCount: 2,
          children:
              items.map((item) => CredentialsGridItem(item: item)).toList(),
        ),
      ),
    );
  }
}

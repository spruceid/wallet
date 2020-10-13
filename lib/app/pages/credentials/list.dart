import 'package:credible/app/pages/credentials/list_item.dart';
import 'package:credible/app/pages/credentials/models/credential.dart';
import 'package:credible/app/shared/palette.dart';
import 'package:credible/app/shared/widget/app_bar.dart';
import 'package:credible/app/shared/widget/navigation_bar.dart';
import 'package:credible/localizations.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CredentialsList extends StatelessWidget {
  final List<CredentialModel> items;

  const CredentialsList({
    Key key,
    this.items,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => SafeArea(
        child: Scaffold(
          backgroundColor: Palette.background,
          appBar: CustomAppBar(
            title: AppLocalizations.of(context).appTitle,
          ),
          bottomNavigationBar: CustomNavBar(index: 0),
          body: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(
              vertical: 24.0,
              horizontal: 16.0,
            ),
            child: Column(
              children: List.generate(
                items.length,
                (index) => CredentialsListItem(item: items[index]),
              ),
            ),
          ),
        ),
      );
}

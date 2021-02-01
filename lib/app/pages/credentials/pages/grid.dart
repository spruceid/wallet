import 'package:credible/app/pages/credentials/blocs/scan.dart';
import 'package:credible/app/pages/credentials/models/credential.dart';
import 'package:credible/app/pages/credentials/widget/grid_item.dart';
import 'package:credible/app/shared/palette.dart';
import 'package:credible/app/shared/widget/base/page.dart';
import 'package:credible/app/shared/widget/navigation_bar.dart';
import 'package:credible/localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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

    return BlocListener(
      cubit: Modular.get<ScanBloc>(),
      listener: (context, state) {
        if (state is ScanStateMessage) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            backgroundColor: state.message.color,
            content: Text(state.message.message),
          ));
        }
      },
      child: BasePage(
        backgroundColor: Palette.background,
        title: localizations.credentialListTitle,
        padding: const EdgeInsets.symmetric(
          vertical: 24.0,
          horizontal: 16.0,
        ),
        navigation: CustomNavBar(index: 0),
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

import 'package:credible/app/pages/credentials/blocs/scan.dart';
import 'package:credible/app/pages/credentials/models/credential.dart';
import 'package:credible/app/pages/credentials/widget/list_item.dart';
import 'package:credible/app/shared/palette.dart';
import 'package:credible/app/shared/widget/base/page.dart';
import 'package:credible/app/shared/widget/navigation_bar.dart';
import 'package:credible/localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_modular/flutter_modular.dart';

class CredentialsPickPage extends StatelessWidget {
  final List<CredentialModel> items;
  final Map<String, dynamic> params;
  final Map<String, dynamic> query;

  const CredentialsPickPage({
    Key key,
    @required this.items,
    @required this.params,
    this.query,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);

    final List<CredentialModel> filtered = query != null
        ? items.where((item) {
            switch (query['type']) {
              case 'QueryByExample':
                // TODO: implement QueryByExample
                // https://w3c-ccg.github.io/vp-request-spec/#query-by-example
                return false;
              case 'DIDAuth':
                // TODO: implement DIDAuth
                // https://w3c-ccg.github.io/vp-request-spec/#did-authentication-request
                return false;
              case 'ZcapQuery':
                // TODO: implement ZcapQuery
                // https://w3c-ccg.github.io/vp-request-spec/#authorization-capability-request
                return false;
              default:
                return true;
            }
          })
        : items;

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
        body: Column(
          children: List.generate(
            filtered.length,
            (index) => CredentialsListItem(
              item: filtered[index],
              onTap: () {
                Modular.get<ScanBloc>().add(
                  ScanEventVerifiablePresentationRequest(
                    url: params['url'],
                    key: params['key'],
                    credential: filtered[index],
                    challenge: params['challenge'],
                    domain: params['domain'],
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

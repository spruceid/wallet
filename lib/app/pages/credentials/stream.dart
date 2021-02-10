import 'package:credible/app/pages/credentials/blocs/wallet.dart';
import 'package:credible/app/pages/credentials/models/credential.dart';
import 'package:credible/app/shared/palette.dart';
import 'package:credible/app/shared/widget/base/page.dart';
import 'package:credible/localizations.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

typedef CredentialsStreamBuilder = Widget Function(
  BuildContext,
  List<CredentialModel>,
);

class CredentialsStream extends StatefulWidget {
  final CredentialsStreamBuilder child;

  const CredentialsStream({
    Key? key,
    required this.child,
  }) : super(key: key);

  @override
  _CredentialsStreamState createState() => _CredentialsStreamState();
}

class _CredentialsStreamState
    extends ModularState<CredentialsStream, WalletBloc> {
  @override
  void initState() {
    super.initState();
    store.findAll();
  }

  @override
  Widget build(BuildContext context) => StreamBuilder<List<CredentialModel>>(
        initialData: [],
        stream: store.credentials$,
        builder: (
          BuildContext context,
          AsyncSnapshot<List<CredentialModel>> snapshot,
        ) {
          final localizations = AppLocalizations.of(context)!;

          if (snapshot.hasError) {
            return BasePage(
              backgroundColor: Palette.background,
              title: localizations.genericError,
              body: Center(
                child: Column(
                  children: <Widget>[
                    IconButton(
                      tooltip: localizations.listActionRefresh,
                      icon: Icon(Icons.refresh),
                      onPressed: () {},
                    ),
                    const SizedBox(height: 16.0),
                    Text(localizations.genericError),
                  ],
                ),
              ),
            );
          } else {
            return widget.child(context, snapshot.data!);
          }
        },
      );
}

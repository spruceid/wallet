import 'package:credible/app/pages/credentials/blocs/scan.dart';
import 'package:credible/app/pages/credentials/models/credential.dart';
import 'package:credible/app/pages/credentials/widget/list_item.dart';
import 'package:credible/app/shared/palette.dart';
import 'package:credible/app/shared/widget/base/page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

class CredentialsPickPage extends StatefulWidget {
  final List<CredentialModel> items;
  final Map<String, dynamic> params;
  final Map<String, dynamic>? query;

  const CredentialsPickPage({
    Key? key,
    required this.items,
    required this.params,
    this.query,
  }) : super(key: key);

  @override
  _CredentialsPickPageState createState() => _CredentialsPickPageState();
}

class _CredentialsPickPageState extends State<CredentialsPickPage> {
  @override
  Widget build(BuildContext context) {
    final filtered = widget.query != null
        ? widget.items.where((item) {
            switch (widget.query!['type']) {
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
          }).toList()
        : widget.items;

    return BasePage(
      backgroundColor: Palette.background,
      title: 'Pick a credential',
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
      body: Column(
        children: <Widget>[
          Text(
            'Choose a credential from your wallet to present',
            style: Theme.of(context).textTheme.bodyText1,
          ),
          const SizedBox(height: 32.0),
          ...List.generate(
            filtered.length,
            (index) => CredentialsListItem(
              item: filtered[index],
              onTap: () {
                Modular.get<ScanBloc>().add(
                  ScanEventVerifiablePresentationRequest(
                    url: widget.params['url'],
                    key: widget.params['key'],
                    credential: filtered[index],
                    challenge: widget.params['challenge'],
                    domain: widget.params['domain'],
                  ),
                );
                // TODO bloc listener wouldn't work so we're going back as soon
                // as the event is sent
                Modular.to.pushReplacementNamed('/credentials/list');
              },
            ),
          ),
        ],
      ),
    );
  }
}

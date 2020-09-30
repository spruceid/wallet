import 'package:credible/app/pages/credentials/models/credential.dart';
import 'package:credible/app/pages/credentials/models/credential_status.dart';
import 'package:credible/app/shared/widget/tooltip_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

class CredentialsListItem extends StatelessWidget {
  final CredentialModel item;

  CredentialsListItem({
    Key key,
    @required this.item,
  }) : super(key: key);

  Widget get _statusIcon {
    switch (item.status) {
      case CredentialStatus.active:
        return Icon(Icons.check_circle, color: Colors.green);
      case CredentialStatus.expired:
        return Icon(Icons.alarm_off, color: Colors.yellow);
      case CredentialStatus.revoked:
        return Icon(Icons.block, color: Colors.red);
      default:
        throw UnimplementedError('Unreachable!');
    }
  }

  @override
  Widget build(BuildContext context) => Card(
        margin: const EdgeInsets.all(4.0),
        child: ListTile(
          onTap: () =>
              Modular.to.pushNamed('/credentials/detail', arguments: item),
          leading: Hero(
            tag: 'credential/${item.id}/icon',
            child: Icon(
              Icons.person,
              size: 48.0,
              color: Colors.black,
            ),
          ),
          title: TooltipText(
            tag: 'credential/${item.id}/issuer',
            text: item.issuer,
            style: TextStyle(
              fontSize: 12.0,
            ),
          ),
          trailing: Hero(
            tag: 'credential/${item.id}/status',
            child: _statusIcon,
          ),
        ),
      );
}

import 'package:credible/app/pages/credentials/models/credential.dart';
import 'package:credible/app/pages/credentials/models/credential_status.dart';
import 'package:credible/app/shared/widget/tooltip_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

class CredentialsGridItem extends StatelessWidget {
  final CredentialModel item;

  CredentialsGridItem({
    required this.item,
  });

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
        margin: const EdgeInsets.all(8.0),
        child: InkWell(
          onTap: () =>
              Modular.to.pushNamed('/credentials/detail', arguments: item),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Stack(
              children: <Widget>[
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    Hero(
                      tag: 'credential/${item.id}/icon',
                      child: Icon(
                        Icons.person,
                        size: 48.0,
                      ),
                    ),
                    TooltipText(
                      tag: 'credential/${item.id}/issuer',
                      text: item.issuer,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 10.0,
                      ),
                    ),
                  ],
                ),
                Align(
                  alignment: Alignment.bottomRight,
                  child: Hero(
                    tag: 'credential/${item.id}/status',
                    child: _statusIcon,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
}

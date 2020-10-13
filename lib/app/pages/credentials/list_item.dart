import 'package:credible/app/pages/credentials/models/credential.dart';
import 'package:credible/app/pages/credentials/models/credential_status.dart';
import 'package:credible/app/shared/palette.dart';
import 'package:credible/app/shared/widget/hero_workaround.dart';
import 'package:credible/app/shared/widget/tooltip_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

class CredentialsListItem extends StatelessWidget {
  final CredentialModel item;

  CredentialsListItem({
    Key key,
    @required this.item,
  }) : super(key: key);

  Color get _statusColor {
    switch (item.status) {
      case CredentialStatus.active:
        return Palette.primary;
      case CredentialStatus.expired:
        return Palette.red;
      case CredentialStatus.revoked:
        return Palette.red;
      default:
        throw UnimplementedError('Unreachable!');
    }
  }

  @override
  Widget build(BuildContext context) => Opacity(
        opacity: item.status != CredentialStatus.active ? 0.33 : 1.0,
        child: Card(
          child: InkWell(
            onTap: () => Modular.to.pushNamed(
              '/credentials/detail',
              arguments: item,
            ),
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Row(
                children: <Widget>[
                  Container(
                    padding: const EdgeInsets.all(16.0),
                    decoration: BoxDecoration(
                      color: Palette.text,
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: HeroFix(
                      tag: 'credential/${item.id}/icon',
                      child: Icon(
                        Icons.domain,
                        size: 24.0,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16.0),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        TooltipText(
                          tag: 'credential/${item.id}/issuer',
                          text: item.issuer,
                          style: TextStyle(
                            color: Palette.text,
                            fontSize: 14.0,
                          ),
                        ),
                        const SizedBox(height: 4.0),
                        TooltipText(
                          tag: 'credential/${item.id}/id',
                          text: item.id,
                          style: TextStyle(
                            color: Colors.black38,
                            fontSize: 10.0,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: 8.0,
                    height: 8.0,
                    margin: const EdgeInsets.only(
                      right: 8.0,
                    ),
                    decoration: BoxDecoration(
                      color: _statusColor,
                      shape: BoxShape.circle,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
}

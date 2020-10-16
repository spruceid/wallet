import 'package:credible/app/pages/credentials/models/credential.dart';
import 'package:credible/app/pages/credentials/models/credential_status.dart';
import 'package:credible/app/shared/palette.dart';
import 'package:credible/app/shared/widget/hero_workaround.dart';
import 'package:credible/app/shared/widget/tooltip_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:google_fonts/google_fonts.dart';

class _BaseItem extends StatelessWidget {
  final Widget child;
  final VoidCallback onTap;
  final bool enabled;

  const _BaseItem({
    Key key,
    @required this.child,
    this.onTap,
    this.enabled = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => Opacity(
        opacity: !enabled ? 0.33 : 1.0,
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 4.0),
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: <BoxShadow>[
              BoxShadow(
                color: Palette.shadow,
                offset: Offset(0.0, 2.0),
                blurRadius: 2.0,
              ),
            ],
            borderRadius: BorderRadius.circular(20.0),
          ),
          child: Material(
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(20.0),
            child: InkWell(
              borderRadius: BorderRadius.circular(20.0),
              onTap: onTap,
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: IntrinsicHeight(child: child),
              ),
            ),
          ),
        ),
      );
}

class _LabeledItem extends StatelessWidget {
  final String label;
  final String hero;
  final String value;

  const _LabeledItem({
    Key key,
    @required this.label,
    @required this.hero,
    @required this.value,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            label,
            style: TextStyle(
              color: Colors.black38,
              fontSize: 10.0,
            ),
          ),
          TooltipText(
            tag: hero,
            text: value,
            style: GoogleFonts.poppins(
              color: Palette.text,
              fontSize: 12.0,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      );
}

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
  Widget build(BuildContext context) =>
      _BaseItem(
        enabled: !(item.status != CredentialStatus.active),
        onTap: () =>
            Modular.to.pushNamed(
              '/credentials/detail',
              arguments: item,
            ),
        child: Row(
          children: <Widget>[
            Container(
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Palette.text,
                borderRadius: BorderRadius.circular(16.0),
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
                    tag: 'credential/${item.id}/id',
                    text: item.id,
                    style: GoogleFonts.poppins(
                      color: Palette.text,
                      fontSize: 16.0,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 8.0),
                  Expanded(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Expanded(
                          child: _LabeledItem(
                            label: 'Issued by:',
                            hero: 'credential/${item.id}/issuer',
                            value: item.issuer,
                          ),
                        ),
                        const SizedBox(width: 16.0),
                        Expanded(
                          child: _LabeledItem(
                            label: 'Valid thru:',
                            hero: 'credential/${item.id}/valid',
                            value: '01/22',
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
}

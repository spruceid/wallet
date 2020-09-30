import 'package:credible/app/pages/credentials/models/credential.dart';
import 'package:credible/app/shared/widget/tooltip_text.dart';
import 'package:credible/localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class CredentialsDetail extends StatefulWidget {
  final CredentialModel item;

  const CredentialsDetail({
    Key key,
    @required this.item,
  }) : super(key: key);

  @override
  _CredentialsDetailState createState() => _CredentialsDetailState();
}

class _CredentialsDetailState extends State<CredentialsDetail> {
  bool showShareMenu = false;

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    final scaffoldKey = GlobalKey<ScaffoldState>();

    return SafeArea(
      child: Scaffold(
        key: scaffoldKey,
        body: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(
            horizontal: 32.0,
            vertical: 64.0,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(32.0),
                child: Hero(
                  tag: 'credential/${widget.item.id}/icon',
                  child: Icon(
                    Icons.person,
                    size: MediaQuery.of(context).size.width * 0.3334,
                  ),
                ),
              ),
              TooltipText(
                tag: 'credential/${widget.item.id}/id',
                text: widget.item.id,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              TooltipText(
                tag: 'credential/${widget.item.id}/issuer',
                text:
                    localizations.credentialDetailIssuedBy(widget.item.issuer),
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 12.0,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ],
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
        floatingActionButton: showShareMenu
            ? Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  FloatingActionButton(
                    heroTag: 'credentials/detail/share/qrcode',
                    child: FaIcon(FontAwesomeIcons.qrcode, size: 16.0),
                    onPressed: () {
                      Modular.to
                          .pushNamed("/qrcode", arguments: widget.item.id);
                    },
                    mini: true,
                  ),
                  FloatingActionButton(
                    heroTag: 'credentials/detail/share/plain-text',
                    child: FaIcon(FontAwesomeIcons.quoteRight, size: 16.0),
                    onPressed: () {
                      Clipboard.setData(ClipboardData(text: widget.item.id));
                      scaffoldKey.currentState.showSnackBar(SnackBar(
                        content: Text('Copied to clipboard!'),
                      ));
                    },
                    mini: true,
                  ),
                  const SizedBox(height: 16.0),
                  FloatingActionButton(
                    heroTag: 'credentials/detail/share',
                    child: Icon(Icons.close),
                    onPressed: () {
                      setState(() {
                        showShareMenu = false;
                      });
                    },
                  ),
                ],
              )
            : FloatingActionButton(
                heroTag: 'credentials/detail/share',
                child: Icon(Icons.share),
                onPressed: () {
                  setState(() {
                    showShareMenu = true;
                  });
                },
              ),
      ),
    );
  }
}

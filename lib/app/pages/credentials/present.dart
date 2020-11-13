import 'package:credible/app/pages/credentials/blocs/scan.dart';
import 'package:credible/app/pages/credentials/models/credential.dart';
import 'package:credible/app/pages/credentials/models/credential_status.dart';
import 'package:credible/app/pages/credentials/widget/document.dart';
import 'package:credible/app/shared/palette.dart';
import 'package:credible/app/shared/widget/base/button.dart';
import 'package:credible/app/shared/widget/base/page.dart';
import 'package:credible/app/shared/widget/tooltip_text.dart';
import 'package:credible/localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_modular/flutter_modular.dart';

class CredentialsPresentPage extends StatefulWidget {
  final Uri url;

  const CredentialsPresentPage({
    Key key,
    @required this.url,
  }) : super(key: key);

  @override
  _CredentialsPresentPageState createState() => _CredentialsPresentPageState();
}

class _CredentialsPresentPageState extends State<CredentialsPresentPage> {
  @override
  Widget build(BuildContext context) {
    // TODO: Add proper localization
    final bloc = Modular.get<ScanBloc>();
    final localizations = AppLocalizations.of(context);
    final scaffoldKey = GlobalKey<ScaffoldState>();

    return BasePage(
      scaffoldKey: scaffoldKey,
      padding: const EdgeInsets.all(16.0),
      title: 'Presentation Request',
      titleTrailing: IconButton(
        onPressed: () {
          Modular.to.pop();
        },
        icon: Icon(
          Icons.close,
          color: Palette.text,
        ),
      ),
      body: BlocConsumer(
        cubit: bloc,
        listener: (context, state) {
          if (state is ScanStateSuccess) {
            Modular.to.pop();
          }
        },
        builder: (context, state) {
          if (state is ScanStateWorking) {
            return LinearProgressIndicator();
          }

          if (state is ScanStatePreview) {
            final preview = state.preview;
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Row(
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width * 0.175,
                      height: MediaQuery.of(context).size.width * 0.175,
                      decoration: BoxDecoration(
                        color: Colors.black45,
                        borderRadius: BorderRadius.circular(16.0),
                      ),
                    ),
                    const SizedBox(width: 16.0),
                    Expanded(
                      child: TooltipText(
                        text: 'Someone is asking for your credential.',
                        maxLines: 3,
                        style: Theme.of(context).textTheme.bodyText1,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16.0),
                DocumentWidget(
                  scaffoldKey: scaffoldKey,
                  item: CredentialModel(
                    id: '',
                    issuer: '',
                    status: CredentialStatus.active,
                    image: '',
                  ),
                ),
                const SizedBox(height: 24.0),
                BaseButton.transparent(
                  borderColor: Palette.blue,
                  onPressed: () {
                    bloc.add(ScanEventVerifiablePresentationRequest(
                        widget.url.toString(), 'key'));
                  },
                  child: Text(localizations.credentialPresentConfirm),
                ),
                const SizedBox(height: 8.0),
                BaseButton.blue(
                  onPressed: () {
                    Modular.to.pop();
                  },
                  child: Text(localizations.credentialPresentCancel),
                ),
              ],
            );
          }

          return Container();
        },
      ),
    );
  }
}

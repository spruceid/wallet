import 'package:credible/app/pages/credentials/blocs/scan.dart';
import 'package:credible/app/shared/ui/ui.dart';
import 'package:credible/app/shared/widget/base/button.dart';
import 'package:credible/app/shared/widget/base/page.dart';
import 'package:credible/app/shared/widget/spinner.dart';
import 'package:credible/app/shared/widget/tooltip_text.dart';
import 'package:credible/localizations.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_modular/flutter_modular.dart';

class CredentialsPresentPage extends StatefulWidget {
  final Uri url;
  final String title;
  final String resource;
  final String? yes;
  final String? no;
  final void Function(Map<String, dynamic>) onSubmit;

  const CredentialsPresentPage({
    Key? key,
    required this.url,
    required this.title,
    this.yes,
    this.no,
    required this.resource,
    required this.onSubmit,
  }) : super(key: key);

  @override
  _CredentialsPresentPageState createState() => _CredentialsPresentPageState();
}

class _CredentialsPresentPageState
    extends ModularState<CredentialsPresentPage, ScanBloc> {
  final VoidCallback goBack = () {
    Modular.to.pushReplacementNamed('/credentials/list');
  };

  @override
  Widget build(BuildContext context) {
    // TODO: Add proper localization
    final localizations = AppLocalizations.of(context)!;

    return BasePage(
      padding: const EdgeInsets.all(16.0),
      title: widget.title,
      titleTrailing: IconButton(
        onPressed: goBack,
        icon: Icon(
          Icons.close,
          color: UiKit.palette.icon,
        ),
      ),
      body: BlocConsumer(
        bloc: store,
        listener: (context, state) {
          if (state is ScanStateSuccess) {
            goBack();
          }
        },
        builder: (context, state) {
          if (state is ScanStateWorking) {
            return Spinner();
          }

          if (state is ScanStatePreview) {
            return _credentialPreview(state, context, localizations);
          }

          return Container();
        },
      ),
    );
  }

  Column _credentialPreview(ScanStatePreview state, BuildContext context,
      AppLocalizations localizations) {
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
                text: 'Someone is asking for your ${widget.resource}.',
                maxLines: 3,
                style: Theme.of(context).textTheme.bodyText1,
              ),
            ),
          ],
        ),
        // const SizedBox(height: 16.0),
        // DocumentWidget(
        //     model: DocumentWidgetModel.fromCredentialModel(
        //         CredentialModel(id: '', image: '', data: {'issuer': ''}))),
        const SizedBox(height: 24.0),
        BaseButton.transparent(
          borderColor: UiKit.palette.primary,
          onPressed: () => widget.onSubmit(preview),
          child: Text(
            widget.yes ?? localizations.credentialPresentConfirm,
          ),
        ),
        const SizedBox(height: 8.0),
        BaseButton.primary(
          onPressed: goBack,
          child: Text(
            widget.no ?? localizations.credentialPresentCancel,
          ),
        ),
      ],
    );
  }
}

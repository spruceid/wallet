import 'dart:convert';

import 'package:credible/app/pages/credentials/blocs/wallet.dart';
import 'package:credible/app/pages/credentials/models/credential.dart';
import 'package:credible/app/pages/credentials/models/verification_state.dart';
import 'package:credible/app/pages/credentials/widget/document/item.dart';
import 'package:credible/app/shared/ui/ui.dart';
import 'package:credible/app/shared/widget/back_leading_button.dart';
import 'package:credible/app/shared/widget/base/box_decoration.dart';
import 'package:credible/app/shared/widget/base/page.dart';
import 'package:credible/app/shared/widget/confirm_dialog.dart';
import 'package:credible/app/shared/widget/text_field_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:logging/logging.dart';

class CredentialsVCEDUDetail extends StatefulWidget {
  final CredentialModel item;

  const CredentialsVCEDUDetail({
    Key? key,
    required this.item,
  }) : super(key: key);

  @override
  _CredentialsVCEDUDetailState createState() => _CredentialsVCEDUDetailState();
}

class _CredentialsVCEDUDetailState
    extends ModularState<CredentialsVCEDUDetail, WalletBloc> {
  bool showShareMenu = false;
  VerificationState verification = VerificationState.Unverified;

  final logger = Logger('credible/credentials/detail');

  void delete() async {
    final confirm = await showDialog<bool>(
          context: context,
          builder: (BuildContext context) {
            final localizations = AppLocalizations.of(context)!;
            return ConfirmDialog(
              title: localizations.credentialDetailDeleteConfirmationDialog,
              yes: localizations.credentialDetailDeleteConfirmationDialogYes,
              no: localizations.credentialDetailDeleteConfirmationDialogNo,
            );
          },
        ) ??
        false;

    if (confirm) {
      await store.deleteById(widget.item.id);
      Modular.to.pop();
    }
  }

  void _edit() async {
    logger.info('Start edit flow');

    final newAlias = await showDialog<String>(
      context: context,
      builder: (context) => TextFieldDialog(
        title: 'Do you want to edit this credential alias?',
        initialValue: widget.item.alias,
        yes: 'Save',
        no: 'Cancel',
      ),
    );

    logger.info('Edit flow answered with: $newAlias');

    if (newAlias != null && newAlias != widget.item.alias) {
      logger.info('New alias is different, going to update credential');

      final newCredential = CredentialModel(
          id: widget.item.id,
          alias: newAlias.isEmpty ? null : newAlias,
          image: widget.item.image,
          data: widget.item.data);
      await store.updateCredential(newCredential);
    }
  }

  @override
  Widget build(BuildContext context) {
    // TODO: Add proper localization
    final localizations = AppLocalizations.of(context)!;

    return BasePage(
      title: widget.item.title,
      titleTag: 'credential/${widget.item.title}/issuer',
      titleLeading: BackLeadingButton(),
      titleTrailing: IconButton(
        onPressed: _edit,
        icon: Icon(
          Icons.edit,
          color: UiKit.palette.icon,
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Container(
            decoration: BaseBoxDecoration(
              color: UiKit.palette.credentialBackground,
              shapeColor: UiKit.palette.credentialDetail.withOpacity(0.2),
              value: 0.0,
              shapeSize: 256.0,
              anchors: <Alignment>[
                Alignment.topRight,
                Alignment.bottomCenter,
              ],
              // value: animation.value,
              borderRadius: BorderRadius.circular(20.0),
            ),
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 20.0, horizontal: 20.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  if (widget.item.data['issuer'].containsKey('image')) ...[
                    Image.network(
                      widget.item.data['issuer']['image'] is String
                          ? widget.item.data['issuer']['image']
                          : widget.item.data['issuer']['image']['id'],
                      height: MediaQuery.of(context).size.width * 0.25,
                    ),
                    const SizedBox(height: 16.0),
                  ],
                  DocumentItemWidget(
                    label: 'Issuer:',
                    value: widget.item.data['issuer']['name'],
                  ),
                  if (widget.item.data['issuer'].containsKey('url')) ...[
                    const SizedBox(height: 8.0),
                    DocumentItemWidget(
                      label: 'URL:',
                      value: widget.item.data['issuer']['url'],
                    ),
                  ],
                ],
              ),
            ),
          ),
          const SizedBox(height: 16.0),
          if (widget.item.data['credentialSubject'].containsKey('achievement'))
            Container(
              decoration: BaseBoxDecoration(
                color: UiKit.palette.credentialBackground,
                shapeColor: UiKit.palette.credentialDetail.withOpacity(0.2),
                value: 0.0,
                shapeSize: 256.0,
                anchors: <Alignment>[
                  Alignment.topRight,
                  Alignment.bottomCenter,
                ],
                // value: animation.value,
                borderRadius: BorderRadius.circular(20.0),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                    vertical: 20.0, horizontal: 20.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    if (widget.item.data['credentialSubject']['achievement']
                        .containsKey('image')) ...[
                      Image.network(
                        widget.item.data['credentialSubject']['achievement']
                                ['image'] is String
                            ? widget.item.data['credentialSubject']
                                ['achievement']['image']
                            : widget.item.data['credentialSubject']
                                ['achievement']['image']['id'],
                      ),
                      const SizedBox(height: 24.0),
                    ],
                    DocumentItemWidget(
                      label: 'Achievement Name:',
                      value: widget.item.data['credentialSubject']
                          ['achievement']['name'],
                    ),
                    const SizedBox(height: 24.0),
                    DocumentItemWidget(
                      label: 'Achievement Description:',
                      value: widget.item.data['credentialSubject']
                          ['achievement']['description'],
                    ),
                    const SizedBox(height: 24.0),
                    DocumentItemWidget(
                      label: 'Achievement Criteria:',
                      value: widget.item.data['credentialSubject']
                          ['achievement']['criteria']['narrative'],
                    ),
                  ],
                ),
              ),
            ),
          const SizedBox(height: 32.0),
          TextButton(
            style: TextButton.styleFrom(
              padding: const EdgeInsets.symmetric(
                horizontal: 32.0,
                vertical: 16.0,
              ),
            ),
            onPressed: () {
              final encoder = JsonEncoder.withIndent('  ');
              final data = encoder.convert(widget.item.data);
              Clipboard.setData(ClipboardData(text: data));
            },
            child: Text(
              'Copy Raw Credential',
              style: Theme.of(context).textTheme.bodyText1!,
            ),
          ),
          const SizedBox(height: 32.0),
          TextButton(
            style: TextButton.styleFrom(
              padding: const EdgeInsets.symmetric(
                horizontal: 32.0,
                vertical: 16.0,
              ),
            ),
            onPressed: delete,
            child: Text(
              localizations.credentialDetailDelete,
              style: Theme.of(context)
                  .textTheme
                  .bodyText1!
                  .apply(color: Colors.redAccent),
            ),
          ),
        ],
      ),
    );
  }
}

import 'dart:convert';

import 'package:credible/app/interop/didkit/didkit.dart';
import 'package:credible/app/pages/credentials/blocs/wallet.dart';
import 'package:credible/app/pages/credentials/models/credential.dart';
import 'package:credible/app/pages/credentials/models/verification_state.dart';
import 'package:credible/app/pages/credentials/widget/document.dart';
import 'package:credible/app/shared/ui/ui.dart';
import 'package:credible/app/shared/widget/back_leading_button.dart';
import 'package:credible/app/shared/widget/base/button.dart';
import 'package:credible/app/shared/widget/base/page.dart';
import 'package:credible/app/shared/widget/confirm_dialog.dart';
import 'package:credible/app/shared/widget/text_field_dialog.dart';
import 'package:credible/localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:logging/logging.dart';

class CredentialsDetail extends StatefulWidget {
  final CredentialModel item;

  const CredentialsDetail({
    Key? key,
    required this.item,
  }) : super(key: key);

  @override
  _CredentialsDetailState createState() => _CredentialsDetailState();
}

class _CredentialsDetailState
    extends ModularState<CredentialsDetail, WalletBloc> {
  bool showShareMenu = false;
  VerificationState verification = VerificationState.Unverified;

  final logger = Logger('credible/credentials/detail');

  @override
  void initState() {
    super.initState();
    verify();
  }

  void verify() async {
    final vcStr = jsonEncode(widget.item.data);
    final optStr = jsonEncode({'proofPurpose': 'assertionMethod'});
    final result =
        await DIDKitProvider.instance.verifyCredential(vcStr, optStr);
    final jsonResult = jsonDecode(result);

    if (jsonResult['warnings'].isNotEmpty) {
      setState(() {
        verification = VerificationState.VerifiedWithWarning;
      });
    } else if (jsonResult['errors'].isNotEmpty) {
      setState(() {
        verification = VerificationState.VerifiedWithError;
      });
    } else {
      setState(() {
        verification = VerificationState.Verified;
      });
    }
  }

  void delete() async {
    final confirm = await showDialog<bool>(
          context: context,
          builder: (BuildContext context) => ConfirmDialog(
            title: 'Do you really want to delete this credential?',
            yes: 'Yes',
            no: 'No',
          ),
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
      title: widget.item.alias ?? widget.item.id,
      titleTag: 'credential/${widget.item.alias ?? widget.item.id}/issuer',
      titleLeading: BackLeadingButton(),
      titleTrailing: IconButton(
        onPressed: _edit,
        icon: Icon(
          Icons.edit,
          color: UiKit.palette.icon,
        ),
      ),
      navigation: SafeArea(
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 24.0,
            vertical: 16.0,
          ),
          height: kBottomNavigationBarHeight * 1.75,
          child: Tooltip(
            message: localizations.credentialDetailShare,
            child: BaseButton.primary(
              onPressed: () {
                Modular.to.pushNamed(
                  '/qr-code/display',
                  arguments: [
                    widget.item.id,
                    widget.item.id,
                  ],
                );
              },
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  SvgPicture.asset(
                    'assets/icon/qr-code.svg',
                    width: 24.0,
                    height: 24.0,
                    color: UiKit.palette.icon,
                  ),
                  const SizedBox(width: 16.0),
                  Text(localizations.credentialDetailShare),
                ],
              ),
            ),
          ),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          DocumentWidget(
            model: DocumentWidgetModel.fromCredentialModel(widget.item),
          ),
          const SizedBox(height: 64.0),
          if (verification == VerificationState.Unverified)
            Center(child: CircularProgressIndicator())
          else ...<Widget>[
            Center(
              child: Text(
                'Verification Status',
                style: Theme.of(context).textTheme.overline!,
              ),
            ),
            const SizedBox(height: 8.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  verification.icon,
                  color: verification.color,
                ),
                const SizedBox(width: 8.0),
                Text(
                  verification.message,
                  style: Theme.of(context)
                      .textTheme
                      .caption!
                      .apply(color: verification.color),
                ),
              ],
            ),
          ],
          const SizedBox(height: 64.0),
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
          const SizedBox(height: 16.0),
        ],
      ),
    );
  }
}

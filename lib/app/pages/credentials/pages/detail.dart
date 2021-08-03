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
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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

  @override
  Widget build(BuildContext context) {
    // TODO: Add proper localization
    final localizations = AppLocalizations.of(context)!;

    return BasePage(
      title: widget.item.issuer,
      titleTag: 'credential/${widget.item.id}/issuer',
      titleLeading: BackLeadingButton(),
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
                localizations.credentialDetailStatus,
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

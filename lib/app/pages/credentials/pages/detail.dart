import 'dart:convert';

import 'package:credible/app/pages/credentials/models/credential.dart';
import 'package:credible/app/pages/credentials/widget/document.dart';
import 'package:credible/app/shared/palette.dart';
import 'package:credible/app/shared/widget/back_leading_button.dart';
import 'package:credible/app/shared/widget/base/button.dart';
import 'package:credible/app/shared/widget/base/page.dart';
import 'package:credible/app/shared/widget/navigation_bar.dart';
import 'package:credible/localizations.dart';
import 'package:didkit/didkit.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CredentialsDetail extends StatefulWidget {
  final CredentialModel item;

  const CredentialsDetail({
    Key? key,
    required this.item,
  }) : super(key: key);

  @override
  _CredentialsDetailState createState() => _CredentialsDetailState();
}

enum VerificationState {
  Unverified,
  Verified,
  VerifiedWithWarning,
  VerifiedWithError,
}

class _CredentialsDetailState extends State<CredentialsDetail> {
  bool showShareMenu = false;
  VerificationState verified = VerificationState.Unverified;

  @override
  void initState() {
    super.initState();
    verify();
  }

  void verify() async {
    final vcStr = jsonEncode(widget.item.data);
    final optStr = jsonEncode({'proofPurpose': 'assertionMethod'});
    final verification = await DIDKit.verifyCredential(vcStr, optStr);
    final jsonVerification = jsonDecode(verification);

    if (jsonVerification['warnings'].isNotEmpty) {
      setState(() {
        verified = VerificationState.VerifiedWithWarning;
      });
    } else if (jsonVerification['errors'].isNotEmpty) {
      setState(() {
        verified = VerificationState.VerifiedWithError;
      });
    } else {
      setState(() {
        verified = VerificationState.Verified;
      });
    }
  }

  String verifyMessage(VerificationState verify) {
    switch (verify) {
      case VerificationState.Unverified:
        return 'Verifying...';
      case VerificationState.Verified:
        return 'Verified';
      case VerificationState.VerifiedWithWarning:
        return 'Verified (with warnings)';
      case VerificationState.VerifiedWithError:
        return 'Failed verification';
    }
  }

  IconData verifyIcon(VerificationState verify) {
    switch (verify) {
      case VerificationState.Unverified:
        return Icons.refresh;
      case VerificationState.Verified:
        return Icons.check_circle_outline;
      case VerificationState.VerifiedWithWarning:
        return Icons.warning_amber_outlined;
      case VerificationState.VerifiedWithError:
        return Icons.error_outline;
    }
  }

  Color verifyColor(VerificationState verify) {
    switch (verify) {
      case VerificationState.Unverified:
        return Colors.black;
      case VerificationState.Verified:
        return Colors.green;
      case VerificationState.VerifiedWithWarning:
        return Colors.orange;
      case VerificationState.VerifiedWithError:
        return Colors.red;
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
      navigation: CustomNavBar(index: 0),
      body: SingleChildScrollView(
        padding: EdgeInsets.zero,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: DocumentWidget(
                item: widget.item,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Tooltip(
                message: localizations.credentialDetailShare,
                child: BaseButton.transparent(
                  borderColor: Palette.blue,
                  onPressed: () {
                    Modular.to.pushNamed(
                      '/qr-code/display',
                      arguments: widget.item.id,
                    );
                  },
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      SvgPicture.asset(
                        'assets/icon/qr-code.svg',
                        width: 24.0,
                        height: 24.0,
                        color: Palette.blue,
                      ),
                      const SizedBox(width: 16.0),
                      Text(
                        localizations.credentialDetailShare,
                        style: Theme.of(context)
                            .textTheme
                            .button!
                            .apply(color: Palette.blue),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 64.0),
            if (verified == VerificationState.Unverified)
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
                    verifyIcon(verified),
                    color: verifyColor(verified),
                  ),
                  const SizedBox(width: 8.0),
                  Text(
                    verifyMessage(verified),
                    style: Theme.of(context)
                        .textTheme
                        .caption!
                        .apply(color: verifyColor(verified)),
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
              onPressed: () {
                // TODO implement deletion
              },
              child: Text(
                localizations.credentialDetailDelete,
                style: Theme.of(context)
                    .textTheme
                    .bodyText1!
                    .apply(color: Palette.greenGrey),
              ),
            ),
            const SizedBox(height: 16.0),
          ],
        ),
      ),
    );
  }
}

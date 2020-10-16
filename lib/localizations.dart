import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'l10n/messages_all.dart';

class AppLocalizations {
  AppLocalizations();

  static const AppLocalizationsDelegate delegate = AppLocalizationsDelegate();

  static Future<AppLocalizations> load(Locale locale) {
    final name =
        locale.countryCode.isEmpty ? locale.languageCode : locale.toString();
    final localeName = Intl.canonicalizedLocale(name);
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      return AppLocalizations();
    });
  }

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  String get appTitle => Intl.message(
        'Credible',
        name: 'appTitle',
        desc: 'App title',
      );

  String get genericError => Intl.message(
        'An error has occurred!',
        name: 'genericError',
        desc: 'Generic error message',
      );

  String get onBoardingStartSubtitle => Intl.message(
        'Lorem ipsum dolor sit amet, consectetur adipiscing elit.',
        name: 'onBoardingStartSubtitle',
        desc: 'On boarding start page subtitle',
      );

  String get onBoardingStartButton => Intl.message(
        "Let's Start",
        name: 'onBoardingStartButton',
        desc: 'On boarding start page button text',
      );

  String get onBoardingTosTitle => Intl.message(
        'Terms & Conditions',
        name: 'onBoardingTosTitle',
        desc: 'On boarding terms and conditions page title',
      );

  String get onBoardingTosButton => Intl.message(
        'Accept',
        name: 'onBoardingTosButton',
        desc: 'On boarding terms and conditions page button text',
      );

  String get onBoardingGenTitle => Intl.message(
        'Private Key Generation',
        name: 'onBoardingGenTitle',
        desc: 'On boarding private key generation page title',
      );

  String get onBoardingGenButton => Intl.message(
        'Generate',
    name: 'onBoardingGenButton',
    desc: 'On boarding private key generation page button text',
  );

  String get onBoardingSuccessTitle =>
      Intl.message(
        'Identity created!',
        name: 'onBoardingSuccessTitle',
        desc: 'On boarding success page title',
      );

  String get onBoardingSuccessButton =>
      Intl.message(
        'Continue',
        name: 'onBoardingSuccessButton',
        desc: 'On boarding success page button text',
      );

  String get credentialDetailShare =>
      Intl.message(
        'Share by QR code',
        name: 'credentialDetailShare',
        desc: 'Share action on credential detail page',
      );

  String get credentialDetailDelete =>
      Intl.message(
        'Delete credential',
        name: 'credentialDetailDelete',
        desc: 'Delete action on credential detail page',
      );

  String get credentialDetailCopyFieldValue =>
      Intl.message(
        'Copied field value to clipboard!',
        name: 'credentialDetailCopyFieldValue',
        desc: 'Copy field value action on credential detail page',
      );

  String get credentialPresentConfirm =>
      Intl.message(
        'Yes, please!',
        name: 'credentialPresentConfirm',
        desc: 'Confirm action on credential presentation',
      );

  String get credentialPresentCancel =>
      Intl.message(
        'Not now',
        name: 'credentialPresentCancel',
        desc: 'Cancel action on credential presentation',
      );

  String get credentialReceiveConfirm =>
      Intl.message(
        'Add to wallet',
        name: 'credentialReceiveConfirm',
        desc: 'Confirm action on credential reception',
      );

  String get credentialReceiveCancel =>
      Intl.message(
        'Not for now',
        name: 'credentialReceiveCancel',
        desc: 'Cancel action on credential reception',
      );

  String get credentialListTitle =>
      Intl.message(
        'My wallet',
        name: 'credentialListTitle',
        desc: 'Title for the Credentials List Page',
      );

  String credentialDetailIssuedBy(String issuer) =>
      Intl.message('issued by {issuer}',
          name: 'credentialDetailIssuedBy',
          desc: 'Credential issuer on detail page',
          args: [issuer]);

  String get listActionRefresh => Intl.message(
        'Refresh',
        name: 'listActionRefresh',
        desc: 'List action button to refresh the content',
      );

  String get listActionViewList => Intl.message(
        'View as list',
        name: 'listActionViewList',
        desc: 'List action button to set view to list mode',
      );

  String get listActionViewGrid => Intl.message(
        'View as grid',
        name: 'listActionViewGrid',
        desc: 'List action button to set view to grid mode',
      );

  String get listActionFilter => Intl.message(
        'Filter',
        name: 'listActionFilter',
        desc: 'List action button to open filter options',
      );

  String get listActionSort => Intl.message(
        'Sort',
        name: 'listActionSort',
        desc: 'List action button to open sort options',
      );
}

class AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const AppLocalizationsDelegate();

  List<Locale> get supportedLocales =>
      const <Locale>[
        Locale('en', ''),
        Locale('pt', 'BR'),
      ];

  @override
  bool isSupported(Locale locale) => _isSupported(locale);

  @override
  Future<AppLocalizations> load(Locale locale) => AppLocalizations.load(locale);

  @override
  bool shouldReload(AppLocalizationsDelegate old) => false;

  bool _isSupported(Locale locale) {
    if (locale != null) {
      for (final supportedLocale in supportedLocales) {
        if (supportedLocale.languageCode == locale.languageCode) {
          return true;
        }
      }
    }
    return false;
  }
}

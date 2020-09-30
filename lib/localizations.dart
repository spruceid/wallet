import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'l10n/messages_all.dart';

class AppLocalizations {
  AppLocalizations();

  static const AppLocalizationsDelegate delegate = AppLocalizationsDelegate();

  static Future<AppLocalizations> load(Locale locale) {
    final String name =
        locale.countryCode.isEmpty ? locale.languageCode : locale.toString();
    final String localeName = Intl.canonicalizedLocale(name);
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      return AppLocalizations();
    });
  }

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  String get genericError {
    return Intl.message(
      'An error has occurred!',
      name: 'genericError',
      desc: 'Generic error message',
    );
  }

  String get credentialListTitle {
    return Intl.message(
      'Credentials',
      name: 'credentialListTitle',
      desc: 'Title for the Credentials List Page',
    );
  }

  String credentialDetailIssuedBy(String issuer) {
    return Intl.message('issued by {issuer}',
        name: 'credentialDetailIssuedBy',
        desc: 'Credential issuer on detail page',
        args: [issuer]);
  }

  String get listActionRefresh {
    return Intl.message(
      'Refresh',
      name: 'listActionRefresh',
      desc: 'List action button to refresh the content',
    );
  }

  String get listActionViewList {
    return Intl.message(
      'View as list',
      name: 'listActionViewList',
      desc: 'List action button to set view to list mode',
    );
  }

  String get listActionViewGrid {
    return Intl.message(
      'View as grid',
      name: 'listActionViewGrid',
      desc: 'List action button to set view to grid mode',
    );
  }

  String get listActionFilter {
    return Intl.message(
      'Filter',
      name: 'listActionFilter',
      desc: 'List action button to open filter options',
    );
  }

  String get listActionSort {
    return Intl.message(
      'Sort',
      name: 'listActionSort',
      desc: 'List action button to open sort options',
    );
  }
}

class AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const AppLocalizationsDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale('en', ''),
      Locale('pt', 'BR'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);

  @override
  Future<AppLocalizations> load(Locale locale) => AppLocalizations.load(locale);

  @override
  bool shouldReload(AppLocalizationsDelegate old) => false;

  bool _isSupported(Locale locale) {
    if (locale != null) {
      for (Locale supportedLocale in supportedLocales) {
        if (supportedLocale.languageCode == locale.languageCode) {
          return true;
        }
      }
    }
    return false;
  }
}

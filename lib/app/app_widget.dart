import 'package:credible/app/shared/ui/ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class AppWidget extends StatelessWidget {
  ThemeData get _themeData {
    final themeData = ThemeData(
      brightness: Brightness.light,
      backgroundColor: UiKit.palette.background,
      primaryColor: UiKit.palette.primary,
      // ignore: deprecated_member_use
      accentColor: UiKit.palette.accent,
      textTheme: UiKit.text.textTheme,
    );

    return themeData;
  }

  @override
  Widget build(BuildContext context) => MaterialApp(
        title: 'Credible',
        initialRoute: '/splash',
        theme: _themeData,
        localizationsDelegates: [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const <Locale>[
          Locale('en', ''),
          Locale('pt', 'BR'),
          Locale('fr', ''),
        ],
      ).modular();
}

import 'package:credible/app/shared/palette.dart';
import 'package:credible/localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:google_fonts/google_fonts.dart';

class AppWidget extends StatelessWidget {
  ThemeData get _themeData {
    final themeData = ThemeData(
      brightness: Brightness.light,
      backgroundColor: Palette.background,
      primaryColor: Palette.primary,
      accentColor: Palette.brand,
      textTheme: TextTheme(
        subtitle1: GoogleFonts.poppins(
          color: Palette.text,
          fontSize: 18.0,
          fontWeight: FontWeight.w600,
        ),
        subtitle2: GoogleFonts.poppins(
          color: Palette.text,
          fontSize: 16.0,
          fontWeight: FontWeight.w600,
        ),
        bodyText1: GoogleFonts.montserrat(
          color: Palette.text,
          fontSize: 14.0,
          fontWeight: FontWeight.normal,
        ),
        bodyText2: GoogleFonts.montserrat(
          fontSize: 12.0,
          color: Palette.text,
          fontWeight: FontWeight.normal,
        ),
        button: GoogleFonts.montserrat(
          fontSize: 14.0,
          color: Palette.text,
        ),
        overline: GoogleFonts.montserrat(
          fontSize: 10.0,
          color: Palette.text,
        ),
        caption: GoogleFonts.montserrat(
          fontSize: 14.0,
          color: Colors.black,
          fontWeight: FontWeight.w600,
        ),
      ),
    );

    return themeData;
  }

  @override
  Widget build(BuildContext context) => MaterialApp(
        initialRoute: "/splash",
        navigatorKey: Modular.navigatorKey,
        onGenerateRoute: Modular.generateRoute,
        theme: _themeData,
        localizationsDelegates: [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
        ],
        supportedLocales: AppLocalizations.delegate.supportedLocales,
      );
}

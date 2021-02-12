import 'package:credible/app/pages/on_boarding/start.dart';
import 'package:credible/localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';

MaterialApp _appWithHomeScreen(final WidgetTester tester) {
  return MaterialApp(
    localizationsDelegates: [
      AppLocalizationsDelegate(),
      GlobalMaterialLocalizations.delegate,
      GlobalWidgetsLocalizations.delegate,
    ],
    supportedLocales: AppLocalizations.delegate.supportedLocales,
    home: Material(
      child: Builder(
        builder: (final BuildContext context) => OnBoardingStartPage(),
      ),
    ),
  );
}

void main() {
  testWidgets(
    'should start',
    (final WidgetTester tester) async {
      await tester.pumpWidget(_appWithHomeScreen(tester));
    },
  );
}

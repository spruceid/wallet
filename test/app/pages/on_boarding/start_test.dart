import 'package:credible/app/pages/on_boarding/start.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';

MaterialApp _appWithHomeScreen(final WidgetTester tester) {
  return MaterialApp(
    localizationsDelegates: [
      GlobalCupertinoLocalizations.delegate,
      GlobalMaterialLocalizations.delegate,
      GlobalWidgetsLocalizations.delegate,
    ],
    supportedLocales: const <Locale>[
      Locale('en', ''),
      Locale('pt', 'BR'),
      Locale('fr', ''),
    ],
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

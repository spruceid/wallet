import 'package:credible/app/shared/ui/ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:local_auth/local_auth.dart';
import 'package:provider/provider.dart';
import 'package:secure_application/secure_application.dart';

class AppLockProvider {
  final Future<void> Function() fn;

  AppLockProvider(this.fn);
}

class AppWidget extends StatefulWidget {
  @override
  State<AppWidget> createState() => _AppWidgetState();
}

class _AppWidgetState extends State<AppWidget> {
  late SecureApplicationController _controller;

  ThemeData get _themeData {
    final themeData = ThemeData(
      brightness: Brightness.light,
      textTheme: UiKit.text.textTheme,
      colorScheme: ColorScheme.light(
        primary: UiKit.palette.primary,
        secondary: UiKit.palette.accent,
        background: UiKit.palette.background,
      ),
    );

    return themeData;
  }

  @override
  void initState() {
    super.initState();
    _controller = SecureApplicationController(SecureApplicationState());
    _controller.secure();
  }

  Future<bool> _authenticate() async {
    final auth = LocalAuthentication();

    return await auth.authenticate(
      localizedReason: 'Please authenticate to use Credible',
      options: const AuthenticationOptions(
        useErrorDialogs: true,
        stickyAuth: true,
      ),
    );
  }

  Future<void> _unlockOnLoad() async {
    _controller.lock();
    if (await _authenticate()) {
      _controller.unlock();
    }
  }

  Future<SecureApplicationAuthenticationStatus> _unlock(
    SecureApplicationController? controller,
  ) async {
    if (await _authenticate()) {
      controller?.authSuccess(unlock: true);
      return SecureApplicationAuthenticationStatus.SUCCESS;
    }

    controller?.authFailed();
    await SystemChannels.platform.invokeMethod('SystemNavigator.pop');
    return SecureApplicationAuthenticationStatus.FAILED;
  }

  @override
  Widget build(BuildContext context) {
    Modular.setInitialRoute('/splash');

    return MaterialApp.router(
      title: 'Credible',
      theme: _themeData,
      routeInformationParser: Modular.routeInformationParser,
      routerDelegate: Modular.routerDelegate,
      builder: (BuildContext context, Widget? child) => Provider(
        create: (_) => AppLockProvider(_unlockOnLoad),
        child: SecureApplication(
          secureApplicationController: _controller,
          nativeRemoveDelay: 250,
          onNeedUnlock: _unlock,
          child: SecureGate(
            blurr: 5,
            opacity: 0.75,
            child: child ?? Container(),
          ),
        ),
      ),
      localizationsDelegates: [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const <Locale>[
        Locale('en', ''),
        Locale('fr', ''),
      ],
    );
  }
}

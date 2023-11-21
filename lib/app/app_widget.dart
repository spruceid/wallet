import 'package:credible/app/pages/tap_to_unlock.dart';
import 'package:credible/app/shared/ui/ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:local_auth/local_auth.dart';
import 'package:provider/provider.dart';
import 'package:secure_application/secure_application.dart';

class AppLockProvider {
  final Future<void> Function() lock;
  final Future<void> Function() pause;
  final Future<void> Function() unpause;

  AppLockProvider(
    this.lock,
    this.pause,
    this.unpause,
  );
}

class AppWidget extends StatefulWidget {
  @override
  State<AppWidget> createState() => _AppWidgetState();
}

class _AppWidgetState extends State<AppWidget> with WidgetsBindingObserver {
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
  void dispose() {
    WidgetsBinding.instance.addObserver(this);

    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _controller = SecureApplicationController(SecureApplicationState());
    _controller.secure();
  }

  Future<bool> _authenticate() async {
    final auth = LocalAuthentication();
    final bool first_authorization;

    // Do not show auth dialog when already unlocked.
    if (!_controller.locked) {
      return true;
    }

    first_authorization = await auth.authenticate(
      localizedReason: 'Please authenticate to use SpruceKit Wallet',
      options: const AuthenticationOptions(
        useErrorDialogs: true,
        // DO NOT ENABLE: Causes problems on Samsung phones.
        stickyAuth: false,
      ),
    );

    // Unlock the app if user auth successfully.
    if (first_authorization) {
      _controller.unlock();
    }

    if (first_authorization) return true;

    return false;
  }

  // Do nothing.
  Future<void> _unlockOnLoad() async {}

  // Triggered by a button in the lock view.
  Future<void> _manualUnlock() async {
    await _authenticate();
  }

  // Do nothing.
  Future<void> _pauseIfUnlocked() async {}

  // Unlock the app so that doc scan and liveness scan don't
  // prompt for auth.
  Future<void> _unpauseIfUnlocked() async {
    _controller.unlock();
  }

  // Triggered every time app comes back from background.
  Future<SecureApplicationAuthenticationStatus> _unlock(
    SecureApplicationController? controller,
  ) async {
    return SecureApplicationAuthenticationStatus.FAILED;
  }

  @override
  Widget build(BuildContext context) {
    Modular.setInitialRoute('/splash');

    return MaterialApp.router(
      title: 'SpruceKit',
      theme: _themeData,
      routeInformationParser: Modular.routeInformationParser,
      routerDelegate: Modular.routerDelegate,
      builder: (BuildContext context, Widget? child) => Provider(
        create: (_) => AppLockProvider(
          _unlockOnLoad,
          _pauseIfUnlocked,
          _unpauseIfUnlocked,
        ),
        child: SecureApplication(
          secureApplicationController: _controller,
          nativeRemoveDelay: 250,
          onNeedUnlock: _unlock,
          child: SecureGate(
            blurr: 5,
            opacity: 0.75,
            lockedBuilder: (context, controller) => TapToUnlockPage(
              authenticate: _manualUnlock,
            ),
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

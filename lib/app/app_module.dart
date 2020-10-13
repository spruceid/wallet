import 'package:credible/app/app_widget.dart';
import 'package:credible/app/pages/credentials/module.dart';
import 'package:credible/app/pages/on_boarding/module.dart';
import 'package:credible/app/pages/qr_code.dart';
import 'package:credible/app/pages/splash.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

class AppModule extends MainModule {
  @override
  List<Bind> get binds => [];

  @override
  List<ModularRouter> get routers => [
        ModularRouter(
          "/splash",
          child: (context, args) => SplashPage(),
          transition: TransitionType.fadeIn,
        ),
        ModularRouter(
          "/on-boarding",
          module: OnBoardingModule(),
          transition: TransitionType.fadeIn,
        ),
        ModularRouter(
          "/credentials",
          module: CredentialsModule(),
          transition: TransitionType.fadeIn,
        ),
        ModularRouter(
          "/qr-code",
          child: (context, args) => QrCodePage(data: args.data),
          transition: TransitionType.rightToLeftWithFade,
        )
      ];

  @override
  Widget get bootstrap => AppWidget();
}

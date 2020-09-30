import 'package:credible/app/app_widget.dart';
import 'package:credible/app/pages/credentials/module.dart';
import 'package:credible/app/pages/qrcode.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

class AppModule extends MainModule {
  @override
  List<Bind> get binds => [];

  @override
  List<ModularRouter> get routers => [
        ModularRouter(
          "/credentials",
          module: CredentialsModule(),
          transition: TransitionType.fadeIn,
        ),
        ModularRouter(
          "/qrcode",
          child: (context, args) => QrCodePage(data: args.data),
          transition: TransitionType.rightToLeftWithFade,
        )
      ];

  @override
  Widget get bootstrap => AppWidget();
}

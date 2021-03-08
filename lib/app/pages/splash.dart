import 'dart:convert';

import 'package:credible/app/interop/chapi/chapi.dart';
import 'package:credible/app/interop/didkit/didkit.dart';
import 'package:credible/app/interop/secure_storage/secure_storage.dart';
import 'package:credible/app/pages/credentials/blocs/scan.dart';
import 'package:credible/app/shared/ui/ui.dart';
import 'package:credible/app/shared/widget/base/page.dart';
import 'package:credible/app/shared/widget/brand.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

class SplashPage extends StatefulWidget {
  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();

    Future.delayed(
      const Duration(
        milliseconds: kIsWeb ? 25 : 1000,
      ),
      () async {
        print(DIDKitProvider.instance.getVersion());

        final key = await SecureStorageProvider.instance.get('key') ?? '';

        if (key.isEmpty) {
          await Modular.to.pushReplacementNamed('/on-boarding');
          return;
        }

        await Modular.to.pushReplacementNamed('/credentials');
      },
    );
  }

  @override
  Widget build(BuildContext context) => BasePage(
        backgroundGradient: UiKit.palette.splashBackground,
        scrollView: false,
        body: Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.all(24.0),
          child: BrandMinimal(),
        ),
      );
}

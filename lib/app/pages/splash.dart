import 'package:credible/app/shared/palette.dart';
import 'package:credible/app/shared/widget/brand.dart';
import 'package:didkit/didkit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
        seconds: 2,
      ),
      () async {
        final version = await DIDKit.getVersion();
        print('DIDKit v$version');

        final storage = FlutterSecureStorage();

        final key = await storage.read(key: 'key') ?? '';

        print(key);

        if (key.isEmpty) {
          await Modular.to.pushReplacementNamed('/on-boarding');
          return;
        }

        await Modular.to.pushReplacementNamed('/credentials');
      },
    );
  }

  @override
  Widget build(BuildContext context) => SafeArea(
        child: Scaffold(
          body: Container(
            alignment: Alignment.center,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: <Color>[
                  Palette.blue,
                  Palette.gradientBlue,
                ],
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: BrandMinimal(),
            ),
          ),
        ),
      );
}

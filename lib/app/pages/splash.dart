import 'package:credible/app/shared/widget/brand.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashPage extends StatefulWidget {
  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    asyncInit();
  }

  void asyncInit() async {
    final prefs = await SharedPreferences.getInstance();
    final onBoard = prefs.getBool('on-board') ?? false;

    await Future.delayed(Duration(
      seconds: 2,
    ));

    if (onBoard) {
      await Modular.to.pushReplacementNamed('/credentials');
    } else {
      await Modular.to.pushReplacementNamed('/on-boarding');
    }
  }

  @override
  Widget build(BuildContext context) => SafeArea(
        child: Scaffold(
          body: Center(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Brand(),
            ),
          ),
        ),
      );
}

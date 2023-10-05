import 'package:credible/app/app_module.dart';
import 'package:credible/app/app_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

Future<void> main() async {
  runApp(ModularApp(
    module: AppModule(),
    child: AppWidget(),
  ));
}

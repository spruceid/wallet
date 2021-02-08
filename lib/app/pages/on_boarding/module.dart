import 'package:credible/app/pages/on_boarding/gen.dart';
import 'package:credible/app/pages/on_boarding/gen_phrase.dart';
import 'package:credible/app/pages/on_boarding/key.dart';
import 'package:credible/app/pages/on_boarding/recovery.dart';
import 'package:credible/app/pages/on_boarding/start.dart';
import 'package:credible/app/pages/on_boarding/success.dart';
import 'package:credible/app/pages/on_boarding/tos.dart';
import 'package:flutter_modular/flutter_modular.dart';

class OnBoardingModule extends Module {
  @override
  List<Bind> get binds => [];

  @override
  List<ModularRoute> get routes => [
        ChildRoute(
          '/start',
          child: (context, args) => OnBoardingStartPage(),
          transition: TransitionType.rightToLeftWithFade,
        ),
        ChildRoute(
          '/tos',
          child: (context, args) => OnBoardingTosPage(),
          transition: TransitionType.rightToLeftWithFade,
        ),
        ChildRoute(
          '/key',
          child: (context, args) => OnBoardingKeyPage(),
          transition: TransitionType.rightToLeftWithFade,
        ),
        ChildRoute(
          '/recovery',
          child: (context, args) => OnBoardingRecoveryPage(),
          transition: TransitionType.rightToLeftWithFade,
        ),
        ChildRoute(
          '/gen-phrase',
          child: (context, args) => OnBoardingGenPhrasePage(),
          transition: TransitionType.rightToLeftWithFade,
        ),
        ChildRoute(
          '/gen',
          child: (context, args) => OnBoardingGenPage(),
          transition: TransitionType.rightToLeftWithFade,
        ),
        ChildRoute(
          '/success',
          child: (context, args) => OnBoardingSuccessPage(),
          transition: TransitionType.rightToLeftWithFade,
        ),
      ];
}

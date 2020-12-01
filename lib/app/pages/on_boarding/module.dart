import 'package:credible/app/pages/on_boarding/gen.dart';
import 'package:credible/app/pages/on_boarding/start.dart';
import 'package:credible/app/pages/on_boarding/success.dart';
import 'package:credible/app/pages/on_boarding/tos.dart';
import 'package:flutter_modular/flutter_modular.dart';

class OnBoardingModule extends ChildModule {
  static Inject get to => Inject<OnBoardingModule>.of();

  @override
  List<Bind> get binds => [];

  @override
  List<ModularRouter> get routers => [
        ModularRouter(
          '/start',
          child: (context, args) => OnBoardingStartPage(),
          transition: TransitionType.rightToLeftWithFade,
        ),
        ModularRouter(
          '/tos',
          child: (context, args) => OnBoardingTosPage(),
          transition: TransitionType.rightToLeftWithFade,
        ),
        ModularRouter(
          '/gen',
          child: (context, args) => OnBoardingGenPage(),
          transition: TransitionType.rightToLeftWithFade,
        ),
        ModularRouter(
          '/success',
          child: (context, args) => OnBoardingSuccessPage(),
          transition: TransitionType.rightToLeftWithFade,
        ),
      ];
}

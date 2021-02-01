import 'package:credible/app/pages/profile/blocs/did.dart';
import 'package:credible/app/pages/profile/blocs/profile.dart';
import 'package:credible/app/pages/profile/pages/notices.dart';
import 'package:credible/app/pages/profile/pages/personal.dart';
import 'package:credible/app/pages/profile/pages/privacy.dart';
import 'package:credible/app/pages/profile/pages/recovery.dart';
import 'package:credible/app/pages/profile/pages/support.dart';
import 'package:credible/app/pages/profile/pages/terms.dart';
import 'package:credible/app/pages/profile/profile.dart';
import 'package:flutter_modular/flutter_modular.dart';

class ProfileModule extends ChildModule {
  static Inject get to => Inject<ProfileModule>.of();

  @override
  List<Bind> get binds => [
        Bind((i) => ProfileBloc()),
        Bind((i) => DIDBloc()),
      ];

  @override
  List<ModularRouter> get routers => [
        ModularRouter(
          '/',
          child: (context, args) => ProfilePage(),
          transition: TransitionType.fadeIn,
        ),
        ModularRouter(
          '/personal',
          child: (context, args) => PersonalPage(profile: args.data),
          transition: TransitionType.rightToLeftWithFade,
        ),
        ModularRouter(
          '/privacy',
          child: (context, args) => PrivacyPage(),
          transition: TransitionType.rightToLeftWithFade,
        ),
        ModularRouter(
          '/terms',
          child: (context, args) => TermsPage(),
          transition: TransitionType.rightToLeftWithFade,
        ),
        ModularRouter(
          '/recovery',
          child: (context, args) => RecoveryPage(),
          transition: TransitionType.rightToLeftWithFade,
        ),
        ModularRouter(
          '/support',
          child: (context, args) => SupportPage(),
          transition: TransitionType.rightToLeftWithFade,
        ),
        ModularRouter(
          '/notices',
          child: (context, args) => NoticesPage(),
          transition: TransitionType.rightToLeftWithFade,
        ),
      ];
}

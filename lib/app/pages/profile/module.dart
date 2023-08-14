import 'package:credible/app/pages/profile/blocs/config.dart';
import 'package:credible/app/pages/profile/blocs/did.dart';
import 'package:credible/app/pages/profile/blocs/profile.dart';
import 'package:credible/app/pages/profile/pages/config.dart';
import 'package:credible/app/pages/profile/pages/notices.dart';
import 'package:credible/app/pages/profile/pages/personal.dart';
import 'package:credible/app/pages/profile/pages/privacy.dart';
import 'package:credible/app/pages/profile/pages/recovery.dart';
import 'package:credible/app/pages/profile/pages/support.dart';
import 'package:credible/app/pages/profile/pages/terms.dart';
import 'package:credible/app/pages/profile/profile.dart';
import 'package:flutter_modular/flutter_modular.dart';

class ProfileModule extends Module {
  @override
  List<Bind> get binds => [
        Bind((i) => ProfileBloc()),
        Bind((i) => ConfigBloc()),
        Bind((i) => DIDBloc()),
      ];

  @override
  List<ModularRoute> get routes => [
        ChildRoute(
          '/',
          child: (context, args) => ProfilePage(),
          transition: TransitionType.fadeIn,
        ),
        ChildRoute(
          '/personal',
          child: (context, args) => PersonalPage(profile: args.data),
          transition: TransitionType.rightToLeftWithFade,
        ),
        ChildRoute(
          '/config',
          child: (context, args) => ConfigPage(),
          transition: TransitionType.rightToLeftWithFade,
        ),
        ChildRoute(
          '/privacy',
          child: (context, args) => PrivacyPage(),
          transition: TransitionType.rightToLeftWithFade,
        ),
        ChildRoute(
          '/terms',
          child: (context, args) => TermsPage(),
          transition: TransitionType.rightToLeftWithFade,
        ),
        ChildRoute(
          '/recovery',
          child: (context, args) => RecoveryPage(),
          transition: TransitionType.rightToLeftWithFade,
        ),
        ChildRoute(
          '/support',
          child: (context, args) => SupportPage(),
          transition: TransitionType.rightToLeftWithFade,
        ),
        ChildRoute(
          '/notices',
          child: (context, args) => NoticesPage(),
          transition: TransitionType.rightToLeftWithFade,
        ),
      ];
}

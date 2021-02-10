import 'package:credible/app/pages/credentials/pages/detail.dart';
import 'package:credible/app/pages/credentials/pages/grid.dart';
import 'package:credible/app/pages/credentials/pages/list.dart';
import 'package:credible/app/pages/credentials/pick.dart';
import 'package:credible/app/pages/credentials/present.dart';
import 'package:credible/app/pages/credentials/receive.dart';
import 'package:credible/app/pages/credentials/stream.dart';
import 'package:flutter_modular/flutter_modular.dart';

class CredentialsModule extends Module {
  @override
  List<Bind> get binds => [];

  @override
  List<ModularRoute> get routes => [
        ChildRoute(
          '/list',
          child: (context, args) => CredentialsStream(
            child: (context, items) => CredentialsList(items: items),
          ),
          transition: TransitionType.fadeIn,
        ),
        ChildRoute(
          '/grid',
          child: (context, args) => CredentialsStream(
            child: (context, items) => CredentialsGrid(items: items),
          ),
          transition: TransitionType.fadeIn,
        ),
        ChildRoute(
          '/detail',
          child: (context, args) => CredentialsDetail(item: args!.data),
          transition: TransitionType.rightToLeftWithFade,
        ),
        ChildRoute(
          '/receive',
          child: (context, args) => CredentialsReceivePage(url: args!.data),
          transition: TransitionType.rightToLeftWithFade,
        ),
        ChildRoute(
          '/present',
          child: (context, args) => CredentialsPresentPage(url: args!.data),
          transition: TransitionType.rightToLeftWithFade,
        ),
        ChildRoute(
          '/pick',
          child: (context, args) => CredentialsStream(
            child: (context, items) => CredentialsPickPage(
              items: items,
              params: args!.data,
            ),
          ),
          transition: TransitionType.rightToLeftWithFade,
        ),
      ];
}

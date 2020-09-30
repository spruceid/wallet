import 'package:credible/app/pages/credentials/bloc.dart';
import 'package:credible/app/pages/credentials/detail.dart';
import 'package:credible/app/pages/credentials/grid.dart';
import 'package:credible/app/pages/credentials/list.dart';
import 'package:credible/app/pages/credentials/repositories/credential.dart';
import 'package:credible/app/pages/credentials/stream.dart';
import 'package:dio/dio.dart';
import 'package:flutter_modular/flutter_modular.dart';

class CredentialsModule extends ChildModule {
  static Inject get to => Inject<CredentialsModule>.of();

  @override
  List<Bind> get binds => [
        Bind((i) => CredentialsBloc(i.get())),
        Bind((i) => CredentialsRepository(i.get())),
        Bind((i) => Dio()),
      ];

  @override
  List<ModularRouter> get routers => [
        ModularRouter(
          "/list",
          child: (context, args) => CredentialsStream(
            child: (context, items) => CredentialsList(items: items),
          ),
          transition: TransitionType.fadeIn,
        ),
        ModularRouter(
          "/grid",
          child: (context, args) => CredentialsStream(
            child: (context, items) => CredentialsGrid(items: items),
          ),
          transition: TransitionType.fadeIn,
        ),
        ModularRouter(
          "/detail",
          child: (context, args) => CredentialsDetail(item: args.data),
          transition: TransitionType.rightToLeftWithFade,
        ),
      ];
}

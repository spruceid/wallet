import 'package:credible/app/pages/credentials/blocs/wallet.dart';
import 'package:credible/app/pages/credentials/pages/detail.dart';
import 'package:credible/app/pages/credentials/pages/grid.dart';
import 'package:credible/app/pages/credentials/pages/list.dart';
import 'package:credible/app/pages/credentials/repositories/credential.dart';
import 'package:credible/app/pages/credentials/stream.dart';
import 'package:credible/app/pages/credentials/present.dart';
import 'package:credible/app/pages/credentials/receive.dart';
import 'package:credible/app/pages/credentials/blocs/scan.dart';
import 'package:dio/dio.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sembast/sembast.dart';
import 'package:sembast/sembast_io.dart';

class CredentialsModule extends ChildModule {
  static Inject get to => Inject<CredentialsModule>.of();

  @override
  List<Bind> get binds => [
        Bind((i) => ScanBloc(i.get())),
        Bind((i) => WalletBloc(i.get())),
        Bind((i) => CredentialsRepository()),
        Bind((i) => Dio()),
      ];

  @override
  List<ModularRouter> get routers => [
        ModularRouter(
          '/list',
          child: (context, args) => CredentialsStream(
            child: (context, items) => CredentialsList(items: items),
          ),
          transition: TransitionType.fadeIn,
        ),
        ModularRouter(
          '/grid',
          child: (context, args) => CredentialsStream(
            child: (context, items) => CredentialsGrid(items: items),
          ),
          transition: TransitionType.fadeIn,
        ),
        ModularRouter(
          '/detail',
          child: (context, args) => CredentialsDetail(item: args.data),
          transition: TransitionType.rightToLeftWithFade,
        ),
        ModularRouter(
          '/receive',
          child: (context, args) => CredentialsReceivePage(url: args.data),
          transition: TransitionType.rightToLeftWithFade,
        ),
        ModularRouter(
          '/present',
          child: (context, args) => CredentialsPresentPage(url: args.data),
          transition: TransitionType.rightToLeftWithFade,
        ),
      ];
}

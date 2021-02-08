import 'dart:io';

import 'package:credible/app/pages/credentials/blocs/scan.dart';
import 'package:credible/app/pages/credentials/blocs/wallet.dart';
import 'package:credible/app/pages/credentials/pages/detail.dart';
import 'package:credible/app/pages/credentials/pages/grid.dart';
import 'package:credible/app/pages/credentials/pages/list.dart';
import 'package:credible/app/pages/credentials/pick.dart';
import 'package:credible/app/pages/credentials/present.dart';
import 'package:credible/app/pages/credentials/receive.dart';
import 'package:credible/app/pages/credentials/repositories/credential.dart';
import 'package:credible/app/pages/credentials/stream.dart';
import 'package:dio/adapter.dart';
import 'package:dio/dio.dart';
import 'package:flutter_modular/flutter_modular.dart';

class CredentialsModule extends Module {
  @override
  List<Bind> get binds => [
        Bind((i) => ScanBloc(i.get())),
        Bind((i) => WalletBloc(i.get())),
        Bind((i) => CredentialsRepository()),
        Bind((i) {
          // TODO: Remove this after testing is done
          // This allows self-signed certificates on the servers.
          final dio = Dio();
          (dio.httpClientAdapter as DefaultHttpClientAdapter)
              .onHttpClientCreate = (HttpClient client) {
            client.badCertificateCallback =
                (X509Certificate cert, String host, int port) => true;
            return client;
          };
          return dio;
        }),
      ];

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
          child: (context, args) => CredentialsDetail(item: args.data),
          transition: TransitionType.rightToLeftWithFade,
        ),
        ChildRoute(
          '/receive',
          child: (context, args) => CredentialsReceivePage(url: args.data),
          transition: TransitionType.rightToLeftWithFade,
        ),
        ChildRoute(
          '/present',
          child: (context, args) => CredentialsPresentPage(url: args.data),
          transition: TransitionType.rightToLeftWithFade,
        ),
        ChildRoute(
          '/receive',
          child: (context, args) => CredentialsStream(
            child: (context, items) => CredentialsPickPage(
              items: items,
              params: args.data,
            ),
          ),
          transition: TransitionType.rightToLeftWithFade,
        ),
      ];
}

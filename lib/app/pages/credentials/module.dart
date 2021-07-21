import 'package:credible/app/pages/credentials/blocs/scan.dart';
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
          child: (context, args) => CredentialsDetail(item: args.data),
          transition: TransitionType.rightToLeftWithFade,
        ),
        ChildRoute(
          '/receive',
          child: (context, args) => CredentialsReceivePage(
            url: args.data,
            onSubmit: (alias) {
              Modular.get<ScanBloc>().add(ScanEventCredentialOffer(
                args.data.toString(),
                alias,
                'key',
              ));
            },
          ),
          transition: TransitionType.rightToLeftWithFade,
        ),
        ChildRoute(
          '/chapi-receive',
          child: (context, args) => CredentialsReceivePage(
            url: args.data['url'],
            onSubmit: (alias) {
              Modular.get<ScanBloc>().add(ScanEventCHAPIStore(
                args.data['data'],
                args.data['done'],
              ));
            },
          ),
          transition: TransitionType.rightToLeftWithFade,
        ),
        ChildRoute(
          '/present',
          child: (context, args) => CredentialsPresentPage(
            title: 'Presentation Request',
            resource: 'credential',
            url: args.data,
            onSubmit: (preview) {
              Modular.to.pushReplacementNamed(
                '/credentials/pick',
                arguments: (selection) {
                  Modular.get<ScanBloc>().add(
                    ScanEventVerifiablePresentationRequest(
                      url: args.data.toString(),
                      key: 'key',
                      credentials: selection,
                      challenge: preview['challenge'],
                      domain: preview['domain'],
                    ),
                  );
                },
              );
            },
          ),
          transition: TransitionType.rightToLeftWithFade,
        ),
        ChildRoute(
          '/chapi-present',
          child: (context, args) {
            final data = args.data;
            // TODO: when CHAPI comes back so does this
            // final root = data['data']['web']['VerifiablePresentation'];
            final root = data['data'];
            final queries = root['query'] as List<dynamic>;

            if (queries.first['type'] == 'DIDAuth') {
              return CredentialsPresentPage(
                title: 'DIDAuth Request',
                resource: 'DID',
                yes: 'Accept',
                url: data['url'],
                onSubmit: (preview) async {
                  Modular.get<ScanBloc>().add(ScanEventCHAPIGetDIDAuth(
                    'key',
                    data['done'],
                    challenge: root['challenge'],
                    domain: root['domain'],
                  ));

                  await Modular.to.pushReplacementNamed('/credentials');
                },
              );
            } else if (queries.first['type'] == 'QueryByExample') {
              return CredentialsPresentPage(
                title: 'Presentation Request',
                resource: 'credential(s)',
                url: data['url'],
                onSubmit: (preview) async {
                  await Modular.to.pushReplacementNamed(
                    '/credentials/pick',
                    arguments: (selection) {
                      Modular.get<ScanBloc>().add(
                        ScanEventCHAPIGetQueryByExample(
                          'key',
                          selection,
                          data['done'],
                          challenge: root['challenge'],
                          domain: root['domain'],
                        ),
                      );
                    },
                  );
                },
              );
            } else {
              throw UnimplementedError('Unimplemented Query Type');
            }
          },
          transition: TransitionType.rightToLeftWithFade,
        ),
        ChildRoute(
          '/pick',
          child: (context, args) => CredentialsStream(
            child: (context, items) => CredentialsPickPage(
              items: items,
              onSubmit: args.data,
            ),
          ),
          transition: TransitionType.rightToLeftWithFade,
        ),
      ];
}

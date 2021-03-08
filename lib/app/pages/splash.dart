import 'package:credible/app/interop/didkit/didkit.dart';
import 'package:credible/app/interop/secure_storage/secure_storage.dart';
import 'package:credible/app/shared/palette.dart';
import 'package:credible/app/shared/widget/brand.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

class SplashPage extends StatefulWidget {
  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();

    Future.delayed(
      const Duration(
        seconds: 2,
      ),
      () async {
        print(DIDKitProvider.instance.getVersion());

        final key = await SecureStorageProvider.instance.get('key') ?? '';

        if (key.isEmpty) {
          await Modular.to.pushReplacementNamed('/on-boarding');
          return;
        }

        CHAPIProvider.instance.init(
          get: (json, done) async {
            final data = jsonDecode(json);
            final url = Uri.parse(data['origin']);

            Modular.get<ScanBloc>().add(ScanEventShowPreview({}));

            await Modular.to.pushReplacementNamed(
              '/credentials/chapi-present',
              arguments: <String, dynamic>{
                'url': url,
                'data': data['event'],
                'done': done,
              },
            );
          },
          store: (json, done) async {
            final data = jsonDecode(json);
            final url = Uri.parse(data['origin']);

            Modular.get<ScanBloc>().add(ScanEventShowPreview({
              'credentialPreview': data['event'],
            }));

            await Modular.to.pushReplacementNamed(
              '/credentials/chapi-receive',
              arguments: <String, dynamic>{
                'url': url,
                'data': data['event'],
                'done': done,
              },
            );
          },
        );

        CHAPIProvider.instance.emitReady();

        await Modular.to.pushReplacementNamed('/credentials');
      },
    );
  }

  @override
  Widget build(BuildContext context) => SafeArea(
        child: Scaffold(
          body: Container(
            alignment: Alignment.center,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: <Color>[
                  Palette.blue,
                  Palette.gradientBlue,
                ],
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: BrandMinimal(),
            ),
          ),
        ),
      );
}

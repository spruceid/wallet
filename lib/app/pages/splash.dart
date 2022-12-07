import 'dart:convert';
import 'dart:io';

import 'package:credible/app/app_widget.dart';
import 'package:credible/app/interop/chapi/chapi.dart';
import 'package:credible/app/interop/didkit/didkit.dart';
import 'package:credible/app/interop/secure_storage/secure_storage.dart';
import 'package:credible/app/pages/credentials/blocs/scan.dart';
import 'package:credible/app/shared/constants.dart';
import 'package:credible/app/shared/handlers/general.dart';
import 'package:credible/app/shared/key_manager_test.dart';
import 'package:credible/app/shared/ui/ui.dart';
import 'package:credible/app/shared/web_share.dart';
import 'package:credible/app/shared/widget/base/page.dart';
import 'package:credible/app/shared/widget/brand.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:provider/provider.dart';

class SplashPage extends StatefulWidget {
  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();

    WebShare.instance.handlers.add(GeneralHandler());

    if (Platform.isIOS) {
      WebShare.setupWebShare();
    }
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    print(DIDKitProvider.instance.getVersion());

    KeyManagerTest.test();

    Future.delayed(
      const Duration(
        milliseconds: kIsWeb ? 25 : 1000,
      ),
      () async {
        // ignore: unawaited_futures
        Provider.of<AppLockProvider>(context, listen: false).fn();

        final didMethod =
            await SecureStorageProvider.instance.get('did_method') ?? '';

        if (didMethod.isEmpty) {
          await SecureStorageProvider.instance
              .set('did_method', Constants.defaultDIDMethod);
        }

        final keyType =
            await SecureStorageProvider.instance.get('key_type') ?? '';

        if (keyType.isEmpty) {
          await SecureStorageProvider.instance
              .set('key_type', Constants.defaultKeyType);
        }

        final key = await SecureStorageProvider.instance.get('key') ?? '';

        if (key.isEmpty) {
          await Modular.to.pushReplacementNamed('/on-boarding/start');
          return;
        }

        final ed25519Key =
            await SecureStorageProvider.instance.get('key/ed25519/0') ?? '';
        if (ed25519Key.isEmpty) {
          final key = DIDKitProvider.instance.generateEd25519Key();
          await SecureStorageProvider.instance.set('key/ed25519/0', key);
        }

        final secp256r1Key =
            await SecureStorageProvider.instance.get('key/secp256r1/0') ?? '';
        if (secp256r1Key.isEmpty) {
          final key = DIDKitProvider.instance.generateSecp256r1Key();
          await SecureStorageProvider.instance.set('key/secp256r1/0', key);
        }

        final secp256k1Key =
            await SecureStorageProvider.instance.get('key/secp256k1/0') ?? '';
        if (secp256k1Key.isEmpty) {
          final key = DIDKitProvider.instance.generateSecp256k1Key();
          await SecureStorageProvider.instance.set('key/secp256k1/0', key);
        }

        final secp384r1Key =
            await SecureStorageProvider.instance.get('key/secp384r1/0') ?? '';
        if (secp384r1Key.isEmpty) {
          final key = DIDKitProvider.instance.generateSecp384r1Key();
          await SecureStorageProvider.instance.set('key/secp384r1/0', key);
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

        if (Platform.isAndroid) {
          await WebShare.registerWebShare();
        }

        await Modular.to.pushReplacementNamed('/credentials/list');
      },
    );
  }

  @override
  Widget build(BuildContext context) => BasePage(
        backgroundGradient: UiKit.palette.splashBackground,
        scrollView: false,
        body: Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.all(24.0),
          child: BrandMinimal(),
        ),
      );
}

import 'dart:convert';
import 'dart:io';

import 'package:credible/app/app_widget.dart';
import 'package:credible/app/interop/chapi/chapi.dart';
import 'package:credible/app/interop/didkit/didkit.dart';
import 'package:credible/app/interop/secure_storage/secure_storage.dart';
import 'package:credible/app/pages/credentials/blocs/scan.dart';
import 'package:credible/app/pages/credentials/database.dart';
import 'package:credible/app/shared/constants.dart';
import 'package:credible/app/shared/key_manager.dart';
import 'package:credible/app/shared/ui/ui.dart';
import 'package:credible/app/shared/url_intent.dart';
import 'package:credible/app/shared/widget/base/page.dart';
import 'package:credible/app/shared/widget/brand.dart';
import 'package:credible/app/shared/widget/info_dialog.dart';
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
  String loading = 'Initial State';

  @override
  void initState() {
    super.initState();
    print(DIDKitProvider.instance.getVersion());
    _initAsync();
  }

  Future<void> _initAsync() async {
    try {
      await Provider.of<AppLockProvider>(context, listen: false).lock();

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

      setState(() {
        loading = 'Setting up Url Intent...';
      });

      UrlIntent.setupUrlIntent();

      setState(() {
        loading = 'Setting preferred orientations...';
      });

      await SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown,
      ]);

      setState(() {
        loading = 'Checking signing keys...';
      });

      const aliasSign = Constants.defaultAliasSign;

      final existsSign = await KeyManager.keyExists(aliasSign);
      if (!existsSign) {
        setState(() {
          loading = 'Creating signing keys...';
        });

        await KeyManager.generateSigningKey(aliasSign);
        debugPrint('Important - Created signing key');
      }
      final signJwk = await KeyManager.getJwk(aliasSign);
      debugPrint('Signing JWK: $signJwk');

      setState(() {
        loading = 'Checking encryption keys...';
      });

      const aliasEncrypt = Constants.defaultAliasEncrypt;
      final existsEncrypt = await KeyManager.keyExists(aliasEncrypt);
      debugPrint('existsEncrypt: $existsEncrypt');

      if (!existsEncrypt) {
        setState(() {
          loading = 'Creating encryption keys...';
        });

        debugPrint('Important - Creating encryption key');
        await KeyManager.generateEncryptionKey(aliasEncrypt);
        debugPrint('Important - Created encryption key');
      }

      setState(() {
        loading = 'Checking database state';
      });

      try {
        await WalletDatabase.db;
      } on SignatureMismatchException catch (_) {
        if (context.mounted) {
          await _databaseReset(context);
        }
        await WalletDatabase.delete();
      } catch (e) {
        debugPrint('Some other error: $e');
      }

      setState(() {
        loading = 'Startup completed!';
      });
      await Modular.to.pushReplacementNamed('/credentials/list');
    } catch (e) {
      debugPrint('Failed at App Startup\nError: $e');
    }
  }

  Future<void> _databaseReset(BuildContext context) async {
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return const InfoDialog(
          title: 'Previous wallet data unavailable',
          subtitle: 'The SpruceKit Wallet app data is unavailable. '
              'Please re-enroll your previous credentials.',
        );
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

import 'dart:convert';

import 'package:credible/app/app_widget.dart';
import 'package:credible/app/interop/chapi/chapi.dart';
import 'package:credible/app/interop/didkit/didkit.dart';
import 'package:credible/app/interop/secure_storage/secure_storage.dart';
import 'package:credible/app/pages/credentials/blocs/scan.dart';
import 'package:credible/app/shared/ui/ui.dart';
import 'package:credible/app/shared/widget/base/page.dart';
import 'package:credible/app/shared/widget/brand.dart';
import 'package:credible/app/shared/logger/logger.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
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
    log.info(#splash, 'Didkit Version: ${DIDKitProvider.instance.getVersion()}');
    log.warn(#splash, 'Didkit Version: ${DIDKitProvider.instance.getVersion()}');
    log.err(#splash, 'Didkit Version: ${DIDKitProvider.instance.getVersion()}');
    Future.delayed(
      const Duration(
        milliseconds: kIsWeb ? 25 : 1000,
      ),
      () async {
        // ignore: unawaited_futures
        Provider.of<AppLockProvider>(context, listen: false).fn();

        final key = await SecureStorageProvider.instance.get('key') ?? '';

        if (key.isEmpty) {
          await Modular.to.pushReplacementNamed('/on-boarding/start');
          return;
        }

        log.info(#system, 'Initializing CHAPIPovider');
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

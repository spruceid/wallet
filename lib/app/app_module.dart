import 'package:credible/app/pages/credentials/blocs/scan.dart';
import 'package:credible/app/pages/credentials/blocs/wallet.dart';
import 'package:credible/app/pages/credentials/module.dart';
import 'package:credible/app/pages/credentials/repositories/credential.dart';
import 'package:credible/app/pages/did/chain.dart';
import 'package:credible/app/pages/did/display.dart';
import 'package:credible/app/pages/on_boarding/module.dart';
import 'package:credible/app/pages/profile/module.dart';
import 'package:credible/app/pages/qr_code/bloc/qrcode.dart';
import 'package:credible/app/pages/qr_code/display.dart';
import 'package:credible/app/pages/qr_code/scan.dart';
import 'package:credible/app/pages/splash.dart';
import 'package:dio/dio.dart';
import 'package:flutter_modular/flutter_modular.dart';

class AppModule extends Module {
  @override
  List<Bind> get binds => [
        Bind((i) => ScanBloc(i.get())),
        Bind((i) => WalletBloc(i.get())),
        Bind((i) => QRCodeBloc(i.get(), i.get())),
        Bind((i) => CredentialsRepository()),
        Bind((i) {
          final dio = Dio(
            BaseOptions(
              receiveDataWhenStatusError: true,
              connectTimeout: 30 * 1000,
              sendTimeout: 30 * 1000,
              receiveTimeout: 30 * 1000,
            ),
          );

          dio.interceptors
              .add(InterceptorsWrapper(onRequest: (options, handler) {
            final cancel = options.cancelToken ?? CancelToken();
            options.cancelToken = cancel;

            options.onReceiveProgress = (received, total) {
              if (!cancel.isCancelled && total > (4 * 1024 * 1024)) {
                cancel.cancel('Maximum response length: 4MB');
              }
            };

            return handler.next(options);
          }));

          return dio;
        }),
      ];

  @override
  List<ModularRoute> get routes => [
        ChildRoute(
          '/splash',
          child: (context, args) => SplashPage(),
          transition: TransitionType.fadeIn,
        ),
        ModuleRoute(
          '/on-boarding',
          module: OnBoardingModule(),
          transition: TransitionType.fadeIn,
        ),
        ModuleRoute(
          '/credentials',
          module: CredentialsModule(),
          transition: TransitionType.fadeIn,
        ),
        ModuleRoute(
          '/profile',
          module: ProfileModule(),
          transition: TransitionType.fadeIn,
        ),
        ChildRoute(
          '/qr-code/scan',
          child: (context, args) => QrCodeScanPage(),
          transition: TransitionType.fadeIn,
        ),
        ChildRoute(
          '/qr-code/display',
          child: (context, args) => QrCodeDisplayPage(
            name: args.data[0],
            data: args.data[1],
          ),
          transition: TransitionType.fadeIn,
        ),
        ChildRoute(
          '/did/display',
          // TODO: fix the name and data args passed to page
          child: (context, args) => DIDDisplayPage(
            name: args.data[0],
            data: args.data[1],
          ),
          transition: TransitionType.fadeIn,
        ),
        ChildRoute(
          '/did/chain',
          // TODO: Update with new DID chain page, placeholder as QR code display
          child: (context, args) => ChainDisplayPage(
            name: args.data[0],
            data: args.data[1],
          ),
          transition: TransitionType.fadeIn,
        ),
      ];
}

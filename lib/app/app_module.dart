import 'package:credible/app/pages/credentials/blocs/scan.dart';
import 'package:credible/app/pages/credentials/blocs/wallet.dart';
import 'package:credible/app/pages/credentials/module.dart';
import 'package:credible/app/pages/credentials/repositories/credential.dart';
import 'package:credible/app/pages/on_boarding/module.dart';
import 'package:credible/app/pages/profile/module.dart';
import 'package:credible/app/pages/qr_code/bloc/qrcode.dart';
import 'package:credible/app/pages/qr_code/display.dart';
import 'package:credible/app/pages/qr_code/scan.dart';
import 'package:credible/app/pages/splash.dart';
import 'package:credible/app/shared/logger/logger.dart';
import 'package:dio/dio.dart';
import 'package:flutter_modular/flutter_modular.dart';

class AppModule extends Module {
  @override
  List<Bind> get binds => [
        Bind((i) {
          final dio = Dio(
            BaseOptions(
              receiveDataWhenStatusError: true,
              connectTimeout: Duration(seconds: 30),
              sendTimeout: Duration(seconds: 30),
              receiveTimeout: Duration(seconds: 30),
            ),
          );

          dio.interceptors.add(
            InterceptorsWrapper(
              onRequest: (options, handler) {
                logRequestOptions(options);
                handler.next(options);
              },
              onResponse: (response, handler) {
                logResponse(response);
                handler.next(response);
              },
              onError: (err, handler) {
                logError(err);
                handler.next(err);
              }
            )
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
        Bind((i) => ScanBloc(i.get())),
        Bind((i) => WalletBloc(i.get())),
        Bind((i) => QRCodeBloc(i.get(), i.get())),
        Bind((i) => CredentialsRepository()),
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
      ];
}

void logRequestOptions(RequestOptions options) {
  log.info(#dio, 'Request method: ${options.method}');
  log.info(#dio, 'Request uri: ${options.uri}');
  log.info(#dio, 'Request headers: ${options.headers}');
  log.info(#dio, 'Request data: ${dioDataToString(options.data)}');
}

void logResponse<T>(Response<T> response) {
  log.info(#dio, 'Response statusCode: ${response.statusCode}');
  log.info(#dio, 'Response statusMessage: ${response.statusMessage}');
  log.info(#dio, 'Response headers: ${response.headers}');
  log.info(#dio, 'Response data: ${dioDataToString(response.data)}');
}

void logError(DioException err) {
  log.info(#dio, 'Error: ${err}');
  log.info(#dio, 'Error message: ${err.message}');

  if(err.response != null) {
    log.info(#dio, '+++Error Response+++');
    logResponse(err.response!);
  }
}

String dioDataToString(dynamic data) {
  if(data is String) {return data;}
  if(data == '') {return '<empty string>';}
  if(data is Null) {return '<null>';}
  if(data is FormData) {return data.fields.toString();}

  return data.toString();
}

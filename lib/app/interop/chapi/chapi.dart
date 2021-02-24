import 'chapi_stub.dart'
    if (dart.library.io) 'chapi_io.dart'
    if (dart.library.js) 'chapi_js.dart';

typedef GetFn = Future<void> Function(
  String query,
  void Function(String),
);

typedef StoreFn = Future<void> Function(
  String data,
  void Function(String),
);

abstract class CHAPIProvider {
  static CHAPIProvider? _instance;

  static CHAPIProvider get instance {
    _instance ??= getProvider();
    return _instance!;
  }

  void init({
    required GetFn get,
    required StoreFn store,
  });

  void emitReady();
}

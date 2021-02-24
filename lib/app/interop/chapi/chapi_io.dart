import 'chapi.dart';

CHAPIProvider getProvider() => CHAPIIO();

class CHAPIIO extends CHAPIProvider {
  @override
  void init({
    required GetFn get,
    required StoreFn store,
  }) {}

  @override
  void emitReady() {}
}

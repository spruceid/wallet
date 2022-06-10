@JS()
library chapi;

import 'dart:ui';

import 'package:js/js.dart';

import 'chapi.dart';

@JS('handlerGet')
external set _get(GetFn fn);

@JS('handlerStore')
external set _store(StoreFn fn);

@JS('window.dispatchEvent')
external void _emit(Event e);

@JS('dart.Event')
class Event {
  external Event(String name);
}

CHAPIProvider getProvider() => CHAPIWeb();

class CHAPIWeb extends CHAPIProvider {
  @override
  void init({
    required GetFn get,
    required StoreFn store,
  }) {
    _get = allowInterop(get);
    _store = allowInterop(store);
  }

  @override
  void emitReady() {
    _emit(Event('wallet-ready'));
  }
}

import 'package:credible/app/shared/key_generation.dart';
import 'package:credible/ffi.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('FFITests', () {
    test('Check time', () async {
      final nowms = await api.greet();
      print('TIME IS: $nowms');
    });
  });
}

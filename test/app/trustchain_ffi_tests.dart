import 'package:credible/app/shared/key_generation.dart';
import 'package:credible/app/interop/trustchain/trustchain.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('FFITests', () {
    test('Check time', () async {
      final nowms = await trustchain_ffi.greet();
      print('TIME IS: $nowms');
    });
  });
}

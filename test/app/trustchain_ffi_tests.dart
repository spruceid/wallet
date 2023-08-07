import 'dart:convert';

import 'package:credible/app/shared/constants.dart';
import 'package:credible/app/shared/key_generation.dart';
import 'package:credible/app/interop/trustchain/trustchain.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('FFITests', () {
    test('Check time', () async {
      final nowms = await trustchain_ffi.greet();
      print('TIME IS: $nowms');
    });

    test('Resolve', () async {
      final did = 'did:ion:test:EiBYdto2LQd_uAj_EXEoxP_KbLmZzwe1E-vXp8ZsMv1Gpg';
      print(Constants.ffiConfig);
      final didDoc = await trustchain_ffi.didResolve(
          did: did, opts: jsonEncode(Constants.ffiConfig));
      print('Resolved doc:\n$didDoc');
    });

    test('Get chain', () async {
      final did = 'did:ion:test:EiBYdto2LQd_uAj_EXEoxP_KbLmZzwe1E-vXp8ZsMv1Gpg';
      print(Constants.ffiConfig);
      final didChain = await trustchain_ffi.didVerify(
          did: did, opts: jsonEncode(Constants.ffiConfig));
      print('Resolved chain:\n$didChain');
    });
  });
}

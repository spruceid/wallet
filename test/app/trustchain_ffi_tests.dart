import 'dart:convert';

import 'package:credible/app/shared/constants.dart';
import 'package:credible/app/interop/trustchain/trustchain.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;

void main() {
  group('FFITests', () {
    test('Check time', () async {
      final nowms = await trustchain_ffi.greet();
      print('Time: $nowms');
    });

    // Requires ION endpoint
    test('Resolve', () async {
      final did = 'did:ion:test:EiBYdto2LQd_uAj_EXEoxP_KbLmZzwe1E-vXp8ZsMv1Gpg';
      final didDoc = await trustchain_ffi.didResolve(
          did: did, opts: jsonEncode(Constants.ffiConfig));
      print('Resolved doc:\n$didDoc');
    });

    // Requires ION and Trustchain endpoints
    test('Get chain', () async {
      final did = 'did:ion:test:EiBYdto2LQd_uAj_EXEoxP_KbLmZzwe1E-vXp8ZsMv1Gpg';
      final didChain = await trustchain_ffi.didVerify(
          did: did, opts: jsonEncode(Constants.ffiConfig));
      print('Resolved chain:\n$didChain');
    });

    // Requires ION and Trustchain endpoints
    test('Verify credential', () async {
      final did = 'did:ion:test:EiBYdto2LQd_uAj_EXEoxP_KbLmZzwe1E-vXp8ZsMv1Gpg';
      final url = Uri.http(
          '10.0.2.2:8081', '/vc/issuer/481935de-f93d-11ed-a309-d7ec1d02e89c');
      final credential = await http.post(url,
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({'subject_id': did}));
      final vcStr = credential.body;
      print(vcStr);

      final ffiConfig = Constants.ffiConfig;
      // The clock on an emulator is not guaranteed to be same as system clock
      // being used to issue credential. Ensure time on emulator is later than
      // the time on the issued credential.
      // ALternatively, can manually edit a dateNow to be later than credential
      // time.
      // final dateNow = DateTime.now().toUtc().toString().replaceFirst(' ', 'T');
      // ffiConfig['linkedDataProofOptions']?['created'] = dateNow;

      await trustchain_ffi.vcVerifyCredential(
          credential: vcStr, opts: jsonEncode(ffiConfig));
    });
  });
}

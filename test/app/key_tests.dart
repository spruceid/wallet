import 'package:credible/app/shared/key_generation.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('KeyGeneration', () {
    test(
        '.privateKey() should always derive the same key when using the same mnemonic',
        () async {
      final mnemonic =
          'state draft moral repeat knife trend animal pretty delay collect fall adjust';
      final generatedKey = await KeyGeneration.privateKey(mnemonic);
      expect(
          generatedKey,
          equals(
              '{"kty":"OKP","crv":"Ed25519","d":"wHwSUdy4a00qTxAhnuOHeWpai4ERjdZGslaou-Lig5g=","x":"AI4pdGWalv3JXZcatmtBM8OfSIBCFC0o_RNzTg-mEAh6"}'));
    });
  });
}

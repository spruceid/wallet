import 'dart:convert';
import 'dart:typed_data';
import 'package:bip39/bip39.dart' as bip39;
import 'package:credible/app/interop/didkit/didkit.dart';
import 'package:ed25519_hd_key/ed25519_hd_key.dart';

class KeyGeneration {
  static Future<String> privateKey(String mnemonic) async {
    return DIDKitProvider.instance.generateEd25519Key();
    final seed = bip39.mnemonicToSeed(mnemonic);

    final child = await ED25519_HD_KEY.derivePath("m/0'/0'", seed);
    final bytes = Uint8List.fromList(child.key);
    final public = await ED25519_HD_KEY.getPublicKey(bytes);

    final sk = base64Url.encode(bytes);
    final pk = base64Url.encode(public);
    final key = {
      'kty': 'OKP',
      'crv': 'Ed25519',
      'd': sk,
      'x': pk,
    };

    return jsonEncode(key);
  }
}

import 'dart:io';
import 'dart:convert';
import 'package:credible/app/pages/chain/models/chain.dart';
import 'package:credible/app/pages/did/models/did.dart';
import 'package:flutter_test/flutter_test.dart';
// import 'package:http/http.dart' as http;

final didChainExample =
    jsonDecode(File('test/data/chain_example.json').readAsStringSync());

void main() {
  group('DIDChainModel', () {
    test('.toMap() encodes a DIDChainModel to map', () {
      final didChain = DIDChainModel(didChain: [
        DIDModel(
            did: 'did:ion:test:...',
            endpoint: 'http://someendpoint.ac.uk',
            data: {'did': 'did:...'})
      ]);

      expect(
          didChain.toMap(),
          equals({
            'didChain': [
              {'did': 'did:...'}
            ]
          }));
    });

    test('.fromMap() should convert a DIDChainModel from map', () {
      final didChain = DIDChainModel.fromMap(didChainExample);
      expect(didChain.didChain, isNotEmpty);
      expect(didChain.toMap(), equals(didChainExample));
    });
  });

  // Uncomment to test querying a local didChain endpoint:
  // test('test that did chain from endpoint is valid map', () async {
  //   var url =
  //       'http://127.0.0.1:8081/did/chain/did:ion:test:EiAtHHKFJWAk5AsM3tgCut3OiBY4ekHTf66AAjoysXL65Q';
  //   var val = jsonDecode((await http.get(Uri.parse(url))).body);
  //   final didChainUrl = DIDChainModel.fromMap(val);
  //   final didChain = DIDChainModel.fromMap(DID_CHAIN_EXAMPLE);
  //   identical(didChainUrl, didChain);
  // });
}

import 'dart:io';
import 'dart:convert';
import 'package:credible/app/pages/did/models/did.dart';
import 'package:flutter_test/flutter_test.dart';

final didExample =
    jsonDecode(File('test/data/did_example.json').readAsStringSync());

void main() {
  group('DIDModel', () {
    test('.toMap() encodes to map', () {
      final did = DIDModel(
          did: 'did:ion:test:...',
          endpoint: 'http://someendpoint.ac.uk',
          data: {'issuer': 'did:...'});
      final m = did.toMap();

      expect(
          m,
          equals({
            'did': 'did:ion:test:...',
            'endpoint': 'http://someendpoint.ac.uk',
            'data': {'issuer': 'did:...'}
          }));
    });

    test('.fromMap() should convert a DID with an ID present', () {
      final did = DIDModel.fromMap(didExample);
      expect(did.did, isNotEmpty);
      expect(did.data, equals(didExample));
    });

    test(
        '.fromMap() should extract correct (trustchain) service endpoint from DID Document',
        () {
      final did_multi_service_ex =
          File('test/data/did_example_multiple_services.json')
              .readAsStringSync();
      final did_multi_service_json = jsonDecode(did_multi_service_ex);
      final did = DIDModel.fromMap(didExample);
      final did_multi_service = DIDModel.fromMap(did_multi_service_json);
      identical(did, equals(did_multi_service));
      expect(did.data['service'], did_multi_service.data['service']);
    });
  });
}

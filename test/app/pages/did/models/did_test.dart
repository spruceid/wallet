import 'dart:io';
import 'dart:convert';
import 'package:credible/app/pages/did/models/did.dart';
import 'package:flutter_test/flutter_test.dart';

const DID_EXAMPLE = {
  'didDocument': {
    '@context': [
      'https://www.w3.org/ns/did/v1',
      {'@base': 'did:ion:test:EiAtHHKFJWAk5AsM3tgCut3OiBY4ekHTf66AAjoysXL65Q'}
    ],
    'id': 'did:ion:test:EiAtHHKFJWAk5AsM3tgCut3OiBY4ekHTf66AAjoysXL65Q',
    'controller': 'did:ion:test:EiBVpjUxXeSRJpvj2TewlX9zNF3GKMCKWwGmKBZqF6pk_A',
    'verificationMethod': [
      {
        'id': '#ePyXsaNza8buW6gNXaoGZ07LMTxgLC9K7cbaIjIizTI',
        'type': 'JsonWebSignature2020',
        'controller':
            'did:ion:test:EiAtHHKFJWAk5AsM3tgCut3OiBY4ekHTf66AAjoysXL65Q',
        'publicKeyJwk': {
          'kty': 'EC',
          'crv': 'secp256k1',
          'x': '0nnR-pz2EZGfb7E1qfuHhnDR824HhBioxz4E-EBMnM4',
          'y': 'rWqDVJ3h16RT1N-Us7H7xRxvbC0UlMMQQgxmXOXd4bY'
        }
      }
    ],
    'service': [
      {
        'id': '#TrustchainID',
        'type': 'Identity',
        'serviceEndpoint':
            'https://identity.foundation/ion/trustchain-root-plus-2'
      }
    ]
  }
};

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
      final did = DIDModel.fromMap(DID_EXAMPLE);
      expect(did.did, isNotEmpty);
      expect(did.data, equals(DID_EXAMPLE));
    });

    test(
        '.fromMap() should convert a DID (read as a String) with an ID present',
        () {
      final did_ex = File('test/test_data/did_example.json').readAsStringSync();
      final did_json = jsonDecode(did_ex);
      final did = DIDModel.fromMap(did_json);
      expect(did.did, isNotEmpty);
      expect(did.data, equals(DID_EXAMPLE));
    });

    test(
        '.fromMap() should extract correct (trustchain) service endpoint from DID Document',
        () {
      final did_ex = File('test/test_data/did_example.json').readAsStringSync();
      final did_multi_service_ex =
          File('test/test_data/did_example_multiple_services.json')
              .readAsStringSync();
      final did_json = jsonDecode(did_ex);
      final did_multi_service_json = jsonDecode(did_multi_service_ex);
      final did = DIDModel.fromMap(did_json);
      final did_multi_service = DIDModel.fromMap(did_multi_service_json);
      identical(did, equals(did_multi_service));
      expect(did.data['service'], did_multi_service.data['service']);
    });

    //   test('.fromMap() with id should not generate a new id', () {
    //     final m = {
    //       'id': 'uuid',
    //       'data': {'issuer': 'did:...'}
    //     };
    //     final credential = CredentialModel.fromMap(m);
    //     expect(credential.id, equals('uuid'));
    //   });
  });
}

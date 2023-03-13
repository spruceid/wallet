import 'package:credible/app/pages/chain/models/chain.dart';
import 'package:credible/app/pages/did/models/did.dart';
import 'package:flutter_test/flutter_test.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';

const DID_CHAIN_EXAMPLE = {
  'didChain': [
    {
      '@context': 'https://w3id.org/did-resolution/v1',
      'didDocument': {
        '@context': [
          'https://www.w3.org/ns/did/v1',
          {
            '@base':
                'did:ion:test:EiCClfEdkTv_aM3UnBBhlOV89LlGhpQAbfeZLFdFxVFkEg'
          }
        ],
        'id': 'did:ion:test:EiCClfEdkTv_aM3UnBBhlOV89LlGhpQAbfeZLFdFxVFkEg',
        'verificationMethod': [
          {
            'id': '#9CMTR3dvGvwm6KOyaXEEIOK8EOTtek-n7BV9SVBr2Es',
            'type': 'JsonWebSignature2020',
            'controller':
                'did:ion:test:EiCClfEdkTv_aM3UnBBhlOV89LlGhpQAbfeZLFdFxVFkEg',
            'publicKeyJwk': {
              'kty': 'EC',
              'crv': 'secp256k1',
              'x': '7ReQHHysGxbyuKEQmspQOjL7oQUqDTldTHuc9V3-yso',
              'y': 'kWvmS7ZOvDUhF8syO08PBzEpEk3BZMuukkvEJOKSjqE'
            }
          }
        ],
        'authentication': ['#9CMTR3dvGvwm6KOyaXEEIOK8EOTtek-n7BV9SVBr2Es'],
        'assertionMethod': ['#9CMTR3dvGvwm6KOyaXEEIOK8EOTtek-n7BV9SVBr2Es'],
        'keyAgreement': ['#9CMTR3dvGvwm6KOyaXEEIOK8EOTtek-n7BV9SVBr2Es'],
        'capabilityInvocation': [
          '#9CMTR3dvGvwm6KOyaXEEIOK8EOTtek-n7BV9SVBr2Es'
        ],
        'capabilityDelegation': [
          '#9CMTR3dvGvwm6KOyaXEEIOK8EOTtek-n7BV9SVBr2Es'
        ],
        'service': [
          {
            'id': '#TrustchainID',
            'type': 'Identity',
            'serviceEndpoint': 'https://identity.foundation/ion/trustchain-root'
          }
        ]
      },
      'didDocumentMetadata': {
        'method': {
          'recoveryCommitment':
              'EiCymv17OGBAs7eLmm4BIXDCQBVhdOUAX5QdpIrN4SDE5w',
          'updateCommitment': 'EiDVRETvZD9iSUnou-HUAz5Ymk_F3tpyzg7FG1jdRG-ZRg',
          'published': true
        },
        'canonicalId':
            'did:ion:test:EiCClfEdkTv_aM3UnBBhlOV89LlGhpQAbfeZLFdFxVFkEg'
      }
    },
    {
      '@context': 'https://w3id.org/did-resolution/v1',
      'didDocument': {
        '@context': [
          'https://www.w3.org/ns/did/v1',
          {
            '@base':
                'did:ion:test:EiBVpjUxXeSRJpvj2TewlX9zNF3GKMCKWwGmKBZqF6pk_A'
          }
        ],
        'id': 'did:ion:test:EiBVpjUxXeSRJpvj2TewlX9zNF3GKMCKWwGmKBZqF6pk_A',
        'controller':
            'did:ion:test:EiCClfEdkTv_aM3UnBBhlOV89LlGhpQAbfeZLFdFxVFkEg',
        'verificationMethod': [
          {
            'id': '#kjqrr3CTkmlzJZVo0uukxNs8vrK5OEsk_OcoBO4SeMQ',
            'type': 'JsonWebSignature2020',
            'controller':
                'did:ion:test:EiBVpjUxXeSRJpvj2TewlX9zNF3GKMCKWwGmKBZqF6pk_A',
            'publicKeyJwk': {
              'kty': 'EC',
              'crv': 'secp256k1',
              'x': 'aApKobPO8H8wOv-oGT8K3Na-8l-B1AE3uBZrWGT6FJU',
              'y': 'dspEqltAtlTKJ7cVRP_gMMknyDPqUw-JHlpwS2mFuh0'
            }
          }
        ],
        'authentication': ['#kjqrr3CTkmlzJZVo0uukxNs8vrK5OEsk_OcoBO4SeMQ'],
        'assertionMethod': ['#kjqrr3CTkmlzJZVo0uukxNs8vrK5OEsk_OcoBO4SeMQ'],
        'keyAgreement': ['#kjqrr3CTkmlzJZVo0uukxNs8vrK5OEsk_OcoBO4SeMQ'],
        'capabilityInvocation': [
          '#kjqrr3CTkmlzJZVo0uukxNs8vrK5OEsk_OcoBO4SeMQ'
        ],
        'capabilityDelegation': [
          '#kjqrr3CTkmlzJZVo0uukxNs8vrK5OEsk_OcoBO4SeMQ'
        ],
        'service': [
          {
            'id': '#TrustchainID',
            'type': 'Identity',
            'serviceEndpoint':
                'https://identity.foundation/ion/trustchain-root-plus-1'
          }
        ]
      },
      'didDocumentMetadata': {
        'method': {
          'recoveryCommitment':
              'EiClOaWycGv1m-QejUjB0L18G6DVFVeTQCZCuTRrmzCBQg',
          'updateCommitment': 'EiA0-GpdeoAa4v0-K4YCHoNTjAPsoroDy7pleDIc4a3_QQ',
          'published': true
        },
        'proof': {
          'type': 'JsonWebSignature2020',
          'proofValue':
              'eyJhbGciOiJFUzI1NksifQ.IkVpQXM5dkx2SmdaNkFHMk5XbUFmTnBrbl9EMlNSSUFSa2tCWE9kajZpMk84Umci.awNd-_O1N1ycZ6i_BxeLGV14ok51Ii2x9f1FBBCflyAWw773sqiHvQRGHIMBebKMnzbxVybFu2qUEPWUuRAC9g',
          'id': 'did:ion:test:EiCClfEdkTv_aM3UnBBhlOV89LlGhpQAbfeZLFdFxVFkEg'
        },
        'canonicalId':
            'did:ion:test:EiBVpjUxXeSRJpvj2TewlX9zNF3GKMCKWwGmKBZqF6pk_A'
      }
    },
    {
      '@context': 'https://w3id.org/did-resolution/v1',
      'didDocument': {
        '@context': [
          'https://www.w3.org/ns/did/v1',
          {
            '@base':
                'did:ion:test:EiAtHHKFJWAk5AsM3tgCut3OiBY4ekHTf66AAjoysXL65Q'
          }
        ],
        'id': 'did:ion:test:EiAtHHKFJWAk5AsM3tgCut3OiBY4ekHTf66AAjoysXL65Q',
        'controller':
            'did:ion:test:EiBVpjUxXeSRJpvj2TewlX9zNF3GKMCKWwGmKBZqF6pk_A',
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
        'authentication': ['#ePyXsaNza8buW6gNXaoGZ07LMTxgLC9K7cbaIjIizTI'],
        'assertionMethod': ['#ePyXsaNza8buW6gNXaoGZ07LMTxgLC9K7cbaIjIizTI'],
        'keyAgreement': ['#ePyXsaNza8buW6gNXaoGZ07LMTxgLC9K7cbaIjIizTI'],
        'capabilityInvocation': [
          '#ePyXsaNza8buW6gNXaoGZ07LMTxgLC9K7cbaIjIizTI'
        ],
        'capabilityDelegation': [
          '#ePyXsaNza8buW6gNXaoGZ07LMTxgLC9K7cbaIjIizTI'
        ],
        'service': [
          {
            'id': '#TrustchainID',
            'type': 'Identity',
            'serviceEndpoint':
                'https://identity.foundation/ion/trustchain-root-plus-2'
          }
        ]
      },
      'didDocumentMetadata': {
        'proof': {
          'id': 'did:ion:test:EiBVpjUxXeSRJpvj2TewlX9zNF3GKMCKWwGmKBZqF6pk_A',
          'type': 'JsonWebSignature2020',
          'proofValue':
              'eyJhbGciOiJFUzI1NksifQ.IkVpQTNtT25QRklDbTdyc2ljVjRIaFMtNjhrT21xMndqa2tlMEtkRnkzQWlWZlEi.Fxlbm8osH2O5KOQ9sS21bypT_WoWxVD8toCU4baBnLk_gOxiOy_n3cMFMVANJ8usPrKAfRFeC27ATTkWBYZzuw'
        },
        'canonicalId':
            'did:ion:test:EiAtHHKFJWAk5AsM3tgCut3OiBY4ekHTf66AAjoysXL65Q',
        'method': {
          'recoveryCommitment':
              'EiCy4pW16uB7H-ijA6V6jO6ddWfGCwqNcDSJpdv_USzoRA',
          'updateCommitment': 'EiAsmJrz7BysD9na9SMGyZ9RjpKIVweh_AFG_2Bs-2Okkg',
          'published': true
        }
      }
    }
  ]
};

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
      final didChain = DIDChainModel.fromMap(DID_CHAIN_EXAMPLE);
      expect(didChain.didChain, isNotEmpty);
      expect(didChain.toMap(), equals(DID_CHAIN_EXAMPLE));
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

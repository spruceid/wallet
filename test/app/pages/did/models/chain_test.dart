import 'package:credible/app/pages/did/models/did.dart';
import 'package:flutter_test/flutter_test.dart';

const DID_EXAMPLE =
    '[\n  {\n    \"@context\": \"https://w3id.org/did-resolution/v1\",\n    \"didDocument\": {\n      \"@context\": [\n        \"https://www.w3.org/ns/did/v1\",\n        {\n          \"@base\": \"did:ion:test:EiCClfEdkTv_aM3UnBBhlOV89LlGhpQAbfeZLFdFxVFkEg\"\n        }\n      ],\n      \"id\": \"did:ion:test:EiCClfEdkTv_aM3UnBBhlOV89LlGhpQAbfeZLFdFxVFkEg\",\n      \"verificationMethod\": [\n        {\n          \"id\": \"#9CMTR3dvGvwm6KOyaXEEIOK8EOTtek-n7BV9SVBr2Es\",\n          \"type\": \"JsonWebSignature2020\",\n          \"controller\": \"did:ion:test:EiCClfEdkTv_aM3UnBBhlOV89LlGhpQAbfeZLFdFxVFkEg\",\n          \"publicKeyJwk\": {\n            \"kty\": \"EC\",\n            \"crv\": \"secp256k1\",\n            \"x\": \"7ReQHHysGxbyuKEQmspQOjL7oQUqDTldTHuc9V3-yso\",\n            \"y\": \"kWvmS7ZOvDUhF8syO08PBzEpEk3BZMuukkvEJOKSjqE\"\n          }\n        }\n      ],\n      \"authentication\": [\n        \"#9CMTR3dvGvwm6KOyaXEEIOK8EOTtek-n7BV9SVBr2Es\"\n      ],\n      \"assertionMethod\": [\n        \"#9CMTR3dvGvwm6KOyaXEEIOK8EOTtek-n7BV9SVBr2Es\"\n      ],\n      \"keyAgreement\": [\n        \"#9CMTR3dvGvwm6KOyaXEEIOK8EOTtek-n7BV9SVBr2Es\"\n      ],\n      \"capabilityInvocation\": [\n        \"#9CMTR3dvGvwm6KOyaXEEIOK8EOTtek-n7BV9SVBr2Es\"\n      ],\n      \"capabilityDelegation\": [\n        \"#9CMTR3dvGvwm6KOyaXEEIOK8EOTtek-n7BV9SVBr2Es\"\n      ],\n      \"service\": [\n        {\n          \"id\": \"#TrustchainID\",\n          \"type\": \"Identity\",\n          \"serviceEndpoint\": \"https://identity.foundation/ion/trustchain-root\"\n        }\n      ]\n    },\n    \"didDocumentMetadata\": {\n      \"method\": {\n        \"published\": true,\n        \"recoveryCommitment\": \"EiCymv17OGBAs7eLmm4BIXDCQBVhdOUAX5QdpIrN4SDE5w\",\n        \"updateCommitment\": \"EiDVRETvZD9iSUnou-HUAz5Ymk_F3tpyzg7FG1jdRG-ZRg\"\n      },\n      \"canonicalId\": \"did:ion:test:EiCClfEdkTv_aM3UnBBhlOV89LlGhpQAbfeZLFdFxVFkEg\"\n    }\n  },\n  {\n    \"@context\": \"https://w3id.org/did-resolution/v1\",\n    \"didDocument\": {\n      \"@context\": [\n        \"https://www.w3.org/ns/did/v1\",\n        {\n          \"@base\": \"did:ion:test:EiBVpjUxXeSRJpvj2TewlX9zNF3GKMCKWwGmKBZqF6pk_A\"\n        }\n      ],\n      \"id\": \"did:ion:test:EiBVpjUxXeSRJpvj2TewlX9zNF3GKMCKWwGmKBZqF6pk_A\",\n      \"controller\": \"did:ion:test:EiCClfEdkTv_aM3UnBBhlOV89LlGhpQAbfeZLFdFxVFkEg\",\n      \"verificationMethod\": [\n        {\n          \"id\": \"#kjqrr3CTkmlzJZVo0uukxNs8vrK5OEsk_OcoBO4SeMQ\",\n          \"type\": \"JsonWebSignature2020\",\n          \"controller\": \"did:ion:test:EiBVpjUxXeSRJpvj2TewlX9zNF3GKMCKWwGmKBZqF6pk_A\",\n          \"publicKeyJwk\": {\n            \"kty\": \"EC\",\n            \"crv\": \"secp256k1\",\n            \"x\": \"aApKobPO8H8wOv-oGT8K3Na-8l-B1AE3uBZrWGT6FJU\",\n            \"y\": \"dspEqltAtlTKJ7cVRP_gMMknyDPqUw-JHlpwS2mFuh0\"\n          }\n        }\n      ],\n      \"authentication\": [\n        \"#kjqrr3CTkmlzJZVo0uukxNs8vrK5OEsk_OcoBO4SeMQ\"\n      ],\n      \"assertionMethod\": [\n        \"#kjqrr3CTkmlzJZVo0uukxNs8vrK5OEsk_OcoBO4SeMQ\"\n      ],\n      \"keyAgreement\": [\n        \"#kjqrr3CTkmlzJZVo0uukxNs8vrK5OEsk_OcoBO4SeMQ\"\n      ],\n      \"capabilityInvocation\": [\n        \"#kjqrr3CTkmlzJZVo0uukxNs8vrK5OEsk_OcoBO4SeMQ\"\n      ],\n      \"capabilityDelegation\": [\n        \"#kjqrr3CTkmlzJZVo0uukxNs8vrK5OEsk_OcoBO4SeMQ\"\n      ],\n      \"service\": [\n        {\n          \"id\": \"#TrustchainID\",\n          \"type\": \"Identity\",\n          \"serviceEndpoint\": \"https://identity.foundation/ion/trustchain-root-plus-1\"\n        }\n      ]\n    },\n    \"didDocumentMetadata\": {\n      \"canonicalId\": \"did:ion:test:EiBVpjUxXeSRJpvj2TewlX9zNF3GKMCKWwGmKBZqF6pk_A\",\n      \"method\": {\n        \"published\": true,\n        \"recoveryCommitment\": \"EiClOaWycGv1m-QejUjB0L18G6DVFVeTQCZCuTRrmzCBQg\",\n        \"updateCommitment\": \"EiA0-GpdeoAa4v0-K4YCHoNTjAPsoroDy7pleDIc4a3_QQ\"\n      },\n      \"proof\": {\n        \"proofValue\": \"eyJhbGciOiJFUzI1NksifQ.IkVpQXM5dkx2SmdaNkFHMk5XbUFmTnBrbl9EMlNSSUFSa2tCWE9kajZpMk84Umci.awNd-_O1N1ycZ6i_BxeLGV14ok51Ii2x9f1FBBCflyAWw773sqiHvQRGHIMBebKMnzbxVybFu2qUEPWUuRAC9g\",\n        \"type\": \"JsonWebSignature2020\",\n        \"id\": \"did:ion:test:EiCClfEdkTv_aM3UnBBhlOV89LlGhpQAbfeZLFdFxVFkEg\"\n      }\n    }\n  },\n  {\n    \"@context\": \"https://w3id.org/did-resolution/v1\",\n    \"didDocument\": {\n      \"@context\": [\n        \"https://www.w3.org/ns/did/v1\",\n        {\n          \"@base\": \"did:ion:test:EiAtHHKFJWAk5AsM3tgCut3OiBY4ekHTf66AAjoysXL65Q\"\n        }\n      ],\n      \"id\": \"did:ion:test:EiAtHHKFJWAk5AsM3tgCut3OiBY4ekHTf66AAjoysXL65Q\",\n      \"controller\": \"did:ion:test:EiBVpjUxXeSRJpvj2TewlX9zNF3GKMCKWwGmKBZqF6pk_A\",\n      \"verificationMethod\": [\n        {\n          \"id\": \"#ePyXsaNza8buW6gNXaoGZ07LMTxgLC9K7cbaIjIizTI\",\n          \"type\": \"JsonWebSignature2020\",\n          \"controller\": \"did:ion:test:EiAtHHKFJWAk5AsM3tgCut3OiBY4ekHTf66AAjoysXL65Q\",\n          \"publicKeyJwk\": {\n            \"kty\": \"EC\",\n            \"crv\": \"secp256k1\",\n            \"x\": \"0nnR-pz2EZGfb7E1qfuHhnDR824HhBioxz4E-EBMnM4\",\n            \"y\": \"rWqDVJ3h16RT1N-Us7H7xRxvbC0UlMMQQgxmXOXd4bY\"\n          }\n        }\n      ],\n      \"authentication\": [\n        \"#ePyXsaNza8buW6gNXaoGZ07LMTxgLC9K7cbaIjIizTI\"\n      ],\n      \"assertionMethod\": [\n        \"#ePyXsaNza8buW6gNXaoGZ07LMTxgLC9K7cbaIjIizTI\"\n      ],\n      \"keyAgreement\": [\n        \"#ePyXsaNza8buW6gNXaoGZ07LMTxgLC9K7cbaIjIizTI\"\n      ],\n      \"capabilityInvocation\": [\n        \"#ePyXsaNza8buW6gNXaoGZ07LMTxgLC9K7cbaIjIizTI\"\n      ],\n      \"capabilityDelegation\": [\n        \"#ePyXsaNza8buW6gNXaoGZ07LMTxgLC9K7cbaIjIizTI\"\n      ],\n      \"service\": [\n        {\n          \"id\": \"#TrustchainID\",\n          \"type\": \"Identity\",\n          \"serviceEndpoint\": \"https://identity.foundation/ion/trustchain-root-plus-2\"\n        }\n      ]\n    },\n    \"didDocumentMetadata\": {\n      \"canonicalId\": \"did:ion:test:EiAtHHKFJWAk5AsM3tgCut3OiBY4ekHTf66AAjoysXL65Q\",\n      \"method\": {\n        \"recoveryCommitment\": \"EiCy4pW16uB7H-ijA6V6jO6ddWfGCwqNcDSJpdv_USzoRA\",\n        \"updateCommitment\": \"EiAsmJrz7BysD9na9SMGyZ9RjpKIVweh_AFG_2Bs-2Okkg\",\n        \"published\": true\n      },\n      \"proof\": {\n        \"proofValue\": \"eyJhbGciOiJFUzI1NksifQ.IkVpQTNtT25QRklDbTdyc2ljVjRIaFMtNjhrT21xMndqa2tlMEtkRnkzQWlWZlEi.Fxlbm8osH2O5KOQ9sS21bypT_WoWxVD8toCU4baBnLk_gOxiOy_n3cMFMVANJ8usPrKAfRFeC27ATTkWBYZzuw\",\n        \"type\": \"JsonWebSignature2020\",\n        \"id\": \"did:ion:test:EiBVpjUxXeSRJpvj2TewlX9zNF3GKMCKWwGmKBZqF6pk_A\"\n      }\n    }\n  }\n]';

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

import 'dart:convert';

class Constants {
  static final String defaultDIDMethod = 'key';
  static final String databaseFilename = 'wallet.db';
  // TODO: convert to config adjustable from settings than can be retrieved from
  // SecureStorage
  static final ffiConfig = {
    'endpointOptions': {
      'ionEndpoint': {'host': '10.0.2.2', 'port': 3000},
      'trustchainEndpoint': {'host': '10.0.2.2', 'port': 8081}
    },
    'trustchainOptions': {'rootEventTime': 1666971942, 'signatureOnly': false},
    'linkedDataProofOptions': {}
  };
}

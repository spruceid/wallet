import 'dart:convert';

class Constants {
  static final String defaultDIDMethod = 'key';
  static final String databaseFilename = 'wallet.db';
  // TODO [#41]: remove/move to tests.
  static final ffiConfig = {
    'endpointOptions': {
      'trustchainEndpoint': {'host': '10.0.2.2', 'port': 8081}
    },
    'trustchainOptions': {'rootEventTime': 1666971942, 'signatureOnly': false},
    'linkedDataProofOptions': {}
  };
  static final int confirmationCodeMinimumLength = 3;
}

import 'dart:convert';

class Constants {
  static final String defaultDIDMethod = 'tz';
  static final String databaseFilename = 'wallet.db';
  // TODO: convert to config adjustable from settings
  static final int rootEventTime = 1666971942;
  static final String endpointStr = jsonEncode({
    'resolverEndpoint': {'url': 'http://10.0.2.2', 'port': 3000},
    'bundleEndpoint': {'url': 'http://10.0.2.2', 'port': 8081}
  });
}

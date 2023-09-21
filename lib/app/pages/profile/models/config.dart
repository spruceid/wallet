class ConfigModel {
  static const String didKey = 'config/did';
  final String did;

  static const String rootEventTimeKey = 'config/rootEventTime';
  final String rootEventTime;

  static const String ionEndpointKey = 'config/ionEndpoint';
  final String ionEndpoint;

  static const String trustchainEndpointKey = 'config/trustchainEndpoint';
  final String trustchainEndpoint;

  const ConfigModel({
    this.did = '',
    this.rootEventTime = '',
    this.ionEndpoint = '',
    this.trustchainEndpoint = '',
  });
}

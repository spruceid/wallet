import 'package:credible/app/pages/profile/models/root.dart';

class ConfigModel {
  static const String didKey = 'config/did';
  final String did;

  static const String rootEventTimeKey = 'config/rootEventTime';
  final String rootEventTime;

  static const String rootEventConfigKey = 'config/rootEventConfig';
  final RootConfigModel? rootConfig;

  static const String ionEndpointKey = 'config/ionEndpoint';
  final String ionEndpoint;

  static const String trustchainEndpointKey = 'config/trustchainEndpoint';
  final String trustchainEndpoint;

  const ConfigModel({
    this.did = '',
    this.rootEventTime = '',
    this.rootConfig = null,
    this.ionEndpoint = '',
    this.trustchainEndpoint = '',
  });
}

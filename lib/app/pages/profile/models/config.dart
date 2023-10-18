import 'package:credible/app/pages/profile/models/root.dart';

class ConfigModel {
  static const String didKey = 'config/did';
  final String did;

  static const String trustchainEndpointKey = 'config/trustchainEndpoint';
  final String trustchainEndpoint;

  static const String rootEventDateKey = 'config/rootEventDate';
  final String rootEventDate; // TODO: should be DateTime?

  static const String confirmationCodeKey = 'config/confirmationCode';
  final String confirmationCode;

  static const String rootDidKey = 'config/rootDid';
  final String rootDid;

  static const String rootTxidKey = 'config/rootTxid';
  final String rootTxid;

  static const String rootBlockHeightKey = 'config/rootBlockHeight';
  final String rootBlockHeight; // TODO: should be int?

  static const String rootEventTimeKey = 'config/rootEventTime';
  final String rootEventTime; // TODO: should be int?

  const ConfigModel({
    this.did = '',
    this.trustchainEndpoint = '',
    this.rootEventDate = '',
    this.confirmationCode = '',
    this.rootDid = '',
    this.rootTxid = '',
    this.rootBlockHeight = '',
    this.rootEventTime = '',
  });
}

import 'package:credible/app/interop/didkit/didkit.dart';
import 'package:credible/app/interop/secure_storage/secure_storage.dart';
import 'package:credible/app/pages/profile/models/config.dart';
import 'package:credible/app/shared/constants.dart';

class FFIConfig {
  Future<int> get_root_event_time() async {
    final rootEventTime = (await SecureStorageProvider.instance
        .get(ConfigModel.rootEventTimeKey))!;
    return int.parse(rootEventTime);
  }

  Future<String> get_trustchain_endpoint() async {
    return (await SecureStorageProvider.instance
        .get(ConfigModel.trustchainEndpointKey))!;
  }

  Future<String> get_did() async {
    return (await SecureStorageProvider.instance.get(ConfigModel.didKey))!;
  }

  Future<Map<String, Map<dynamic, dynamic>>> get_ffi_config() async {
    var ffiConfig = Constants.ffiConfig;
    ffiConfig['trustchainOptions']!['rootEventTime'] =
        await get_root_event_time();
    final trustchainEndpoint = await get_trustchain_endpoint();
    final trustchainEndpointUri = Uri.parse(trustchainEndpoint);
    ffiConfig['endpointOptions']!['trustchainEndpoint']!['host'] =
        trustchainEndpointUri.toString();
    ffiConfig['endpointOptions']!['trustchainEndpoint']!['port'] =
        trustchainEndpointUri.port;
    return ffiConfig;
  }
}

var ffi_config_instance = FFIConfig();

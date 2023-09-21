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

  Future<String> get_ion_endpoint() async {
    return (await SecureStorageProvider.instance
        .get(ConfigModel.ionEndpointKey))!;
  }

  Future<String> get_did() async {
    return (await SecureStorageProvider.instance.get(ConfigModel.didKey))!;
  }

  Future<Map<String, Map<dynamic, dynamic>>> get_ffi_config() async {
    // TODO [#40]: revisit after refactor to use https
    var ffiConfig = Constants.ffiConfig;
    ffiConfig['trustchainOptions']!['rootEventTime'] =
        await get_root_event_time();
    final ionEndpoint = await get_ion_endpoint();
    final trustchainEndpoint = await get_trustchain_endpoint();
    ffiConfig['endpointOptions']!['ionEndpoint']!['host'] =
        ionEndpoint.split(':')[0];
    ffiConfig['endpointOptions']!['ionEndpoint']!['port'] =
        int.parse(ionEndpoint.split(':')[1]);
    ffiConfig['endpointOptions']!['trustchainEndpoint']!['host'] =
        trustchainEndpoint.split(':')[0];
    ffiConfig['endpointOptions']!['trustchainEndpoint']!['port'] =
        int.parse(trustchainEndpoint.split(':')[1]);
    return ffiConfig;
  }
}

var ffi_config_instance = FFIConfig();

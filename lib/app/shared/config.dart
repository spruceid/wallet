import 'package:credible/app/interop/didkit/didkit.dart';
import 'package:credible/app/interop/secure_storage/secure_storage.dart';
import 'package:credible/app/pages/profile/models/config.dart';
import 'package:credible/app/shared/constants.dart';

class FFIConfig {
  Future<int> get_root_event_time() async {
    final rootEventTime = await SecureStorageProvider.instance
            .get(ConfigModel.rootEventTimeKey) ??
        Constants.ffiConfig['trustchainOptions']!['rootEventTime']!;
    return int.parse(rootEventTime);
  }

  Future<String> get_trustchain_endpoint() async {
    return await SecureStorageProvider.instance
            .get(ConfigModel.trustchainEndpointKey) ??
        '10.0.2.2:8081';
  }

  Future<String> get_ion_endpoint() async {
    return await SecureStorageProvider.instance
            .get(ConfigModel.ionEndpointKey) ??
        '10.0.2.2:3000';
  }

  Future<String> get_did() async {
    final key = (await SecureStorageProvider.instance.get('key'))!;
    final did_key =
        DIDKitProvider.instance.keyToDID(Constants.defaultDIDMethod, key);
    final did_stored =
        (await SecureStorageProvider.instance.get(ConfigModel.didKey))!;
    final did = did_stored == '' ? did_key : did_stored;
    return did;
  }

  Future<Map<String, Map<dynamic, dynamic>>> get_ffi_config() async {
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

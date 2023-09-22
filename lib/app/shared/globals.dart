import 'package:credible/app/pages/chain/models/chain.dart';
import 'package:credible/app/pages/did/models/did.dart';
import 'package:dio/dio.dart';

import 'config.dart';

Future<DIDModel> resolveDid(String did) async {
  final endpoint = (await ffi_config_instance.get_trustchain_endpoint());
  final route = '/did/' + did;
  final uri = Uri.parse(endpoint + route);
  return DIDModel.fromMap((await Dio().getUri(uri)).data);
}

// TODO: replace with FFI call
Future<DIDChainModel> resolveDidChain(String did) async {
  final endpoint = (await ffi_config_instance.get_trustchain_endpoint());
  final route = '/did/chain/' + did;
  final queryParams = {
    'root_event_time':
        (await ffi_config_instance.get_root_event_time()).toString(),
  };
  final uri = Uri.parse(endpoint + route).replace(queryParameters: queryParams);
  return DIDChainModel.fromMap((await Dio().getUri(uri)).data);
}

String humanReadableEndpoint(String endpoint) {
  return endpoint.split('www.').last;
}

Map<String, dynamic> stripContext(Map<String, dynamic> map) {
  // Remove any jsonld context entries in the hierarchy
  var result = Map<String, dynamic>();
  map.forEach((key, value) {
    if (key != '@context') {
      if (value is Map<String, dynamic>) {
        result[key] = stripContext(value);
      } else {
        result[key] = value;
      }
    }
  });
  return result;
}

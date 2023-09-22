import 'dart:convert';

import 'package:credible/app/pages/did/models/did.dart';
import 'package:http/http.dart' as http;

import 'config.dart';

Future<DIDModel> resolve_did(String did) async {
  final url =
      (await ffi_config_instance.get_trustchain_endpoint()) + '/did/' + did;
  final url_split = url.split('/');
  final route = '/' + url_split.sublist(1).join('/');
  final uri = Uri.http(url_split[0], route);
  return DIDModel.fromMap(jsonDecode((await http.get(uri)).body));
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

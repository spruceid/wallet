import 'package:credible/app/pages/credentials/models/credential.dart';
import 'package:credible/app/shared/web_share.dart';
import 'package:flutter/src/widgets/framework.dart';

extension ContainsKeyEqualTo on Map<String, dynamic> {
  bool containsKeyEqualTo(String key, String test) {
    if (!containsKey(key)) return false;
    if (this[key] != test) return false;
    return true;
  }
}

class GeneralHandler extends WebShareHandler {
  static Future<dynamic> _verify(Map<String, dynamic> json) async {
    if (!json.containsKey('credential')) return null;
    if (!(json['credential'] is Map<String, dynamic>)) return null;
    final credential = json['credential'] as Map<String, dynamic>;

    if (!credential.containsKeyEqualTo('type', 'web') ||
        !credential.containsKeyEqualTo('dataType', 'VerifiablePresentation')) {
      return null;
    }

    if (!credential.containsKey('data')) return null;
    if (!(credential['data'] is Map<String, dynamic>)) return null;
    final presentation = credential['data'] as Map<String, dynamic>;

    if (!presentation.containsKey('verifiableCredential')) return null;
    if (!(presentation['verifiableCredential'] is List<dynamic>)) {
      return null;
    }

    final credentials = presentation['verifiableCredential'] as List<dynamic>;
    final singleCredential = credentials.first as Map<String, dynamic>;

    // TODO: verify credential

    return CredentialModel.fromMap({'data': singleCredential});
  }

  static Future<bool> _show(BuildContext _context, dynamic _data) async {
    return true;
  }

  GeneralHandler() : super(_verify, _show);
}

import 'package:credible/app/pages/credentials/models/credential.dart';
import 'package:credible/app/pages/credentials/models/credential_status.dart';
import 'package:credible/app/pages/did/models/did.dart';
import 'package:credible/app/shared/globals.dart';
import 'package:uuid/uuid.dart';

class CredentialDisplayModel {
  final CredentialModel model;
  final String displayedIssuer;

  String get issuer => model.data['issuer']!;

  DateTime? get expirationDate => (model.data['expirationDate'] != null)
      ? DateTime.parse(model.data['expirationDate'])
      : null;

  CredentialStatus get status {
    if (expirationDate == null) {
      return CredentialStatus.active;
    }

    return expirationDate!.isAfter(DateTime.now())
        ? CredentialStatus.active
        : CredentialStatus.expired;
  }

  Map<String, dynamic> _stripContext(Map<String, dynamic> map) {
    // Remove any jsonld context entries in the hierarchy
    var result = Map<String, dynamic>();
    map.forEach((key, value) {
      if (key != '@context') {
        if (value is Map<String, dynamic>) {
          result[key] = _stripContext(value);
        } else {
          result[key] = value;
        }
      }
      ;
    });
    return result;
  }

  Map<String, dynamic> get details {
    // Remove the jsonld context to avoid overcomplicating things for human viewers
    return _stripContext(model.data);
  }

  const CredentialDisplayModel({
    required this.model,
    required this.displayedIssuer,
  });

  static Future<CredentialDisplayModel> constructCredentialDisplayModel(
      CredentialModel model) async {
    var displayedIssuer = model.issuer;
    try {
      var did_model = await resolve_did(model.issuer);
      displayedIssuer = humanReadableEndpoint(did_model.endpoint);
    } catch (e) {
      // Do nothing: issuer DID is displayed by default.
    }

    return CredentialDisplayModel(
        model: model, displayedIssuer: displayedIssuer);
  }

  Map<String, dynamic> toMap() => {
        'id': model.id,
        'alias': model.alias,
        'image': model.image,
        'data': model.data,
        'issuerDid': displayedIssuer
      };
}

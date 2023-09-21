import 'package:credible/app/pages/credentials/models/credential.dart';
import 'package:credible/app/pages/credentials/models/credential_status.dart';
import 'package:credible/app/pages/did/models/did.dart';
import 'package:credible/app/shared/globals.dart';
import 'package:uuid/uuid.dart';

// For displaying a credential with issuer endpoint (extracted from DID document)
class CredentialDisplayModel {
  final CredentialModel model;
  final String displayedIssuer;

  String get issuer => model.issuer;

  DateTime? get expirationDate => model.expirationDate;

  CredentialStatus get status => model.status;

  Map<String, dynamic> get details => model.details;

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
        'displayedIssuer': displayedIssuer
      };
}

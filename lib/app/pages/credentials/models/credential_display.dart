import 'package:credible/app/pages/credentials/models/credential.dart';
import 'package:credible/app/pages/credentials/models/credential_status.dart';
import 'package:credible/app/pages/did/models/did.dart';
import 'package:credible/app/shared/globals.dart';
import 'package:uuid/uuid.dart';

// Wrapper for CredentialModel, with issuer endpoint (extracted from their DID document).
class CredentialDisplayModel {
  final CredentialModel wrappedModel;
  final String displayedIssuer;

  String get issuer => wrappedModel.issuer;

  DateTime? get expirationDate => wrappedModel.expirationDate;

  CredentialStatus get status => wrappedModel.status;

  Map<String, dynamic> get details => wrappedModel.details;

  const CredentialDisplayModel({
    required this.wrappedModel,
    required this.displayedIssuer,
  });

  static Future<CredentialDisplayModel> constructCredentialDisplayModel(
      CredentialModel model) async {
    var displayedIssuer = model.issuer;
    try {
      var did_model = await resolveDid(model.issuer);
      displayedIssuer = humanReadableEndpoint(did_model.endpoint);
    } catch (e) {
      // Do nothing: issuer DID is displayed by default.
    }

    return CredentialDisplayModel(
        wrappedModel: model, displayedIssuer: displayedIssuer);
  }

  Map<String, dynamic> toMap() => {
        'id': wrappedModel.id,
        'alias': wrappedModel.alias,
        'image': wrappedModel.image,
        'data': wrappedModel.data,
        'displayedIssuer': displayedIssuer
      };
}

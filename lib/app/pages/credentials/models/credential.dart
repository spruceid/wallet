import 'package:credible/app/pages/credentials/models/credential_status.dart';

class CredentialModel {
  final String id;
  final String issuer;
  final String image;
  final CredentialStatus status;

  final Map<String, dynamic> data;

  const CredentialModel({
    required this.id,
    required this.issuer,
    required this.image,
    required this.status,
    required this.data,
  });

  factory CredentialModel.fromMap(Map<String, dynamic> m) {
    assert(m.containsKey('id'));
    assert(m.containsKey('issuer'));

    late final status;

    if (m.containsKey('expirationDate')) {
      final exp = DateTime.parse(m['expirationDate']);
      status = exp.isAfter(DateTime.now())
          ? CredentialStatus.active
          : CredentialStatus.expired;
    } else {
      status = CredentialStatus.active;
    }

    return CredentialModel(
      id: m['id'],
      issuer: m['issuer'],
      image: '',
      status: status,
      data: m,
    );
  }

  Map<String, dynamic> toJson() => data;
}

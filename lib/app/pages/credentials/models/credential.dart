import 'package:credible/app/pages/credentials/models/credential_status.dart';
import 'package:uuid/uuid.dart';

class CredentialModel {
  final String id;
  final String? image;
  final Map<String, dynamic> data;

  String get issuer => data['issuer']!;

  DateTime? get expirationDate => (data['expirationDate'] != null)
      ? DateTime.parse(data['expirationDate'])
      : null;

  CredentialStatus get status {
    if (expirationDate == null) {
      return CredentialStatus.active;
    }

    return expirationDate!.isAfter(DateTime.now())
          ? CredentialStatus.active
          : CredentialStatus.expired;
  }

  const CredentialModel({
    required this.id,
    required this.image,
    required this.data,
  });

  factory CredentialModel.fromMap(Map<String, dynamic> m) {
    assert(m.containsKey('data'));

    final data = m['data'] as Map<String, dynamic>;
    assert(data.containsKey('issuer'));

    return CredentialModel(
      id: m['id'] ?? Uuid().v4(),
      image: m['image'],
      data: data,
    );
  }

  Map<String, dynamic> toMap() => {'id': id, 'image': image, 'data': data};
}

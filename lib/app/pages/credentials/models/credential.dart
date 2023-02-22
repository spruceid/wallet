import 'package:credible/app/pages/credentials/models/credential_status.dart';
import 'package:uuid/uuid.dart';

class CredentialModel {
  final String id;
  final String? alias;
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
      };
    });
    return result;
  }

  Map<String, dynamic> get details {
    // Remove the jsonld context to avoid overcomplicating things for human viewers
    return _stripContext(data);
  }

  const CredentialModel({
    required this.id,
    required this.alias,
    required this.image,
    required this.data,
  });

  factory CredentialModel.fromMap(Map<String, dynamic> m) {
    assert(m.containsKey('data'));

    final data = m['data'] as Map<String, dynamic>;
    assert(data.containsKey('issuer'));

    return CredentialModel(
      id: m['id'] ?? Uuid().v4(),
      alias: m['alias'],
      image: m['image'],
      data: data,
    );
  }

  Map<String, dynamic> toMap() =>
      {'id': id, 'alias': alias, 'image': image, 'data': data};
}

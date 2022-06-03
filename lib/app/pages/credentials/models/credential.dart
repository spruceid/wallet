import 'package:credible/app/pages/credentials/models/credential_status.dart';
import 'package:uuid/uuid.dart';

class CredentialModel {
  final String id;
  final String? alias;
  final String? image;
  final Map<String, dynamic> data;

  String get title {
    if (alias != null && alias!.isNotEmpty) return alias!;
    return id;
  }

  List<String> get types {
    if (data['type'] is Iterable) {
      return (data['type'] as List).map((e) => e as String).toList();
    } else {
      print(data['type'].runtimeType);
      return <String>[data['type']];
    }
  }

  String get issuer {
    if (data['issuer'] is String) {
      return data['issuer'];
    } else {
      return data['issuer']!['id'];
    }
  }

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

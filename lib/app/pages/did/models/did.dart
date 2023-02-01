class DIDModel {
  final String did;
  // TODO: add optionality to endpoint presence
  final String endpoint;
  final int? level;
  final String? alias;
  final Map<String, dynamic> data;

  const DIDModel({
    required this.did,
    required this.endpoint,
    required this.level,
    required this.alias,
    required this.data,
  });
  factory DIDModel.fromMap(Map<String, dynamic> m) {
    assert(m.containsKey('data'));

    final data = m['data'] as Map<String, dynamic>;
    assert(data.containsKey('didDocument'));
    final didDocument = data['didDocument'];
    assert(didDocument.containsKey('id'));
    final did = didDocument['id'];
    final endpoint = didDocument['service']['serviceEnpoint'];

    return DIDModel(
      did: did,
      endpoint: endpoint,
      alias: null,
      level: null,
      data: data,
    );
  }

  Map<String, dynamic> toMap() => {
        'did': did,
        'endpoint': endpoint,
        'alias': alias,
        'level': level,
        'data': data
      };
}

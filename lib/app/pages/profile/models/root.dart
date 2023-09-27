class RootConfigModel {
  final DateTime date;
  String? confimationCode;
  RootIdentifierModel? root;

  RootConfigModel({
    required this.date,
  });

  factory RootConfigModel.fromDate(DateTime date) {
    return RootConfigModel(date: date);
  }
}

// Represents a root DID candidate, with corresponding Bitcoin transaction ID.
class RootIdentifierModel {
  final String did;
  final String txid;

  const RootIdentifierModel({
    required this.did,
    required this.txid,
  });

  factory RootIdentifierModel.fromMap(Map<String, dynamic> data) {
    assert(data.containsKey('did'));
    final did = data['did'];
    assert(data.containsKey('txid'));
    final txid = data['txid'];
    return RootIdentifierModel(did: did, txid: txid);
  }

  Map<String, String> toMap() => {'did': did, 'txid': txid};
}

// Represents a list of root DID candidates for a given calendar date.
class RootCandidatesModel {
  final DateTime date;
  final List<RootIdentifierModel> candidates;

  const RootCandidatesModel({
    required this.date,
    required this.candidates,
  });

  // Throws a FormatException if the 'date' string cannot be parsed.
  factory RootCandidatesModel.fromMap(Map<String, dynamic> data) {
    assert(data.containsKey('date'));
    final date = DateTime.parse(data['date']);
    assert(data.containsKey('rootCandidates'));
    var candidates = data['rootCandidates']
        .map<RootIdentifierModel>((m) => RootIdentifierModel.fromMap(m))
        .toList();

    return RootCandidatesModel(date: date, candidates: candidates);
  }

  Map<String, dynamic> toMap() => {
        'date': date,
        'rootCandidates':
            candidates.map((m) => m.toMap()['candidates']).toList()
      };
}

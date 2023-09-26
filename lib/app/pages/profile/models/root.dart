class RootConfigModel {
  final DateTime date;
  String? confimationCode;

  RootConfigModel({
    required this.date,
    required this.confimationCode,
  });

  factory RootConfigModel.fromDate(DateTime date) {
    return RootConfigModel(date: date, confimationCode: null);
  }
}

// Represents a root DID candidate, with corresponding Bitcoin transaction ID.
class RootCandidateModel {
  final String did;
  final String txid;

  const RootCandidateModel({
    required this.did,
    required this.txid,
  });

  factory RootCandidateModel.fromMap(Map<String, dynamic> data) {
    assert(data.containsKey('did'));
    final did = data['did'];
    assert(data.containsKey('txid'));
    final txid = data['txid'];
    return RootCandidateModel(did: did, txid: txid);
  }

  Map<String, String> toMap() => {'did': did, 'txid': txid};
}

// Represents a list of root DID candidates for a given calendar date.
class RootCandidatesModel {
  final DateTime date;
  final List<RootCandidateModel> candidates;

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
        .map<RootCandidateModel>((m) => RootCandidateModel.fromMap(m))
        .toList();

    return RootCandidatesModel(date: date, candidates: candidates);
  }

  Map<String, dynamic> toMap() => {
        'date': date,
        'rootCandidates':
            candidates.map((m) => m.toMap()['candidates']).toList()
      };
}

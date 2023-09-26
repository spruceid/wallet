// TODO.
// class RootModel {
//   final DateTime date;
//   String confimationCode;

//   const RootModel({
//     required this.date,
//   })

// }

class RootCandidateModel {
  final String did;
  final String txid;

  const RootCandidateModel({
    required this.did,
    required this.txid,
  });

  // TODO: find out why the ! is needed here, but isn't in DIDModel.fromMap().
  factory RootCandidateModel.fromMap(Map<String, dynamic> data) {
    assert(data.containsKey('did'));
    final did = data['did']!;
    assert(data.containsKey('txid'));
    final txid = data['txid']!;
    return RootCandidateModel(did: did, txid: txid);
  }

  Map<String, String> toMap() => {'did': did, 'txid': txid};
}

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

class DIDModel {
  final String did;
  // TODO: add optionality to endpoint presence
  final String endpoint;
  final Map<String, dynamic> data;

  const DIDModel({
    required this.did,
    required this.endpoint,
    required this.data,
  });
  // Assumed map is an HTTP API resolved DID: https://w3c-ccg.github.io/did-resolution/
  factory DIDModel.fromMap(Map<String, dynamic> data) {
    // TODO: check whether removing data as a root field is best choice
    // assert(m.containsKey('data'));
    // final data = m['data'] as Map<String, dynamic>;
    assert(data.containsKey('didDocument'));
    final didDocument = data['didDocument'];
    assert(didDocument.containsKey('id'));
    final did = didDocument['id'];
    // TODO: add robust checks for converting HTTP API DID result into DIDModel
    // E.g. multiple services, field existence, etc
    //
    // Loop over services (must be more than 0) and extract service endpoint for
    // service with service["id"] == "TrustchainID".
    
    var ep;
    for (var s in didDocument['service']){
      if (s['id'] == '#TrustchainID'){
        ep = s['serviceEndpoint'];
        break;
      } else {
        ep = 'Trustchain ID endpoint not found';
      }
    }
    final endpoint = ep;

    // Must have both DID and service endpoint
    assert(endpoint != 'Trustchain ID endpoint not found');
    return DIDModel(
      did: did,
      endpoint: endpoint,
      data: data,
    );
  }

  Map<String, dynamic> toMap() =>
      {'did': did, 'endpoint': endpoint, 'data': data};
}

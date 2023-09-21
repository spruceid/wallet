String extractEndpoint(dynamic did_document, String service_id) {
  // TODO: refine handling when sevice not found
  var ep = '';
  for (var service in did_document['service']) {
    if (service['id'] == service_id) {
      ep = service['serviceEndpoint'];
      break;
    }
  }
  return ep;
}

class DIDModel {
  final String did;
  // TODO: consider optionality to endpoint presence, currently asserting always
  // present in the returned 'didDocument'
  final String endpoint;
  final Map<String, dynamic> data;

  const DIDModel({
    required this.did,
    required this.endpoint,
    required this.data,
  });
  // Assumed map is an HTTP API resolved DID: https://w3c-ccg.github.io/did-resolution/
  factory DIDModel.fromMap(Map<String, dynamic> data) {
    assert(data.containsKey('didDocument'));
    final didDocument = data['didDocument'];
    assert(didDocument.containsKey('id'));
    final did = didDocument['id'];
    // TODO: add robust checks for converting HTTP API DID result into DIDModel.
    // E.g. multiple services, field existence, etc

    // Extract service endpoint for "TrustchainID".
    assert(didDocument.containsKey('service'));
    final endpoint = extractEndpoint(didDocument, '#TrustchainID');

    return DIDModel(
      did: did,
      endpoint: endpoint,
      data: data,
    );
  }

  Map<String, dynamic> toMap() =>
      {'did': did, 'endpoint': endpoint, 'data': data};
}

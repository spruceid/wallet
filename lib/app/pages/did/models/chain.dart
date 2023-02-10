import 'did.dart';

class DIDChainModel {
  final String did;
  final List<DIDModel> data;
  const DIDChainModel({
    required this.did,
    required this.data,
  });
  // Assumed map is an HTTP API resolved DID: https://w3c-ccg.github.io/did-resolution/
  factory DIDChainModel.fromMap(Map<String, dynamic> data) {
    // factory DIDChainModel.fromList(List<dynamic> data) {
    // TODO: check whether removing data as a root field is best choice
    // assert(m.containsKey('data'));
    // final data = m['data'] as Map<String, dynamic>;
    // assert(data.containsKey('didDocument'));
    // final didDocument = data['didDocument'];
    // assert(didDocument.containsKey('id'));
    // final did = didDocument['id'];

    return DIDChainModel(
      did: did,
      data: data,
    );
  }

  Map<String, dynamic> toMap() =>
      {'did': did, 'endpoint': endpoint, 'data': data};
}

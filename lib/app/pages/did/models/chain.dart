import 'did.dart';

class DIDChainModel {
  final List<DIDModel> didChain;
  const DIDChainModel({
    required this.didChain,
  });
  // Assumed map is an HTTP API resolved DIDChain
  // factory DIDChainModel.fromMap(Map<String, List<Map<String, dynamic>>> data) {
  factory DIDChainModel.fromMap(Map<String, dynamic> data) {
    assert(data.containsKey('didChain'));
    print('type is ${data['didChain'].runtimeType}');
    // assert(data['didChain'] is List<Map<String, dynamic>>);
    // assert(data['didChain'] is Map<String, dynamic>);
    var mapped =
        data['didChain']!.map<DIDModel>((m) => DIDModel.fromMap(m)).toList();
    print('mapped type: ${mapped.runtimeType}');

    return DIDChainModel(
      didChain: mapped,
    );
  }

  Map<String, dynamic> toMap() =>
      {'didChain': didChain.map((m) => m.toMap()['data']).toList()};
}

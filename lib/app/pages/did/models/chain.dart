import 'did.dart';

class DIDChainModel {
  final List<DIDModel> didChain;
  const DIDChainModel({
    required this.didChain,
  });
  // Assumed map is an HTTP API resolved DIDChain
  factory DIDChainModel.fromMap(Map<String, dynamic> data) {
    assert(data.containsKey('didChain'));
    return DIDChainModel(
      didChain:
          data['didChain']!.map<DIDModel>((m) => DIDModel.fromMap(m)).toList(),
    );
  }

  Map<String, dynamic> toMap() =>
      {'didChain': didChain.map((m) => m.toMap()['data']).toList()};
}

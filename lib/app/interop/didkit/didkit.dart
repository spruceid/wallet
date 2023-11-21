import 'didkit_stub.dart'
    if (dart.library.io) 'didkit_io.dart'
    if (dart.library.js) 'didkit_js.dart';

abstract class DIDKitProvider {
  static DIDKitProvider? _instance;

  static DIDKitProvider get instance {
    _instance ??= getProvider();
    return _instance!;
  }

  String getVersion();

  String generateEd25519Key();

  String generateSecp256r1Key();

  String generateSecp256k1Key();

  String generateSecp384r1Key();

  String keyToDID(String methodName, String key);

  Future<String> keyToVerificationMethod(String methodName, String key);

  Future<String> issueCredential(
    String credential,
    String options,
    String key, [
    String? contextMap,
  ]);

  Future<String> verifyCredential(
    String credential,
    String options, [
    String? contextMap,
  ]);

  Future<String> issuePresentation(
    String presentation,
    String options,
    String key, [
    String? contextMap,
  ]);

  Future<String> verifyPresentation(
    String presentation,
    String options, [
    String? contextMap,
  ]);

  Future<String> resolveDID(
    String did,
    String inputMetadata,
  );

  Future<String> dereferenceDIDURL(
    String didUrl,
    String inputMetadata,
  );

  Future<String> didAuth(
    String did,
    String options,
    String key, [
    String? contextMap,
  ]);

  Future<String> createContext(
    String url,
    String json,
  );

  Future<String> createContextMap(
    List<String> contexts,
  );

  Future<String> prepareIssueCredential(
    String credential,
    String options,
    String key, [
    String? contextMap,
  ]);

  Future<String> completeIssueCredential(
    String credential,
    String preparation,
    String signature,
  );

  Future<String> prepareIssuePresentation(
    String presentation,
    String options,
    String key, [
    String? contextMap,
  ]);

  Future<String> completeIssuePresentation(
    String presentation,
    String preparation,
    String signature,
  );
}

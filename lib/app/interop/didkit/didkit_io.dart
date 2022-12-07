library didkit;

import 'package:didkit/didkit.dart';

import 'didkit.dart';

DIDKitProvider getProvider() => DIDKitIO();

class DIDKitIO extends DIDKitProvider {
  @override
  String getVersion() {
    return DIDKit.getVersion();
  }

  @override
  String generateEd25519Key() {
    return DIDKit.generateEd25519Key();
  }

  @override
  String generateSecp256r1Key() {
    return DIDKit.generateSecp256r1Key();
  }

  @override
  String generateSecp256k1Key() {
    return DIDKit.generateSecp256k1Key();
  }

  @override
  String generateSecp384r1Key() {
    return DIDKit.generateSecp384r1Key();
  }

  @override
  String keyToDID(String methodName, String key) {
    return DIDKit.keyToDID(methodName, key);
  }

  @override
  Future<String> keyToVerificationMethod(String methodName, String key) async {
    return DIDKit.keyToVerificationMethod(methodName, key);
  }

  @override
  Future<String> issueCredential(
    String credential,
    String options,
    String key,
  ) async {
    return DIDKit.issueCredential(credential, options, key);
  }

  @override
  Future<String> verifyCredential(
    String credential,
    String options,
  ) async {
    return DIDKit.verifyCredential(credential, options);
  }

  @override
  Future<String> issuePresentation(
    String presentation,
    String options,
    String key,
  ) async {
    return DIDKit.issuePresentation(presentation, options, key);
  }

  @override
  Future<String> verifyPresentation(
    String presentation,
    String options,
  ) async {
    return DIDKit.verifyPresentation(presentation, options);
  }

  @override
  Future<String> resolveDID(
    String did,
    String inputMetadata,
  ) async {
    return DIDKit.resolveDID(did, inputMetadata);
  }

  @override
  Future<String> dereferenceDIDURL(
    String didUrl,
    String inputMetadata,
  ) async {
    return DIDKit.dereferenceDIDURL(didUrl, inputMetadata);
  }

  @override
  Future<String> DIDAuth(
    String did,
    String options,
    String key,
  ) async {
    return DIDKit.DIDAuth(did, options, key);
  }

  @override
  Future<String> prepareIssueCredential(
    String credential,
    String options,
    String key,
  ) async {
    return DIDKit.prepareIssueCredential(
      credential,
      options,
      key,
    );
  }

  @override
  Future<String> completeIssueCredential(
    String credential,
    String preparation,
    String signature,
  ) async {
    return DIDKit.completeIssueCredential(
      credential,
      preparation,
      signature,
    );
  }

  @override
  Future<String> prepareIssuePresentation(
    String presentation,
    String options,
    String key,
  ) async {
    return DIDKit.prepareIssuePresentation(
      presentation,
      options,
      key,
    );
  }

  @override
  Future<String> completeIssuePresentation(
    String presentation,
    String preparation,
    String signature,
  ) async {
    return DIDKit.completeIssuePresentation(
      presentation,
      preparation,
      signature,
    );
  }
}

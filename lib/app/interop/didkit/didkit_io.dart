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
  String keyToDID(String methodName, String key) {
    return DIDKit.keyToDID(methodName, key);
  }

  @override
  String keyToDIDKey(String key) {
    return DIDKit.keyToDIDKey(key);
  }

  @override
  String keyToVerificationMethod(String methodName, String key) {
    return DIDKit.keyToVerificationMethod(methodName, key);
  }

  @override
  String issueCredential(String credential, String options, String key) {
    return DIDKit.issueCredential(credential, options, key);
  }

  @override
  String verifyCredential(String credential, String options) {
    return DIDKit.verifyCredential(credential, options);
  }

  @override
  String issuePresentation(String presentation, String options, String key) {
    return DIDKit.issuePresentation(presentation, options, key);
  }

  @override
  String verifyPresentation(String presentation, String options) {
    return DIDKit.verifyPresentation(presentation, options);
  }

  @override
  String resolveDID(String did, String inputMetadata) {
    return DIDKit.resolveDID(did, inputMetadata);
  }

  @override
  String dereferenceDIDURL(String didUrl, String inputMetadata) {
    return DIDKit.dereferenceDIDURL(didUrl, inputMetadata);
  }
}

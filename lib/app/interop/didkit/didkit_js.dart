@JS()
library didkit;

import 'package:js/js.dart';

import 'didkit.dart';

DIDKitProvider getProvider() => DIDKitWeb();

@JS('DIDKit')
class DIDKitJS {
  external static String getVersion();

  external static String generateEd25519Key();

  external static String keyToDID(String methodName, String key);

  external static String keyToDIDKey(String key);

  external static String keyToVerificationMethod(String methodName, String key);

  external static String issueCredential(
      String credential, String options, String key);

  external static String verifyCredential(String credential, String options);

  external static String issuePresentation(
      String presentation, String options, String key);

  external static String verifyPresentation(
      String presentation, String options);

  external static String resolveDID(String did, String inputMetadata);

  external static String dereferenceDIDURL(String didUrl, String inputMetadata);
}

class DIDKitWeb extends DIDKitProvider {
  @override
  String getVersion() {
    return DIDKitJS.getVersion();
  }

  @override
  String generateEd25519Key() {
    return DIDKitJS.generateEd25519Key();
  }

  @override
  String keyToDID(String methodName, String key) {
    return DIDKitJS.keyToDID(methodName, key);
  }

  @override
  String keyToVerificationMethod(String methodName, String key) {
    return DIDKitJS.keyToVerificationMethod(methodName, key);
  }

  @override
  String issueCredential(String credential, String options, String key) {
    return DIDKitJS.issueCredential(credential, options, key);
  }

  @override
  String verifyCredential(String credential, String options) {
    return DIDKitJS.verifyCredential(credential, options);
  }

  @override
  String issuePresentation(String presentation, String options, String key) {
    return DIDKitJS.issuePresentation(presentation, options, key);
  }

  @override
  String verifyPresentation(String presentation, String options) {
    return DIDKitJS.verifyPresentation(presentation, options);
  }

  @override
  String resolveDID(String did, String inputMetadata) {
    return DIDKitJS.resolveDID(did, inputMetadata);
  }

  @override
  String dereferenceDIDURL(String didUrl, String inputMetadata) {
    return DIDKitJS.dereferenceDIDURL(didUrl, inputMetadata);
  }
}

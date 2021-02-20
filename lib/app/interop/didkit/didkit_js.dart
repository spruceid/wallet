@JS()
library didkit;

import 'package:js/js.dart';

import 'didkit.dart';

DIDKitProvider getProvider() => DIDKitWeb();

@JS('window.DIDKit.getVersion')
external String _getVersion();

@JS('window.DIDKit.generateEd25519Key')
external String _generateEd25519Key();

@JS('window.DIDKit.keyToDID')
external String _keyToDID(String methodName, String key);

@JS('window.DIDKit.keyToDIDKey')
external String _keyToDIDKey(String key);

@JS('window.DIDKit.keyToVerificationMethod')
external String _keyToVerificationMethod(String methodName, String key);

@JS('window.DIDKit.issueCredential')
external String _issueCredential(String credential, String options, String key);

@JS('window.DIDKit.verifyCredential')
external String _verifyCredential(String credential, String options);

@JS('window.DIDKit.issuePresentation')
external String _issuePresentation(
    String presentation, String options, String key);

@JS('window.DIDKit.verifyPresentation')
external String _verifyPresentation(String presentation, String options);

@JS('window.DIDKit.resolveDID')
external String _resolveDID(String did, String inputMetadata);

@JS('window.DIDKit.dereferenceDIDURL')
external String _dereferenceDIDURL(String didUrl, String inputMetadata);

class DIDKitWeb extends DIDKitProvider {
  @override
  String getVersion() {
    return _getVersion();
  }

  @override
  String generateEd25519Key() {
    return _generateEd25519Key();
  }

  @override
  String keyToDID(String methodName, String key) {
    return _keyToDID(methodName, key);
  }

  @override
  String keyToDIDKey(String key) {
    return _keyToDIDKey(key);
  }

  @override
  String keyToVerificationMethod(String methodName, String key) {
    return _keyToVerificationMethod(methodName, key);
  }

  @override
  String issueCredential(String credential, String options, String key) {
    return _issueCredential(credential, options, key);
  }

  @override
  String verifyCredential(String credential, String options) {
    return _verifyCredential(credential, options);
  }

  @override
  String issuePresentation(String presentation, String options, String key) {
    return _issuePresentation(presentation, options, key);
  }

  @override
  String verifyPresentation(String presentation, String options) {
    return _verifyPresentation(presentation, options);
  }

  @override
  String resolveDID(String did, String inputMetadata) {
    return _resolveDID(did, inputMetadata);
  }

  @override
  String dereferenceDIDURL(String didUrl, String inputMetadata) {
    return _dereferenceDIDURL(didUrl, inputMetadata);
  }
}

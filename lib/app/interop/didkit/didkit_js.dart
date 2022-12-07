@JS()
library didkit;

import 'package:js/js.dart';
import 'package:js/js_util.dart';

import 'didkit.dart';

DIDKitProvider getProvider() => DIDKitWeb();

@JS('window.DIDKit.getVersion')
external String _getVersion();

@JS('window.DIDKit.generateEd25519Key')
external String _generateEd25519Key();

@JS('window.DIDKit.generateSecp256r1Key')
external String _generateSecp256r1Key();

@JS('window.DIDKit.generateSecp256k1Key')
external String _generateSecp256k1Key();

@JS('window.DIDKit.generateSecp384r1Key')
external String _generateSecp384r1Key();

@JS('window.DIDKit.keyToDID')
external String _keyToDID(String methodName, String key);

@JS('window.DIDKit.keyToVerificationMethod')
external String _keyToVerificationMethod(String methodName, String key);

@JS('window.DIDKit.issueCredential')
external String _issueCredential(
  String credential,
  String options,
  String key,
);

@JS('window.DIDKit.verifyCredential')
external String _verifyCredential(
  String credential,
  String options,
);

@JS('window.DIDKit.issuePresentation')
external String _issuePresentation(
  String presentation,
  String options,
  String key,
);

@JS('window.DIDKit.verifyPresentation')
external String _verifyPresentation(
  String presentation,
  String options,
);

@JS('window.DIDKit.resolveDID')
external String _resolveDID(
  String did,
  String inputMetadata,
);

@JS('window.DIDKit.dereferenceDIDURL')
external String _dereferenceDIDURL(
  String didUrl,
  String inputMetadata,
);

@JS('window.DIDKit.DIDAuth')
external String _DIDAuth(
  String did,
  String options,
  String key,
);

@JS('window.DIDKit.prepareIssueCredential')
external String _prepareIssueCredential(
  String credential,
  String options,
  String key,
);

@JS('window.DIDKit.completeIssueCredential')
external String _completeIssueCredential(
  String credential,
  String preparation,
  String signature,
);

@JS('window.DIDKit.prepareIssuePresentation')
external String _prepareIssuePresentation(
  String presentation,
  String options,
  String key,
);

@JS('window.DIDKit.completeIssuePresentation')
external String _completeIssuePresentation(
  String presentation,
  String preparation,
  String signature,
);

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
  String generateSecp256r1Key() {
    return _generateSecp256r1Key();
  }

  @override
  String generateSecp256k1Key() {
    return _generateSecp256k1Key();
  }

  @override
  String generateSecp384r1Key() {
    return _generateSecp384r1Key();
  }

  @override
  String keyToDID(String methodName, String key) {
    return _keyToDID(methodName, key);
  }

  @override
  Future<String> keyToVerificationMethod(String methodName, String key) async {
    return await promiseToFuture(_keyToVerificationMethod(methodName, key));
  }

  @override
  Future<String> issueCredential(
    String credential,
    String options,
    String key,
  ) async {
    return await promiseToFuture(_issueCredential(
      credential,
      options,
      key,
    ));
  }

  @override
  Future<String> verifyCredential(
    String credential,
    String options,
  ) async {
    return await promiseToFuture(_verifyCredential(
      credential,
      options,
    ));
  }

  @override
  Future<String> issuePresentation(
    String presentation,
    String options,
    String key,
  ) async {
    return await promiseToFuture(_issuePresentation(
      presentation,
      options,
      key,
    ));
  }

  @override
  Future<String> verifyPresentation(
    String presentation,
    String options,
  ) async {
    return await promiseToFuture(_verifyPresentation(
      presentation,
      options,
    ));
  }

  @override
  Future<String> resolveDID(
    String did,
    String inputMetadata,
  ) async {
    return await promiseToFuture(_resolveDID(
      did,
      inputMetadata,
    ));
  }

  @override
  Future<String> dereferenceDIDURL(
    String didUrl,
    String inputMetadata,
  ) async {
    return await promiseToFuture(_dereferenceDIDURL(
      didUrl,
      inputMetadata,
    ));
  }

  @override
  Future<String> DIDAuth(
    String did,
    String options,
    String key,
  ) async {
    return await promiseToFuture(_DIDAuth(
      did,
      options,
      key,
    ));
  }

  @override
  Future<String> prepareIssueCredential(
    String credential,
    String options,
    String key,
  ) async {
    return await promiseToFuture(_prepareIssueCredential(
      credential,
      options,
      key,
    ));
  }

  @override
  Future<String> completeIssueCredential(
    String credential,
    String preparation,
    String signature,
  ) async {
    return await promiseToFuture(_completeIssueCredential(
      credential,
      preparation,
      signature,
    ));
  }

  @override
  Future<String> prepareIssuePresentation(
    String presentation,
    String options,
    String key,
  ) async {
    return await promiseToFuture(_prepareIssuePresentation(
      presentation,
      options,
      key,
    ));
  }

  @override
  Future<String> completeIssuePresentation(
    String presentation,
    String preparation,
    String signature,
  ) async {
    return await promiseToFuture(_completeIssuePresentation(
      presentation,
      preparation,
      signature,
    ));
  }
}

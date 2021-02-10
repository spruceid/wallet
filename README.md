# credible

Credible Wallet

## Getting Started

A manual build of this project has the following dependencies:

* A nightly build of the rust compiler, most easily obtained using [rustup](https://www.rust-lang.org/tools/install). 
Once installed, nightly can be enabled globally using:
```bash
$ rustup default nightly 
```
Or on a per-project level by running the following in the root of the targeted cargo project:
```bash
$ rustup override set nightly
```

* Java 7 or higher

* [Flutter](https://flutter.dev/docs/get-started/install) set to the dev channel. 
This is done on *nix type systems after installation by running:
```bash
$ flutter channel dev
$ flutter upgrade
```

* [Android Studio](https://developer.android.com/studio/install) which must be installed, then opened for the first time to allow further dependencies to be installed.

This project also depends on two other Spruce projects first, [DIDKit](https://github.com/spruceid/didkit), which depends on [ssi](https://github.com/spruceid/ssi).

For now it's required to build DIDKit on the side before building this project. For more detailed instructions on how to set it up, please see the [DIDKit Installation Manual Installation](/docs/didkit/install#manual) and the [DIDKit Android Bindings](/docs/didkit/ffis#android) Sections.

If all of the Spruce dependencies are in the same directory, the will correcltly resolve using relative paths, and the next two steps can be skipped

Otherwise, point didkit to ssi by editing the didkit/lib/Cargo.toml:
```toml
[dependencies]
ssi = { path = "path/to/ssi", default-features = false }
did-key = { path = "path/to/ssi/did-key" }
did-tezos = { path = "path/to/ssi/did-tezos" }
did-web = { path = "path/to/ssi/did-web", optional = true }
```

And point Credible to didkit in the credible/pubspec.yaml:
```yaml
dependencies:
  didkit:
    path: path/to/didkit/lib/flutter
```

Then, to build the flutter artifacts, run one of the following
commands from the root of this repository:

```bash
$ flutter build apk             # Android APK
$ flutter build appbundle       # Android Appbundle
```

Then [Android Studio](https://developer.android.com/studio/run/emulator) can be used to run the built application.

Alternatively, 
```bash
$ flutter run
```
With a running emulator will work as well.

## Supported Protocols

All QRCode interactions start as listed below:

- User scans a QRCode containing a URL;
- User is presented the choice to trust the domain in the URL;
- App makes a GET request to the URL;

Then, depending on the type of message, one of the following protocols will be
executed.

### CredentialOffer

After receiving a `CredentialOffer` from a trusted host, the app calls the API
with `subject_id` in the form body, that value is the didKey obtained from the
private key stored in the `FlutterSecureStorage`, which is backed by KeyStore 
on Android and Keychain on iOS.

The flow of events and actions is listed below:

- User is presented a credential preview to review and make a decision;
- App generates `didKey` from the stored private key using `DIDKit.keyToDIDKey`;
- App makes a POST request to the initial URL with the subject set to the `didKey`;
- App receives and stores the new credential;
- User is redirect back to the wallet.

### VerifiablePresentationRequest

After receiving a `VerifiablePresentationRequest` from a trusted host, the app
calls the API with `presentation` the form body, that value is a JSON encoded
string with the presentation obtained from the selected credential and signed
with the credential's private key using `DIDKit.issuePresentation`.

Here are some of the parameters used to generate a presentation:

- `presentation`
  - `id` is set to a random `UUID.v4` string;
  - `holder` is set to the selected credential's `didKey`;
  - `verifiableCredential` is set to the credential value;
- `options`
  - `verificationMethod` is set to the DID's `verificationMethod` `id`;
  - `proofPurpose` is set to `'authentication'`;
  - `challenge` is set to the request's `challenge';
  - `domain` is set to the request's `domain';
- `key` is the credential's stored private key;

The flow of events and actions is listed below:

- User is presented a presentation request to review and make a decision;
- App generates `didKey` from the stored private key using `DIDKit.keyToDIDKey`;
- App issues a presentation using `DIDKit.issuePresentation`;
- App makes a POST request to the initial URL with the presentation;
- User is redirect back to the wallet.

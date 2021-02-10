![Credible header](https://spruceid.dev/assets/images/crediblehead-9f539ffe32f0082fb362572e7d308c6e.png)

[![](https://img.shields.io/badge/Flutter-1.22.6-blue)](https://flutter.dev/docs/get-started/install) [![](https://img.shields.io/badge/ssi-v0.1-green)](https://www.github.com/spruceid/ssi) [![](https://img.shields.io/badge/DIDKit-v0.1-green)](https://www.github.com/spruceid/didkit) [![](https://img.shields.io/badge/License-Apache--2.0-green)](https://github.com/spruceid/credible/blob/main/LICENSE) [![](https://img.shields.io/twitter/follow/sprucesystems?label=Follow&style=social)](https://twitter.com/sprucesystems) 

Check out the Credible documentation [here](https://spruceid.dev/docs/credible/).

# Credible

Credible is a lightweight, app-store-approved wallet for individuals to manage DIDs and VCs from their mobile phones. It is white-label friendly, open-source, and build on our core SSI libraries.  Over time, we expect to integrate many DID methods and presentation protocols to make this the wallet fully-featured without being ledger-bound or vendor-favoring.

## Getting Started
Regardless of target platform manual build of this project has the 
following dependencies:

* A nightly build of the rust compiler, most easily obtained using
  [rustup](https://www.rust-lang.org/tools/install). Once installed, 
  nightly can be enabled globally using:

```bash
$ rustup default nightly 
```

Or on a per-project level by running the following in the root of the 
targeted cargo project:

```bash
$ rustup override set nightly
```
* Java 7 or higher

* [Flutter](https://flutter.dev/docs/get-started/install) set to the 
  dev channel. This is done on *nix type systems after installation 
  by running:
```bash
$ flutter channel dev
$ flutter upgrade
```

This project also depends on two other Spruce projects:
[DIDKit](https://github.com/spruceid/didkit), which in turn depends on
[ssi](https://github.com/spruceid/ssi). The default assumption is that 
these three repos (`credible`, `didkit`, and `ssi`) are in the same
directory, though instructions for override are provided below.

### Android Specific Instructions: 
Android builds have the additional requirement of:

[Android Studio](https://developer.android.com/studio/install) which must be
installed, then opened for the first time to allow further dependencies to be
installed. Addiontally, requires the installation of Android NDK in Android 
Studio by going to Settings > Appearance & Behavior > System Settings > 
Android SDK. Select and install the NDK (Side by Side).

After that, the following will need to be run from the root of `didkit`:
(Note, this may take some time as it runs several builds for different targets)
```bash
$ export ANDROID_SDK_ROOT=/path/to/Android/sdk
$ make -C lib install-rustup-android
$ make -C lib ../target/test/java.stamp
$ make -C lib ../target/test/aar.stamp
$ make -C lib ../target/test/flutter.stamp
$ cargo build
```

### iOS Specific Instructions:
iOS builds have the additional requirement of cocoapods, which can 
be installed on MacOS using `brew`:
```bash
$ brew install cocoapods
```

If building for iOS, the following will need to be run from the root of `didkit`:
(Note, this may take some time as it runs several builds for different targets)
```bash
$ make -C lib install-rustup-ios 
$ make -C lib ../target/test/ios.stamp
$ cargo build
```

### Platform agnostic final steps:
Regardless of platform, run the following:
```bash
$ flutter doctor
```
If any issues are detected, please resolve them before proceeding.

If all of the Spruce dependencies are in the same directory, they will correctly
resolve using relative paths, and the next two steps can be skipped. Otherwise,
point `didkit` to `ssi` by editing the didkit/lib/Cargo.toml:

```toml
[dependencies]
ssi = { path = "path/to/ssi", default-features = false }
did-key = { path = "path/to/ssi/did-key" }
did-tezos = { path = "path/to/ssi/did-tezos" }
did-web = { path = "path/to/ssi/did-web", optional = true }
```

And point `Credible` to `didkit` in the credible/pubspec.yaml:

```yaml
dependencies:
  didkit:
    path: path/to/didkit/lib/flutter
```

Then, to build the flutter artifacts, run one of the following
commands from the root of the `credible` repository to either build
or run the app on an emulator/connected dev-device:

```bash
$ flutter build apk                     # Android APK
$ flutter build appbundle               # Android Appbundle
$ flutter build ios                     # iOS
$ flutter build ipa                     # iOS
$ flutter run  --no-sound-null-safety   # Run on emulator
```

If any errors are encountered, the first thing to try is running
```bash
$ flutter clean
```
From the root of `credible` then retrying the build or run.

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

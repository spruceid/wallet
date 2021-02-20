![Credible header](https://spruceid.dev/assets/images/crediblehead-9f539ffe32f0082fb362572e7d308c6e.png)

[![](https://img.shields.io/badge/Flutter-1.22.6-blue)](https://flutter.dev/docs/get-started/install) [![](https://img.shields.io/badge/ssi-v0.1-green)](https://www.github.com/spruceid/ssi) [![](https://img.shields.io/badge/DIDKit-v0.1-green)](https://www.github.com/spruceid/didkit) [![](https://img.shields.io/badge/License-Apache--2.0-green)](https://github.com/spruceid/credible/blob/main/LICENSE) [![](https://img.shields.io/twitter/follow/sprucesystems?label=Follow&style=social)](https://twitter.com/sprucesystems) 

Check out the Credible documentation [here](https://spruceid.dev/docs/credible/).

# Credible

Credible is a native mobile wallet that supports W3C Verifiable Credentials and
Decentralized Identifiers built on [DIDKit](https://github.com/spruceid/didkit)
and [Flutter](https://flutter.dev/). We packaged the DIDKit library written in
Rust into a Flutter application running on both Android and iOS, using C
bindings and Dart’s FFI capabilities. This is the wallet counterpart to the
rich, growing toolkit supplied by DIDKit, the two pillars of a reference
architecture for creating trusted interactions at scale.

## Maturity disclaimer
In the v0.1 release on February 10, 2021, Credible has not yet undergone a
formal security audit and to desired levels of confidence for suitable use in
production systems. This implementation is currently suitable for exploratory
work and experimentation only. We welcome feedback on the usability,
architecture, and security of this implementation and are committed to a
conducting a formal audit with a reputable security firm before the v1.0
release. We are also working on large stability improvements through a
continuous integration testing process across Android and iOS.

We are setting up a process to accept contributions. Please feel free to open
issues or PRs in the interim, but we cannot merge external changes until this
process is in place.

We are also in the process of listing Credible on the iOS TestFlight and
Android Play Beta programs, and eventually their respective app marketplaces
plus F-Droid.

## Getting Started
To manually build Credible for either Android or iOS, you will need to install
the following dependencies:

- Rust (`nightly`)
- Java 7 or higher
- Flutter (`dev` channel)
- `DIDKit`/`SSI`

### Rust

It is recommended to use [rustup](https://www.rust-lang.org/tools/install) to
manage your Rust installation.

To use the `nightly` version of Rust globally, you should execute the following
command:

```bash
$ rustup default nightly 
```

Or, if you would prefer to configure `nightly` for a single project, you should
execute the following command at its root (where `Cargo.toml` lives).

```bash
$ rustup override set nightly
```

### Java

On Ubuntu you could run:

```bash
# apt update
# apt install openjdk-8-jdk
```

For more information, please refer to the documentation of your favorite flavour
of Java and your operating system/package manager.

### Flutter

Please follow the official instalation instructions available 
[here](https://flutter.dev/docs/get-started/install) to install Flutter,
don't forget to also install the build dependencies for the platform you
will be building (Android SDK/NDK, Xcode, etc).

We currently only support build this project using the `dev` channel of Flutter.

To change your installation to the `dev` channel, please execute the following command:

```bash
$ flutter channel dev
$ flutter upgrade
```

To confirm that everything is setup correctly, please run the following command
and resolve any issues that arise before proceeding to the next steps.

```bash
$ flutter doctor
```

### DIDKit and SSI

This project also depends on two other Spruce projects, [`DIDKit`](https://github.com/spruceid/didkit)
and [`SSI`](https://github.com/spruceid/ssi). 

These projects are all configured to work with relative paths by default,
so it is recommended to clone them all under the same root directory, for example
`$HOME/spruceid/{didkit,ssi,credible}`.

## Platform Specific Instructions

### Android 

To build Credible for Android, you will require both the Android SDK and NDK.

These two dependencies can be easily obtained with
[Android Studio](https://developer.android.com/studio/install), which when
first openened 
installed, then opened for the first time to allow further dependencies to be
installed. Addiontally, requires the installation of Android NDK in Android 
Studio by going to Settings > Appearance & Behavior > System Settings > 
Android SDK. Select and install the NDK (Side by Side).

If your Android SDK doesn't live at `$HOME/Android/Sdk` you will need to set
`ANDROID_SDK_ROOT` like so:

```bash
$ export ANDROID_SDK_ROOT=/path/to/Android/Sdk
```

If for some reason your `build-tools` and/or `NDK` also live in different
locations, you can also configure the following two environment variables:

```bash
$ export ANDROID_TOOLS=/path/to/build-tools
$ export ANDROID_NDK_HOME=/path/to/ndk
```

#### Building DIDKit

To build `DIDKit` for the Android targets, you will go to the root of `DIDKit`
and run:

```bash
$ make -C lib install-rustup-android
$ make -C lib ../target/test/java.stamp
$ make -C lib ../target/test/aar.stamp
$ make -C lib ../target/test/flutter.stamp
$ cargo build
```

*This may take some time as it compiles the entire project for multiple targets*

### iOS

To build Credible for iOS you will need to install CocoaPods, which can be done
with Homebrew on MacOS.

```bash
$ brew install cocoapods
```

### WEB
$ make -C lib install-wasm-pack
$ make -C lib ../target/test/wasm.stamp
$ flutter build web --no-sound-null-safety --csp --web-renderer html --release

#### Building DIDKit

To build DIDKit for the iOS targets, you will go to the root of `DIDKit` and
run: 

```bash
$ make -C lib install-rustup-ios 
$ make -C lib ../target/test/ios.stamp
$ cargo build
```

*This may take some time as it compiles the entire project for multiple targets*

## Building

You are now ready to build Credible.

If you want to run the project on your connected device, you can use:
```bash
$ flutter run  --no-sound-null-safety                                 # Run on emulator
```

Otherwise, Flutter allows us to build many artifacts for Android and iOS, below you can
find the most common and useful commands, all of which you should run from the root of
Credible.

### Android APK
```bash
$ flutter build apk --no-sound-null-safety
```

### Android App Bundle
```bash
$ flutter build appbundle --no-sound-null-safety
```

### iOS .app for Simulator
```bash
$ flutter build ios --no-sound-null-safety --no-codesign --simulator
```

### iOS .app for Devices
```bash
$ flutter build ios --no-sound-null-safety --no-codesign
```

### iOS IPA
```bash
$ flutter build ipa --no-sound-null-safety
```

For more details about any of these commands you can run
```bash
$ flutter build $SUBCOMMAND --help
```

### Note about `nullsafety`
While we are ready to migrate to Dart with nullsafety, a couple of the dependencies of
the project are still lagging behind, so we need to add `--no-sound-null-safely` to both
run and build commands for the time being.

### Troubleshooting

If you encounter any errors in the build process described here, please first try
clean builds of the projects listed.

For instance, on Flutter, you can delete build files to start over by running:
```bash
$ flutter clean
```

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

And below is another version of the step-by-step:

| Wallet | <sup>1</sup>| | Server |
| --- | --- | :---: | ---: |
| Scan QRCode <sup>2</sup> | | |
| Trust Host | ○ / × | | |
| HTTP GET | | → | https://domain.tld/endpoint |
| | | ← | CredentialOffer |
| Preview Credential | | | |
| Choose DID | ○ / × | | |
| HTTP POST <sup>3</sup> | | → | https://domain.tld/endpoint |
| | | ← | VerifiableCredential |
| Verify Credential | | | |
| Store Credential | | | |

*<sup>1</sup> Whether this action requires user confirmation, exiting the flow
early when the user denies.*  
*<sup>2</sup> The QRCode should contain the HTTP endpoint where the requests
will be made.*  
*<sup>3</sup> The body of the request contains a field `subject_id` set to the
chosen DID.*

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

And below is another version of the step-by-step:

| Wallet | <sup>1</sup> | | Server |
| --- | --- | :---: | ---: |
| Scan QRCode <sup>2</sup> | | |
| Trust Host | ○ / × | | |
| HTTP GET | | → | https://domain.tld/endpoint |
| | | ← | VerifiablePresentationRequest |
| Preview Presentation | | | |
| Choose Verifiable Credential | ○ / × | | |
| HTTP POST <sup>3</sup> | | → | https://domain.tld/endpoint |
| | | ← | Result |

*<sup>1</sup> Whether this action requires user confirmation, exiting the flow
early when the user denies.*  
*<sup>2</sup> The QRCode should contain the HTTP endpoint where the requests
will be made.*  
*<sup>3</sup> The body of the request contains a field `presentation` set to the
verifiable presentation.*

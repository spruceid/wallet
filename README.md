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

## Security Audits
Credible has undergone the following security reviews:
- [March 14th, 2022 - Trail of Bits](https://github.com/trailofbits/publications/blob/master/reviews/SpruceID.pdf) | [Summary of Findings](https://blog.spruceid.com/spruce-completes-first-security-audit-from-trail-of-bits/)

We are setting up a process to accept contributions. Please feel free to open
issues or PRs in the interim, but we cannot merge external changes until this
process is in place.

## Common Dependencies

To manually build Credible for either Android or iOS, you will need to install
the following dependencies:

- Rust
- Java 7 or higher
- Flutter (`dev` channel)
- [DIDKit](https://github.com/spruceid/didkit)/[SSI](https://github.com/spruceid/ssi)
- `wasm-pack` (WEB)
- `binaryen` (WEB and targeting ASM.js)

### Rust

It is recommended to use [rustup](https://www.rust-lang.org/tools/install) to
manage your Rust installation.

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

### `wasm-pack` (Required for both WEB targets)

To build the WASM target you will need `wasm-pack`, it can be obtained running:

```bash
$ curl https://rustwasm.github.io/wasm-pack/installer/init.sh -sSf | sh
```

### `binaryen`

To build Credible for WEB using ASM.js you will need
[binaryen](https://github.com/WebAssembly/binaryen), which allows the conversion
of DIDKit WASM to ASM.js. This is necessary when you don't have WASM support and
need to run your page in pure Javascript. More detailed instructions on
how to build `binaryen` can be found [here](https://github.com/WebAssembly/binaryen).

If you are in a UNIX-like distribution you just have to clone the repo and build,
we recommend cloning into your `${HOME}`, to avoid having to specify the
`${BINARYEN_ROOT}` variable:

```bash
$ git clone https://github.com/WebAssembly/binaryen ~/binaryen
$ cd ~/binaryen
$ cmake . && make
```
### DIDKit and SSI

This project also depends on two other Spruce projects,
[`DIDKit`](https://github.com/spruceid/didkit) and
[`SSI`](https://github.com/spruceid/ssi). 

These projects are all configured to work with relative paths by default,
so it is recommended to clone them all under the same root directory, for 
example `$HOME/spruceid/{didkit,ssi,credible}`.

## Target-Specific Dependencies

### Android Dependencies

To build Credible for Android, you will require both the Android SDK and NDK.

These two dependencies can be easily obtained with [Android
Studio](https://developer.android.com/studio/install), which install further
dependencies upon first being opened after installation. Installing the
appropriate Android NDK (often not the newest) in Android Studio can be
accomplished by going to Settings > Appearance & Behavior > System Settings >
Android SDK and selecting to install the "NDK (Side by Side)". An alternative
method of installing SDK and NDK without Android Studio can be found in the
optional [install_android_dependencies.sh](install_android_dependencies.sh)
script included here.

If your Android SDK doesn't live at `$HOME/Android/Sdk` you will need to set
`ANDROID_SDK_ROOT` like so:

```bash
$ export ANDROID_SDK_ROOT=/path/to/Android/Sdk
```

:::note Some users have experienced difficulties with cross-compilation
artefacts missing from the newest NDK, which is downloaded by default in the
installation process.  If you experience errors of this kind, you may have to
manually downgrade or install multiple NDK versions as [shown
here])(img/ndk_downgrade.png) in the Android Studio installer (screengrabbed
from an Ubuntu installation). Alternately, running all or parts of the
[install_android_dependencies.sh](install_android_dependencies.sh) script may be
helpful.

If your `build-tools` and/or `NDK`  live in different locations than the default ones inside /SDK/, or if you want to specify a specific NDK or build-tools version, you can manually configure the following two environment variables:

```bash
$ export ANDROID_TOOLS=/path/to/SDK/build-tools/XX.X.X/
$ export ANDROID_NDK_HOME=/path/to/SDK/ndk/XX.X.XXXXX/
```
::: 

### iOS Dependencies

To build Credible for iOS you will need to install CocoaPods, which can be done
with Homebrew on MacOS.

```bash
$ brew install cocoapods
```

## Building DIDKit for different targets

### Android

To build `DIDKit` for the Android targets, you will go to the root of `DIDKit`
and run:

```bash
$ make -C lib install-rustup-android
$ make -C lib ../target/test/java.stamp
$ make -C lib ../target/test/android.stamp
$ make -C lib ../target/test/flutter.stamp
$ cargo build
```
*This may take some time as it compiles the entire project for multiple targets*

### Android APK
```bash
$ flutter build apk
```

### Android App Bundle
```bash
$ flutter build appbundle
```

### iOS

To build DIDKit for the iOS targets, you will go to the root of `DIDKit` and run
: 

```bash
$ make -C lib install-rustup-ios 
$ make -C lib ../target/test/ios.stamp
$ cargo build
```

### Web *using WASM*

```bash
$ make -C lib ../target/test/wasm.stamp
```

### Web *using ASM.js*

If you have installed `bynarien` somewhere other than $HOME, you will have to
set `BYNARIEN_ROOT` as shown below, otherwise, just run the `make` command.

```bash
$ export BINARYEN_ROOT=/path/to/binaryen
$ make -C lib ../target/test/asmjs.stamp
```

## Building Credible

You are now ready to build or run Credible.

### Run on emulator

If you want to run the project on your connected device, you can use:

```bash
$ flutter run
```

### Run on browser

If you want to run the project on your browser, you can use:

```bash
$ flutter run -d chrome --csp --release
```

Otherwise, Flutter allows us to build many artifacts for Android, iOS and WEB,
below you can find the most common and useful commands, all of which you should
run from the root of Credible.

### iOS .app for Simulator
```bash
$ flutter build ios --simulator
```

### iOS .app for Devices
```bash
$ flutter build ios --no-codesign
```

### iOS IPA
```bash
$ flutter build ipa
```

### Web
```bash
$ flutter build web \
  --csp \
  --release
```

If you don't have support for WASM, you'll probably need to provide your own
`canvaskit` dependency without WASM as well as DIDKit, to do that you need to
specify the `FLUTTER_WEB_CANVASKIT_URL` in the build command like below.

```bash
$ flutter build web \
  --csp \
  --dart-define=FLUTTER_WEB_CANVASKIT_URL=vendor/ \
  --release
```

For more details about any of these commands you can run
```bash
$ flutter build $SUBCOMMAND --help
```


### Note about `canvaskit`

Since by default `canvaskit` comes in a `WASM` build, in order to the `ASM.js`
be fully supported `canvaskit` was manually built for this target.

A prebuilt `canvaskit` is already included in the Credible web folder.
If you want to build it by yourself, however, follow these steps:

- Install [`emscripten`](https://emscripten.org/docs/getting_started/downloads.html)
- Clone [Skia](https://skia.org/user/download) repository and pull its dependencies

```bash
git clone https://skia.googlesource.com/skia.git --depth 1 --branch canvaskit/0.22.0
cd skia
python2 tools/git-sync-deps
```

- Modify build script `modules/canvaskit/compile.sh`

```
diff --git a/modules/canvaskit/compile.sh b/modules/canvaskit/compile.sh
index 6ba58bfae9..51f0297eb6 100755
--- a/modules/canvaskit/compile.sh
+++ b/modules/canvaskit/compile.sh
@@ -397,6 +397,7 @@ EMCC_DEBUG=1 ${EMCXX} \
     -s MODULARIZE=1 \
     -s NO_EXIT_RUNTIME=1 \
     -s INITIAL_MEMORY=128MB \
-    -s WASM=1 \
+    -s WASM=0 \
+    -s NO_DYNAMIC_EXECUTION=1 \
     $STRICTNESS \
     -o $BUILD_DIR/canvaskit.js
```

- Build `canvaskit`

```bash
$ cd modules/canvaskit
$ make debug
```

- Replace this line on `$SKIA/modules/canvaskit/canvaskit/bin/canvaskit.js`

```git
618c618
< var isNode = !(new Function('try {return this===window;}catch(e){ return false;}')());
---
> var isNode = false;
```

- Copy `$SKIA/modules/canvaskit/canvaskit/bin/canvaskit.js` to
`$CREDIBLE/web/vendor/`

- Build Credible as described above.

## Troubleshooting

If you encounter any errors in the build process described here, please first try
clean builds of the projects listed.

For instance, on Flutter, you can delete build files to start over by running:

```bash
$ flutter clean
```
Also, reviewing the
[install_android_dependencies.sh](install_android_dependencies.sh) script may be
helpful.

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

| Wallet                   | <sup>1</sup> |       |                      Server |
| ------------------------ | ------------ | :---: | --------------------------: |
| Scan QRCode <sup>2</sup> |              |       |
| Trust Host               | ○ / ×        |       |                             |
| HTTP GET                 |              |   →   | https://domain.tld/endpoint |
|                          |              |   ←   |             CredentialOffer |
| Preview Credential       |              |       |                             |
| Choose DID               | ○ / ×        |       |                             |
| HTTP POST <sup>3</sup>   |              |   →   | https://domain.tld/endpoint |
|                          |              |   ←   |        VerifiableCredential |
| Verify Credential        |              |       |                             |
| Store Credential         |              |       |                             |

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

| Wallet                       | <sup>1</sup> |       |                        Server |
| ---------------------------- | ------------ | :---: | ----------------------------: |
| Scan QRCode <sup>2</sup>     |              |       |
| Trust Host                   | ○ / ×        |       |                               |
| HTTP GET                     |              |   →   |   https://domain.tld/endpoint |
|                              |              |   ←   | VerifiablePresentationRequest |
| Preview Presentation         |              |       |                               |
| Choose Verifiable Credential | ○ / ×        |       |                               |
| HTTP POST <sup>3</sup>       |              |   →   |   https://domain.tld/endpoint |
|                              |              |   ←   |                        Result |

*<sup>1</sup> Whether this action requires user confirmation, exiting the flow
early when the user denies.*  
*<sup>2</sup> The QRCode should contain the HTTP endpoint where the requests
will be made.*  
*<sup>3</sup> The body of the request contains a field `presentation` set to the
verifiable presentation.*

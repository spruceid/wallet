# Trustchain FFI with flutter rust bridge

Provides Trustchain functionality in credible with FFI through [`flutter_rust_bridge`](https://github.com/fzyzcjy/flutter_rust_bridge).

## Install
The below steps follow the guide in [section 5](https://cjycode.com/flutter_rust_bridge/integrate.html):

- Clone [trustchain](https://github.com/alan-turing-institute/trustchain) to a path adjacent to credible root path.
- Install cargo [dependencies]():
```
cargo install flutter_rust_bridge_codegen
```
- Follow android [instructions](https://cjycode.com/flutter_rust_bridge/template/setup_android.html)
- Add targets:
```
rustup target add \
    aarch64-linux-android \
    armv7-linux-androideabi \
    x86_64-linux-android \
    i686-linux-android
```
- Add `ANDROID_NDK` as a [gradle property](https://cjycode.com/flutter_rust_bridge/template/setup_android.html#android_ndk-gradle-property):
```
echo "ANDROID_NDK=(path to NDK)" >> ~/.gradle/gradle.properties
```
- Install [`cargo ndk`](https://cjycode.com/flutter_rust_bridge/template/setup_android.html):
```shell
cargo install cargo-ndk --version 2.6.0
```

## Build
With an android emulator, build can be completed from credible root with:
```
flutter run
```
Upon any modifications to the Trustchain Rust API, the FFI needs to be rebuilt with:
```
flutter_rust_bridge_codegen \
    -r ../trustchain/trustchain-ion/src/api.rs \
    -d lib/bridge_generated.dart
```

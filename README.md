# credible

Credible Wallet

## Getting Started

This project depends on DIDKit.

For more detailed instructions on how to set it up,
please follow [this link](https://github.com/spruceid/didkit/blob/main/lib/FFI.md)

For now it's required to build DIDKit on the side before building this project.
You have to point to your local copy in the `pubspec.yml` file:

```yaml
didkit:
    path: ../path/to/didkit/lib/flutter
```

Then, to build the flutter artifacts, run one of the following
commands from the root of this repository:

```bash
$ flutter build apk             # Android APK
$ flutter build appbundle       # Android Appbundle
```
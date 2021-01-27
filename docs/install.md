---
id: install
title: Installation
---

## Manual Assembly (Android)

This project depends on [DIDKit](https://github.com/spruceid/didkit). 

For now it's required to build DIDKit on the side before building this project. For more detailed instructions on how to set it up, please see the [DIDKit Installation Manual Installation](/docs/didkit/install#manual) and the [DIDKit Android Bindings](/docs/didkit/ffis#android) Sections.

Once installed, you will have to point to your local copy of DIDKit/SSI in the `pubspec.yaml` file:

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

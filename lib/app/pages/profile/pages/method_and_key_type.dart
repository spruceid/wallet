import 'dart:async';

import 'package:credible/app/interop/didkit/didkit.dart';
import 'package:credible/app/interop/secure_storage/secure_storage.dart';
import 'package:credible/app/shared/ui/ui.dart';
import 'package:credible/app/shared/widget/back_leading_button.dart';
import 'package:credible/app/shared/widget/base/button.dart';
import 'package:credible/app/shared/widget/base/page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_modular/flutter_modular.dart';

enum DIDMethod { Jwk, Key }

extension DIDMethodString on DIDMethod {
  static DIDMethod parse(String value) {
    switch (value) {
      case 'jwk':
        return DIDMethod.Jwk;
      case 'key':
        return DIDMethod.Key;
      default:
        throw Exception("invalid '$value' value for DIDMethod");
    }
  }

  String display() {
    switch (this) {
      case DIDMethod.Jwk:
        return 'did:jwk';
      case DIDMethod.Key:
        return 'did:key';
    }
  }

  String stringify() {
    switch (this) {
      case DIDMethod.Jwk:
        return 'jwk';
      case DIDMethod.Key:
        return 'key';
    }
  }
}

enum KeyType {
  Ed25519,
  Secp256r1,
  Secp256k1,
  Secp384r1,
}

extension KeyTypeString on KeyType {
  static KeyType parse(String value) {
    switch (value) {
      case 'ed25519':
        return KeyType.Ed25519;
      case 'secp256r1':
        return KeyType.Secp256r1;
      case 'secp256k1':
        return KeyType.Secp256k1;
      case 'secp384r1':
        return KeyType.Secp384r1;
      default:
        throw Exception("invalid '$value' value for KeyType");
    }
  }

  String display() {
    switch (this) {
      case KeyType.Ed25519:
        return 'Ed25519';
      case KeyType.Secp256r1:
        return 'Secp256r1';
      case KeyType.Secp256k1:
        return 'Secp256k1';
      case KeyType.Secp384r1:
        return 'Secp384r1';
    }
  }

  String stringify() {
    switch (this) {
      case KeyType.Ed25519:
        return 'ed25519';
      case KeyType.Secp256r1:
        return 'secp256r1';
      case KeyType.Secp256k1:
        return 'secp256k1';
      case KeyType.Secp384r1:
        return 'secp384r1';
    }
  }
}

class MethodAndKeyTypePage extends StatefulWidget {
  const MethodAndKeyTypePage({
    Key? key,
  }) : super(key: key);

  @override
  _MethodAndKeyTypePageState createState() => _MethodAndKeyTypePageState();
}

class _MethodAndKeyTypePageState extends State<MethodAndKeyTypePage> {
  late Completer<String> preview;
  late bool valid;

  DIDMethod? didMethod;
  KeyType? keyType;

  @override
  void initState() {
    super.initState();
    loadValues();
    preview = Completer();
  }

  Future<void> loadValues() async {
    didMethod = DIDMethodString.parse(
        (await SecureStorageProvider.instance.get('did_method'))!);
    keyType = KeyTypeString.parse(
        (await SecureStorageProvider.instance.get('key_type'))!);

    setState(() {});

    await loadPreview();
  }

  Future<void> loadPreview() async {
    preview = Completer();

    if (didMethod == null) {
      preview.completeError('Invalid DID Method');
      return;
    }

    if (keyType == null) {
      preview.completeError('Invalid Key Type');
      return;
    }

    final key;
    switch (keyType!) {
      case KeyType.Ed25519:
        key = await SecureStorageProvider.instance.get('key/ed25519/0');
        break;
      case KeyType.Secp256r1:
        key = await SecureStorageProvider.instance.get('key/secp256r1/0');
        break;
      case KeyType.Secp256k1:
        key = await SecureStorageProvider.instance.get('key/secp256k1/0');
        break;
      case KeyType.Secp384r1:
        key = await SecureStorageProvider.instance.get('key/secp384r1/0');
        break;
    }

    valid = false;
    try {
      final did = DIDKitProvider.instance.keyToDID(didMethod!.stringify(), key);
      preview.complete(did);
      valid = true;
    } catch (e) {
      preview.completeError('This combination is not supported');
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return BasePage(
      title: 'DID Method and Key Type',
      titleLeading: BackLeadingButton(),
      titleTrailing: InkWell(
        borderRadius: BorderRadius.circular(8.0),
        onTap: valid
            ? () async {
                await SecureStorageProvider.instance
                    .set('did_method', didMethod!.stringify());

                await SecureStorageProvider.instance
                    .set('key_type', keyType!.stringify());

                Modular.to.pop();
              }
            : null,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 12.0,
            vertical: 8.0,
          ),
          child: Text(
            valid ? 'Save' : 'Cannot\nSave',
            textAlign: TextAlign.center,
            style: Theme.of(context)
                .textTheme
                .bodyText1!
                .apply(color: valid ? UiKit.palette.primary : Colors.grey),
          ),
        ),
      ),
      padding: const EdgeInsets.symmetric(
        vertical: 32.0,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Text(
              'DID Method',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.subtitle2,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 64.0),
            child: DropdownButton<DIDMethod>(
              value: didMethod,
              isExpanded: true,
              items: DIDMethod.values
                  .map((e) => DropdownMenuItem(
                        alignment: Alignment.center,
                        value: e,
                        child: Text(
                          e.display(),
                          style: Theme.of(context)
                              .textTheme
                              .bodyText1!
                              .apply(fontSizeFactor: 1.25),
                        ),
                      ))
                  .toList(),
              onChanged: (value) {
                setState(() {
                  didMethod = value;
                });
                loadPreview();
              },
            ),
          ),
          const SizedBox(height: 32.0),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Text(
              'Key Type',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.subtitle2,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 64.0),
            child: DropdownButton<KeyType>(
              value: keyType,
              isExpanded: true,
              items: KeyType.values
                  .map((e) => DropdownMenuItem(
                        alignment: Alignment.center,
                        value: e,
                        child: Text(
                          e.display(),
                          style: Theme.of(context)
                              .textTheme
                              .bodyText1!
                              .apply(fontSizeFactor: 1.25),
                        ),
                      ))
                  .toList(),
              onChanged: (value) {
                setState(() {
                  keyType = value;
                });
                loadPreview();
              },
            ),
          ),
          const SizedBox(height: 48.0),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Text(
              'Preview',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.subtitle2,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 24.0,
            ),
            child: FutureBuilder<String>(
              future: preview.future,
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Column(
                    children: [
                      const SizedBox(height: 16.0),
                      Icon(Icons.error),
                      const SizedBox(height: 8.0),
                      Text(
                        'Failed to get preview\nError: ${snapshot.error}',
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.bodyText1!,
                      ),
                    ],
                  );
                }

                if (snapshot.hasData) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const SizedBox(height: 16.0),
                      Text(
                        snapshot.data!,
                        textAlign: TextAlign.center,
                        softWrap: true,
                        style: Theme.of(context)
                            .textTheme
                            .overline!
                            .apply(fontSizeFactor: 1.5),
                      ),
                      const SizedBox(height: 24.0),
                      BaseButton.primary(
                        onPressed: () {
                          Clipboard.setData(ClipboardData(
                            text: snapshot.data!,
                          ));
                        },
                        child: Text('Copy to clipboard'),
                      ),
                    ],
                  );
                }

                return Center(
                  child: CircularProgressIndicator(),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

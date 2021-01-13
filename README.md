# credible

Credible Wallet

## Getting Started

This project depends on [DIDKit](https://github.com/spruceid/didkit).

For now it's required to build DIDKit on the side before building this project.

For more detailed instructions on how to set it up,
please follow [this link](https://github.com/spruceid/didkit/blob/main/lib/FFI.md).

You have to point to your local copy in the `pubspec.yaml` file:

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

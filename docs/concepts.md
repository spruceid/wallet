---
id: concepts
title: Core Concepts
---

Credible is designed to be a powerful but simple personal wallet for holding verifiable credentials-- and little more. 

## High-level explanation of QR Code Logic

All QRCode interactions start as listed below:
1. User scans a QRCode containing a URL;
2. User is presented the choice to trust the domain in the URL;
3. App makes a GET request to the URL;

:::note
Todo:
* Clarify if there are two GET requests with choice of identifier/alias in between, or one. 
:::

Then, depending on the type of message, one of the following protocols will be
executed.

:::note

* Did this selection step gonna make it into v0.1?
* Is the exception if keystore is corrupted implemented yet ?

:::

## CredentialOffer

If the wallet manages multiple keypairs/subject identifiers, the user will be prompted to select one. If no additional subject identifiers are available, the wallet will default to the on-device keypair created at time of installation. If this cannot be found, the protocol will throw an exception.
:::

After receiving a `CredentialOffer` from a trusted host and selecting (or defaulting to) an identifier to which that credential will be issued, the wallet app calls the issuer's API with the selected `subject_id` in the form body. If the on-device identifier is chosen or defaulted to, it must first be wrapped in a "DID:Key" object (See glossary), which is derived deterministically from the keypair stored in the `FlutterSecureStorage`, which is backed by [KeyStore][] on Android and [Keychain][] on iOS.

### Flow

The flow of events and actions is thus:
1. User is presented a credential preview to review and make their decision;
1. [Optional] 
   1. If User selected identifier (by "petname" or alias), its current DID will be fetched from app storage. Otherwise:
   2. App generates `didKey` from the secure on-device keypair using the `DIDKit.keyToDIDKey` function;
2. App makes a POST request to the initial URL with `subject_id` set to this DID;
3. App receives and stores the new credential in app storage;
4. User is redirect back to the wallet's homepage.

![swimlane diagram](/img/credible_swimlane_issuance.png)
[hi-rez swimlane here](/img/credible_swimlane_issuance.png)

## Verifiable Presentation Request

After receiving a `VerifiablePresentationRequest` from a trusted host, the wallet app calls the requestor's POST API with the `presentation` value set in the body. This value is a stringified JSON-LD presentation object generated  from the selected credential and signed with the credential's private key using `DIDKit.issuePresentation`.

### Parameters

:::note
Todo: 
* I assume the `holder` is not being validated, right? If the credential has a URI that isn't a DID or a DID:Key, the presentation issuance protocol doesn't throw an exception?
* Only one VC for now, right? stringified JSON-LD, I assume?
* What do you mean the credential's stored private key? Do you mean the private key corresponding to the `id` of the credential *subject*?
:::

Here are some of the parameters used to generate a presentation:
- `presentation`
  - `id` is set to a unique and random `UUID.v4` generated in each `issuePresentation` call;
  - `holder` is set to the selected credential's subject (DID);
  - `verifiableCredential` contains the presented credential in stringified JSON-LD form;
- `options`
  - `verificationMethod` is set to the `id` field in the passed DID's `verificationMethod`;
  - `proofPurpose` only supports 'authentication' for now;
  - `challenge` is set to the `challenge` value found in the request;
  - `domain` is set to the `domain` value found in the request;
- `key` is the credential's stored private key;


###  Flow

The flow of events and actions is listed below:
- User is presented a presentation request to review and make a decision;
- App generates `didKey` from the stored private key using `DIDKit.keyToDIDKey`;
- App issues a presentation using `DIDKit.issuePresentation`;
- App makes a POST request to the initial URL with the presentation;
- User is redirect back to the wallet.

![swimlane diagram](/img/credible_swimlane_vp_request.png)
[hi-rez swimlane here](/img/credible_swimlane_vp_request.png)

## Future Protocols

Coming in future versions (before v1.0)
* DIDComm v2 support
* Presentation Exchange

Note: Verifiable Presentation requests are presented in the form specified by the current W3C-CCG [VP Request Spec] draft. As community-wide, vendor-agnostic specifications for Credential/[Presentation Exchange][], [Wallet Portability][], and DID-based [Transport][] come into maturity, we will support them in future versions.

[Presentation Exchange]:https://identity.foundation/presentation-exchange/
[Wallet Portability]:https://w3c-ccg.github.io/universal-wallet-interop-spec/
[Transport]: https://identity.foundation/didcomm-messaging/spec/
[VP Request Spec]:https://w3c-ccg.github.io/vp-request-spec/ 
[KeyStore]:https://developer.android.com/training/articles/keystore
[KeyChain]:https://developer.apple.com/documentation/security/keychain_services
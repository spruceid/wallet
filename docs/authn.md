---
id: authn
title: Authenticating to other services
---

Credible's current authentication model is simple: services request a verifiable credential issued to the wallet-holder at each authentication, and an interactive presentation is used to initiate a session. Future extensions and alternatives are roadmapped.

## VP-Authentication

The presentation request formulated by a "relying party" (i.e., the service relying on credible to authenticate its user) currently comes in only two forms: 
1. **Unspecified VP Request for enrollment**: any wallet holding 1 or more VCs can pass this verification to create an account keyed to the presenting identifier.
2. **Unspecified VP Request for authentication**: if the relying party wants to allow any enrolled party to sign in, they can simply request a presentation of any credential and check the received credential's presenter identifier against  records of enrolled users, to decide whom (if anyone) to authenticate.
3. **Specified VP Request for authentication**: if the relying party retained the wallet/identifier pair used in an interactive enrolment, they can simply specify the same identifier in a VP request-- anyone except the previously-enrolled party will not 

It is presently only possible to verify that a verifiable presentation is valid, i.e. that the signature is valid and corresponds to the public key & identifier (DID) passed with it. For this reason, the passed DID may be used as a unique, stable user identifier between sessions on the basis that a valid VC-holding wallet will consistently prove the same private key for the life of the wallet/identifier combination. No verification based on the *content* of the presented credential is yet supported.

See also the code snippets provided below of a Credible VP flow used to authenticate to another service.

*Note: The current version does not allow the "relying party" to specify much about the verifiable credential requested, and then check the presented credential against this specification. It also does not support backups or recovery of wallet contents.*

*Future versions will be able to specify a subject DID, or a subject DID type (by method), or a date range of issuance, or an issuer, etc etc. Without such specification against which to validate a authenticating presentation, Credible's authentication should be considered "for testing purposes only" and not used to authenticate users to real-world systems.*

:::note

## OIDC Considerations
* v0.2? 
  
:::
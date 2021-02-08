---
id: terminology
title: Terminology
---

## Terminology

For more detailed explanations and references to core specifications, see the [developer portal glossary](https://spruceid.dev/docs/glossary).

### Verifiable Credentials ("*VCs*")
Verifiable Credentials combine properties and superpowers from many different mental models. They are like portable, free-floating data units, which are not exactly documents or data points or records. They are signed and thus tamper-evident, and thus share much of the verifiability of blockchain data or signed PDFs insofar as the signatures they contain can be properly verified by reference to the identities included inside the document. Particularly in the form of JSON-LD verifiable credentials, they are highly portable, in that the structure of their data can often be reconstructed years later and completely out of their original context. For more on JSON-LD and linked data, see the Semantics section of the [DIDKit Core Concepts](/docs/didkit/concepts.md#Semantics) entry.

### Wallet
The mental model of a "wallet" for storing directly and manually controlled information and assets has become increasingly common in recent years thanks to the growing popularity of ledger-based cryptocurrencies, NFTs, and other virtual assets controlled by cryptography. Just as wallet software makes cryptographic key management intuitive and human-scaled when handling such cryptographically-controlled assets on common ledgers, so too can "wallet" interfaces make cryptographically-controlled documents like Verifiable Credentials manageable. 

In the verifiable credential space, a "wallet" is traditionally assumed to manage one or more strong cryptographic identifiers, which must be authenticated to an issuer to receive identifier-specific or identifier-locked credentials. This is often assumed to be a direct and interactive process, as is the process of presenting these strong credentials to verifiers (usually double-authenticated, to both the verifier and to the credential, with two respective identifiers). Credible Wallet was designed to a secure, production-grade, yet lightweight and general-purpose wallet for such use cases, completely free of platform-, vendor-, or blockchain-lock-in.

There are, however, fiduciary, automated, and/or "custodial" wallets (by analogy to cryptocurrency). Here, the dividing line between wallets and agents, services, and service providers gets a little blurry; particularly when the wallet holder is a legal entity or non-human actor, this is an important wrinkle on the concept of the "wallet." Here, DIDKit may be combined with enterprise identity and security platforms to provide a less human-scale "wallet" for handling strong credentials about human and non-human actors. 

### VC Nomenclature & Life-Cycle

![Architecture Diagram](/img/did-core_vc-lifecycle.png)

Src: [DID specification](https://www.w3.org/TR/vc-data-model/#lifecycle-details)


### Decentralized Identifiers ("*DIDs*")
Decentralized Identifiers are stable identifiers which are bound to a controlling keypair, which is usually rotatable without changing the identifier. This is achieved by a publication mechanism maintaining information about key material in verifiable data stores (usually distributed ledgers) over time. This information is referred to as a DID Document. The [specification](https://www.w3.org/TR/did-core/) governing these identifiers is maintained by a dedicated W3C [working group](https://www.w3.org/2019/did-wg/), of which Spruce is a member. For more information on the W3C, see the **Further Reading** section.

### DID Document
A record returned by a query for a DID, containing information on how to verify information linked in some way to that identifier. The name can be misleading, since in many cases this "document" is entirely ephemeral or contextual and not intended to be a static file or document stored or cached anywhere.  It is sometimes couched in a "Resolution object," which contains metadata about the query and resolution process, although most application developers have no need to worry about these DID mechanics. For a The [specification](https://w3c-ccg.github.io/did-resolution/) governing the DID-->Document resolution process is maintained by a dedicated W3C [working group](https://www.w3.org/2019/did-wg/), of which Spruce is a member. For more information on the W3C, see the **Further Reading** section.

### DID Taxonomy & Architecture

![Architecture Diagram](/img/did-core_architecture.png)

Src: [DID specification](https://www.w3.org/TR/did-core/#architecture-overview)

### DID Method
A set of interdependent governance, publication, and discovery mechanisms for DIDs in a given DID namespace, specified by a shared specification. This specification explains how to validate a DID (namespace rules), where to query and what to expect back when resolving a DID, etc. The [registry](https://w3c.github.io/did-spec-registries/#did-methods) of compliant specifications for DID Methods is maintained by a dedicated W3C [working group](https://www.w3.org/2019/did-wg/), of which Spruce is a member. For more information on the W3C, see the **Further Reading** section.

### DID:Key
A special DID Method that generates conformant, offchain DID documents for local, private, and/or ephemeral resolution from a keypair. This can be helpful for integrating conventional PKI or signing infrastructure with DID issuance, or to allow caching or local resolution of DID documents where it is undesirable or impossible to resolve remote DIDs. The [specification](https://w3c-ccg.github.io/did-method-key/) for this method was originally created in, and maintained in, the [W3C-Credentials Community Group](https://w3c-ccg.github.io/).
  
## Further Reading

Further educational/contextual resources on decentralized identity topics can be found on the [Education page](https://identity.foundation/education/) of the Decentralized Identity Foundation. 

For insight into the core specifications authored and maintained by the W3C working group, the best overview is the github repositories section of their [homepage](https://www.w3.org/2019/did-wg/) on W3.org. The largely overlapping [Credentials Community Group](https://w3c-ccg.github.io/), with weekly open, recorded, and scribed [calls](https://w3c-ccg.github.io/meetings/) open to W3C non-members, is also a good venue for getting to know the debates around the core specifications.
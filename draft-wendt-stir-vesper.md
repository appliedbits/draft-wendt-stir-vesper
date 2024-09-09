---
title: "VESPER PASSporT and Identity Tokens - VErifiable STI Personas"
abbrev: "vesper"
category: std

docname: draft-wendt-stir-vesper-latest
submissiontype: IETF  # also: "independent", "editorial", "IAB", or "IRTF"
number:
date:
consensus: true
v: 3
area: "Applications and Real-Time"
workgroup: "Secure Telephone Identity Revisited"
keyword:
 - telephone number
 - vetting
 - KYC
venue:
  group: "Secure Telephone Identity Revisited"
  type: "Working Group"
  mail: "stir@ietf.org"
  arch: "https://mailarchive.ietf.org/arch/browse/stir/"
  github: "appliedbits/draft-wendt-stir-vesper"
  latest: "https://appliedbits.github.io/draft-wendt-stir-vesper/draft-wendt-stir-vesper.html"

author:
 -
    fullname: Chris Wendt
    organization: Somos, Inc.
    email: "chris@appliedbits.com"
    country: US
 -
    fullname: Rob Sliwa
    organization: Somos, Inc.
    email: robjsliwa@gmail.com
    country: US

normative:
  RFC7519:
  RFC7800:
  RFC8224:
  RFC8225:
  RFC8226:
  RFC9060:
  I-D.ietf-oauth-selective-disclosure-jwt:
  I-D.ietf-sipcore-callinfo-spam:

informative:


--- abstract

This document extends the STIR architecture by defining a secure telephone identity token and PASSporT with a type of “vesper” and specifies the use of Selective Disclosure JWT (SD-JWT) for representing persona related claim information intended to be associated with verifiable information such as the assignment of a telephone number or the output of a Know Your Customer (KYC) or Know Your Business (KYB) type of vetting process or Rich Call Data (RCD) or claims of consent provided to the telephone number holder. It defines logical roles that form trusted relationships to establish overall eco-system trust.  These roles are in the context of a Subject Entity (SE) that is the end entity that is the holder and has the right to use a telephone number. An Issuing Agent (IA) establishes the Subject Entity to the perform the initial vetting and establishment of the persona to the eco-system. A Notary Agent (NA) is a neutral role that maintains a graph of relationships between all roles, claims, and identities with a corresponding transparency log that generates verifiable receipts to “notarize” the recording of these relationships and claims being established. Importantly, privacy is enabled in this Notary role because the submitters have the option of submitting hashes of claims to protect information, or may usefully want to publicly declare their association to a claim to allow the public monitoring to avoid duplicate, mistaken or negligent claims which can be identified before enabling any illegitimate usage in the eco-system. A Claim Agent (CA) is a party that produces claims in the form of SD-JWT + receipts from the NA. There is multiple specific claim agent types and the claims definitions of key value pairs they are required or optionally can include. These SD-JWT + receipt objects are then collected by the SE into a digital wallet that it can then use for selective disclosure presentation and incorporate into a “vesper” PASSporT with different “vesper” claim SD-JWT + receipt objects and signed by the delegate certificate with telephone number to tie the telephone number back to the SE.

--- middle

# Introduction

The Secure Telephone Identity (STI) architecture fundamentally defined by STI certificates in {{RFC8226}}, PASSporTs in {{RFC8225}}, and the SIP Identity header field {{RFC8224}} describe a set of constructs and protocols for the use of tokens and digital signatures to protect the integrity and provide non-repudiation of information as part of a communications session most notably the associated telephone numbers. This document extends that architecture to address the association of a telephone number to a persona (e.g. a person or business entity) given responsibility for the right to use that telephone number. Recently, the illegitimate use of telephone numbers by unauthorized parties and the associated fraudulent activity associated with those communications has generally eroded trust in communications systems. Further, basic reliance on the trust of the signer alone to at the time of the communications without has proven to require time and people consuming work to perform after-the-fact investigation and enforcement activities. Other industries, like the financial industry, have adopted well-known successful practices of Know Your Customer (KYC) or Know Your Business (KYB), otherwise referred to as the application of vetting practices of an entity. This document focuses on a set of roles and the protocol interactions between those roles that can properly establish mechanisms for trusted transactions, an explicit set of processes that should be followed to establish the representation of claims about the persona that are vetted before any communications can be initiated. These claim information establishment transactions are recorded or notarized with authorized or responsible parties while also importantly enabling privacy controls around the disclosure of the persona information. Transparency logging of relationships and transaction events for claim information is also required to further establish trust with optional public disclosure to guarantee uniqueness when desired. The explicit connection between a persona, as a person or business entity, with a telephone number and the responsibilities associated with its use is a critical step towards building the use of telephone numbers and ability to enforce usage policies that allow privacy but discourage taking advantage of those properties for intent to impersonate for illegitimate reasons. Ultimately, the establishment of secure telephone identity with reasonable policies for establishing those identities will result in greater trusted relationships between parties involved in a set of communications.

This document describes the establishment of a "vesper" (VErifiable Sti PERsona) PASSporT type with corresponding “vesper” claims which are signed claims using a three party trust model represented by SD-JWTs and enabled with transparency logs and corresponding receipts that enable either a privacy protecting hash disclosure or a public disclosure that allows for verifiable eco-system trust that those that validate claim information are legitimate actors in the ecosystem. Additionally, the vesper token and claim architecture provides mechanisms for providing selective disclosure of any personally identifying information to be disclosed to those that the persona chooses directly or in limited cases, for example, based on enforcement actions, required for legitimately authorized legal or regulatory activity.

In the current state of digital identities, the unique identifier used to identify the persona behind the identifier is obviously a critical part of using an identifier as part of a digital protocol, but just as important is the ability to associate a real-world persona to that identifier as the responsible party behind that identifier. The telephone number as an identifier and as part of a set of traditional communications services offered around the world has been facing a challenge of illegitimate fraud based on the lack of a formal framework for the explicit association of a set of communications to a directly responsible party. The use of "spoofing" of telephone numbers, a practice of the use of telephone numbers by not directly authorized parties, while having very legitimate use-cases, has been exploited by actors of fraudulent intent to either impersonate the legitimate party, or simply obfuscate the actual party behind the call. Fraud and illegitimate activity has proliferated based on the loose connection of telephone numbers to responsible parties.


# Conventions and Definitions

{::boilerplate bcp14-tagged}

# Overview

The vetting process for entities involves verifying their identity and legitimacy, typically through KYC and KYB vetting procedures. This document proposes a standardized method for representing the results of these vetting procedures using Selective Disclosure JWT (SD-JWT). This document does not address how the KYC/KYB should be performed or what documents or processes should be used. Rather the goal of this document is to create a standardized identifier for the Vetted Entities (VE) to present that they are who they claim to be.

# Vesper Architectural Overview

## Introduction to Vesper Tokens and Trust Model

The use of vesper tokens in communications will allow for a trust model enabled by a three party trust system based on an agreed set of vetting policies with a set of privacy enabled features to allow for selective disclosure for communications that require authorized use of a telephone number with the ability to support use-cases that require anonymity all the way up to full disclosure of vetted persona information if that is desired. The establishment of roles that facilitate the trust of the association of a telephone number and other entity information is in the form of claims made by authoritative or identified trusted actors in the eco-system.  This document defines these roles as Claim Agents that have specific types with associated standard mandatory and optional key values.

### Key Features of Vesper Tokens

- Selective Disclosure: Entities can choose which information to disclose to different parties.
- Authorized Use of Telephone Numbers: Vesper tokens ensure that only authorized parties can use telephone numbers.
- Flexible Use Cases: Vesper tokens can be used for KYC/KYB vetting, Rich Call Data (RCD), and consent claims.  New use-cases can be defined in the future.

## Roles and Responsibilities in the Vesper Ecosystem

The trust framework defines several roles that facilitate claims about telephone numbers and other entity information. These roles, known as Claim Agents, are responsible for making authoritative claims about the subject entity (SE).

### Claim Agent Roles

- Vetting Claim Agent (VCA): Handles KYC/KYB vetting and establishes the SE in the ecosystem.
- Telephone Number Claim Agent (TNCA): Handles the assignment of telephone numbers to the SE.
- Rich Call Data Claim Agent (RCDCA): Provides vetting and validation of Rich Call Data claims.
- Consent Claim Agent (CCA): Handles consent claims for allowing SE's to call or message specific telephone numbers.

### Claim Agent Responsibilities

Claim Agents make claims about the Subject Entity. These agents are registered with a Notary Agent (NA) who maintains a Claim Graph for the Subject Entities and issues transparency receipts for each claim event. Claim Agents issue SD-JWT tokens with the claims and the SE holds these SD-JWT tokens (verifiable claims) in Vesper Wallet (VW).

## Notary Agent - Claim Graph and Transparency Log

In the Vesper ecosystem, Claim Agents issue claims about the Subject Entity.  To ensure trust and accountability between Claim Agents, all interactions are governed by the Notary Agent, which internally operates two key services: the Claim Graph and the Transparency Log.

### Claim Graph

The Claim Graph is responsible for building and maintaining a graph of claims related to SEs. Each claim issued by a Claim Agent is added to this graph as a node, with relationships represented as edges between entities.

- Snapshot Hashing: Every time a new claim is added or updated in the Claim Graph, the service creates a hash of the current snapshot of the graph. This hash serves as a unique cryptographic representation of the claim state at that moment in time.
- Transparency: The hashed snapshot is then recorded in the Transparency Log, ensuring that the claims history is transparent, immutable, and auditable. By using cryptographic hashing, the Claim Graph remains secure, and any changes to the claims can be traced and verified.

### Transparency Log

The Transparency Log is part of the NA’s services and plays a crucial role in ensuring that all claims made by Claim Agents are trustworthy. It allows claims to be verifiable across different agents using cryptographic methods. Once a claim is hashed by the Claim Graph, it is added to the log, making it accessible for verification.

- Receipt Issuance: After each claim is recorded, the NA issues a Receipt to the SE. This receipt includes proof that the claim has been added to the Transparency Log. The SE can then present this receipt alongside claims in SD-JWT as proof that the claims have been transparently logged.
- Interaction with Claim Agents: Claim Agents do not directly modify the Claim Graph. Instead, they interact with NA via its APIs, which serve as a wrapper around both the Claim Graph and Transparency Log. This ensures that claims are properly registered, hashed, and logged without direct manipulation of the underlying data structures.

### Claim Agents and Privacy

An important feature of this system is its ability to protect the privacy of the SE. Claim Agents are not required to store any private data in the Claim Graph. Instead, they store only the hash of the data, which acts as a representation of the claim without exposing sensitive information.

- Public vs. Private Data: If the SE has public data (e.g., a business name or logo), it can be added to the Claim Graph for greater visibility. This allows other Claim Agents to detect fraud or suspicious activity. However, private data should always remain hashed and protected unless specifically required for disclosure by the SE.

## Transport - Vesper PASSporT

The SE can use claims stored in their Vesper Wallet to generate a Vesper PASSporT, which includes SD-JWTs and associated NA Receipts. This Vesper PASSporT is signed by a delegate certificate and attached to communications, such as in the case of STIR.

Vesper PASSporT Flow:

1. Using Vesper Wallet, SE creates a Vesper PASSporT containing claims and SD-JWTs.
2. Vesper PASSporT is signed by a delegate certificate.
3. The signed PASSporT is attached to a SIP identity header for verification by the destination party.

## Verification and Proof of Authenticity

The Authentication Service (AS) and the Verification Service (VS) are responsible for validating the Vesper Token and its claims.

### AS Verification

When the Vesper Token is created, the AS verifies its signature. This is a important step in preventing unauthorized or tampered tokens from being used. The Vesper Token contains SD-JWTs (with claims) and associated NA Receipts, and its signature is signed by a delegate certificate.

- Signature Verification: The AS ensures that the Vesper Token’s signature is valid and matches the certificate provided.
- Action on Failure: If the Vesper Presentation (the wrapped SD-JWTs and Receipts) is invalid, the AS will stop processing the request, ensuring that the call will not proceed under fraudulent conditions.

NOTE: The relationship between Vesper Wallet that creates Vesper Token and the AS in practice will be likely a trusted relationship and therefore AS may chose to trust the Vesper Token without further verification.

### STI-VS Verification

Once the Vesper Token reaches the VS, the token undergoes further checks to confirm its authenticity and integrity.

- Payload Verification: The first step for VS is to verify the Vesper Token’s signature. This ensures that the token has not been tampered with during transit. Any modification to the payload will invalidate the signature, and the VS will reject the communication.
- SD-JWT Claim Verification: After validating the Vesper Token, the VS looks up each of the SD-JWTs associated with the claim types included in the Vesper Token. Each SD-JWT contains claims made by the Claim Agents and must be verified individually.
- Public Key Verification: The VS uses the public key provided as a JSON Web Key (JWK) to verify the signatures of the SD-JWTs. Each SD-JWT’s signature ensures that the claim data has not been altered and that the entity issuing the claim is legitimate.

### Final Trust and Intelligence

Once the VS completes these verifications, it can trust the caller’s identity and the claims made in the Vesper Token.

- Caller Trust: The successful validation of the Vesper Token and its claims allows the VS to trust that the caller is who they claim to be.
- Call Intelligence: In addition to verifying identity, the VS can use the claims enclosed within the Vesper Token for further insights. These claims may include additional information about the caller, such as their vetted identity or other metadata (e.g., business name, consent), which can be used to enhance call routing and decision-making.

# Terminology

Claim Agent: An entity that is either authorized or trusted in the eco-system to make claims of persona-related information and issues verifiable selectively disclosable tokens containing the vetted claim information. A Claim Agent can be a trusted third party or a service provider that performs the vetting of persona-related information. Claim Agent is a role catagory where their are defined a set of specific claim agent types with associated claim attribute key values that are either required or optional by specification.

Vetting Claim Agent (VCA): The Claim Agent entity that initiates and establishes a Subject Entity into the eco-system. Its role is to vet a set of claims that are related to the persona like physical address, business identifiers, contact information and other identifying information. Generally, this information is not disclosed as part of a typical communications transaction, although nothing prevents it.  However, it’s an important set of information to establish the existence and legal standing of a persona. This information is also relevant to a potential legal or policy enforcement action if that becomes required based on alleged illegal or policy violations, something the VCA would be the responsible party to facilitate.

Telephone Number Claim Agent (TNCA): The Claim Agent entity that generally represents an authorized provider of telephone numbers for direct assignment.

Rich Call Data Claim Agent (RCDCA): The Claim Agent entity that is responsible for vetting the Rich Call Data claims and validating they represent the Subject Entity and conform to any relevant content policies for any relying eco-systems a Vesper PASSporT token may be used.

Consent Claim Agent (CCA): The Claim Agent entity that is responsible for handling and vetting consent claims made representing different called party destination numbers toward a calling party originating telephone number.  These could include consent to call/message for specific telephone numbers or consent to calls of various types that correspond to {{I-D.ietf-sipcore-callinfo-spam}} types of callers, or consent to call with robocalling, AI-enabled, or chatbot types of automated calling or messaging.

Subject Entity (SE): An entity that is vetted by a Vetting Agent and holds the verifiable token containing the vetted information. The Vetting Entity can be a person or a business entity.

Vesper PASSporT or Token: A verifiable token that follows the definition of PASSporT in {{RFC8225}} created by a Subject Entity containing the presentation of disclosable claims for a specific relying party destination. The Vesper Token is represented as a JSON Web Token (JWT) PASSporT that contains “vesper” claims that are Selective Disclosure JWT (SD-JWT) + transparency receipts generated by the Notary Agent (NA).

# The “vesper” PASSporT

A Vesper PASSporT introduces a mechanism for the verification of provable claims based on third party validation and vetting of authorized or provable information that the verifier can have greater trust because through the vesper PASSporT and associated claims there is a signed explicit relationship with two important concepts in the vesper framework:

  * the Claim Agent that is known to be a valid participant in the vesper framework and has a type association with the claims being made
  * the transparency receipt created by the Notary Agent representing the time and claim assertion event recorded

The Vesper PASSporT is a PASSporT as defined in {{RFC8225}} which is a JSON Web Token {{RFC7519}} and upon creation should include the standard PASSporT claims including the “orig” and “dest” and “iat” claims required for replay attack protection. It MUST include a PASSporT type, “ppt”, with the value of the string “vesper” in the protected header of the PASSporT.
A Vesper PASSporT, as can any PASSporT, can contain any claims that a relying party verification service might understand, but the intention of the Vesper framework is that a Vesper PASSporT contain one or more “vesper” claim objects, defined in the “Vesper Claims” section.

## Compact Form Not Supported

The use of the compact form of PASSporT is not specified for a “vesper” PASSporT primarily because when using the {{RFC8224}} defined identity header field as the transport of a “vesper” PASSporT there will not be any corresponding vesper information or claims provided in plain text or unprotected, nor should there be.

# Vesper Claims

A Vesper Claim is defined as a JWT claim {{RFC7519}} JSON object with a claim key that is the string “vesper” and with a claim value that is a JSON object containing the following key values:

* a “type” key with the claim value as the string that defines the claim agent type defined in the “Claim Agent” section of this document or future claim agent types defined and registered in claim agent IANA registry
* a “claim-token” key with a claim value of the SD-JWT {{I-D.ietf-oauth-selective-disclosure-jwt}} which represents the actual signed claims from the Claim Agent and defined in the section “Vesper Claim SD-JWT”
* a “receipt” key with the claim value of the Signed Vesper Timestamp the Claim Agent received from the Notary Agent defined in the “Signed Vesper Timestamp” section of the document.


## Vesper Claim SD-JWT (Selective Disclosure JSON Web Tokens)

This section defines the vesper claims object as a SD-JWT, defined in {{I-D.ietf-oauth-selective-disclosure-jwt}}. The claim and issuance process and disclosure of information closely follows the SD-JWT Issuance and Presentation Flow, Disclosure and Verification, and more generally the three-party model (i.e. Issuer, Holder, Verifier) defined in SD-JWT.  The Issuer in the context of the vesper token is the Claim Agent, the Holder corresponds to the Subject Entity, and the Verifier is the the receiver of the Vesper Claim, which in the context of this document would be contained in a Vesper Claim object that is signed inside of a Vesper PASSporT.

## SD-JWT and Disclosures

SD-JWT is a digitally signed JSON document containing digests over the selectively disclosable claims with the Disclosures outside the document. Disclosures can be omitted without breaking the signature, and modifying them can be detected. Selectively disclosable claims can be individual object properties (name-value pairs) or array elements. When presenting an SD-JWT to a Verifier, the Holder only includes the Disclosures for the claims that it wants to reveal to that Verifier. An SD-JWT can also contain clear-text claims that are always disclosed to the Verifier.

To disclose to a Verifier a subset of the SD-JWT claim values, a Holder sends only the Disclosures of those selectively released claims to the Verifier as part of the SD-JWT. The use of Key Binding is an optional feature.

## Vesper Claim SD-JWT Data Formats

An SD-JWT is composed of

* an Claim Agent signed JWT, and
* zero or more Disclosures.

The serialized format for the SD-JWT is the concatenation of each part delineated with a single tilde (‘~’) character as follows:

~~~~~~~~~~~
<Issuer-signed JWT>~<Disclosure 1>~<Disclosure 2>~...~<Disclosure N>~
~~~~~~~~~~~

The payload of a vesper token as an SD-JWT is a JSON object according to the following rules:

The payload MAY contain the _sd_alg key described in Section 5.1.1 of {{I-D.ietf-oauth-selective-disclosure-jwt}}.
The payload MAY contain one or more digests of Disclosures to enable selective disclosure of the respective claims, created and formatted as described in Section 5.2.
The payload MAY contain one or more decoy digests to obscure the actual number of claims in the SD-JWT, created and formatted as described in Section 5.2.5.
The payload MAY contain one or more non-selectively disclosable claims.
The payload MAY contain the Holder’s public key(s) or reference(s) thereto, as explained in Section 5.1.2.
The payload MAY contain further claims such as iss, iat, etc. as defined or required by the application using SD-JWTs.

In order to represent the vetted claim information about a VE. The SD-JWT MUST include the following claims:

iss: Issuer, the Claim Agent.
sub: Subject, the subject entity represented by a unique entity-id
iat: Issuance timestamp.
exp: Expiry timestamp.
claim-data-hash: Hash of the claim data.
transparency-receipt: Transparency receipt issued by the transparency service.  (SVCT)
(optional) cnf: Public key of the Subject Entity, only if key binding is required, defined in {{RFC7800}}

# Claim Agents

Claim Agents are entities that act as issuers in the three party trust model, but generally validate information provided by a Subject Entity via either checking an authorized source or via a vetting procedure.  The details of either of these processes are very likely application or jurisdiction specific and should follow an eco-system specific set of policies and therefore are out-of-scope of this document.

There are different types of claims that can be validated on behalf of a subject entity, but specific to telephone number identities and the entities that are assigned the right to use telephone numbers and more generally the subject and focus of this document there are two required claim types defined in this document and two optional supplemental claim types defined in this document.  It is anticipated that future specifications may define new claim types with additional relevant information that requires trust and validation and therefore an IANA registry for Vesper Claim Agent types is setup to register unique type indicators.

## Claim Agent Types and Claim Values

Each Claim Agent Type has a corresponding unique string that uniquely identifies a Claim Agent as a particular type and the associated claim object generated by a claim agent to include defined set of claim key values that include both required and optional key values.

### Vetting Claim Agent - “vca”

The Vetting Claim Agent is a required claim agent data type and is also the first claim that MUST be established to establish a globally unique entity-id to represent the Subject Entity in the Notary Agent uniquely.

The Vetting Claim object is defined to include the following key values in the claim object:

~~~~~~~~~~~~~
+---------------------+-------------+------------------------------------+
| Claim Info Key      | Value Type  | Value Description                  |
+---------------------+-------------+------------------------------------+
| address             | JSON object |                                    |
+---------------------+-------------+------------------------------------+
| street_address      | String      |                                    |
| locality            | String      |                                    |
| region              | String      |                                    |
| country             | String      |                                    |
| postal_code         | String      |                                    |
+---------------------+-------------+------------------------------------+
| contact_given_name  | String      |                                    |
| contact_family_name | String      |                                    |
| contact_email       | String      |                                    |
| contact_phone_num   | String      |                                    |
+---------------------+-------------+------------------------------------+
| business_ids        | JSON Array  |                                    |
+---------------------+-------------+------------------------------------+
| EIN                 | String      |                                    |
+---------------------+-------------+------------------------------------+
~~~~~~~~~~~~~


### Telephone Number Claim Agent - “tnca”

The Telephone Number Claim Agent is a required claim agent data type and is tied to a telephone number service provider or Responsible Organization that is authorized to assign telephone numbers. The Subject Entity has a business relationship with their telephone number provider that also either directly or through a relationship with a Claim Agent can validate the assigned Telephone Number.

Note: the telephone number service provider also should provide the mechanism to provide a delegate certificate with the telephone number resource as part of the TNAuthList.

The Vetting Claim object is defined to include the following key values in the claim object:

~~~~~~~~~~~~~
+---------------------+-------------+------------------------------------+
| Claim Info Key      | Value Type  | Value Description                  |
+---------------------+-------------+------------------------------------+
| telephone_num       | Value Array | Array of e.164 Strings             |
+---------------------+-------------+------------------------------------+
~~~~~~~~~~~~~


### Rich Call Data Claim Agent - “rcdca”

The Rich Call Data Claim Agent is an optional claim agent data type and is tied to Rich Call Data as defined in {{I.D-ietf-stir-passport-rcd}}.

The Rich Call Data Claim object is defined to include the following key values in the claim object:

~~~~~~~~~~~~~
+---------------------+-------------+------------------------------------+
| Claim Info Key      | Value Type  | Value Description                  |
+---------------------+-------------+------------------------------------+
| rcd Array           | JSON Array  | Array of rcd claims objects        |
+---------------------+-------------+------------------------------------+
| rcd                 | JSON Object | rcd claim                          |
| rcdi                | JSON Object | rcdi claim                         |
| crn                 | JSON Object | call reason claim                  |
+---------------------+-------------+------------------------------------+
~~~~~~~~~~~~~

### Consent Claim Agent - “cca”

The Consent Claim Agent is an optional claim agent data type and is tied to a consent assertion associated to a destination telephone number.

The Consent Claim object is defined to include the following key values in the claim object:

~~~~~~~~~~~~~
+---------------------+-------------+------------------------------------+
| Claim Info Key      | Value Type  | Value Description                  |
+---------------------+-------------+------------------------------------+
| consent_assertion   | JSON Array  | Array of consent_assertion objects |
+---------------------+-------------+------------------------------------+
| consent_type        | String      | consent_type                       |
| destination_tn      | e.164 array | array of destination tns           |
+---------------------+-------------+------------------------------------+
~~~~~~~~~~~~~

# Notary Agent Overview

The notarization process involves



## Transparency Service

Description of Transparency Service

### Signed Vesper Claim Timestamp

Signed Vesper Claim Timestamp (SVCT) is a signed timestamp that is issued by a Transparency Service to confirm that the claim event info has been successfully registered and appended to the log. The SVCT is used to verify the integrity of the claim event info and ensure that it has not been tampered with.

### JSON Reprsentation of SVCT

Here is JSON representation of SVCT:

~~~~~~~~~~~~~
{
	“LogID”: “0x1234567890abcdef”,
	“Timestamp”: 1683000000,
	“Signature”: ...
}
~~~~~~~~~~~~~

# Notary Agent Procedures

The notary process generally involves the following steps:


## Setup and Registration of Claim Agents with NA

1. Registration of the Claim Agent with a NA

## Setup and Registration of SE with NA by the VCA

2. Registration of the SE with a NA by a VCA. Note: the VCA as described above is the only Claim Agent type that can register a SE with a NA. The SE creates an authenticated account relationship with the VCA, and a unique entity-id is created.
3. The SE provides the VCA claim information and performs the vetting and KYC checks according to their procedures.

RECOMMENDED but optional use of Key Binding (KB) as defined in {{I-D.ietf-oauth-selective-disclosure-jwt}}:

4. The entity generates a public/private key pair, or the VCA does it on the entity's behalf.
5. The public key is registered with the VCA.

## VCA registers claim event to NA

6. The VCA performs a hash over the claim object key values.
7. The NA registers the claim event, including hash to an append-only transparency log.
8. The append-only log, upon verification of the claim event and hash and queuing it into the log, issues a Signed Vesper Claim Timestamp (SVCT).

## VCA receives notary receipt (SCVT) and delivers claim + receipt to SE to deposit in their wallet

9. The SE wallet acts as a holder of Vetting Credentials and provides a method for verifiers to request the vetted information.
10. The VCA issues an SD-JWT containing the vetting claim information, the public key in a CNF claim (per SD-JWT RFC draft), and the transparency receipt, including the hash of the data.

## Additional Claim Agent Procedures

11. After the VCA has established the SE with its entity-id at the NA, additional claims can be made for that SE by another claim agent (e.g. telephone number claims, RCD claims, or consent claims)
12. The Claim Agent performs a hash over the claim object key values but can also submit public claims intended to be disclosed for transparency monitoring.
13. The NA registers the claim event, including either hashed or public claims or both.



# Use Case Example: Telephone Number Assignment
1. The VE undergoes KYC/KYB vetting by a VA and receives a KYC/KYB Vesper token.
2. The VE presents this KYC/KYB token to a TNSP when requesting TN assignment.
3. The VE may also present a TNSP Vesper token that includes credentials for the TN lease and RCD.
4. The TNSP verifies the Vesper tokens and assigns the
5. TN, ensuring that the VE is legitimate and that the additional information (e.g., RCD) is accurate and trustworthy.

TODO: Add diagram from Mural...

# Multi-Vesper Token Presentation

A Vetted Entity (VE), acting as the Holder of multiple Vesper tokens, may need to present a combination of these tokens to satisfy various verification requirements in a single interaction. For instance, in the STIR ecosystem, the VE might first present a KYC/KYB Vesper token to a Telephone Number Service Provider (TNSP) to prove its identity. Once trusted, the TNSP issues a Right To Use (RTU) Vesper token for a specific Telephone Number (TN) and associated Rich Call Data (RCD). The VE can then present both the KYC/KYB and RTU Vesper tokens to the STI-AS when signing a call.

## Structure of Multi-Vesper Presentation

When creating a multi-Vesper token presentation, the VE assembles a package that may contain:

1. Multiple Base SD-JWTs: The core JWTs from each Vesper token (e.g., KYC/KYB and RTU), representing the vetted claims.
2. Disclosures: The selectively disclosable claims from each token that are relevant to the verifier.
3. Key Binding JWTs (KB-JWTs): For each SD-JWT, there is an associated KB-JWT to bind the SD-JWT to a specific key pair, ensuring that the tokens are bound to the Holder's (VE’s) key pair.

The presentation package is composed as follows:

~~~~~~~~~~~~~
<SD-JWT-1>~<Disclosure 1-1>~<Disclosure 1-2>~...~<KB-JWT-1>~<SD-JWT-2>~<Disclosure 2-1>~<Disclosure 2-2>~...~<KB-JWT-2>
~~~~~~~~~~~~~

In this format:

- <SD-JWT-1> and <SD-JWT-2> represent the KYC/KYB and RTU Vesper tokens, respectively.
- <Disclosure 1-1>, <Disclosure 1-2>, etc., represent selectively disclosed claims from each token.
- <KB-JWT-1> and <KB-JWT-2> represent Key Binding JWTs, if Key Binding is used for either or both SD-JWTs.

## Process Flow for Multi-Vesper Presentation

1. TNSP as Issuer: The VE first proves its identity to the TNSP using the KYC/KYB Vesper token.
2. RTU Vesper Token Issuance: The TNSP, now trusting the VE, issues an RTU Vesper token that includes the TN lease and RCD.
3. Presentation Assembly: The VE assembles a presentation package with both the KYC/KYB and RTU Vesper tokens, their disclosures, and optionally the KB-JWTs for each SD-JWT.
4. Verification by STI-AS: The STI-AS, acting as the verifier, validates each SD-JWT, checks the disclosures, and verifies the KB-JWTs to ensure the tokens are bound to the correct key pair.
5. Call Signing: Based on the verified tokens, the STI-AS completes the call signing, ensuring that the call is associated with a legitimate TN and the correct RCD.

# Preventing Replay Attacks

A replay attack occurs when a malicious actor intercepts a valid token or message and reuses it to gain unauthorized access or perform unauthorized actions. In the context of Vesper tokens, this could involve reusing a token or presentation package to fraudulently sign calls or access services. To address the potential replay attack issue in the Vesper token ecosystem, JWT ID (JTI) claim is used.

## Mitigation Strategy - JWT ID (JTI) Claim

- Description: The JTI claim is a unique identifier for each JWT. This identifier ensures that each token is distinct, even if it contains the same claims. The JTI can be used by the verifier to track tokens and detect if the same token is being reused maliciously.

- Implementation:
  - When a Vesper token (SD-JWT) is issued, the Vetting Agent (VA) includes a unique jti value in the JWT payload.
  - Verifiers, such as the STI-AS, should store recent JTI values temporarily (e.g., in a cache) to detect if the same token is being presented multiple times within a short period. This prevents replay attacks using old tokens.

Example:

~~~~~~~~~~~~~
{
  "iss": "https://vetting-agent.example.com",
  "sub": "Business_42",
  "iat": 1683000000,
  "exp": 1883000000,
  "jti": "unique-token-id-12345",
  ...
}
~~~~~~~~~~~~~



## Example Issuance

The Issuer is using the following input claim set:

~~~~~~~~~~~~~
{
  "sub": "Business_42",
  "telephone_number_rtu": [
    +18001231234,
    +18881231234
  ],
  "rcd": [
    {"nam":"Business_42","icn":"https://example.com/logo.png"}
  ]
  "business_ids": [
    {"EIN":"123456789"}
  ]
  "address": {
    "street_address": "123 Main St",
    "locality": "Anytown",
    "region": "Anystate",
    "country": "US"
  },
  "contact_given_name": "John",
  "contact_family_name": "Doe",
  "contact_email": "johndoe@example.com",
  "contact_phone_number": "+12025550101"
}
~~~~~~~~~~~~~

The Issuer in this case made the following decisions:

* The "telephone_number_rtu" array and contents is always visible.
* The "rcd" array is always visible, but its contents are selectively disclosable.
* The sub element and essential verification data (iss, iat, cnf, etc.) are always visible.
* All other claims are selectively disclosable.
* For address, all of the claims can only be selectively disclosed in full.

The following payload is used for the SD-JWT:

~~~~~~~~~~~~
{
  "_sd": [
    "CrQe7S5kqBAHt-nMYXgc6bdt2SH5aTY1sU_M-PgkjPI",
    "JzYjH4svliH0R3PyEMfeZu6Jt69u5qehZo7F7EPYlSE",
    "PorFbpKuVu6xymJagvkFsFXAbRoc2JGlAUA2BA4o7cI",
    "TGf4oLbgwd5JQaHyKVQZU9UdGE0w5rtDsrZzfUaomLo",
    "XQ_3kPKt1XyX7KANkqVR6yZ2Va5NrPIvPYbyMvRKBMM",
    "XzFrzwscM6Gn6CJDc6vVK8BkMnfG8vOSKfpPIZdAfdE",
    "gbOsI4Edq2x2Kw-w5wPEzakob9hV1cRD0ATN3oQL9JM",
    "jsu9yVulwQQlhFlM_3JlzMaSFzglhQG0DpfayQwLUK4"
  ],
  "iss": "https://vetting-agent.example.com",
  "iat": 1683000000,
  "exp": 1883000000,
  "sub": "Business_42",
  "telephone_number_rtu": [
    +18001231234,
    +18881231234
  ],
  "rcd": [
    {
      "...": "pFndjkZ_VCzmyTa6UjlZo3dh-ko8aIKQc9DlGzhaVYo"
    }
  ],
  "business_ids": [
    {
      "...": "7Cf6JkPudry3lcbwHgeZ8khAv1U1OSlerP0VkBJrWZ0"
    }
  ],
  "svt": "8khAv1U1OSlerP0VkBJrWZ07Cf6JkPudry3lcbwHgeZ",
  "vcm": {
      "vcm_version": 1,
      "vetting_agent": {
          "agent_name": "Vetting Authority Inc.",
          "agent_metadata": {}
      },
      "vetted_entity": {
          "entity_id": "VE654321",
          "entity_name": "Business_42"
      },
      "vetting_metadata": []
  },
  "_sd_alg": "sha-256",
  "cnf": {
    "jwk": {
      "kty": "EC",
      "crv": "P-256",
      "x": "TCAER19Zvu3OHF4j4W4vfSVoHIP1ILilDls7vCeGemc",
      "y": "ZxjiWWbZMQGHVWKVQ4hbSIirsVfuecCE6t4jT9F2HZQ"
    }
  }
}
~~~~~~~~~~~~~

The following Disclosures are created by the Issuer:

Claim contact_given_name:

~~~~~~~~~~~~~
SHA-256 Hash: jsu9yVulwQQlhFlM_3JlzMaSFzglhQG0DpfayQwLUK4
Disclosure:
WyIyR0xDNDJzS1F2ZUNmR2ZyeU5STjl3IiwgImdpdmVuX25hbWUiLCAiSm9o
biJd
Contents: ["2GLC42sKQveCfGfryNRN9w", "contact_given_name", "John"]
~~~~~~~~~~~~~

Claim contact_family_name:

~~~~~~~~~~~~~
SHA-256 Hash: TGf4oLbgwd5JQaHyKVQZU9UdGE0w5rtDsrZzfUaomLo
Disclosure:
WyJlbHVWNU9nM2dTTklJOEVZbnN4QV9BIiwgImZhbWlseV9uYW1lIiwgIkRv
ZSJd
Contents: ["eluV5Og3gSNII8EYnsxA_A", "contact_family_name", "Doe"]
~~~~~~~~~~~~~

Claim contact_email:

~~~~~~~~~~~~~
SHA-256 Hash: JzYjH4svliH0R3PyEMfeZu6Jt69u5qehZo7F7EPYlSE
Disclosure:
WyI2SWo3dE0tYTVpVlBHYm9TNXRtdlZBIiwgImVtYWlsIiwgImpvaG5kb2VA
ZXhhbXBsZS5jb20iXQ
Contents: ["6Ij7tM-a5iVPGboS5tmvVA", "contact_email", "johndoe@example.com"]
~~~~~~~~~~~~~

Claim phone_number:

~~~~~~~~~~~~~
SHA-256 Hash: PorFbpKuVu6xymJagvkFsFXAbRoc2JGlAUA2BA4o7cI
Disclosure:
WyJlSThaV205UW5LUHBOUGVOZW5IZGhRIiwgInBob25lX251bWJlciIsICIr
MS0yMDItNTU1LTAxMDEiXQ
Contents: ["eI8ZWm9QnKPpNPeNenHdhQ", "contact_phone_number",
"+1-202-555-0101"]
~~~~~~~~~~~~~

Claim business_ids:

~~~~~~~~~~~~~
SHA-256 Hash: XQ_3kPKt1XyX7KANkqVR6yZ2Va5NrPIvPYbyMvRKBMM
Disclosure:
WyJRZ19PNjR6cUF4ZTQxMmExMDhpcm9BIiwgInBob25lX251bWJlcl92ZXJp
ZmllZCIsIHRydWVd
Contents: ["Qg_O64zqAxe412a108iroA", "business_ids", true]
~~~~~~~~~~~~~

Claim address:

~~~~~~~~~~~~~
SHA-256 Hash: XzFrzwscM6Gn6CJDc6vVK8BkMnfG8vOSKfpPIZdAfdE
Disclosure:
WyJBSngtMDk1VlBycFR0TjRRTU9xUk9BIiwgImFkZHJlc3MiLCB7InN0cmVl
dF9hZGRyZXNzIjogIjEyMyBNYWluIFN0IiwgImxvY2FsaXR5IjogIkFueXRv
d24iLCAicmVnaW9uIjogIkFueXN0YXRlIiwgImNvdW50cnkiOiAiVVMifV0
Contents: ["AJx-095VPrpTtN4QMOqROA", "address", {"street_address":
"123 Main St", "locality": "Anytown", "region": "Anystate",
"country": "US"}]
~~~~~~~~~~~~~

Array Entry:

~~~~~~~~~~~~~
SHA-256 Hash: pFndjkZ_VCzmyTa6UjlZo3dh-ko8aIKQc9DlGzhaVYo
Disclosure: WyJsa2x4RjVqTVlsR1RQVW92TU5JdkNBIiwgIlVTIl0
Contents: ["lklxF5jMYlGTPUovMNIvCA", "{"nam":"Business_42","icn":"https://example.com/logo.png"}"]
~~~~~~~~~~~~~

Array Entry:

~~~~~~~~~~~~~
SHA-256 Hash: 7Cf6JkPudry3lcbwHgeZ8khAv1U1OSlerP0VkBJrWZ0
Disclosure: WyJuUHVvUW5rUkZxM0JJZUFtN0FuWEZBIiwgIkRFIl0
Contents: ["nPuoQnkRFq3BIeAm7AnXFA", "123456789"]
~~~~~~~~~~~~~

The payload is then signed by the Issuer to create a JWT like the following:

~~~~~~~~~~~~~
eyJhbGciOiAiRVMyNTYiLCAidHlwIjogImV4YW1wbGUrc2Qtand0In0.eyJfc2QiOiBb
IkNyUWU3UzVrcUJBSHQtbk1ZWGdjNmJkdDJTSDVhVFkxc1VfTS1QZ2tqUEkiLCAiSnpZ
akg0c3ZsaUgwUjNQeUVNZmVadTZKdDY5dTVxZWhabzdGN0VQWWxTRSIsICJQb3JGYnBL
dVZ1Nnh5bUphZ3ZrRnNGWEFiUm9jMkpHbEFVQTJCQTRvN2NJIiwgIlRHZjRvTGJnd2Q1
SlFhSHlLVlFaVTlVZEdFMHc1cnREc3JaemZVYW9tTG8iLCAiWFFfM2tQS3QxWHlYN0tB
TmtxVlI2eVoyVmE1TnJQSXZQWWJ5TXZSS0JNTSIsICJYekZyendzY002R242Q0pEYzZ2
Vks4QmtNbmZHOHZPU0tmcFBJWmRBZmRFIiwgImdiT3NJNEVkcTJ4Mkt3LXc1d1BFemFr
b2I5aFYxY1JEMEFUTjNvUUw5Sk0iLCAianN1OXlWdWx3UVFsaEZsTV8zSmx6TWFTRnpn
bGhRRzBEcGZheVF3TFVLNCJdLCAiaXNzIjogImh0dHBzOi8vaXNzdWVyLmV4YW1wbGUu
Y29tIiwgImlhdCI6IDE2ODMwMDAwMDAsICJleHAiOiAxODgzMDAwMDAwLCAic3ViIjog
InVzZXJfNDIiLCAibmF0aW9uYWxpdGllcyI6IFt7Ii4uLiI6ICJwRm5kamtaX1ZDem15
VGE2VWpsWm8zZGgta284YUlLUWM5RGxHemhhVllvIn0sIHsiLi4uIjogIjdDZjZKa1B1
ZHJ5M2xjYndIZ2VaOGtoQXYxVTFPU2xlclAwVmtCSnJXWjAifV0sICJfc2RfYWxnIjog
InNoYS0yNTYiLCAiY25mIjogeyJqd2siOiB7Imt0eSI6ICJFQyIsICJjcnYiOiAiUC0y
NTYiLCAieCI6ICJUQ0FFUjE5WnZ1M09IRjRqNFc0dmZTVm9ISVAxSUxpbERsczd2Q2VH
ZW1jIiwgInkiOiAiWnhqaVdXYlpNUUdIVldLVlE0aGJTSWlyc1ZmdWVjQ0U2dDRqVDlG
MkhaUSJ9fX0.XaB1KmNGBE-uKjT8M3VSu65QVWdNMjuhJI1sIEM4TIEs6Ae2f0DfWP80
TAg79QIhbz04IIrrXyrEbzkeZLoVHQ

The issued SD-JWT might look as follows:

eyJhbGciOiAiRVMyNTYiLCAidHlwIjogImV4YW1wbGUrc2Qtand0In0.eyJfc2QiOiBb
IkNyUWU3UzVrcUJBSHQtbk1ZWGdjNmJkdDJTSDVhVFkxc1VfTS1QZ2tqUEkiLCAiSnpZ
akg0c3ZsaUgwUjNQeUVNZmVadTZKdDY5dTVxZWhabzdGN0VQWWxTRSIsICJQb3JGYnBL
dVZ1Nnh5bUphZ3ZrRnNGWEFiUm9jMkpHbEFVQTJCQTRvN2NJIiwgIlRHZjRvTGJnd2Q1
SlFhSHlLVlFaVTlVZEdFMHc1cnREc3JaemZVYW9tTG8iLCAiWFFfM2tQS3QxWHlYN0tB
TmtxVlI2eVoyVmE1TnJQSXZQWWJ5TXZSS0JNTSIsICJYekZyendzY002R242Q0pEYzZ2
Vks4QmtNbmZHOHZPU0tmcFBJWmRBZmRFIiwgImdiT3NJNEVkcTJ4Mkt3LXc1d1BFemFr
b2I5aFYxY1JEMEFUTjNvUUw5Sk0iLCAianN1OXlWdWx3UVFsaEZsTV8zSmx6TWFTRnpn
bGhRRzBEcGZheVF3TFVLNCJdLCAiaXNzIjogImh0dHBzOi8vaXNzdWVyLmV4YW1wbGUu
Y29tIiwgImlhdCI6IDE2ODMwMDAwMDAsICJleHAiOiAxODgzMDAwMDAwLCAic3ViIjog
InVzZXJfNDIiLCAibmF0aW9uYWxpdGllcyI6IFt7Ii4uLiI6ICJwRm5kamtaX1ZDem15
VGE2VWpsWm8zZGgta284YUlLUWM5RGxHemhhVllvIn0sIHsiLi4uIjogIjdDZjZKa1B1
ZHJ5M2xjYndIZ2VaOGtoQXYxVTFPU2xlclAwVmtCSnJXWjAifV0sICJfc2RfYWxnIjog
InNoYS0yNTYiLCAiY25mIjogeyJqd2siOiB7Imt0eSI6ICJFQyIsICJjcnYiOiAiUC0y
NTYiLCAieCI6ICJUQ0FFUjE5WnZ1M09IRjRqNFc0dmZTVm9ISVAxSUxpbERsczd2Q2VH
ZW1jIiwgInkiOiAiWnhqaVdXYlpNUUdIVldLVlE0aGJTSWlyc1ZmdWVjQ0U2dDRqVDlG
MkhaUSJ9fX0.XaB1KmNGBE-uKjT8M3VSu65QVWdNMjuhJI1sIEM4TIEs6Ae2f0DfWP80
TAg79QIhbz04IIrrXyrEbzkeZLoVHQ~WyIyR0xDNDJzS1F2ZUNmR2ZyeU5STjl3IiwgI
mdpdmVuX25hbWUiLCAiSm9obiJd~WyJlbHVWNU9nM2dTTklJOEVZbnN4QV9BIiwgImZh
bWlseV9uYW1lIiwgIkRvZSJd~WyI2SWo3dE0tYTVpVlBHYm9TNXRtdlZBIiwgImVtYWl
sIiwgImpvaG5kb2VAZXhhbXBsZS5jb20iXQ~WyJlSThaV205UW5LUHBOUGVOZW5IZGhR
IiwgInBob25lX251bWJlciIsICIrMS0yMDItNTU1LTAxMDEiXQ~WyJRZ19PNjR6cUF4Z
TQxMmExMDhpcm9BIiwgInBob25lX251bWJlcl92ZXJpZmllZCIsIHRydWVd~WyJBSngt
MDk1VlBycFR0TjRRTU9xUk9BIiwgImFkZHJlc3MiLCB7InN0cmVldF9hZGRyZXNzIjog
IjEyMyBNYWluIFN0IiwgImxvY2FsaXR5IjogIkFueXRvd24iLCAicmVnaW9uIjogIkFu
eXN0YXRlIiwgImNvdW50cnkiOiAiVVMifV0~WyJQYzMzSk0yTGNoY1VfbEhnZ3ZfdWZR
IiwgImJpcnRoZGF0ZSIsICIxOTQwLTAxLTAxIl0~WyJHMDJOU3JRZmpGWFE3SW8wOXN5
YWpBIiwgInVwZGF0ZWRfYXQiLCAxNTcwMDAwMDAwXQ~WyJsa2x4RjVqTVlsR1RQVW92T
U5JdkNBIiwgIlVTIl0~WyJuUHVvUW5rUkZxM0JJZUFtN0FuWEZBIiwgIkRFIl0~
~~~~~~~~~~~~~

Presentation

The following non-normative example shows an SD-JWT+KB as it would be sent from the Holder to the Verifier. Note that it consists of six tilde-separated parts, with the Issuer-signed JWT as shown above in the beginning, four Disclosures (for the claims given_name, family_name, address, and nationalities) in the middle, and the Key Binding JWT as the last element.

~~~~~~~~~~~~~
eyJhbGciOiAiRVMyNTYiLCAidHlwIjogImV4YW1wbGUrc2Qtand0In0.eyJfc2QiOiBb
IkNyUWU3UzVrcUJBSHQtbk1ZWGdjNmJkdDJTSDVhVFkxc1VfTS1QZ2tqUEkiLCAiSnpZ
akg0c3ZsaUgwUjNQeUVNZmVadTZKdDY5dTVxZWhabzdGN0VQWWxTRSIsICJQb3JGYnBL
dVZ1Nnh5bUphZ3ZrRnNGWEFiUm9jMkpHbEFVQTJCQTRvN2NJIiwgIlRHZjRvTGJnd2Q1
SlFhSHlLVlFaVTlVZEdFMHc1cnREc3JaemZVYW9tTG8iLCAiWFFfM2tQS3QxWHlYN0tB
TmtxVlI2eVoyVmE1TnJQSXZQWWJ5TXZSS0JNTSIsICJYekZyendzY002R242Q0pEYzZ2
Vks4QmtNbmZHOHZPU0tmcFBJWmRBZmRFIiwgImdiT3NJNEVkcTJ4Mkt3LXc1d1BFemFr
b2I5aFYxY1JEMEFUTjNvUUw5Sk0iLCAianN1OXlWdWx3UVFsaEZsTV8zSmx6TWFTRnpn
bGhRRzBEcGZheVF3TFVLNCJdLCAiaXNzIjogImh0dHBzOi8vaXNzdWVyLmV4YW1wbGUu
Y29tIiwgImlhdCI6IDE2ODMwMDAwMDAsICJleHAiOiAxODgzMDAwMDAwLCAic3ViIjog
InVzZXJfNDIiLCAibmF0aW9uYWxpdGllcyI6IFt7Ii4uLiI6ICJwRm5kamtaX1ZDem15
VGE2VWpsWm8zZGgta284YUlLUWM5RGxHemhhVllvIn0sIHsiLi4uIjogIjdDZjZKa1B1
ZHJ5M2xjYndIZ2VaOGtoQXYxVTFPU2xlclAwVmtCSnJXWjAifV0sICJfc2RfYWxnIjog
InNoYS0yNTYiLCAiY25mIjogeyJqd2siOiB7Imt0eSI6ICJFQyIsICJjcnYiOiAiUC0y
NTYiLCAieCI6ICJUQ0FFUjE5WnZ1M09IRjRqNFc0dmZTVm9ISVAxSUxpbERsczd2Q2VH
ZW1jIiwgInkiOiAiWnhqaVdXYlpNUUdIVldLVlE0aGJTSWlyc1ZmdWVjQ0U2dDRqVDlG
MkhaUSJ9fX0.XaB1KmNGBE-uKjT8M3VSu65QVWdNMjuhJI1sIEM4TIEs6Ae2f0DfWP80
TAg79QIhbz04IIrrXyrEbzkeZLoVHQ~WyJlbHVWNU9nM2dTTklJOEVZbnN4QV9BIiwgI
mZhbWlseV9uYW1lIiwgIkRvZSJd~WyJBSngtMDk1VlBycFR0TjRRTU9xUk9BIiwgImFk
ZHJlc3MiLCB7InN0cmVldF9hZGRyZXNzIjogIjEyMyBNYWluIFN0IiwgImxvY2FsaXR5
IjogIkFueXRvd24iLCAicmVnaW9uIjogIkFueXN0YXRlIiwgImNvdW50cnkiOiAiVVMi
fV0~WyIyR0xDNDJzS1F2ZUNmR2ZyeU5STjl3IiwgImdpdmVuX25hbWUiLCAiSm9obiJd
~WyJsa2x4RjVqTVlsR1RQVW92TU5JdkNBIiwgIlVTIl0~eyJhbGciOiAiRVMyNTYiLCA
idHlwIjogImtiK2p3dCJ9.eyJub25jZSI6ICIxMjM0NTY3ODkwIiwgImF1ZCI6ICJodH
RwczovL3ZlcmlmaWVyLmV4YW1wbGUub3JnIiwgImlhdCI6IDE3MTgyOTg3NjYsICJzZF
9oYXNoIjogImEyWTh0bUhrUm9MQXFrWTlKMjR0aXhucWJNLVVxcFg2MUpJRm5BVDIxX2
sifQ.sqzbrv_SfCuI7yk3w7Hot82zFZiaWB-EH2GqsSi2-ZukcgP7z8DQGhPkSV97-WZ
r5hGm-nR0MmSDTXgmoFeViQ
~~~~~~~~~~~~~

The following Key Binding JWT payload was created and signed for this presentation by the Holder:

~~~~~~~~~~~~~
{
  "nonce": "1234567890",
  "aud": "https://verifier.example.org",
  "iat": 1718298766,
  "sd_hash": "a2Y8tmHkRoLAqkY9J24tixnqbM-UqpX61JIFnAT21_k"
}
~~~~~~~~~~~~~

If the Verifier did not require Key Binding, then the Holder could have presented the SD-JWT with selected Disclosures directly, instead of encapsulating it in an SD-JWT+KB.



# API Endpoints

The vetting service provides the following APIs:

## Request Vetting Token API

~~~~~~~~~~~~~
Endpoint: /api/request-vetting-token
Method: POST
Description: Requests a vetting token (SD-JWT) from the Vetting Authority (VA).
Headers:
  Authorization: Bearer (VE's m2m bearer token)
~~~~~~~~~~~~~

Request Body:

~~~~~~~~~~~~
{
  "entity_id": "unique-entity-id",
  "key_binding": true,
  "public_key_jwk": {
    "kty": "RSA",
    "e": "AQAB",
    "n": "lsO0Qe0Qu7FwZQ22T5vlqXN...",
    "alg": "RS256"
  }
}
~~~~~~~~~~~~

Response:

~~~~~~~~~~~~
{
  "status": "success",
  "vetting_token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
  "transparency_receipt": {
    "log_entry_id": "transparency-log-001",
    "receipt": {
      "hash": "abc123...",
      "timestamp": "2024-06-11T12:35:00Z",
      "signature": "transparency-service-signature"
    }
  }
}
~~~~~~~~~~~~

Note: entity_id is generated by VA. The mechanism how persona is vetted is not subject of this document. This API can only be called after the vetting was complete and entity_id was issued.

## Public API for Verifiers

~~~~~~~~~~~~~
Endpoint: /api/verify-vetted-info
Method: POST
Description: Verifies the validity of transparency receipt.
Request Body:
~~~~~~~~~~~~~

~~~~~~~~~~~~
{
  "transparency_receipt": {
    "log_entry_id": "transparency-log-001",
    "receipt": {
      "hash": "abc123...",
      "timestamp": "2024-06-11T12:35:00Z",
      "signature": "transparency-service-signature"
    }
  }
}
~~~~~~~~~~~~

Response:

~~~~~~~~~~~~
{
  "status": "success",
  "message": "Vetted information verified successfully."
}
~~~~~~~~~~~~

# Vesper Transparency Log Usage

1.	VCM Submission:
- When a VA issues a proof of vetting for VE, it submits the Vetting Confirmation Manifest (VCM) to a Vesper Certificate Transparency (VESPER CT) log server.
- The log server records the VCM in its append-only log.
2.	Generating the SVT:
- The log server generates a Signed Vetting Timestamp (SVT) for the submitted VCM.
- The SVT includes the following fields:
- Version: Indicates the version of the SVT.
- Log ID: A unique identifier for the VESPER CT log server, typically the hash of the log server’s public key.
- Timestamp: The time at which the certificate was submitted to the log, measured in milliseconds since the Unix epoch.
- Signature: A digital signature created by the log server using its private key. This signature covers the log ID, timestamp, and VCM data.
3.	SVT Delivery:
- The VA receives the SVT from the log server and delivers it as part of the Vesper token.
4.	VV Verification:
•	When VV receives a Vesper token and embedded SVT, it performs the following steps to verify the SVT:
•	Extract the Log ID: The VV extracts the log ID from the SVT.
•	Retrieve the Public Key: Using the log ID, the VV retrieves the corresponding public key from its list of trusted Vesper logs.
•	Verify the Signature: The VV verifies the SVT’s signature using the log server’s public key. This ensures that the SVT was indeed issued by the log server and has not been tampered with.
5.	Merkle Tree Inclusion Proof (Optional but recommended):
•	To further ensure that the VCM is in the log, the VV can request a Merkle Tree inclusion proof from the log server. This proof demonstrates that the VCM is part of the log’s Merkle Tree without revealing the entire log.
•	The proof consists of:
•	Leaf Node: The hash of the VCM.
•	Path: A sequence of hashes that demonstrate the VCM's inclusion in the Merkle Tree.
6.	Validation:
•	The VV validates the Merkle Tree proof by reconstructing the Merkle Tree hash from the leaf node and the path provided by the log server.
•	By comparing the reconstructed hash to the known root hash of the log’s Merkle Tree (obtained from periodic signed tree heads), the VV can confirm the VCM's inclusion.

# Vesper Transparency Service API

## Add VCM to Log

### Endpoint: /vesper/v1/add-vcm
- Method: POST
- Description: Adds a VCM (Vetting Credential Manifest) to the log.
- Inputs:
  - vcm: A base64-encoded Vetting Credential Manifest.
- Outputs:
  - svt_version: The version of the Signed Vetting Timestamp structure, in decimal.
  - id: The log ID, base64 encoded.
  - timestamp: The SVT timestamp, in decimal.
  - extensions: An opaque type for future expansion. Logs should set this to the empty string. Clients should decode the base64-encoded data and include it in the SVT.
  - signature: The SVT signature, base64 encoded.

### Example Request

```json
{
  "vcm": "base64-encoded-vcm"
}
```

### Example Response

```json
{
  "svt_version": 1,
  "id": "base64-encoded-log-id",
  "timestamp": 1683000000,
  "extensions": "",
  "signature": "base64-encoded-signature"
}
```

## Retrieve Latest Signed Tree Head

### Endpoint: /vesper/v1/get-sth
- Method: GET
- Description: Retrieves the latest signed tree head.
- Inputs: None
- Outputs:
  - tree_size: The size of the tree, in entries, in decimal.
  - timestamp: The timestamp, in decimal.
  - sha256_root_hash: The Merkle Tree Hash of the tree, in base64.
  - tree_head_signature: A TreeHeadSignature for the above data.

### Example Response

```json
{
  "tree_size": 100,
  "timestamp": 1683000000,
  "sha256_root_hash": "base64-encoded-root-hash",
  "tree_head_signature": "base64-encoded-signature"
}
```

## Retrieve Merkle Consistency Proof between Two Signed Tree Heads

### Endpoint: /vesper/v1/get-sth-consistency
- Method: GET
- Description: Retrieves a Merkle consistency proof between two signed tree heads.
- Inputs:
  - first: The tree_size of the first tree, in decimal.
  - second: The tree_size of the second tree, in decimal.
- Outputs:
  - consistency: An array of Merkle Tree nodes, base64 encoded.

### Example Request

```
/vesper/v1/get-sth-consistency?first=50&second=100
```

### Example Response

```json
{
  "consistency": [
    "base64-encoded-node1",
    "base64-encoded-node2"
  ]
}
```

## Retrieve Merkle Audit Proof from Log by Leaf Hash

### Endpoint: /vesper/v1/get-proof-by-hash
- Method: GET
- Description: Retrieves a Merkle audit proof from the log by leaf hash.
- Inputs:
  - hash: A base64-encoded leaf hash.
  - tree_size: The tree_size of the tree on which to base the proof, in decimal.
- Outputs:
  - leaf_index: The 0-based index of the end entity corresponding to the `hash` parameter.
  - audit_path: An array of base64-encoded Merkle Tree nodes proving the inclusion of the chosen VCM.

### Example Request

```
/vesper/v1/get-proof-by-hash?hash=base64-encoded-hash&tree_size=100
```

### Example Response

```json
{
  "leaf_index": 10,
  "audit_path": [
    "base64-encoded-node1",
    "base64-encoded-node2"
  ]
}
```

## Retrieve Entries from Log

### Endpoint: /vesper/v1/get-entries
- Method: GET
- Description: Retrieves entries from the log.
- Inputs:
  - start: 0-based index of first entry to retrieve, in decimal.
  - end: 0-based index of last entry to retrieve, in decimal.
- Outputs:
  - entries: An array of objects, each consisting of:
    - leaf_input: The base64-encoded MerkleTreeLeaf structure.
    - extra_data: The base64-encoded unsigned data pertaining to the log entry.

### Example Request

```
/vesper/v1/get-entries?start=0&end=10
```

### Example Response

```json
{
  "entries": [
    {
      "leaf_input": "base64-encoded-leaf1",
      "extra_data": "base64-encoded-extra-data1"
    },
    {
      "leaf_input": "base64-encoded-leaf2",
      "extra_data": "base64-encoded-extra-data2"
    }
  ]
}
```

## Retrieve Accepted Root Certificates

### Endpoint: /vesper/v1/get-roots
- Method: GET
- Description: Retrieves the list of accepted root certificates.
- Inputs: None
- Outputs:
  - certificates: An array of base64-encoded root certificates that are acceptable to the log.

### Example Response

```json
{
  "certificates": [
    "base64-encoded-root-cert1",
    "base64-encoded-root-cert2"
  ]
}
```

## Retrieve Entry + Merkle Audit Proof from Log

### Endpoint: /vesper/v1/get-entry-and-proof
- Method: GET
- Description: Retrieves an entry and its Merkle audit proof from the log.
- Inputs:
  - leaf_index: The index of the desired entry.
  - tree_size: The tree_size of the tree for which the proof is desired.
- Outputs:
  - leaf_input: The base64-encoded MerkleTreeLeaf structure.
  - extra_data: The base64-encoded unsigned data.
  - audit_path: An array of base64-encoded Merkle Tree nodes proving the inclusion of the chosen VCM.

### Example Request

```
/vesper/v1/get-entry-and-proof?leaf_index=10&tree_size=100
```

### Example Response

```json
{
  "leaf_input": "base64-encoded-leaf",
  "extra_data": "base64-encoded-extra-data",
  "audit_path": [
    "base64-encoded-node1",
    "base64-encoded-node2"
  ]
}
```

# Requirement for SHA-256 in Append-only Logs

To ensure compatibility and prevent inconsistencies across different implementations of Transparency Services, all Append-only Logs used in the VESPER architecture MUST employ SHA-256 as the cryptographic hash function. Specifically:

- Each entry in the Append-only Log MUST be hashed using the SHA-256 algorithm.
- The log structure, whether implemented as a Merkle Tree or any other verifiable data structure, MUST utilize SHA-256 for all cryptographic operations.
- This uniformity in the choice of the hash function guarantees that all participants and auditors can independently verify the integrity and consistency of the logs without compatibility issues.
- Transparency Services MUST provide cryptographic proofs (inclusion proofs and consistency proofs) based on SHA-256, as detailed in [I-D.draft-ietf-cose-merkle-tree-proofs].

By mandating the use of SHA-256 for all logs, VESPER ensures a standardized and secure approach to maintaining and verifying the integrity of supply chain data.

# Security Considerations

TODO Security


# IANA Considerations

## JSON Web Token claims

This specification requests that the IANA add two new claims to the JSON Web Token Claims registry as defined in [RFC7519].

Claim Name: “vesper”

Claim Description: A JSON object that includes both an SD-JWT object containing Vesper Claims from a Vesper Claim Agent and a Notary Agent transparency receipt object as required by the STIR Vesper framework

Change Controller: IESG

Specification Document(s): [RFCThis]

## PASSporT Types

This specification requests that the IANA add a new entry to the Personal Assertion Token (PASSporT) Extensions registry for the type “vesper” which is specified in [RFCThis].


--- back

# Acknowledgments
{:numbered="false"}

TODO acknowledge.

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
  RFC3261:
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

## Vesper Architectural Overview

The use of vesper tokens in communications will allow for a trust model enabled by a three party trust system based on an agreed set of vetting policies with a set of privacy enabled features to allow for selective disclosure for communications that require authorized use of a telephone number with the ability to support use-cases that require anonymity all the way up to full disclosure of vetted persona information if that is desired. The establishment of roles that facilitate the trust of the association of a telephone number and other entity information is in the form of claims made by authoritative or identified trusted actors in the eco-system.  This document defines these roles as Claim Agents that have specific types with associated standard mandatory and optional key values. This document defines the following Claim Agent roles, Vetting Claim Agent (VCA), Right to Use Claim Agent (RTUCA), Rich Call Data Claim Agent (RCDCA), and Consent Claim Agent (CCA). The responsibilities of Claim Agents generally and of each specific type will be detailed in the document and a Claim Agent type registry is established. Future documents may define other Claim Agent types and associated claim key values. Claim Agents make claims about the end entity that is the holder of a telephone number or set of numbers who is referred to as the Subject Entity (SE) as the subject of the claims. All claim agents are required to be registered with a Notary Agent (NA) who acts in a neutral role but critically maintains a graph of authorized and responsible parties that issue claims. These claims are recorded and “notarized” via a transparency log with a corresponding receipt that proves the transaction happened and who issued the claims and the telephone number identity associated. The SE is associated however is opaque for privacy considerations. Claims are optionally able to be made publicly visible for the additional trust and for enabling uniqueness, so either a mistaken or illegitimate claim to an identity attribute can be prevented for those that require that uniqueness to be enforced, i.e. a business name or logo. All of the claims represented by an SD-JWT {{I-D.ietf-oauth-selective-disclosure-jwt}} and a transparency receipt are deposited into a digital “wallet” held by the SE, these selectively disclosable set of claims are then able to be presented by wrapping the selected SD-JWTs as “vesper” claims in a “vesper” PASSporT that is signed by a delegate certificate {{RFC9060}} provided by an authorized telephone number provider and tied to the assigned telephone numbers in the TNAuthList of the delegate certificate. This signed “vesper” PASSporT is then attached to a set of communications with a specific destination party verifier, in the context of STIR this would be delivered using a SIP identity header field verifiable by a STIR Verification Service defined in {{RFC8824}}. The verifier then has proof of both the issuers of the claims, receipts to represent the notarization of the claims being made, and the tie to a authentically delegated certificate confirming the current assignment and right to use the telephone number.

# Terminology

Claim Agent: An entity that is either authorized or trusted in the eco-system to make claims of persona-related information and issues verifiable selectively disclosable tokens containing the vetted claim information. A Claim Agent can be a trusted third party or a service provider that performs the vetting of persona-related information. Claim Agent is a role catagory where their are defined a set of specific claim agent types with associated claim attribute key values that are either required or optional by specification.

Vetting Claim Agent (VCA): The Claim Agent entity that initiates and establishes a Subject Entity into the eco-system. Its role is to vet a set of claims that are related to the persona like physical address, business identifiers, contact information and other identifying information. Generally, this information is not disclosed as part of a typical communications transaction, although nothing prevents it.  However, it’s an important set of information to establish the existence and legal standing of a persona. This information is also relevant to a potential legal or policy enforcement action if that becomes required based on alleged illegal or policy violations, something the VCA would be the responsible party to facilitate.

Right to Use Claim Agent (RTUCA): The Claim Agent entity that generally represents an authorized provider of telephone numbers for direct assignment.

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

## Compact Form and Other Representations of Vesper Information

The use of the compact form of PASSporT is not specified for a “vesper” PASSporT primarily because generally or specifically when using the {{RFC8224}} defined identity header field as the transport of a “vesper” PASSporT there MUST NOT be any corresponding vesper information or claims provided that are unprotected or not signed to validate it's issuer in SIP {{RFC3261}} or SIP header fields, nor should there be due to the trusted intent of "vesper" claims or "vesper" PASSporTs. "Vesper" claims and PASSporTs are intended to only be used with the identity header field defined in {{RFC8224}}. Other uses may be considered but MUST consider the use of digital signatures to tie responsible parties and issuers to vesper related information.

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


### Right to Use Claim Agent - “rtuca”

The Right to Use Claim Agent is a required claim agent data type and is tied to a telephone number service provider or Responsible Organization that is authorized to assign telephone numbers. The Subject Entity has a business relationship with their telephone number provider that also either directly or through a relationship with a Claim Agent can validate the assigned Telephone Number.  

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

The notarization process involves two main logical components the time-stamped and signed formalization of a claim transaction between a Claim Agent and a Subject Entity and the associated submission of those transactions to a monitorable transparency service that provides digital receipts that can be used to prove that the transaction was notarized by an authorized notary agent. The Notary Agent role is likely performed by a neutral party in the ecosystem. Because telephone number assignment is a key and required vesper claim a notary role may make sense to be directly associated with telephone number assignment administration.
The key interfaces provided by a Notary Agent is the registration of Claim Agents and Subject Entities with unique entity-ids and the corresponding claim event submission and Signed Vesper Claim Timestamp (SVCT) responses, APIs and transparency service log monitoring APIs. These are described in detail in the sections below.

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

11. After the VCA has established the SE with its entity-id at the NA, additional claims can be made for that SE by another claim agent (e.g. Right to Use claims, RCD claims, or consent claims)
12. The Claim Agent performs a hash over the claim object key values but can also submit public claims intended to be disclosed for transparency monitoring.
13. The NA registers the claim event, including either hashed or public claims or both.

# Use Case Example: Telephone Number Assignment
1. The VE undergoes KYC/KYB vetting by a VA and receives a KYC/KYB Vesper token.
2. The VE presents this KYC/KYB token to a TNSP when requesting TN assignment.
3. The VE may also present a TNSP Vesper token that includes credentials for the TN lease and RCD.
4. The TNSP verifies the Vesper tokens and assigns the
5. TN, ensuring that the VE is legitimate and that the additional information (e.g., RCD) is accurate and trustworthy.

TODO: Add diagram ...

# Vesper PASSporT Token as a wrapper for Multiple Vesper Claims Presentation

A Subject Entity (SE), acting as the Holder of multiple Vesper claims as SD-JWT + reciepts, may need to present a combination of these tokens to satisfy various verification requirements in a single interaction. For instance, in the STIR ecosystem, the SE might first present a vetting Vesper claim to a Telephone Number Service Provider (TNSP) to prove its identity. Once trusted, the TNSP issues a Right To Use (RTU) Vesper token for a specific Telephone Number (TN) and associated Rich Call Data (RCD). The SE can then present both the vetting and RTU Vesper claims to the AS when signing a call.

## Structure of multiple Vesper Claim Presentation

When creating a multiple Vesper Claim presentation, the SE assembles a package that may contain:

1. Multiple Base SD-JWTs: The core JWTs from each Vesper token (e.g., KYC/KYB and RTU), representing the vetted claims.
2. Disclosures: The selectively disclosable claims from each token that are relevant to the verifier.
3. Key Binding JWTs (KB-JWTs): For each SD-JWT, there is an associated KB-JWT to bind the SD-JWT to a specific key pair, ensuring that the tokens are bound to the Holder's (SE’s) key pair.

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

The following non-normative example shows a Vesper PASSporT as it would be sent from the Holder (SE) to the Verifier. 

Add Example

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

---
title: "VESPER - VErifiable STI Personas"
abbrev: "vesper"
category: info

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
    fullname: "Chris Wendt"
    organization: Somos, Inc.
    email: "chris@appliedbits.com"
    country: US
 -
    fullname: Rob Sliwa
    organization: Somos, Inc.
    email: robjsliwa@gmail.com
    country: US

normative:
  RFC8824:
  RFC8825:
  RFC8226:

informative:


--- abstract

This document extends the STIR architecture by specifying the use of JSON Web Tokens (JWT) and Selective Disclosure JWT (SD-JWT) for verifying Know Your Customer (KYC) and Know Your Business (KYB) types of vetting processes. It defines a standard for Vetting Agents (VA) to create verifiable tokens that represent the vetting status of entities, or VERifiable Sti PERsonas (vesper). The resulting token can be used by the Vetted Party (VP) to proof to third parties that they are who they claim to be, optionally disclosing selected information about themselves in privacy protecting complete or zero knowledge manner. The document also describes an API standard to be supported/hosted by a Vetting Agent (VA), which allow vetted parties to present tokens proving their KYC/KYB conformance, and incorporates proof of possession to ensure the legitimacy of the entity presenting the token.

--- middle

# Introduction

The Secure Telephone Identity (STI) architecture fundamentally defined by STI certificates, PASSporTs, and the SIP Identity header field describes a set of constructs and protocols for the use of tokens and digital signatures to protect the integrity and provide non-repudiation of information including the telephone numbers associated with a call event. This document extends that architecture to address the association of a telephone number to the persona or entity responsible for the use and set of communications associated with that telephone number. Recently, the illegitimate use of telephone numbers by unauthorized parties and the associated fraudulent activity associated with those communications has eroded trust. Further, reliance on the trust of the signer at the time of the communications has proven to require time and people consuming work to perform after-the-fact investigation and enforcement activities. Other industries, like the financial industry, have adopted well-known successful practices of Know Your Customer (KYC), otherwise referred to as vetting, of the responsible parties before any communications can be initiated. The confirmation and acknowledgement of the connection between a persona or business entity with a telephone number and the responsibilities associated with its use is a critical step towards building true trusted relationship between the parties involved in a set of communications. This document describes the vesper token, a VErifiable Sti PERsona represented by a token signed by a party that is acknowledged and trusted as part of a communications ecosystem to perform the KYC or vetting procedures typically corresponding to an agreed upon set of policies defined by that ecosystem. Additionally, vetting information required to verify the persona is information that likely requires strict privacy practices. The vesper token and architecture provides mechanisms for providing selective disclosure of any personally identifying information to be disclosed to those that are authorized by either the persona directly or, for example, based on enforcement actions required for legitimately authorized legal activity.
The use of vesper tokens in communications will allow for a trust model enabled by a three party trust system based on an agreed set of vetting policies with a set of privacy enabled features to allow for selective disclosure for communications that require authorized use of a telephone number with the ability to support use-cases that require anonymity all the way up to full disclosure of vetted persona information if that is desired. Vesper token is designed to be used in many ways to represent the vetting of the persona associated with a telephone number. This document defines the specific use of the vesper token in the STI architecture.

In the current state of digital identities, the unique identifier used to identify the persona behind the identifier is obviously a critical part of using an identifier as part of a digital protocol, but just as important is the ability to associate a real-world persona to that identifier as the responsible party behind that identifier. The telephone number as an identifier and as part of a set of traditional communications services offered around the world has been facing a challenge of illegitimate fraud based on the lack of a formal framework for the explicit association of a set of communications to a directly responsible party. The use of "spoofing" of telephone numbers, a practice of the use of telephone numbers by not directly authorized parties, while having very legitimate use-cases, has been exploited by actors of fraudulent intent to either impersonate the legitimate party, or simply obfuscate the actual party behind the call. Fraud and illegitimate activity has proliferated based on the loose connection of telephone numbers to responsible parties.
The Secure Telephone Identity (STI) architecture defined primarily by the following documents {{RFC8224}}, {{RFC8225}}, and {{RFC8226}} and subsequent documents defined as part of STIR have defined the basis for a set of protocols to protect the telephone number and other associated information specific to the calling and/or called party for a specific communications session. This document takes the next step to provide a specific protocol as a token, referred to in this document as the "vesper" token, to provide


# Conventions and Definitions

{::boilerplate bcp14-tagged}

# Overview

The vetting process for entities involves verifying their identity and legitimacy, typically through KYC and KYB vetting procedures. This document proposes a standardized method for representing the results of these vetting procedures using JSON Web Tokens (JWT) and Selective Disclosure JWT (SD-JWT). This document does not address how the KYC/KYB should be performed or what documents or processes should be used. Rather the goal of this document is to create a standardized identifier for the Vetted Entities (VE) to present that they are who they claim to be.

# Vetting Process Overview

The vetting process involves the following steps:

Registration of the entity with a Vetting Authority (VA).
The VA performs KYC/KYB checks according to their procedures.
The entity generates a public/private key pair or the VA does it on the entries behalf.
The public key is registered with the VA.
The VA creates hash of their vetting data and/or results. What exactly is included in generation of the hash is up to VA and influenced by the process used.
The VA logs the hash of the KYC/KYB data with a transparency service and issues a transparency receipt.
The VA provides the API service or the Vetted Entity (VE) hosts their own according the API definition in this document.
The VA or VE issues an SD-JWT containing the KYC/KYB information, the public key, and the transparency receipt.
Verifying party ensures that token signature is correct.
Verifier can verify the Transparency log signature to further trust the token.
Verifier can call proof of possession API and issue the challenge to ensure that the entity presenting the token is the legitimate holder of it.

# JSON Web Tokens (JWT) for KYC/KYB Vetting

The SD-JWT includes the following claims:

iss: Issuer, the Vetting Authority.
sub: Subject, the vetted entity.
iat: Issuance timestamp.
exp: Expiry timestamp.
kyc_data_hash: Hash of the KYC/KYB data.
transparency_receipt: Transparency receipt issued by the transparency service.
public_key: Public key of the vetted entity.
vetting_process: Details of the vetting process, including the date and methodology.
vetting_outcome: Result of the vetting process.

# API Endpoints

The vetting service provides the following APIs:

## Register Public Key API

Endpoint: /api/register-public-key
Method: POST
Description: Registers the public key of the vetted party.
Request Body:

~~~~~~~~~~~~
{
  "entity_id": "unique-entity-id",
  "public_key": "MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEA..."
}
~~~~~~~~~~~~

Response:

~~~~~~~~~~~~
{
  "status": "success",
  "message": "Public key registered successfully."
}
~~~~~~~~~~~~

## Issue Vetting Token API

Endpoint: /api/issue-vetting-token
Method: POST
Description: Issues a vetting token (SD-JWT) containing KYC/KYB information and a transparency receipt.
Request Body:

{
  "entity_id": "unique-entity-id",
  "kyc_data": {
    "name": "Example VoIP Entity",
    "registration_number": "123456789",
    "address": "1234 Example St, Example City, EX 12345"
  }
}

Response:

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

## Verify Vetting Token API

Endpoint: /api/verify-vetting-token
Method: POST
Description: Verifies the validity of a vetting token (SD-JWT) and its associated transparency receipt.
Request Body:

{
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

Response:

{
  "status": "success",
  "message": "Vetting token and transparency receipt verified successfully."
}

# Proof of Possession Mechanism

The proof of possession mechanism ensures that the entity presenting the token is the legitimate holder of it. This involves:

The verifier issuing a unique challenge to the entity.
The entity signing the challenge with its private key.
The verifier verifying the signed challenge using the public key included in the vetting token.



# Security Considerations

TODO Security


# IANA Considerations

This document has no IANA actions.


--- back

# Acknowledgments
{:numbered="false"}

TODO acknowledge.

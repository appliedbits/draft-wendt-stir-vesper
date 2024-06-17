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
  I-D.ietf-oauth-selective-disclosure-jwt:

informative:


--- abstract

This document extends the STIR architecture by specifying the use of JSON Web Tokens (JWT) and Selective Disclosure JWT (SD-JWT) for representing persona related information intended to be the output of a Know Your Customer (KYC) or Know Your Business (KYB) type of vetting process. It defines entities called Vetting Agents (VA) that perform a vetting of persona related information and can issue a verifiable token bearing the VA signature, containing information that can be disclosed or selectively disclosed to an interested party. The Vetted Entity (VE) can hold this token in selectively disclosable forms to disclose specific information to the third parties. The vesper token enables the delivery and verification of information with privacy protecting mechanism in a complete, selective or zero knowledge manner specifically supported by the SD-JWT. This document also describes an API standard to be supported/hosted by a Vetting Agent (VA), which allow vetted parties to present tokens proving their KYC/KYB conformance, and incorporates proof of possession to ensure the legitimacy of the entity presenting the token.

--- middle

# Introduction

The Secure Telephone Identity (STI) architecture fundamentally defined by STI certificates in {{RFC8226}}, PASSporTs in {{RFC8225}}, and the SIP Identity header field {{RFC8224}} describe a set of constructs and protocols for the use of tokens and digital signatures to protect the integrity and provide non-repudiation of information as part of a communications session most notably the associated telephone numbers. This document extends that architecture to address the association of a telephone number to a persona (e.g. a person or business entity) given responsibility for the right to use that telephone number. Recently, the illegitimate use of telephone numbers by unauthorized parties and the associated fraudulent activity associated with those communications has generally eroded trust in communications systems. Further, basic reliance on the trust of the signer alone to at the time of the communications without has proven to require time and people consuming work to perform after-the-fact investigation and enforcement activities. Other industries, like the financial industry, have adopted well-known successful practices of Know Your Customer (KYC) or Know Your Business (KYB), otherwise referred to as the application of vetting practices of an entity. This document focuses on the representation of the vetting results and the information vetted for the responsible parties before any communications can be initiated. The confirmation and acknowledgement of the connection between a persona or business entity with a telephone number and the responsibilities associated with its use is a critical step towards building true trusted relationships between parties involved in a set of communications. This document describes the "vesper" token, a VErifiable Sti PERsona represented by a token signed by a party that can be used as an acknowledged and trusted as part of a communications ecosystem to represent the output of the KYC or vetting procedures likely corresponding to an agreed upon set of policies defined by a communications ecosystem. Additionally, the use of detailed vetting information required to verify a persona is information that likely requires strict privacy practices and policies to be enforced. The vesper token and architecture provides mechanisms for providing selective disclosure of any personally identifying information to be disclosed to those that are authorized by either the persona directly or, for example, based on enforcement actions required for legitimately authorized legal or regulatory activity.

In the current state of digital identities, the unique identifier used to identify the persona behind the identifier is obviously a critical part of using an identifier as part of a digital protocol, but just as important is the ability to associate a real-world persona to that identifier as the responsible party behind that identifier. The telephone number as an identifier and as part of a set of traditional communications services offered around the world has been facing a challenge of illegitimate fraud based on the lack of a formal framework for the explicit association of a set of communications to a directly responsible party. The use of "spoofing" of telephone numbers, a practice of the use of telephone numbers by not directly authorized parties, while having very legitimate use-cases, has been exploited by actors of fraudulent intent to either impersonate the legitimate party, or simply obfuscate the actual party behind the call. Fraud and illegitimate activity has proliferated based on the loose connection of telephone numbers to responsible parties.

The use of vesper tokens in communications will allow for a trust model enabled by a three party trust system based on an agreed set of vetting policies with a set of privacy enabled features to allow for selective disclosure for communications that require authorized use of a telephone number with the ability to support use-cases that require anonymity all the way up to full disclosure of vetted persona information if that is desired. The Vetting Agent (VA) issues the vesper token as the party taking responsibility to vet Vetting Parties according to a set of policies and best practices, the Vetting Entity (VE) holds the resulting token or ability to provide access to a fresh token for proof and disclosure that they were vetted by the VA, and Vetting Verifier (VV) verifies the token based on trust that the VA is reputable and follows policies and best practices. The Vesper token is primarily designed to be used in many ways to represent the vetting of the persona associated with a telephone number or as referred to more generally an STI. This document defines the specific use of the vesper token in the STI architecture.

# Conventions and Definitions

{::boilerplate bcp14-tagged}

# Overview

The vetting process for entities involves verifying their identity and legitimacy, typically through KYC and KYB vetting procedures. This document proposes a standardized method for representing the results of these vetting procedures using JSON Web Tokens (JWT) and Selective Disclosure JWT (SD-JWT). This document does not address how the KYC/KYB should be performed or what documents or processes should be used. Rather the goal of this document is to create a standardized identifier for the Vetted Entities (VE) to present that they are who they claim to be.

# Vetting Process Overview

The vetting process is much about registration and authentication of a Vetting Entity (VE) with a Vetting Authority (VA). The VE makes claims about themselves to prove whom they are and associated claims that should be vetted by the VA and will be used to make trusted disclosures to at Vetting Verifier (VV). The vesper token is issued with that set of selectively disclosable claims to formalize that the information has been vetted and represents the VE accurately.

# Vetting Process Procedures

The vetting process generally involves the following steps:

1. Registration of the Vetting Entity (VE) with a Vetting Authority (VA).  The VE creates an authenticated account relationship with the VA.
2. The entity generates a public/private key pair or the VA does it on the entries behalf.
3. The public key is registered with the VA.
4. The VE submits a set of information to describe itself with uniquely identifiable entity specific information.  This document describes a baseline set of information claims that SHOULD be included, but anticipates future specifications that correspond to future communications ecosystem policies and best practices that may extend that set of information including the syntax and definitions. The submittal of information to the VA is RECOMMENDED to follow the format and syntax of what will be defined later in the document as the token claim format for each set of information, but this document does not specifically define a protocol for the submission of information, only the token that represents the results of the process. 
5. The VA performs the vetting functions and KYC/KYB checks according to their procedures.  The vetting functions is believed to be something that can be performed in many ways in different countries and legal jurisdictions and therefore this document does not specify any specifics to how the VA performs these vetting functions and is out of scope of this document.
6. The VA creates hash of their vetting data and/or results. What exactly is included in generation of the hash is up to VA and influenced by the process used.
7. The VA logs the hash of the KYC/KYB data with a transparency service and issues a transparency receipt.
8. The VA provides the API service or the Vetted Entity (VE) hosts their own according the API definition in this document.
9. The VA or VE issues an SD-JWT containing the KYC/KYB information, the public key, and the transparency receipt.
10. Verifying party ensures that token signature is correct.
11. Verifier can verify the Transparency log signature to further trust the token.
12. Verifier can call proof of possession API and issue the challenge to ensure that the entity presenting the token is the legitimate holder of it.  (? this is to validate that the holder is indeed the holder based on issuer)

# Selective Disclosure JSON Web Tokens (SD-JWT) for Vetted information

This document defines the vesper token using the SD-JWT, defined in {{I-D.ietf-oauth-selective-disclosure-jwt}}. The vetting process and disclosure of information closely follows the SD-JWT Issuance and Presentation Flow, Disclosure and Verification, and generally the three-party model (i.e. Issuer, Holder, Verifier) defined in that document. 

In order to represent the vetted claim information about a VE. The SD-JWT MUST include the following claims:

iss: Issuer, the Vetting Authority (VA), a URI uniquely representing the issuer/VA
sub: Subject, the Vetting Entity (VE), a URI uniquely representing the subject/VE
iat: Issuance timestamp.
exp: Expiry timestamp.
vetting_claims_hash: Hash of the fully disclosed vetting claims.
transparency_receipt: Transparency receipt issued by the transparency service.
public_key: Public key of the vetted entity.  CW: should this be the cnf??
vetting_process: Details of the vetting process, including the date and methodology.
vetting_outcome: Result of the vetting process.

# API Endpoints

The vetting service provides the following APIs:

## Register Public Key API

Endpoint: /api/register-public-key
Method: POST
Description: Registers the public key of the vetted entity.
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

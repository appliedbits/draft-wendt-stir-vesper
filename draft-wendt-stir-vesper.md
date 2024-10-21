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
  I-D.ietf-oauth-selective-disclosure-jwt:
  I-D.ietf-sipcore-callinfo-spam:
  I-D.ietf-stir-passport-rcd:

informative:


--- abstract

This document extends the STIR architecture by defining a Personal Assertion Token (PASSporT) with a type of "vesper" (VErifiable Sti PERsona) and specifies the use of PASSporTs as a JSON Web Tokens (JWT) and Selective Disclosure JWT (SD-JWT) for representing verifiable claims related to a persona (a person or business entity) associated with a Secure Telephone Identity (STI). This set of extensible claims can include verifiable information such as the assignment of a telephone number, the output of a Know Your Customer (KYC) or Know Your Business (KYB) type of vetting process, Rich Call Data (RCD) or claims of consent provided to the telephone number holder. The architecture, dependencies, and process flow of Vesper includes logical roles that represent certain responsibilities for establishing a secure telephone identity. These roles represent the basis for trusted relationships to information that is being claimed and who is validating and taking responsibility for the accuracy of that information. These roles begin with a Subject Entity (SE) that is the end entity that intended to be represented by the STI telephone number identifier. A Vetting Claim Agent (VCA) establishes the Subject Entity as a vetted entity after performing the initial vetting and existence as a entity that fulfills the criteria and policies of the ecosystem to be associated with an STI. A Notary Agent (NA) is a neutral role that maintains a graph of relationships among all roles, claims, and identities, but importantly, for protecting privacy, doesn't hold any claim information other than the recording of claim events to the STI telephone number. The NA records these claim event transactions with a corresponding transparency log that generates verifiable receipts to "notarize" the recording of these relationships and claims being established. Privacy is enabled in this Notary role because the submitters have the option of submitting hashes of claims to protect information, or may usefully want to publicly declare their association to a claim to allow the public monitoring to avoid duplicate, mistaken or negligent claims which can be identified before illegitimate usage in the eco-system can occur. Other Claim Agents are defined producing claims in the form of SD-JWT + receipts from the NA. There are multiple claim agent types with corresponding extensible claim definitions with key value pairs that can be required or optionally included. These SD-JWT + receipt claim objects are then collected by the SE into a digital wallet that it can then use for selective disclosure presentation and incorporate into a "vesper" PASSporT signed by the a delegate certificate associated with STI telephone number to validate the SE is indeed the authorized holder of the telephone number and vesper token at the time the presentation is required and ties the SE to the STIR eco-system a STIR certificates policy for use in communications.

--- middle

# Introduction

The Secure Telephone Identity (STI) architecture fundamentally defined by STI certificates in {{RFC8226}}, PASSporTs in {{RFC8225}}, and the SIP Identity header field {{RFC8224}} describe a set of constructs and protocols for the use of tokens and digital signatures to protect the integrity and provide non-repudiation of information as part of a communications session most notably the associated telephone numbers. This document extends that architecture to address the association of a telephone number to a persona (e.g. a person or business entity) given responsibility for the right to use that telephone number. Recently, the illegitimate use of telephone numbers by unauthorized parties and the associated fraudulent activity associated with those communications has generally eroded trust in communications systems. Further, basic reliance on the trustworthiness of the signer alone at the time of the communications has proven to require people to perform time-consuming work in the form of after-the-fact investigation and enforcement activities, but to date has proven mostly ineffective because the true initiator of the communications is generally not directly associated to that communications. Other industries like the financial industry, have adopted well-known successful practices of Know Your Customer (KYC) or Know Your Business (KYB) that apply different vetting practices of an end entity. This document focuses on a set of roles and the protocol interactions between those roles that can properly establish mechanisms for trusted transactions, an explicit set of processes and verifiable actions that should be followed to establish the representation of claims about the persona that are vetted before any communications can be initiated. These claim information establishment transactions are recorded or notarized with authorized or responsible parties while also importantly enabling privacy controls around the disclosure of the persona information. Transparency logging of relationships and transaction events for claim information is also required to further establish trust with optional public disclosure to guarantee uniqueness when desired. The explicit connection between a persona with a telephone number and the responsibilities associated with its use is a critical step towards building the use of telephone numbers and ability to enforce usage policies that allow privacy but discourage taking advantage of those properties with the intent to impersonate for illegitimate reasons. Ultimately, the establishment of secure telephone identity with reasonable policies for establishing those identities will result in greater trusted relationships between parties involved in a set of communications.

# Conventions and Definitions

{::boilerplate bcp14-tagged}

# Overview

This document describes the establishment of a "vesper" (VErifiable Sti PERsona) PASSporT type with corresponding "vesper" claims which are signed claims using a three party trust model represented by SD-JWTs {{I-D.ietf-oauth-selective-disclosure-jwt}} and enabled with transparency logs and corresponding receipts that enable either a privacy protecting hash disclosure or a public disclosure that allows for verifiable trust to ensure that those entities that validate claim information are legitimate actors in the ecosystem. Additionally, the vesper token in conjunction with the claims architecture provides mechanisms that enable a persona to selectively disclose any personally identifying information to other parties, while at the same time making this information available in special limited cases, for example, based on enforcement actions, required for legitimately authorized legal or regulatory activity.

In the current state of digital identities, the unique identifier used to identify a persona is obviously a critical component of digital protocols that need to identify the persona. However, just as important, is the ability to verify the existence of a real-world persona to that identifier as the responsible party behind that identifier. The telephone number as an identifier and as part of a set of traditional communications services offered around the world has been facing a challenge of illegitimate fraud based on the lack of a formal framework for the explicit association of a set of communications to a directly responsible party. The use of "spoofing" of telephone numbers, a practice of the use of telephone numbers by not directly authorized parties, while having very legitimate use-cases, has been exploited by actors of fraudulent intent to either impersonate the legitimate party, or simply obfuscate the actual party behind the call. Fraud and illegitimate activity has proliferated based on the loose connection of telephone numbers to responsible parties.

The vetting process for entities involves verifying their identity and legitimacy, typically through KYC and KYB vetting procedures. This document proposes a standardized method for representing the results of these vetting procedures using Selective Disclosure JWT (SD-JWT). This document does not address how the KYC/KYB should be performed or policies around what documents or processes should be used. Rather the goal of this document is to create a standardized identifier for the Subject Entities (SE) to present that they are who they claim to be and associated verified claims.

# Vesper Architectural Overview

## Introduction to Vesper Tokens and Trust Model

The use of Vesper Tokens in communications will allow for a trust model enabled by a three-party trust system based on an agreed set of vetting policies with a set of privacy enabled features to allow for selective disclosure for communications. This trust framework requires establishment of policies for participation of end entities and those that vet and validate information about those end entities.  This information includes validated information about the entities themselves, the authorized right to use of a telephone number with the ability to support use-cases that validate all claims about the end entity or might only require anonymity and simply only validate the telephone number but the entity behind that telephone number exists and is real. The representation of roles that facilitate the trust of the association of a telephone number and other entity information is in the form of claims.  This document defines the role of those that validate and create claims against an entity are called Claim Agents that create specific claim types that have specified associated standard mandatory and optional key values.

### Key Features of Vesper Tokens

- Selective Disclosure: In order to protect privacy or in the mode of exposing only the required level of detail of information in a zero knowledge proof type of disclosure, entities can choose to convey a transaction specific presentation of information to different relying parties.
- Right to Use (RTU) of Telephone Numbers: Vesper tokens can ensure that only those entities that are assigned telephone numbers can use or delegate the use of those telephone numbers with the control of an explicit token.
- Flexible Use Cases: Vesper tokens can be used for KYC/KYB vetting, Rich Call Data (RCD), and consent claims.  New use-cases can be and are anticipated to be defined in the future.

## Roles and Responsibilities in the Vesper Ecosystem

The trust framework defines several roles that facilitate claims about telephone numbers and other entity information. The first two primary roles are defined as Claim Agents and Subject Entities (SE).  The Claim Agents are responsible for making either authoritative or validated claims about a Subject Entity (SE). The Claim Agent in turn collects these validated claims to present to other entities that they want to trust that information.

### Claim Agent Roles

The following are the claim agent roles defined in this document.

- Vetting Claim Agent (VCA): Handles KYC/KYB vetting and establishes the SE as an identifiable entity in the ecosystem.
- Right To Use Claim Agent (RTUCA): Handles the vetting of telephone numbers assigned to the SE.
- Rich Call Data Claim Agent (RCDCA): Provides vetting and validation of Rich Call Data claims for the SE.
- Consent Claim Agent (CCA): Handles consent claims for allowing SE's to call or message specific telephone numbers.

 Further details about these roles and the specific claims and key value attributes of the claims validated by the Claim Agents are defined later in the document. Future Claim Agent roles are anticipated to be defined by future documents.

### Claim Agent Responsibilities

Claim Agents validate and register claims about Subject Entities. Claim Agents are registered and uniquely identified in the Vesper Framework via the Notary Agent (NA). The NA maintains a common append-only Claim Graph for claim events each Claim Agent makes regarding Subject Entities and issues transparency receipts for the recording and notarizing each claim event. The details of this are described later in the document. Claim Agents ultimately issue SD-JWT tokens containing the validated claim key values to the Subject Entities (SE) vetted by the Claim Agent. The Claim Agent asserts the validated claims in a signed SD-JWT which, combined with a transparency receipt from the NA, are delivered to the SE which holds these SD-JWT tokens + receipts (vesper claims) in a Vesper Wallet (VW). The Vesper Wallet can then be used for specific selective disclosure of information presented to relying party.

## Notary Agent - Claim Graph and Transparency Log

In the Vesper ecosystem, Claim Agents issue claims about the Subject Entity. To ensure trust and accountability, all interactions between Claim Agents and Subject Entities are registered and notarized by the Notary Agent. The NE internally operates two key dependent services: the Claim Graph and the Transparency Log. Importantly, these notarizations can be privacy protected by storing hashes of the claim JSON objects or can be used for public transparency of the claim object contents so they can be monitored for mis-claims made by other non-authorized Subject Entities and handled through a resolution process that is eco-system specific. This resolution process is not in-scope for this document, but is likely coordinated via the Notary Agent through establishment of contacts and communications to the Claim Agents.

### Claim Graph

The Claim Graph is an append-only registry of the recording of claim validation events made by a Claim Agent responsible vetting the claims related to an SE. Each claim validation event issued by a Claim Agent is added to this graph as a node, with relationships represented as edges between entities.

Every time a new claim is added or updated in the Claim Graph, the service creates a graph snapshot hash of the graph, thereby uniquely representing a current snapshot of the graph. This hash serves as a unique cryptographic representation of the claim graph state at that moment in time. The hashed snapshot is then recorded in the Transparency Log, ensuring that the claims history is transparent, immutable, and auditable. By using cryptographic hashing, the Claim Graph remains secure, and any changes to the claims can be traced and verified.

### Transparency Log

The Transparency Log is part of the NA's services and plays a crucial role in ensuring that all claims made by Claim Agents are trustworthy. It allows claims to be verifiable across different agents using cryptographic methods. Once a claim is hashed by the Claim Graph, it is added to the log, making it accessible for verification.

Receipt Issuance:
After each claim is recorded, the NA issues a Receipt to submitting Claim Agent, ultimately sent to the SE to pair with the claim token. This receipt includes proof that the claim has been added to the Transparency Log. The SE can then present this receipt alongside claims in SD-JWT as proof that the claims have been transparently logged.

Interaction with Claim Agents:
Claim Agents do not directly modify the Claim Graph. Instead, they interact with NA via its APIs, which serve as a wrapper around both the Claim Graph and Transparency Log. This ensures that claims are properly registered, hashed, and logged without direct manipulation of the underlying data structures.

### Claim Agents and Claim Information Privacy

An important feature of this system is its ability to protect the privacy of the SE. Claim Agents are not required to store any private data in the Claim Graph. Instead, they store only the hash of the data, which acts as a representation of the claim without exposing sensitive information.

Public vs. Private Data:
If the SE has public data (e.g., a business name or logo that is inherently public or the SE has incentive to publicly declare that information with no privacy implications), it can be added to the Claim Graph for greater visibility, perhaps with more trust implied because of the public scrutiny over the uniqueness of that information. This public declaration allows other Claim Agents or other interested ecosystem actors to detect fraud or suspicious activity. However, private data should always remain hashed and protected unless specifically required for disclosure by the SE.

## Transport and Presentation - Vesper PASSporT

The SE can use claims stored in their Vesper Wallet to generate a Vesper PASSporT, which includes SD-JWTs and associated NA Transparency Receipts. This Vesper PASSporT is signed by a delegate certificate and attached to communications, such as in the case of STIR.

Vesper PASSporT Flow:
1. Using Vesper Wallet, SE determines through selective disclosure the presentation required for a particular set of communications (e.g. a call or message to particular destination verifier) which creates a 'vesper' PASSporT containing 'vesper' claims including corresponding SD-JWT + receipts of claims the SE desires to be presented.
2. Vesper PASSporT is signed by a delegate certificate associated with the telephone number the SE has the right to use, representing its legitimate participation in the STIR ecosystem set of communications delegated by the TNSP or RespOrg that assigned the telephone number resource.
3. The signed PASSporT is attached to a SIP identity header for verification by the destination party.

## Vesper PASSporT and Vesper Claim Verification and Proof of Authenticity

The Vesper framework generally allows the relying party and verification service to validate both the PASSporT specific communication association (i.e. the "orig", "dest", and "iat" PASSporT claims specific to that communications) as well as the claims and the identity of who issued each of the 'vesper' claims with the appropriate amount of disclosure or presentation required for the verifier.  This framework ties both trust of the claims to those Claim Agents that validate claims. Via STIR and the use of STIR certificates and PASSporTs the Vesper PASSporT ties the valid use of a STIR certificates within an eco-system governed by STIR certificate policies to a certificate with a TNAuthList containing the relevant telephone number associated with the STI and use of certificate delegation to the end entity associated with that telephone number.

### AS Verification

As the Vesper PASSporT is constructed and signed for a specific destination party, the AS will be provided with a set of 'vesper' claims which MAY be verified by the AS. This is optionally supported by Authentication Services that want to validate the Vesper Token for its verifiability or perhaps its conformance to policies. More generally, whether the AS chooses to verify the vesper claims, any issues with the verifiability of the Vesper PASSporT should be discovered by the relying party doing verification.

Signature Verification:
The AS ensures that the Vesper Token's signature is valid based on the public key provided.

Action on Failure:
If the Vesper Presentation (the wrapped SD-JWTs and Receipts) is invalid, the AS will stop processing the request, ensuring that the call will not proceed and MAY notify caller of the validation failure via STIR error codes (i.e. 4xx) defined in {{RFC8224}}.

The Vesper Token contains SD-JWTs (with claims) and associated NA Receipts, and its signature is signed by a delegate certificate delegated by the authorized entity in the STIR ecosystem.

NOTE: The relationship between Vesper Wallet that creates Vesper Token and the AS in practice will be likely a trusted relationship and therefore AS may chose to trust the Vesper Token without further verification.

### VS Verification

Once the Vesper Token reaches the Verification Service (VS), the token undergoes further checks to confirm its authenticity and integrity.

Payload Verification:
The first step for VS is to verify the Vesper Token's signature. This ensures that the token has not been tampered with during transit. Any modification to the payload will invalidate the signature, and the VS will fail the verification and MAY fail the communication.

SD-JWT Claim Verification:
After validating the Vesper Token, the VS looks up each of the SD-JWTs associated with the claim types included in the Vesper Token. Each SD-JWT contains claims made by the Claim Agents and the signature of the SD-JWT must be verified individually by the VS, using the Public Key Verification described below. If the Vesper Presentation (the wrapped SD-JWTs and Receipts) are invalid, the VS will stop processing the request, ensuring that the call will not proceed and MUST notify the caller via STIR error codes (i.e. 4xx) defined in {{RFC8224}}.

Public Key Verification:
The VS uses the public key provided as a JSON Web Key (JWK) to verify the signatures of the SD-JWTs. Each SD-JWT's signature ensures that the claim data has not been altered and that the entity issuing the claim is legitimate.

### Verification and Relying Party Actions

Once the VS of the relying party completes verification procedures, it can reliably depend on the fact that the vesper presentation of the token or PASSporT has been signed with non-repudation by the subject entity and that the subject entity has used the services of the claim agents that have issued and signed each of the 'vesper' claims contained in the parent Vesper token.  In addition, with the NA transparency receipts the relying party can also trust that a claim was made by authorized participants in the eco-system.  The public declaration of claim information can also be verified for cases where that may be an important criteria for the trustability of that information (e.g. the corporate logo or name of a business entity).

Traceability:
The successful validation of the Vesper Token and its claims allows the VS to trust that the caller is who they claim to be. Because the identity of the responsible claim agents that validated the information about the SE, and the identity of SE itself are transparent, if there is any question about the validity of information comes into question, the relying party or other ecosystem or law enforcement entity has a direct path for investigating and questioning the claim agents and the subject entity themselves. This direct accountability and clear lines of responsibility is a critical part of maintaining the trust in the ecosystem which the Vesper framework is very much intended to represent. A robust set of policies about the characteristics and definitions of the content of the claims is beyond the scope of this document, but should also be part of a specific governance or jurisdictional implementation of the Vesper framework.

# Terminology

Claim Agent: An entity that is either authorized by or trusted within the eco-system to make claims of persona-related information and to issue verifiable selectively disclosable tokens containing the vetted claim information. A Claim Agent can be a trusted third party or a service provider that performs the vetting of persona-related information. Claim Agent is a role category where there are a defined a set of specific claim agent types with associated claim attribute key values that are either required or optional by specification.

Vetting Claim Agent (VCA): The Claim Agent entity that initiates and establishes a Subject Entity into the eco-system. Its role is to vet a set of claims that identify the persona as an entity in the real world; claims that identify physical address, business identifiers, contact information and other real-world identifying information. Generally, this information is not disclosed as part of a typical communications transaction, although nothing prevents it from being disclosed if the SE so wishes. However, it's an important set of information to establish the existence and legal standing of a persona. This information is also relevant to a potential legal or policy enforcement action that may be required based on alleged legal or policy violations (which is something the VCA would be a responsible party to facilitate).

Right to Use Claim Agent (RTUCA): The Claim Agent entity that generally represents an authorized provider of telephone numbers for direct assignment to an SE.

Rich Call Data Claim Agent (RCDCA): The Claim Agent entity that is responsible for vetting the Rich Call Data claims and validating they represent the Subject Entity and conform to any relevant content policies for any relying eco-systems a Vesper PASSporT token may be used.

Consent Claim Agent (CCA): The Claim Agent entity that is responsible for handling and vetting consent claims associated with different called party destination numbers for calls initiated by the calling party's originating telephone number. These could include consent to call/message for specific telephone numbers or consent to calls of various types of callers as defined in {{I-D.ietf-sipcore-callinfo-spam}}, or consent to call with robocalling, AI-enabled, or chatbot types of automated calling or messaging.

Subject Entity (SE): An entity that is vetted by a Claims Agent and holds the verifiable token containing the vetted information. The Claims Agent can be a person or a business entity.

Notary Agent (NA): The entity that maintains the Claim Graph and Transparency Log. The Notary Agent is responsible for ensuring the integrity and transparency of the claims made by the Claim Agents. The Notary Agent issues receipts for each claim event, which are used to verify the authenticity of the claims. The Notary Agent role is likely performed by a neutral party in the ecosystem.

Vesper PASSporT or Token: A verifiable token that follows the definition of PASSporT in {{RFC8225}} created by a Subject Entity containing the presentation of disclosable claims for a specific relying party destination. The Vesper Token is represented as a JSON Web Token (JWT) PASSporT that contains "vesper" claims that are Selective Disclosure JWT (SD-JWT) + transparency receipts generated by the Notary Agent.

# Vesper Achitecture

The Vesper architecture is designed around the concept of creating a secure Persona for each Subject Entity (SE) within an eco-system. This Persona is characterized by its verifiability, privacy-preserving nature, tamper resistance, and auditability. It enables SEs to interact with other entities confidently, knowing that their claims and credentials are cryptographically secured and independently verifiable. The architecture ensures that sensitive information is protected while still allowing for seamless, trust-based exchanges between parties.

The Vesper architecture employs the following key entities to manage and maintain these secure Personas:

Subject Entities (SEs): The organizations whose claims are being issued and verified within the system.
Claim Agents: Entities that facilitate the exchange of claims between SEs and verify the validity of these claims.
Notary Agent (NA): A central authority that ensures the integrity, transparency, and auditability of interactions by maintaining a verifiable log of claims and transactions, ensuring tamper-proof records.

## High Level Flow

The Vesper framework follows a high-level flow that involves the provisioning of the Subject Entity and the subsequent management of claims through different Claim Agents. This section outlines the primary interactions between the SE, the Vetting Claim Agent (VCA), the Right To Use Claim Agent (RTUCA), and potentially other Claim Agent services. The flow ends with the SE generating a Vesper PASSporT presentation in order to, for example, use with a STIR Authentication Service while making a phone call. This Vesper PASSporT presentation will include the relevant claims and selected disclosures intended for that call for verification by the Verification Service.

This overview provides the context for more detailed explanations in subsequent sections.

High-Level Flow:

1. VCA Provisions SE:
   - The SE as a business or person entity is first vetted by the VCA, which performs KYC types of checks.
   - Once the SE is validated, the event is captured in the Notary Agent (NA) via the Claim Graph (CG) and Transparency Service (TS).
   - The SE receives an SD-JWT containing the KYC claims and a Transparency Receipt, which are stored in the Vesper Wallet (VW).
2. SE Contacts RTUCA corresponding to their Telephone Number Assignment:
   - The SE interacts with the Right To Use Claim Agent (RTUCA) to obtain telephone numbers.
   - The RTUCA claims and validates one or more TNs and records the event in the NA, returning an SD-JWT with the assigned TNs and a corresponding Transparency Receipt.
   - The SE stores this data in the VW.
3. SE Contacts RCD Claim Agent for Rich Call Data:
   - The SE contacts the Rich Call Data Claim Agent to enrich the telephone call data.
   - The RCD Claim Agent verifies the SE's claims and adds Rich Call Data to the CG.
   - An SD-JWT containing the new claims and a Transparency Receipt is returned to the SE, which is stored in the VW.
4. SE Makes a Phone Call:
   - When the SE makes a phone call, the Vesper Wallet builds a Vesper PASSporT by encapsulating the relevant claims (e.g., KYC, TN assignment, and RCD) into a JWT.
   - The Authentication Service (AS) includes the Vesper PASSporT in the SIP header of the call.
5. Verification Service (VS) Verifies Vesper PASSporT:
   - The VS receives the Vesper PASSporT and verifies the token and included SD-JWTs.
   - Based on the validated claims, the VS makes decisions regarding the call's authenticity and proceeds accordingly.

~~~~~~~~~~~
+--------------+                    +----------+       +-----------+
|   Subject    |                    | Vetting  |       | Notary    |
|   Entity     |                    |  Claim   |       |  Agent    |
|              |                    |  Agent   |       |           |
+--------------+                    +----------+       +-----------+
      |                                  |                   |
      |<-------- SE creates account -----|                   |
      |                                  |                   |
      |----- Provides KYC values ------->|                   |
      |                                  |                   |
      |<----- KYC Validation complete ---|                   |
      |                                  |- Claim Notary --->|
      |                                  |<- Notary Receipt -|
      |<-- Receives KYC SD-JWT+Receipt --|                   |
      |                                  |                   |
+--------------+                    +----------+       +-----------+
| Vesper Wallet|                    | Claim    |       | Notary    |
|    (VW)      |                    |  Agents  |       |  Agent    |
+--------------+                    +----------+       +-----------+
      |                                  |                   |
      |-- Requests TN from RTUCA ------->|                   |
      |                                  |                   |
      |<--- Receives TN SD-JWT+Receipt --|                   |
      |                                  |                   |
      |-- Requests RCD Claims ---------->|- Claim Notary --->|
      |                                  |<- Notary Receipt -|
      |<-- Receives RCD SD-JWT+Receipt --|                   |
      |                                  |                   |
+--------------+                    +----------+
|  Phone Call  |                    | Verifier |
| (Vesper PASS)|                    | Service  |
+--------------+                    +----------+
      |                                  |
      |- Vesper PASSporT in SIP Header ->|
      |                                  |
      |<----------- Verified ------------|
~~~~~~~~~~~

## Notary Agent Flows

The Notary Agent (NA) is responsible for maintaining the integrity and transparency of Subject Entity (SE) claims through the Claim Graph (CG) and Transparency Log. This section provides an in-depth look at how the NA processes claims, records changes to the Claim Graph, and ensures verifiable, immutable records in the Transparency Log. It also explores how Claim Agents interact with the NA, and how trust is established across the Vesper framework.

### Claim Graph

The CG is a dynamic structure that represents the identity of an SE and tracks all claims related to that identity. Each SE is represented as a node (or IdentityRoot), and additional claims are linked to this root through edges. These claims can represent actions such as KYC validation, telephone number assignments, and rich call data.

Note: While the Claim Graph is conceptually a graph, its internal representation can be stored simply as, for example, JSON objects in a document database or tables in SQL database for performance optimization.

### Merkle Tree and Transparency Log

The Transparency Log is implemented as a Merkle Tree to provide an immutable and cryptographically secure log of claim changes. Each change to the SE's identity or associated claims results in a new "leaf" being added to the Merkle Tree. This tree structure enables the creation of Notary Receipts, which are verifiable cryptographic proofs that a particular claim was recorded at a specific time.

### Vetting Claim Agent (VCA) Provisions New Subject Entity

The process begins when the Vetting Claim Agent provisions a new SE. The VCA performs KYC checks on the SE and records the SE's identity in the Claim Graph. The NA creates a new IdentityRoot node for the SE, representing their entity in the system.

Claim Graph Structure (Entity Creation):

~~~~~~~~~~~~~~~
[entity_id]   --->    {
                        node_type: IdentityRoot,
                        entity_id: 12345,
                        attributes: { ... }
                      }

Transparency Log:
__________________
Tree:        h(d0)
             /
           d0 (Initial creation event)
~~~~~~~~~~~~~~~~

At this point, the SE is issued an SD-JWT containing their KYC claims and a Notary Receipt, which they store in their Vesper Wallet (VW).

### Vetting Claim Agent Adds KYC Claims

After creating the SE, the VCA adds the KYC claims to the Claim Graph, linking them to the IdentityRoot node. These KYC claims are hashed for privacy.

Claim Graph Structure (Adding KYC Claims):

~~~~~~~~~~~~~~~~~
[entity_id] --- has_kyc ---> [hashed KYC data]

Internal Representation:
{
  node_type: IdentityRoot,
  entity_id: 12345,
  attributes: { ... },
  has_kyc: { hashed_data }
}

Transparency Log:
__________________
Tree:
       h01
      /   \
    h0    h1

Leaves:
   d0    d1 (KYC claims added)
~~~~~~~~~~~~~~~~~

The KYC claims are stored in the Transparency Log, and the SE receives an updated KYC SD-JWT with the KYC claims, along with a Notary Receipt that proves the claims have been recorded immutably. This SD-JWT is stored in the Vesper Wallet, and is presented as proof of identity and KYC verification in subsequent interactions with Claim Agents. The x-vesper-kyc header is used to present this SD-JWT to future Claim Agents.

### RTU Claim Agent Adds Telephone Number (TN) Assignment

The SE contacts the Right To Use Claim Agent (RTUCA) to request the assignment of one or more telephone numbers (TNs). The RTUCA verifies the SE's identity using the KYC SD-JWT in the x-vesper-kyc header to retrieve the SE's entity_id. After SD-JWT validation, the RTUCA verifies the SE's right to use the telephone number, assigns the telephone number to the SE and updates the Claim Graph.

Claim Graph Structure (Adding TN Assignment):

~~~~~~~~~~~
[TN] <- assigned_tn -- [entity_id] -- has_kyc -> [hashed KYC data]

Internal Representation:
{
  node_type: IdentityRoot,
  entity_id: 12345,
  attributes: { ... },
  has_kyc: { hashed_data },
  assigned_tn: { telephone_number }
}

Transparency Log:
_________________
Tree:
       h02
      /   \
    h01   h2
   /   \
 h0    h1

Leaves:
   d0    d1    d2 (TN assignment added)
~~~~~~~~~~~

The TN assignment event is logged in the Transparency Log, and the SE receives an SD-JWT containing the telephone number Right to Use claims and a new Notary Receipt. This SD-JWT is also stored in the SE's Vesper Wallet for future use.

### Claim Agent Adds Rich Call Data (RCD)

Next, the SE contacts the Rich Call Data (RCD) Claim Agent to enrich the SE's telephone call data. The RCD Claim Agent verifies the SE's identity using the KYC SD-JWT and adds the RCD claims to the Claim Graph.

Claim Graph Structure (Adding RCD Data):

~~~~~~~~~~~
[TN] <- assigned_tn -- [entity_id] -- has_kyc -> [hashed KYC data]
                            |
                         has_rcd
                            |
                          [RCD]

Internal Representation:
{
  node_type: IdentityRoot,
  entity_id: 12345,
  attributes: { ... },
  has_kyc: { hashed_data },
  assigned_tn: { telephone_number },
  has_rcd: { rich_call_data }
}

Transparency Log:
_________________
Tree:
          hroot
         /    \
      h01     h23
     /   \   /   \
   h0    h1 h2   h3

Leaves:
   d0    d1   d2   d3 (RCD data added)
~~~~~~~~~~~

Once again, this event is recorded in the Transparency Log, and the SE receives an updated SD-JWT with the RCD claims and a Notary Receipt. The SE stores this SD-JWT in their Vesper Wallet for future verification.

### Using SD-JWT for Trust

Each step in the claim process relies on the SD-JWT issued by the Issuing Agent and passed via the x-vesper-kyc header. Claim Agents can trust the SE based on the following process:

1. The SE presents the KYC SD-JWT and receipt to the Claim Agent in the API request.
2. The Claim Agent verifies the SD-JWT signature and checks the Transparency Receipt to confirm that the KYC event was logged and notarized by the NA.
3. Once verified, the Claim Agent can trust the SE's identity and entity_id, allowing further claims (such as TN assignment or RCD claims) to be added securely.

## Notary Agent API

The Notary Agent (NA) exposes a set of APIs that allow Claim Agents and other authorized participants in the Vesper ecosystem to interact with the Claim Graph (CG) and the Transparency Log. These APIs are designed to provide secure, auditable interactions for creating entities, adding claims, and verifying Notary Receipts. This section outlines the key APIs available for interacting with the NA and provides an overview of their functionality.

### Create Subject Entity (SE) API

This API is used by a Claim Agent, generally always a Vetting Claim Agent (VCA), to provision a new Subject Entity (SE) in the system. The SE is created in the Claim Graph, and a record is added to the Transparency Log.

Endpoint:
POST /na/entity/create

Request:

~~~~~~~~~~~
{
  "entity_data": {
    "entity_name": "Company A",
    "address": "123 Main St",
    "contact_email": "info@companya.com",
    "contact_phone": "+1234567890"
  },
  "claim_agent": {
    "id": "vca-001",
    "public_key": "public-key-vca-001"
  }
}
~~~~~~~~~~~

Response:

~~~~~~~~~~~
{
  "entity_id": "12345",
  "notary_receipt": "NotaryReceipt1234",
  "sd_jwt": "eyJhbGciOi..."
}
~~~~~~~~~~~

entity_data: Information about the SE being created.<br>
claim_agent: The VCA creating the SE, including its ID and public key.<br>
entity_id: The unique identifier assigned to the SE.<br>
notary_receipt: A cryptographic proof that the entity creation was logged in the Transparency Log.<br>
sd_jwt: The SD-JWT containing the KYC claims and the entity_id for the SE.<br>

### Add KYC Claims API

Once an SE has been created, the Vetting Claim Agent uses this API to add KYC claims to the Claim Graph. This API also records the event in the Transparency Log and issues a new Notary Receipt.

Endpoint:
POST /na/entity/{entity_id}/kyc

Request:

~~~~~~~~~~~
{
  "entity_id": "12345",
  "kyc_data": {
    "full_name": "John Doe",
    "document_id": "ID123456789",
    "issue_date": "2023-01-15"
  },
  "issuing_agent": {
    "id": "vca-001",
    "signature": "signature-of-kyc-data"
  }
}
~~~~~~~~~~~

Response:

~~~~~~~~~~~
{
  "notary_receipt": "NotaryReceipt5678",
  "sd_jwt": "eyJhbGciOi..."
}
~~~~~~~~~~~

kyc_data: The KYC claims (hashed for privacy) being added to the SE's Claim Graph.<br>
claim_agent: Information about the VCA making the request, including a signature over the data.<br>
notary_receipt: The Notary Receipt showing that the KYC claims were recorded.<br>
sd_jwt: An SD-JWT containing the KYC claims and the entity_id.<br>

### Add Telephone Number (TN) Assignment API

The Right To Use Claim Agent (RTUCA) uses this API to assign one or more telephone numbers to an SE. The event is logged in the Transparency Log, and an updated SD-JWT is issued to the SE.

Endpoint:
POST /na/entity/{entity_id}/tn/assign

Request:

~~~~~~~~~~~~~~~~
{
  "entity_id": "12345",
  "tn_data": {
    "telephone_numbers": ["+1234567890", "+9876543210"]
  },
  "claim_agent": {
    "id": "rtuca-001",
    "public_key": "public-key-ca-001",
    "signature": "signature-of-tn-data"
  }
}
~~~~~~~~~~~~~~~~~

Response:

~~~~~~~~~~~
{
  "notary_receipt": "NotaryReceipt7890",
  "sd_jwt": "eyJhbGciOi..."
}
~~~~~~~~~~~

tn_data: The telephone numbers being assigned to the SE.<br>
claim_agent: Information about the RTUCA making the request.<br>
notary_receipt: Proof that the TN assignment was recorded in the Transparency Log.<br>
sd_jwt: An updated SD-JWT containing the assigned TN claims and the entity_id.<br>

### Add Rich Call Data (RCD) Claims API

The Rich Call Data (RCD) Claim Agent uses this API to add RCD claims to the SE's Claim Graph. The RCD data is linked to the SE's telephone numbers, and the event is logged in the Transparency Log.

Endpoint:
POST /na/entity/{entity_id}/rcd

Request:

~~~~~~~~~~~
{
  "entity_id": "12345",
  "rcd_data": {
    "call_reason": "Business Inquiry",
    "rcd": {
      "caller_name": "Company A",
      "caller_location": "123 Main St"
    }
  },
  "claim_agent": {
    "id": "rcdca-001",
    "public_key": "public-key-ca-002",
    "signature": "signature-of-rcd-data"
  }
}
~~~~~~~~~~~

Response:

~~~~~~~~~~~
{
  "notary_receipt": "NotaryReceipt8901",
  "sd_jwt": "eyJhbGciOi..."
}
~~~~~~~~~~~

rcd_data: The RCD claims being added to the SE's identity.<br>
claim_agent: Information about the RCD Claim Agent making the request.<br>
notary_receipt: The updated Notary Receipt showing that the RCD claims were recorded.<br>
sd_jwt: An updated SD-JWT containing the RCD claims and the entity_id.<br>

### Verify Notary Receipt API

Any verifier can use this API to check the validity of a Notary Receipt. This allows third parties (such as Verification Services) to confirm that a claim was logged in the Transparency Log.

Endpoint:
POST /na/verify/receipt

Request:

~~~~~~~~~~~
{
  "receipt": "NotaryReceipt1234"
}
~~~~~~~~~~~

Response:

~~~~~~~~~~~
{
  "status": "verified",
  "log_entry": {
    "entity_id": "12345",
    "timestamp": "2024-09-09T12:00:00Z",
    "claims": {
      "kyc": "verified",
      "tn": "verified",
      "rcd": "verified"
    }
  }
}
~~~~~~~~~~~

receipt: The Notary Receipt being verified.<br>
status: Whether the receipt is valid and recorded in the Transparency Log.<br>
log_entry: Details about the entity_id, timestamp, and verified claims.<br>

### Retrieve Entity History API

This API allows authorized participants to retrieve the entire history of an SE from the Transparency Log, including all claims added over time.

Endpoint:
GET /na/entity/{entity_id}/history

Response:

~~~~~~~~~~~
{
  "entity_id": "12345",
  "history": [
    {
      "timestamp": "2024-09-09T12:00:00Z",
      "event": "Entity Created",
      "notary_receipt": "NotaryReceipt1234"
    },
    {
      "timestamp": "2024-09-10T10:00:00Z",
      "event": "KYC Claims Added",
      "notary_receipt": "NotaryReceipt5678"
    },
    {
      "timestamp": "2024-09-11T11:00:00Z",
      "event": "TN Assignment Added",
      "notary_receipt": "NotaryReceipt7890"
    }
  ]
}
~~~~~~~~~~~

entity_id: The ID of the SE whose history is being retrieved.<br>
history: A list of all events associated with the SE, including timestamps and Notary Receipts.<br>

## Vesper Wallet Flows

The Vesper Wallet manages claims, cryptographic keys, and the construction of Vesper PASSporTs. It securely stores all claims (in the form of SD-JWTs) along with the corresponding Notary Receipts, which prove that the claims have been notarized by the Notary Agent (NA). Additionally, the Vesper Wallet handles the generation and management of key pairs used for signing PASSporTs and requesting delegate certificates.

### Vesper Wallet Key Pair Generation

The Vesper Wallet creates and manages a public/private key pair. This key pair is used for two purposes:

- Requesting Delegate Certificate: The public key is sent to a Certificate Authority (CA) to obtain a Delegate Certificate, which authorizes the SE to use specific telephone numbers (TNs).
- Signing Vesper PASSporTs: The private key is used to sign Vesper PASSporTs, which are cryptographically bound to the SE's claims.

Key Pair Generation Flow:

~~~~~~~~~~~
+-------------------+                 +-----------------+
|  Vesper Wallet    |                 | Certificate     |
|   (VW)            |                 |    Authority    |
+-------------------+                 +-----------------+
      |                                        |
      |<-- Create public/private key pair      |
      |                                        |
      |---> Request Delegate Certificate  ---->|
      |        (Includes public key)           |
      |                                        |
      |<---- Delegate Certificate issued ------|
      |                                        |
~~~~~~~~~~~

### Storage of SD-JWTs and Notary Receipts

The Vesper Wallet stores SD-JWTs for each claim type, along with the corresponding Notary Receipts. These SD-JWTs represent claims such as KYC, telephone number assignment, and rich call data (RCD). The Notary Receipts are proof that each claim has been logged in the Transparency Log by the NA.

SD-JWT Storage Structure:

~~~~~~~~~~~
+------------------+       +-----------------+
|   Vesper Wallet  |       |  Claims Storage |
+------------------+       +-----------------+
      |                             |
      |--> Stores SD-JWTs --------->|
      |      + Notary Receipts      |
      |                             |
      +-----------------------------+
~~~~~~~~~~~

Each claim stored in the Vesper Wallet contains:

- SD-JWT: The selective disclosure JWT containing the claim.
- Notary Receipt: Proof from the Transparency Log that the claim was notarized.

### Building the Vesper Token

When the SE needs to present claims (e.g., during a phone call), the Vesper Wallet constructs a Vesper Token, which serves as a presentation of the claims to the Verification Service (VS). The Vesper Token contains:

1. Claim Type: Identifies the type of claim (e.g., KYC, TN, RCD, CC).
2. SD-JWT: The SD-JWT for the claim, containing selectively disclosable claims.
3. Notary Receipt: The Notary Receipt that verifies the claim was recorded in the Transparency Log.

Vesper Token Structure:

~~~~~~~~~~~
{
  ...
  "claims": [
    {
      "type": "kyc",
      "sd_jwt": "eyJhbGciOi...",
      "receipt": "NotaryReceipt1234"
    },
    {
      "type": "tn",
      "sd_jwt": "eyJhbGci...",
      "receipt": "NotaryReceipt5678"
    },
    {
      "type": "rcd",
      "sd_jwt: "eyJhbGci...",
      "receipt": "NotaryReceipt8901"
    }
  ]
  ...
}
~~~~~~~~~~~

The "kyc" and "tn" claim types are mandatory, while the "rcd" and "cc" claim types are optional.

Once the Vesper Token is built, it is included in a Vesper PASSporT. The Vesper PASSporT is a specialized form of PASSporT that encapsulates multiple Vesper Tokens and is signed by the SE's private key (the same private key associated with the Delegate Certificate).

### Signing the Vesper PASSporT

The Vesper PASSporT is signed using the SE's private key, which is associated with the Delegate Certificate. This signature binds the claims and their associated receipts to the SE and ensures that the Vesper PASSporT can be trusted by the Verification Service (VS).

Signing the Vesper PASSporT:

~~~~~~~~~~~
+-------------------+       +----------------------+
|  Vesper Wallet    |       | Delegate Certificate |
+-------------------+       +----------------------+
      |                                |
      |<-- Uses private key to sign  --|
      |   Vesper PASSporT              |
      |                                |
~~~~~~~~~~~

The signed Vesper PASSporT is then sent to the Authentication Service (AS), which includes it in the SIP header during a call.

### Passing the Vesper PASSporT to the Authentication Service (AS)

Once the Vesper PASSporT is signed, it is passed to the Authentication Service (AS). The AS inserts the Vesper PASSporT into the SIP header, which is transmitted as part of the phone call. This allows the Verification Service (VS) to receive the Vesper PASSporT for validation.

Sending Vesper PASSporT:

~~~~~~~~~~~
+-------------------+       +----------------------+
|  Vesper Wallet    |       | Authentication       |
|   (VW)            |       |     Service (AS)     |
+-------------------+       +----------------------+
      |                                 |
      |-- Pass Vesper PASSporT -------->|
      |      to AS                      |
      |                                 |
~~~~~~~~~~~

### Verification of Vesper PASSporT by VS

When the Verification Service (VS) receives the Vesper PASSporT, it performs several verification steps to ensure the validity of the claims:

1. Signature Verification: The VS checks the signature on the Vesper PASSporT using the public key from the Delegate Certificate to confirm that the SE legitimately signed the token.
2. SD-JWT Verification: The VS goes through the SD-JWTs inside the Vesper PASSporT and verifies their individual signatures. Each SD-JWT contains a JWK (JSON Web Key) representing the public key used to sign the claim.

JWK Claim Example:

~~~~~~~~~~~
{
  "alg": "RS256",
  "typ": "JWT",
  "jwk": {
    "kty": "RSA",
    "kid": "key-id",
    "n": "...",
    "e": "..."
  }
}
~~~~~~~~~~~

3. Receipt Validation: For each SD-JWT, presence of Notary Receipt should be sufficient to accept the claims.  However, VS may optionally choose to verify the Notary Receipts against the Transparency Log to ensure that the claims were notarized by the NA.  This step would be done out of the call path in different process or service.  If the receipt is not valid, the VS will put the Vesper PASSporT claims on the black list for the future calls.

Verification Process:

~~~~~~~~~~~
+-------------------+        +---------------------+
| Verification      |        |  Transparency Log   |
|  Service (VS)     |        |                     |
+-------------------+        +---------------------+
      |                                 |
      |----> Verifies Vesper PASSporT   |
      |     signature (Delegate Cert)   |
      |                                 |
      |--> Verifies SD-JWTs signatures  |
      |                                 |
      |--- Validates Notary Receipts -->|
      |                                 |
~~~~~~~~~~~

Once the Vesper PASSporT and its claims are verified, the VS can make decisions based on the presented claims, such as authenticating the call and allowing it to proceed.

# The "vesper" PASSporT

A Vesper PASSporT introduces a mechanism for the verification of provable claims based on third party validation and vetting of authorized or provable information that the verifier can have greater trust because through the vesper PASSporT and associated claims there is a signed explicit relationship with two important concepts in the vesper framework:

* the Claim Agent that is known to be a valid participant in the vesper framework and has a type association with the claims being made
* the transparency receipt created by the Notary Agent representing the time and claim assertion event recorded

The Vesper PASSporT is a PASSporT as defined in {{RFC8225}} which is a JSON Web Token {{RFC7519}} and upon creation should include the standard PASSporT claims including the "orig" and "dest" and "iat" claims required for replay attack protection. It MUST include a PASSporT type, "ppt", with the value of the string "vesper" in the protected header of the PASSporT.
A Vesper PASSporT, as can any PASSporT, can contain any claims that a relying party verification service might understand, but the intention of the Vesper framework is that a Vesper PASSporT contain one or more "vesper" claim objects, defined in the "Vesper Claims" section.

## Compact Form and Other Representations of Vesper Information

The use of the compact form of PASSporT is not specified for a "vesper" PASSporT primarily because generally or specifically when using the {{RFC8224}} defined identity header field as the transport of a "vesper" PASSporT there MUST NOT be any corresponding vesper information or claims provided that are unprotected or not signed to validate it's issuer in SIP {{RFC3261}} or SIP header fields, nor should there be due to the trusted intent of "vesper" claims or "vesper" PASSporTs. "Vesper" claims and PASSporTs are intended to only be used with the identity header field defined in {{RFC8224}}. Other uses may be considered but MUST consider the use of digital signatures to tie responsible parties and issuers to vesper related information.

# Vesper Claims

A Vesper Claim is defined as a JWT claim {{RFC7519}} JSON object with a claim key that is the string "vesper" and with a claim value that is a JSON object containing the following key values:

* a "type" key with the claim value as the string that defines the claim agent type defined in the "Claim Agent" section of this document or future claim agent types defined and registered in claim agent IANA registry
* a "claim-token" key with a claim value of the SD-JWT {{I-D.ietf-oauth-selective-disclosure-jwt}} which represents the actual signed claims from the Claim Agent and defined in the section "Vesper Claim SD-JWT"
* a "receipt" key with the claim value of the Signed Vesper Timestamp the Claim Agent received from the Notary Agent defined in the "Signed Vesper Timestamp" section of the document.


## Vesper Claim SD-JWT (Selective Disclosure JSON Web Tokens)

This section defines the vesper "claims" object "claim-token" key as a SD-JWT, defined in {{I-D.ietf-oauth-selective-disclosure-jwt}}. The claim and issuance process and disclosure of information closely follows the SD-JWT Issuance and Presentation Flow, Disclosure and Verification, and more generally the three-party model (i.e. Issuer, Holder, Verifier) defined in SD-JWT.  The Issuer in the context of the vesper token is the Claim Agent, the Holder corresponds to the Subject Entity, and the Verifier is the receiver of the Vesper Claim, which in the context of this document would be contained in a Vesper Claim object that is signed inside of a Vesper PASSporT.

## SD-JWT and Disclosures

SD-JWT is a digitally signed JSON document containing digests over the selectively disclosable claims with the Disclosures outside the document. Disclosures can be omitted without breaking the signature, and modifying them can be detected. Selectively disclosable claims can be individual object properties (name-value pairs) or array elements. When presenting an SD-JWT to a Verifier, the Holder only includes the Disclosures for the claims that it wants to reveal to that Verifier. An SD-JWT can also contain clear-text claims that are always disclosed to the Verifier.

To disclose to a Verifier a subset of the SD-JWT claim values, a Holder sends only the Disclosures of those selectively released claims to the Verifier as part of the SD-JWT. The use of Key Binding is an optional feature.

## Vesper Claim SD-JWT Data Formats

An SD-JWT is composed of

* an Claim Agent signed JWT, and
* zero or more Disclosures.

The serialized format for the SD-JWT is the concatenation of each part delineated with a single tilde ('~') character as follows:

~~~~~~~~~~~
<Issuer-signed JWT>~<Disclosure 1>~<Disclosure 2>~...~<Disclosure N>~
~~~~~~~~~~~

The payload of a vesper token as an SD-JWT is a JSON object according to the following rules:

The payload MAY contain the _sd_alg key described in Section 5.1.1 of {{I-D.ietf-oauth-selective-disclosure-jwt}}.
The payload MAY contain one or more digests of Disclosures to enable selective disclosure of the respective claims, created and formatted as described in Section 5.2.
The payload MAY contain one or more decoy digests to obscure the actual number of claims in the SD-JWT, created and formatted as described in Section 5.2.5.
The payload MAY contain one or more non-selectively disclosable claims.
The payload MAY contain the Holder's public key(s) or reference(s) thereto, as explained in Section 5.1.2.
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

Claim Agents are entities that act as issuers in the SD-JWT three party trust model, but generally validate information provided by a Subject Entity via either checking an authorized source or via a vetting procedure.  The details of either of these processes are very likely application or jurisdiction specific and should follow an eco-system specific set of policies and therefore are out-of-scope of this document.

There are different types of claims that can be validated on behalf of a subject entity, but specific to telephone number identities and the entities that are assigned the right to use telephone numbers and more generally the subject and focus of this document there are two required claim types defined in this document and two optional supplemental claim types defined in this document.  It is anticipated that future specifications may define new claim types with additional relevant information that requires trust and validation and therefore an IANA registry for Vesper Claim Agent types is setup to register unique type indicators.

## Claim Agent Types and Claim Values

Each Claim Agent Type has a corresponding unique string that uniquely identifies a Claim Agent as a particular type and the associated claim object generated by a claim agent to include defined set of claim key values that include both required and optional key values.

### Vetting Claim Agent - "vca"

The Vetting Claim Agent is a required claim agent data type and is also the first claim that MUST be established to establish a globally unique entity-id to represent the Subject Entity in the Notary Agent uniquely.

The Vetting Claim object is defined to include the following key values in the claim object:

~~~~~~~~~~~~~
+---------------------+-------------+------------------------------+
| Claim Info Key      | Value Type  | Value Description            |
+---------------------+-------------+------------------------------+
| address             | JSON object |                              |
+---------------------+-------------+------------------------------+
| street_address      | String      |                              |
| locality            | String      |                              |
| region              | String      |                              |
| country             | String      |                              |
| postal_code         | String      |                              |
+---------------------+-------------+------------------------------+
| contact_given_name  | String      |                              |
| contact_family_name | String      |                              |
| contact_email       | String      |                              |
| contact_phone_num   | String      |                              |
+---------------------+-------------+------------------------------+
| business_ids        | JSON Array  |                              |
+---------------------+-------------+------------------------------+
| EIN                 | String      |                              |
+---------------------+-------------+------------------------------+
~~~~~~~~~~~~~


### Right to Use Claim Agent - "rtuca"

The Right to Use Claim Agent is a required claim agent data type and is tied to a telephone number service provider or Responsible Organization that is authorized to assign telephone numbers. The Subject Entity has a business relationship with their telephone number provider that also either directly or through a relationship with a Claim Agent can validate the assigned Telephone Number.

Note: the telephone number service provider also should provide the mechanism to provide a delegate certificate with the telephone number resource as part of the TNAuthList.

The Vetting Claim object is defined to include the following key values in the claim object:

~~~~~~~~~~~~~
+---------------------+-------------+------------------------------+
| Claim Info Key      | Value Type  | Value Description            |
+---------------------+-------------+------------------------------+
| telephone_num       | Value Array | Array of e.164 Strings       |
+---------------------+-------------+------------------------------+
~~~~~~~~~~~~~


### Rich Call Data Claim Agent - "rcdca"

The Rich Call Data Claim Agent is an optional claim agent data type and is tied to Rich Call Data as defined in {{I-D.ietf-stir-passport-rcd}}.

The Rich Call Data Claim object is defined to include the following key values in the claim object:

~~~~~~~~~~~~~
+---------------------+-------------+------------------------------+
| Claim Info Key      | Value Type  | Value Description            |
+---------------------+-------------+------------------------------+
| rcd Array           | JSON Array  | Array of rcd claims objects  |
+---------------------+-------------+------------------------------+
| rcd                 | JSON Object | rcd claim                    |
| rcdi                | JSON Object | rcdi claim                   |
| crn                 | JSON Object | call reason claim            |
+---------------------+-------------+------------------------------+
~~~~~~~~~~~~~

### Consent Claim Agent - "cca"

The Consent Claim Agent is an optional claim agent data type and is tied to a consent assertion associated to a destination telephone number.

The Consent Claim object is defined to include the following key values in the claim object:

~~~~~~~~~~~~~
+---------------------+-------------+------------------------------+
| Claim Info Key      | Value Type  | Value Description            |
+---------------------+-------------+------------------------------+
| consent_assertion   | JSON Array  | Array consent_assertion objs |
+---------------------+-------------+------------------------------+
| consent_type        | String      | consent_type                 |
| destination_tn      | e.164 array | array of destination tns     |
+---------------------+-------------+------------------------------+
~~~~~~~~~~~~~

# Vesper PASSporT Token as a wrapper for Multiple Vesper Claims Presentation

A Subject Entity (SE), acting as the Holder of multiple Vesper claims as SD-JWT + receipts, may need to present a combination of these tokens to satisfy various verification requirements in a single interaction. For instance, in the STIR ecosystem, the SE might first present a vetting Vesper claim to a Telephone Number Service Provider (TNSP) to prove its identity. Once trusted, the TNSP issues a Right To Use (RTU) Vesper claim for a specific Telephone Number (TN) and associated Rich Call Data (RCD). The SE can then present both the vetting and RTU Vesper claims to the AS when signing a call.

## Structure of multiple Vesper Claim Presentation

When creating a multiple Vesper Claim presentation, the SE assembles a package that may contain:

1. Multiple Base SD-JWTs: The core JWTs from each Vesper token (e.g., KYC/KYB and RTU), representing the vetted claims.
2. Disclosures: The selectively disclosable claims from each token that are relevant to the verifier.

The presentation package is composed as follows:

~~~~~~~~~~~~~
<SD-JWT-1>~<Disclosure 1-1>~<Disclosure 1-2>~...<SD-JWT-2>~
  <Disclosure 2-1>~<Disclosure 2-2>~
~~~~~~~~~~~~~

In this format:

- \<SD-JWT-1\> and \<SD-JWT-2\> represent the KYC/KYB and RTU Vesper tokens, respectively.
- \<Disclosure 1-1\>, \<Disclosure 1-2\>, etc., represent selectively disclosed claims from each token.

# Preventing Replay Attacks

A replay attack occurs when a malicious actor intercepts a valid token or message and reuses it to gain unauthorized access or perform unauthorized actions. In the context of Vesper tokens, this could involve reusing a token or presentation package to fraudulently sign calls or access services. To address the potential replay attack issue in the Vesper token ecosystem, JWT ID (JTI) claim is used.

## Mitigation Strategy - JWT ID (JTI) Claim

- Description: The JTI claim is a unique identifier for each JWT. This identifier ensures that each token is distinct, even if it contains the same claims. The JTI can be used by the verifier to track tokens and detect if the same token is being reused maliciously.

- Implementation:
  - When a Vesper token (SD-JWT) is issued, the Claim Agent includes a unique jti value in the JWT payload.
  - Verifiers, such as the AS, should store recent JTI values temporarily (e.g., in a cache) to detect if the same token is being presented multiple times within a short period. This prevents replay attacks using old tokens.

Example:

~~~~~~~~~~~~~
{
  "iss": "https://vetting-claim-agent.example.com",
  "sub": "Business_42",
  "iat": 1683000000,
  "exp": 1883000000,
  "jti": "unique-token-id-12345",
  ...
}
~~~~~~~~~~~~~

# Examples

Note: this example section is still very much a work in progress

## Example SD-JWT Claim Token Issuance

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
  "iss": "https://vetting-claim-agent.example.com",
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
Contents: ["6Ij7tM-a5iVPGboS5tmvVA", "contact_email",
   "johndoe@example.com"]
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
Contents: ["lklxF5jMYlGTPUovMNIvCA", "{"nam":"Business_42",
  "icn":"https://example.com/logo.png"}"]
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

## Example Vesper PASSporT

The following non-normative example shows a Vesper PASSporT as it would be sent from the Holder (SE) to the Verifier.

Add Example

## Example Presentation

Examples of different presentation scenarios

Add Example

# Security Considerations

TODO Security


# IANA Considerations

## JSON Web Token claims

This specification requests that the IANA add two new claims to the JSON Web Token Claims registry as defined in [RFC7519].

Claim Name: "vesper"

Claim Description: A JSON object that includes both an SD-JWT object containing Vesper Claims from a Vesper Claim Agent and a Notary Agent transparency receipt object as required by the STIR Vesper framework

Change Controller: IESG

Specification Document(s): [RFCThis]

## PASSporT Types

This specification requests that the IANA add a new entry to the Personal Assertion Token (PASSporT) Extensions registry for the type "vesper" which is specified in [RFCThis].


--- back

# Acknowledgments
{:numbered="false"}

TODO acknowledge.

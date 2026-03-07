---
title: "VESPER - Verifiable STI Presentation and Evidence for RTU"
abbrev: "VESPER"
category: std

docname: draft-wendt-stir-vesper-07
submissiontype: IETF  # also: "independent", "editorial", "IAB", or "IRTF"
number:
date:
consensus: true
v: 3
area: "Applications and Real-Time"
workgroup: "Secure Telephone Identity Revisited"
keyword:
 - telephone number
 - domain

author:
 -
    fullname: Chris Wendt
    organization: Somos, Inc.
    email: "chris@appliedbits.com"
    country: US
 -
    fullname: Rob &#x015A;liwa
    organization: Somos, Inc.
    email: robjsliwa@gmail.com
    country: US

normative:
  RFC8224:
  RFC8225:
  RFC8226:
  RFC9118:
  RFC9447:
  RFC9448:
  RFC9795:
  I-D.ietf-stir-rfc4916-update:
  I-D.ietf-acme-authority-token-jwtclaimcon:
  I-D.ietf-stir-certificates-shortlived:

informative:

--- abstract

This document defines VESPER (Verifiable STI Presentation and Evidence for RTU) as a framework for issuing, distributing, and verifying delegate certificates that cryptographically bind two trust elements and one origination scope: the telephone number authority assigned by a responsible provider or organization to the responsible entity, the domain identity of the responsible entity established through control of its domain and associated certificate credentials, and the set of originating service providers (OSPs) enabled as legitimate originators for calls from those telephone numbers onto the telephone network.

The delegate certificate is the canonical trust artifact. It carries the assigned telephone numbers and the set of enabled originating service provider codes (SPCs) in a TNAuthList extension, the entity's domain in a Subject Alternative Name, optional claim constraints via JWTClaimConstraints and EnhancedJWTClaimConstraints extensions, and a transparency receipt proving the certificate was recorded in a public log prior to use. Origination by any service provider not identified in the certificate's TNAuthList is not considered legitimate for those telephone numbers. The certificate's trust is backed by two authority tokens: a TNAuthList Authority Token representing the responsible provider or organization's telephone number assignment authority, and optionally a JWTClaimConstraints Authority Token authorizing additional PASSporT claims and constraining their values.

From this certificate, two output token types are derived: a PASSporT signed by the delegate certificate for use in SIP signaling as defined in {{RFC8224}}, and a portable RTU Token (a JWT with a confirmation claim) for use in origination policy distribution, web verification, and other multi-channel trust contexts.

The domain-telephone number binding established by this framework enables verifiable trust signals across voice, web, SMS/messaging, and email channels. When a telephone number appears in a webpage, email, or message as a tel URI or when a URL appears in a communication associated with a telephone number, the VESPER certificate provides a basis for validating that these references are associated with the domain of the responsible entity. References that cannot be validated against the certificate's domain-TN binding should be treated as potentially fraudulent. This document does not define relying-party enforcement policy, user interface behavior, or jurisdictional governance.

--- middle

# Introduction

The Secure Telephone Identity (STI) architecture, based on STI certificates {{RFC8226}}, PASSporTs {{RFC8225}}, and the SIP Identity header field {{RFC8224}}, provides cryptographic integrity protection for calling information in real-time communications. These mechanisms enable relying parties to verify that a telephone number was not modified in transit and that it was signed using credentials authorized for that number. However, the STI architecture does not define how a telephone number is authoritatively associated with the domain-based identity of the entity to which it was assigned pursuant to applicable numbering plan policies, nor does it provide a mechanism to identify which originating service providers are enabled as legitimate originators for calls from that entity's telephone numbers.

In practice, telephone numbers appear across a wide range of digital contexts: in SIP signaling, on websites, in SMS and rich communication messages, and in email. Today, there is no standard mechanism for a relying party to verify that a domain presenting a telephone number is the same entity to which that number was assigned, or to confirm that an OSP originating a call is one of the legitimate originators enabled for that number. This gap enables impersonation, unauthorized origination, and the presentation of misleading contact information across digital channels.

VESPER addresses this by defining a delegate certificate that serves as a single, auditable trust artifact binding three things: the telephone numbers assigned to the responsible entity, the domain that entity controls and for which it holds certificate credentials, and the set of originating service providers enabled as legitimate originators for calls from those telephone numbers. Because this binding is expressed in a standard X.509 certificate subject to existing STIR certificate policy, it can be validated using widely deployed PKI mechanisms and recorded in a transparency system for ecosystem auditability.

The domain-telephone number binding introduced by this framework has broad applicability beyond voice. A web resource that references a telephone number can be verified as authentic by checking whether its domain is bound to that number in a VESPER delegate certificate. An SMS message that includes a URL can be evaluated for trustworthiness by confirming that the domain in the URL is associated with the originating telephone number. An email from a domain that references a telephone number can be validated against the same certificate. This multi-channel trust surface is a direct consequence of anchoring telephone number authority to a verifiable domain identity.

This document defines the certificate profile, the certificate repository and TN-keyed discovery mechanism, the PASSporT usage profile, the RTU Token format, and the relationship to origination policy distribution. Decisions regarding trust enforcement, user interface presentation, and jurisdictional governance are intentionally outside the scope of this specification.

# Conventions and Definitions

{::boilerplate bcp14-tagged}

# Overview

## The VESPER Delegate Certificate

The VESPER framework is built around a delegate certificate issued to the entity that holds the right-to-use for one or more telephone numbers. This certificate is issued within the STIR ecosystem PKI, whose trust anchors govern the authority chain. The delegate certificate represents the issued credentials that bind telephone number authority to the entity that is the domain holder and subject of the certificate. Trust assertions in VESPER are expressions of what is certified in this credential, validated against the STIR ecosystem trust anchors through the certificate chain.

The certificate carries the following:

* Telephone number authority: one or more telephone numbers (or ranges) in the TNAuthList extension, representing the entity's right-to-use as assigned by a responsible provider or organization pursuant to applicable numbering plan policies. The authoritative role of the responsible provider or organization is represented in the STI certificate chain: the STI Certification Authority (STI CA) that issues the delegate certificate operates under certificate policy that recognizes the responsible provider or organization's authority over the relevant telephone numbers. Combined with the TNAuthList Authority Token issued by that responsible provider or organization and presented to the STI CA, this certificate chain representation is what enables and validates the issuance of the delegate certificate.
* Originating service provider enablement: one or more service provider codes (SPCs) in the same TNAuthList extension, identifying the OSPs enabled as legitimate originators for calls from those telephone numbers onto the telephone network. Any OSP not identified in this list that originates calls from those numbers should be treated as operating without legitimate authorization. Both TN entries and SPC entries MAY appear together in a single TNAuthList, as permitted by {{RFC8226}}.
* Domain identity: a DNS domain name in the SubjectAltName extension (dNSName), representing the entity's domain as established through WebPKI. This domain is the stable, verifiable identifier for the entity across all channels.
* Optional claim constraints: JWTClaimConstraints {{RFC8226}} and/or EnhancedJWTClaimConstraints {{RFC9118}} extensions, authorizing additional PASSporT claims (such as Rich Call Data) and optionally constraining their values. These constraints are backed by a JWTClaimConstraints Authority Token issued in accordance with {{I-D.ietf-acme-authority-token-jwtclaimcon}}.
* Transparency receipt: a Signed Certificate Timestamp (SCT) or equivalent proof of inclusion, embedded in the certificate, proving that the certificate was submitted to and recorded in a transparency log before use.

Short-lived certificates MUST be used. Implementations MUST support the profile in {{I-D.ietf-stir-certificates-shortlived}} and MUST convey the certificate chain inline using the "x5c" PASSporT header parameter.

## Domain as First-Class Trust Element

Prior STIR specifications establish telephone number authority through the TNAuthList but do not bind that authority to the real-world entity to which the number was assigned. VESPER introduces the entity's domain as the binding element that connects telephone number authority to an established Internet identity.

The domain in the delegate certificate SAN corresponds to the domain the responsible entity controls and for which it holds certificate credentials. Control of that domain, established through the entity's ability to obtain certificate credentials for it, provides a corroborating identity signal that is independent of the telephone number ecosystem. When a relying party validates a VESPER delegate certificate, it obtains verifiable evidence that a specific Internet entity — identified by the domain it controls — has been assigned credentials for specific telephone numbers by a responsible provider or organization.

## Certificate Repository and TN-Keyed Discovery

An entity that holds a VESPER delegate certificate MUST publish that certificate at a stable, domain-controlled location so that relying parties can retrieve it given a telephone number. The certificate repository is hosted at one of the following locations:

* MUST support: `https://stir.{domain}/` (e.g., `https://stir.example.com/`)
* MAY support: `https://{domain}/.well-known/stir/`

The TLS certificate on the repository host validates domain ownership through standard WebPKI. The domain in the repository's TLS certificate MUST match the dNSName SAN in the VESPER delegate certificate. No cross-signing between the STI delegate certificate and the web TLS certificate is required or defined.

### TN-Keyed Lookup

To enable relying-party lookup without exposing the entity's complete set of telephone numbers, lookups are keyed by a hash of the telephone number rather than by a directory or index. A relying party that has observed a telephone number performs the following steps:

1. Normalize the telephone number to E.164 format (e.g., `+12125551234`).
2. Compute `hash = base64url( SHA-256( E.164-string ) )`.
3. Fetch `https://stir.{domain}/{hash}.json`.
4. The response is a JSON object containing at minimum:
   - `cert`: an HTTPS URL pointing to the delegate certificate file (a UUID-named `.pem`, e.g., `https://stir.example.com/certs/{UUID}.pem`)
   - `receipt`: the transparency receipt or a reference to it
5. Fetch and validate the certificate at the `cert` URL.

The use of a hash-derived lookup path means that a relying party who knows a telephone number can locate the corresponding certificate deterministically, while an observer who does not know the telephone numbers cannot enumerate the entity's number inventory by traversing the repository. Certificate files are named with opaque UUIDs to prevent guessing from the certificate URL itself.

For entities with large TN ranges, the publishing side MAY generate hash entries for each individual number in the range pointing to the same certificate. This is a publishing implementation detail and does not affect the lookup protocol.

## Two Output Tokens

### PASSporT (SIP Signaling)

For use in SIP signaling as defined in {{RFC8224}}, VESPER uses a standard PASSporT {{RFC8225}} signed by the delegate certificate. The PASSporT carries:

* Standard claims: `orig`, `dest`, `iat`
* The `vper` claim: `{ "domain": "example.com" }` where `domain` is the entity's domain and MUST match the dNSName SAN in the signing delegate certificate
* Optional additional claims authorized by JWTClaimConstraints in the certificate (e.g., Rich Call Data)

Implementations MUST use the `x5c` header parameter to convey the certificate chain inline. Verification Services MUST prefer `x5c` over `x5u` and MUST NOT dereference `x5u` when a valid `x5c` chain is present.

### RTU Token (Portable Distribution)

For contexts beyond SIP signaling including origination policy distribution, web verification, and multi-channel trust use cases, VESPER defines an RTU Token. The RTU Token is a JWT (not PASSporT-typed) signed by the delegate certificate's private key, with a `cnf` (confirmation) claim {{RFC7800}} that binds the token to the signing certificate's public key.

The RTU Token carries the entity's TNs, domain, and enabled originating service provider codes and may optionally include claim-constrained attributes. It serves as a distributable, verifiable credential that can be presented to OSPs, relying parties, or policy systems without requiring those parties to perform live certificate lookups.

A future extension of the RTU Token using SD-JWT to support selective disclosure and a holder-wallet model is anticipated but not defined in this document.

## Multi-Channel Trust Surface

The binding of telephone number authority and domain identity in a single delegate certificate creates verifiable trust signals that extend beyond voice signaling into every digital channel where telephone numbers and domain names co-occur.

Voice and SIP: The PASSporT signed by the delegate certificate provides cryptographic verification that the originating TN was assigned to the entity whose domain is certified in the certificate, and that origination is occurring through an OSP identified as a legitimate originator in the certificate's TNAuthList.

Web: A relying party that encounters a telephone number on a web page — whether as a `tel:` URI or in display text — can verify that the page's origin domain is bound to that number by querying the certificate repository at `stir.{domain}`. If the TN appears in the TNAuthList of the certificate served there, the domain is verified as the authorized holder of that number. Conversely, a `tel:` URI on a page whose domain does not match the certificate for that TN should be treated as a potential spoofing indicator.

SMS and Rich Messaging: A message received from a telephone number that includes a URL can be evaluated by checking whether the domain in the URL is bound to the originating TN via a VESPER certificate. A URL whose domain does not match the certified domain for the originating TN should be treated as a potential fraud indicator, as it suggests the message content is not associated with the entity that holds the right-to-use for that number. This provides a trust signal for URL safety that is grounded in telephone number authority rather than reputation alone.

Email: An email from a domain that references a telephone number in a signature block, a notification, or a verification message can be validated by checking whether that domain is bound to the referenced TN in a VESPER certificate. A `tel:` URI in an email whose sending domain does not match the certificate for that TN is a signal that the reference may not be legitimate.

In all cases, the trust signal is that the domain and the telephone number have been co-certified through the STI ecosystem. The VESPER certificate establishes an exclusive association: references to a telephone number or to URLs under a domain that do not match the certificate's domain-TN binding should be treated as potentially fraudulent, regardless of the channel in which they appear.

# VESPER Roles and Certificate Issuance

## Roles

The VESPER framework defines the following functional roles. This document standardizes the artifacts and verification inputs used across these roles and does not prescribe organizational governance models, jurisdiction-specific business identifiers, or relying-party enforcement and UI policy.

1. Domain Operator: the entity that controls a domain and holds the right-to-use for one or more telephone numbers. The Domain Operator is the subject of the VESPER delegate certificate and operates the certificate repository at its domain.
2. Right-to-Use (RTU) Authority: the ecosystem participant(s) that can authoritatively represent telephone number assignment for issuance of TNAuthList-constrained credentials (e.g., numbering administrators, responsible organizations/providers, or other established RTU authorities).
3. STI Certification Authority (STI CA): issues VESPER delegate certificates after validating RTU evidence and domain association, operating under STIR ecosystem certificate policy {{RFC8226}}.
4. Transparency Log Operator(s): record issued delegate certificates and return SCTs or other verifiable proofs of inclusion to enable ecosystem auditability and detection of mis-issuance.

## Role Responsibilities

### Domain Operator

The Domain Operator controls a domain (e.g., `example.com`) and holds the right-to-use for the telephone numbers listed in its VESPER delegate certificate. The Domain Operator operates the certificate repository at `https://stir.{domain}/`, publishes TN-keyed lookup entries for each authorized number, and uses the delegate certificate's private key to sign PASSporTs and RTU Tokens.

In some deployments the Domain Operator may hold telephone numbers directly (e.g., an enterprise with assigned numbers). In others, the Domain Operator may be acting as an authorized agent for a right-to-use holder, provided the issued delegate certificate reflects that authorization.

### Responsible Provider or Responsible Organization

A Responsible Provider, sometimes called a Telephone Number Service Provider (TNSP), or Responsible Organization (RespOrg) plays both their traditional well-defined role in the allocation and assignment of telephone numbers in accordance with national or international numbering plans generally followed internationally via E.164 and E.164.1 but also a foundational role in the VESPER ecosystem by validation of the association of telephone number assignments to certificate subjects (i.e., RTU holders). These parties operate under regulatory authority and are responsible for administering number resources associated with a specific country code or region.

Their responsibilities include:

* Number Assignment: Allocating telephone numbers to certificate subjects under the rules of an authorized numbering plan.
* Certificate Subject Association: Establishing and maintaining a record that links each assigned telephone number to a specific, uniquely identified certificate subject. This includes assigning a persistent identifier or account reference to the certificate subject to which a number is assigned, providing an opaque identifier. This identifier can be used by the certificate subject to reference its assignment and to support issuance workflows (e.g., RTU evidence or TNAuthList Authority Tokens), and may be referenced during disputes or disclosures when necessary.

The Responsible Provider or Organization follows the applicable numbering assignment process and supports issuance (directly or indirectly) of RTU evidence that can be presented to an STI CA for issuance of TNAuthList-constrained delegate certificates. VESPER does not require publication of jurisdiction-specific entity identifiers as part of this base authorization flow.

### Transparency Log Operator Responsibilities

Transparency Log Operators provide ecosystem auditability for issued delegate certificates by recording certificates and returning verifiable proofs of inclusion (e.g., SCTs or receipts). This enables relying parties and observers to detect mis-issuance and to validate that a certificate used for authorization has been publicly recorded.

This document does not define a dispute resolution process. Disputes and remediation are handled by ecosystem governance outside the scope of this specification.

## Delegate Certificate Issuance Process

In the VESPER framework, issuance of a delegate certificate involves the roles defined in this document, including the Responsible Provider or Responsible Organization (as applicable to the numbering plan), and an STI Certification Authority (STI CA) operating under the STIR ecosystem certificate policy {{RFC8226}}.

The issuance flow is telephone-number-first:

1. A Right-to-Use (RTU) Authority (e.g., a responsible organization/provider or other established RTU authority) produces verifiable RTU evidence for one or more telephone numbers.
2. The subject requesting the delegate certificate (the RTU holder, or an authorized agent acting on its behalf) presents that RTU evidence to an STI CA.
3. The STI CA validates the RTU evidence (e.g., via ACME challenges) and issues a TNAuthList-constrained delegate certificate.
4. The issued certificate is recorded in a transparency system and is subsequently used to sign PASSporTs.

This specification does not require the publication of jurisdiction-specific business identifiers or registry-derived identity artifacts as inputs to the base issuance flow.

### Establishing Telephone Number Authority

The trust anchor for telephone number authority in VESPER is established through two complementary representations. First, the authoritative responsible provider or organization is represented in the STI certificate chain itself: the STI CA that issues the delegate certificate operates under certificate policy that recognizes the responsible provider or organization's authority to assign telephone numbers pursuant to applicable numbering plan policies for the relevant country code. Second, the TNAuthList Authority Token, issued by that same responsible provider or organization, cryptographically represents the right-to-use of the specific telephone number(s) assigned to the certificate subject.

It is the combination of these two representations — the responsible provider or organization's presence in the certificate chain and the TNAuthList Authority Token asserting the specific assignment — that enables and validates issuance of the TNAuthList-constrained delegate certificate by the STI CA. The STI CA validates the TNAuthList Authority Token using mechanisms such as {{RFC9447}}, {{RFC9448}}, and {{I-D.ietf-acme-authority-token-jwtclaimcon}}, presented as part of an ACME challenge response. A relying party that validates the full delegate certificate chain therefore has cryptographic assurance of both the responsible provider or organization's authority and the specific telephone number assignment.

### Optional Authorization of Additional Claims

If a certificate subject wishes to assert additional PASSporT claims beyond the base claims defined in {{RFC8225}} (e.g., Rich Call Data (RCD) {{RFC9795}}), those claims must be authorized via a JWTClaimConstraints Authority Token {{I-D.ietf-acme-authority-token-jwtclaimcon}}. This token governs what claims (and claim values, where applicable) the subject is authorized to present in communications, and is presented to the STI CA as part of the certificate issuance process.

Where a JWTClaimConstraints Authority Token is used, it SHOULD be scoped to the same telephone number authority being requested (e.g., by referencing the same TNAuthList Authority Token or equivalent RTU evidence), ensuring the two authority tokens are coherently bound to the same certificate subject. The trust anchor for any additional claims asserted in PASSporTs signed by the issued certificate is the JWTClaimConstraints Authority Token presented at issuance.

### Certificate Request and Issuance

Once the required RTU evidence (and any optional claim-authorization evidence) has been obtained, the certificate subject generates a Certificate Signing Request (CSR) and initiates issuance with an STI CA authorized to issue certificates within the STIR ecosystem.

The subject presents the RTU evidence (and, if applicable, the JWTClaimConstraints Authority Token) to the STI CA as part of the ACME issuance process. Upon successful validation, the STI CA issues a delegate certificate.

STI CAs SHOULD issue short-lived certificates with brief validity intervals as specified in {{I-D.ietf-stir-certificates-shortlived}}, and subjects SHOULD automate renewal to avoid service interruptions.

The issued delegate certificate MUST include:

* A TNAuthList extension {{RFC8226}}, representing the telephone number(s) the certificate holder is authorized to use and, where applicable, the SPC(s) of the originating service providers authorized to carry traffic for those numbers. TN entries and SPC entries MAY appear together in a single TNAuthList extension.

If the certificate is intended to authorize claims beyond the base PASSporT claims defined in {{RFC8225}}, it MUST also include:

* A JWTClaimConstraints extension {{RFC8226}} and/or EnhancedJWTClaimConstraints extension {{RFC9118}}, representing constraints on claims the certificate holder is permitted to assert.

### Transparency Recording

The issued certificate MUST be submitted to a transparency log. A corresponding SCT or other verifiable proof of inclusion is returned to the submitting party and MUST be embedded in the certificate prior to deployment. The embedded transparency receipt provides relying parties with verifiable evidence that the certificate was publicly recorded before use, without requiring a live log query.

Transparency recording provides ecosystem visibility and supports detection of mis-issuance. This specification does not define remediation procedures; handling of mis-issuance and trust decisions are governed by ecosystem policy outside the scope of this document.

## VESPER Certificate Profile

VESPER delegate certificates MUST conform to the STIR certificate profile in {{RFC8226}} and MUST support the short-lived certificate profile in {{I-D.ietf-stir-certificates-shortlived}}.

### Subject and SubjectAltName

The certificate Subject SHOULD include an Organization (O) field reflecting the entity's name. The SubjectAltName extension MUST include a dNSName entry carrying the entity's domain (e.g., `example.com`). This domain MUST be DNS-resolvable, MUST match the domain of the certificate repository host, and MUST match the `domain` field of any `vper` claim in PASSporTs signed by this certificate.

### TNAuthList Extension

The certificate MUST include a TNAuthList extension {{RFC8226}}. The TNAuthList is a SEQUENCE OF TNEntry, where each TNEntry is a CHOICE of telephone number (TN), telephone number range, or service provider code (SPC). VESPER delegate certificates MAY include both TN entries and SPC entries in the same TNAuthList extension.

* TN entries represent the telephone numbers assigned to and held by the certificate subject, as established by the TNAuthList Authority Token and validated through the certificate chain that reflects the responsible provider or organization's authority.
* SPC entries identify the originating service providers enabled as legitimate originators for calls from the listed telephone numbers. Origination by an OSP not present in the TNAuthList is not considered legitimate and should be treated as potential spoofing.

The combination of TN and SPC entries in a single certificate is the mechanism by which VESPER defines the legitimate origination path for a telephone number, enabling downstream origination policy distribution.

### JWTClaimConstraints Extension (OPTIONAL)

If the certificate is intended to authorize PASSporT claims beyond the base claims defined in {{RFC8225}}, the certificate MUST include a JWTClaimConstraints extension {{RFC8226}} and/or EnhancedJWTClaimConstraints extension {{RFC9118}}, derived from a JWTClaimConstraints Authority Token issued in accordance with {{I-D.ietf-acme-authority-token-jwtclaimcon}}. The JWTClaimConstraints Authority Token is the trust anchor for any additional entity information or claim values asserted in PASSporTs signed by this certificate. The STI CA MUST NOT widen the constraints specified in the Authority Token.

### Transparency Receipt

The issued certificate MUST be submitted to a transparency log prior to deployment. The resulting SCT or equivalent proof of inclusion MUST be embedded in the certificate. Relying parties MUST validate the embedded transparency receipt as part of certificate validation. The receipt proves the certificate was publicly recorded before use without requiring a live log query at verification time.

### Validity and Renewal

CAs SHOULD issue certificates with short validity intervals as specified in {{I-D.ietf-stir-certificates-shortlived}}. Certificate subjects SHOULD automate renewal to avoid service interruption. PASSporTs MUST include the full certificate chain using the `x5c` header parameter. Verification Services MUST prefer `x5c` over `x5u` and MUST NOT dereference `x5u` when a valid `x5c` chain is present.

## Use of VESPER Delegate Certificates for Signing Communications

Once a certificate subject has received a VESPER delegate certificate, it uses that certificate's private key to sign PASSporTs for calls and messages associated with the authorized telephone numbers. The JWTClaimConstraints extension in the certificate governs what additional claims the subject is permitted to assert, ensuring no claim can exceed what was authorized by the JWTClaimConstraints Authority Token presented at issuance.

For SIP calls, the signed PASSporT is attached to the SIP Identity header as defined in {{RFC8224}}, using the `x5c` header parameter to convey the certificate chain inline as specified in {{I-D.ietf-stir-certificates-shortlived}}.

## VESPER Authentication and Verification Procedures

These procedures extend the baseline STIR authentication and verification models defined in {{RFC8224}}, {{RFC8225}}, and {{RFC8226}}.

### Authentication Service Behavior

When originating a call or message, the Authentication Service:

- Constructs a PASSporT containing `orig`, `dest`, `iat`, the `vper` claim, and any optional claims authorized by JWTClaimConstraints in the certificate.
- Signs the PASSporT using a VESPER delegate certificate whose TNAuthList authorizes the `orig` telephone number and that contains an embedded transparency receipt.
- Conveys the certificate chain inline using the `x5c` header parameter.

### Verification Service Behavior

Upon receiving a PASSporT, the Verification Service MUST:

- Validate the PASSporT signature.
- Validate the certificate trust chain against STIR ecosystem trust anchors.
- Confirm the TNAuthList extension authorizes the `orig` telephone number.
- Validate the embedded transparency receipt.
- If JWTClaimConstraints or EnhancedJWTClaimConstraints extensions are present, verify that all asserted claims conform to those constraints.
- Confirm the `vper` domain matches the dNSName SAN of the signing certificate.
- Prefer `x5c` for certificate chain retrieval; MUST NOT dereference `x5u` when a valid `x5c` chain is present.

The PASSporT MUST be rejected if any of the above checks fail.

### Connected Identity

When VESPER is used with Connected Identity {{I-D.ietf-stir-rfc4916-update}}, the destination party returns a PASSporT of type `rsp` in a SIP 200 OK, signed using a VESPER delegate certificate authorized for the `dest` telephone number. The `rsp` PASSporT MUST include the original `orig` and `dest` values, a fresh `iat`, and optionally a `vper` claim reflecting the destination party's domain. The originating party MUST verify the `rsp` PASSporT using the same certificate validation steps above, applied to the `dest` telephone number and the destination party's certificate.

# PASSporT Claim: "vper" (Verifiable Persona Representation)

This section defines the `vper` PASSporT claim for conveying the domain identity of the party presenting a telephone number. The claim provides a verifiable binding between the PASSporT and the entity's domain as certified in the signing delegate certificate.

The `vper` claim is a JSON object containing the following field:

~~~~~~~~~~~~
"vper": {
  "domain": "string"
}
~~~~~~~~~~~~

* `domain` (REQUIRED): A DNS domain name under the administrative control of the party asserting the claim. The value MUST match the dNSName SAN in the signing VESPER delegate certificate. The value MUST be DNS-resolvable and is used as the primary identifier for domain-based discovery via the certificate repository defined in this document.

## Semantics and Verification

The `vper` claim is conveyed inside a PASSporT and is integrity protected by the PASSporT signature. A relying party that successfully validates the PASSporT signature and the TNAuthList constraints of the signing delegate certificate can treat the `domain` value as bound to the authorized telephone number(s) for that certificate.

The `domain` value MUST match the dNSName SAN of the signing certificate. A relying party MUST reject a PASSporT where the `vper` domain does not match the certificate's dNSName SAN.

A relying party MAY use the `domain` value as input to the TN-keyed certificate repository lookup defined in this document to retrieve and independently validate the delegate certificate.

# RTU Token

This section defines the RTU Token, a portable JWT credential signed by the VESPER delegate certificate that can be distributed to originating service providers, relying parties, or policy systems as verifiable evidence of telephone number right-to-use and domain association.

## Token Format

The RTU Token is a JWT {{RFC7519}} signed using the private key of the VESPER delegate certificate. It is not a PASSporT and does not use PASSporT typing. The token MUST include a `cnf` (confirmation) claim {{RFC7800}} containing the public key of the signing delegate certificate (or a reference to it), binding the token to the certificate.

The RTU Token MUST include:

* `iss`: the entity's domain (matching the dNSName SAN of the signing certificate)
* `iat`, `exp`: issuance and expiration times
* `cnf`: confirmation claim binding the token to the signing certificate's public key
* `tns`: array of E.164 telephone numbers authorized by the certificate's TNAuthList
* `spcs`: array of SPCs authorized in the certificate's TNAuthList (MAY be omitted if no SPCs are present)
* `domain`: the entity's domain (same value as `iss`)

The token MAY additionally include claim-constrained attributes authorized by the JWTClaimConstraints extension of the signing certificate (e.g., Rich Call Data elements).

## Usage

The RTU Token is intended for distribution flows where a relying party or policy system needs portable evidence of RTU without performing a live certificate lookup. Primary use cases include:

* Origination policy distribution: the token provides the SPC-scoped evidence that an OSP can validate to confirm it is an enabled legitimate originator for the listed TNs.
* Web and multi-channel verification: a relying party that receives an RTU Token can validate the domain-TN binding without querying the certificate repository.
* API-based registry interactions: the token can serve as a bearer credential in RTU registry or policy API contexts.

## SD-JWT Extension

A future extension of the RTU Token using SD-JWT {{I-D.ietf-oauth-selective-disclosure-jwt}} to support selective disclosure and a holder-wallet distribution model is anticipated. In that model, the entity holds a wallet of RTU Tokens and presents selective disclosures to relying parties on demand, enabling privacy-preserving verification without revealing the full TN inventory. This extension is not defined in this document.

# JWTClaimConstraints for Transparent Claims

This section defines how VESPER profiles JWTClaimConstraints {{RFC8226}} and EnhancedJWTClaimConstraints {{RFC9118}} to enable transparency-audited authorization of additional PASSporT claims while preserving privacy when desired. In this model, a JWTClaimConstraints Authority Token {{I-D.ietf-acme-authority-token-jwtclaimcon}} is issued to an STI CA authorizing specific claim names and, where applicable, constraining permissible claim values or value commitments. The STI CA includes corresponding constraints in the delegate certificate, and that certificate is logged for ecosystem auditability.

Three privacy modes are supported:

1. Transparent-Value: the constraint fixes the exact value to be asserted (fully transparent).
2. Semi-Private (Unsalted Hash): the constraint fixes a hash of the value (guessable by an observer who can test likely values).
3. Private (Salted Commitment): the constraint fixes a salted hash commitment; verification requires out-of-band salt disclosure from the certificate subject to an explicitly authorized relying party.

## Constraint Encodings

For each constrained claim, the JWTClaimConstraints Authority Token and the certificate extension MUST carry exactly one of the following encodings.

### Transparent-Value Constraint

The claim value is directly constrained to be the value in open text. The VS compares the presented PASSporT claim value for equality with the constrained value.

### Semi-Private Constraint (Unsalted Hash)

The certificate fixes a digest D over the canonicalized value without a salt.

Computation:

    V_bytes = deterministic_serialize(V)
    D = SHA-256(V_bytes)

Verification: The VS computes D' over the received value and accepts if D' == digest. This mirrors the integrity mechanism in {{RFC9795}}.

### Private Constraint (Salted Commitment)

The certificate fixes a commitment C incorporating a secret per-claim salt S. Only C is published. The certificate subject may disclose S and V out-of-band to an authorized relying party for verification.

Computation:

    V_bytes = deterministic_serialize(V)
    C = SHA-256( S || V_bytes )

The salt S MUST be generated using a CSPRNG (minimum 128 bits) and MUST NOT be included in the certificate or transparency log.

## Certificate and Transparency Log Requirements

The STI CA MUST copy the constraints from the JWTClaimConstraints Authority Token into the certificate extension without widening them. The issued certificate MUST be submitted to a transparency log, which records the existence of each constrained claim and its encoding (clear value, hash, or commitment) without revealing salts.

## Verification by a Relying Party

* For value mode: ensure the presented claim equals the constrained value.
* For hash mode: recompute the digest over the presented claim and compare.
* For commit mode: if the RP has received S and V out-of-band, recompute and compare the commitment. If S is not available, the RP MUST treat the constraint as authorized but not presently verifiable and apply local policy.

# Security Considerations

## Threat Model and Goals

VESPER provides verifiable evidence that a certificate subject is authorized to use one or more telephone numbers and (optionally) authorized to assert specific additional PASSporT claims. VESPER does not, by itself, determine whether a relying party should trust a caller, render user interface indicators, or enforce policy.

The primary security goals are:

* Prevent unauthorized parties from asserting telephone number authority.
* Prevent over-claiming (asserting claims beyond those authorized by constraints).
* Provide ecosystem auditability to detect mis-issuance.
* Support privacy-preserving authorization of sensitive claim values.
* Prevent enumeration of an entity's telephone number inventory via the certificate repository.

## Certificate Repository Security

### TN Hash Lookup

The hash-keyed lookup path prevents enumeration of an entity's TN inventory by parties who do not already know the telephone numbers. Relying parties MUST compute lookup paths from the E.164 form of the telephone number as observed in context (e.g., from a PASSporT, a web page, or a message). Implementations SHOULD rate-limit repository responses to reduce the effectiveness of targeted probing.

### Repository Domain Binding

The domain of the certificate repository's TLS certificate MUST match the dNSName SAN of the VESPER delegate certificate served there. A relying party MUST reject a certificate if this match fails. This binding, together with standard WebPKI TLS validation, eliminates the need for cross-signing between the STI delegate certificate and the web TLS certificate.

## PASSporT Header Retrieval

Implementations MUST prefer `x5c` and MUST NOT dereference `x5u` when a valid `x5c` chain is present. If `x5u` dereferencing is permitted by local policy when `x5c` is absent, relying parties SHOULD restrict retrieval to HTTPS, enforce URI allowlisting, apply timeouts and size limits, and reject redirects to non-HTTPS schemes.

## Claim Constraint Enforcement

Relying parties MUST verify that any asserted claims conform to the JWTClaimConstraints and/or EnhancedJWTClaimConstraints extensions in the delegate certificate. A PASSporT that violates constraints MUST be treated as invalid.

For the Semi-Private (Unsalted Hash) mode, observers may guess low-entropy values and test digests; deployments SHOULD use this mode only where that risk is acceptable.

For the Private (Salted Commitment) mode, salts MUST be generated using a CSPRNG and MUST NOT be included in certificates or transparency logs. Salt disclosure MUST occur over authenticated and confidential channels.

## Transparency Receipt Validation

Relying parties MUST validate the embedded transparency receipt in the delegate certificate. Relying parties SHOULD apply local policy about which logs are trusted, minimum inclusion proof requirements, and handling of receipt validation failure.

## Certificate Lifetime and Replay

Short-lived certificates reduce dependence on revocation. Relying parties MUST enforce certificate validity windows and SHOULD enforce freshness checks on PASSporT `iat` claims. Relying parties SHOULD apply existing STIR replay mitigations appropriate to their environment.

## Policy Separation

VESPER standardizes evidence and verification inputs. Decisions about enforcement, dispute handling, and remediation are intentionally outside the scope of this document and MUST be governed by ecosystem policy.

# IANA Considerations

New PASSporT Claim: "vper"

This document requests that the IANA add a new entry to the "PASSporT Claims" registry as follows:

| Claim Name | Claim Value Type | Reference |
| ---------- | ---------------- | --------- |
| vper       | JSON object      | RFCthis   |
{: title="PASSporT Claims registry entry for "vper"}

# Acknowledgments

The authors would like to acknowledge Jon Peterson for valuable feedback into the concepts and framework for this document. This work is mainly based on the many years of inputs and specifications developed in the STIR working group and the larger telephone industry which the authors acknowledge as a critically important feedback and influence toward the development of the VESPER framework.

--- back

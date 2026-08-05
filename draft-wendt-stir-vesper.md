---
title: "VESPER - Verifiable STI Presentation and Evidence for RTU"
abbrev: "VESPER"
category: std

docname: draft-wendt-stir-vesper-10
submissiontype: IETF
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
  RFC5280:
  RFC7519:
  RFC8224:
  RFC8225:
  RFC8226:
  RFC9060:
  RFC9447:
  RFC9448:
  I-D.wendt-stir-tn-domain-binding:
  I-D.ietf-stir-certificate-transparency:

informative:
  RFC9118:
  RFC9475:
  RFC9795:
  RFC9970:
  I-D.ietf-acme-authority-token-jwtclaimcon:
  I-D.ietf-stir-certificates-shortlived:

--- abstract

This document defines VESPER (Verifiable STI Presentation and Evidence for RTU), a profile for the use of delegate certificates in STIR. VESPER profiles the binding of telephone number authority to a domain identifier, the STIR certificate and PASSporT specifications, ACME-based authority token issuance, and certificate transparency into a delegate certificate that associates the right-to-use for a telephone number with the entity behind the number asserted in the PASSporT `orig` claim. This document describes the certificate usage, a PASSporT usage profile for SIP signaling, and a portable Right-to-Use Token for use outside of SIP.

--- middle

# Introduction

The Secure Telephone Identity (STI) architecture, based on STI certificates {{RFC8226}}, PASSporTs {{RFC8225}}, and the SIP Identity header field {{RFC8224}}, provides cryptographic integrity protection for calling information in real-time communications. These mechanisms verify that a telephone number was not modified in transit and that it was signed using credentials authorized for that number. They do not, on their own, establish that a telephone number is being used by the entity it was assigned to, or carry a verifiable entity identity that a relying party can recognize across channels.

VESPER addresses these gaps not by inventing new cryptographic machinery but by composing mechanisms that already exist. The one genuinely new element VESPER depends on, the binding of telephone number authority to a domain identifier within a single certificate, is specified separately in {{I-D.wendt-stir-tn-domain-binding}}. Everything else in this document describes how that bound certificate, together with STIR PASSporTs, ACME-based authority tokens, certificate transparency, and the existing STIR certificate profile, fit together into a coherent whole.

The result is a profile in which a delegate certificate serves as a single, auditable trust artifact: it carries the telephone numbers assigned to an entity and the domain that entity controls, and it is recorded in a transparency log. This document defines the roles, the certificate repository and discovery model, the PASSporT usage profile, and the portable Right-to-Use Token, and it points to the binding specification for the underlying credential semantics.

# Conventions and Definitions

{::boilerplate bcp14-tagged}

This document uses terms defined in {{RFC8226}}, {{RFC9060}}, and {{I-D.wendt-stir-tn-domain-binding}}, including TNAuthList, delegate certificate, domain identifier, and bound certificate. The VESPER delegate certificate referred to throughout this document is a bound certificate as defined in {{I-D.wendt-stir-tn-domain-binding}}, used within the profile described here.

# Profile Overview

## The VESPER Delegate Certificate

The VESPER profile is built around a delegate certificate {{RFC9060}} scoped to a set of telephone numbers carried in its TNAuthList {{RFC8226}}, issued on the basis of a validated association between those numbers and the entity that holds the right-to-use for them. This certificate is a bound certificate as defined in {{I-D.wendt-stir-tn-domain-binding}}: its TNAuthList and its SubjectAltName domain identifier are co-validated at issuance, so the certificate attests that the same entity holds the right-to-use for the numbers and controls the domain, and that it is authorized to use those numbers as an originating identity in the communications signed under it. The subject of the certificate, referred to in this document as the Domain Operator, is the entity that demonstrated control of that domain and holds the right-to-use for those telephone numbers. VESPER uses this bound certificate as the anchor for all of its trust assertions.

The certificate is delegated from a parent certificate held by the authority responsible for that right-to-use, typically the Telephone Number Service Provider (TNSP) that assigned the numbers to the subject, or another organization that is authoritative for them in the telephone network and identified by an SPC. Following the delegation model of {{RFC9060}}, Section 4.1, the parent certificate may be SPC scoped, and the scope of the VESPER delegate certificate MUST be encompassed by the parent's scope. The chain therefore expresses that a network-authoritative provider has delegated the right-to-use of specific telephone numbers to the subject of the VESPER delegate certificate.

The chain spans two levels of authentication. An SPC-scoped certificate authenticates a provider that is authoritative in the telephone network, which is the level at which STIR has been deployed to date. A telephone-number-scoped delegate certificate authenticates at the level of an individual telephone number and the entity assigned to use it. VESPER is concerned with the latter, and relies on the former for the authority it delegates.

VESPER is defined for telephone numbers. An identity expressed as a SIP URI carries a domain within the identifier itself, so the entity behind it is anchored in a domain by construction. A telephone number carries no such association: telephone number authority and domain control are administered independently of one another. VESPER addresses that gap, establishing as verifiable evidence that the entity holding the right-to-use for a telephone number is the same entity that controls a given domain.

A VESPER delegate certificate MUST carry the following, all as defined in their respective specifications:

* Telephone number authority: one or more telephone numbers in the TNAuthList extension {{RFC8226}}, representing the entity's right-to-use.
* Domain identifier: a domain name in the SubjectAltName {{RFC5280}}, bound to the telephone number authority as defined in {{I-D.wendt-stir-tn-domain-binding}}.
* Claim constraints: claim constraints are the mechanism by which the issuer governs what the subject may assert. A VESPER delegate certificate that authorizes any PASSporT claim beyond the baseline `iat`, `orig`, and `dest` claims, such as Rich Call Data {{RFC9795}}, MUST carry the Enhanced JWT Claim Constraints extension {{RFC9118}}. Every STIR-defined PASSporT claim that the issuer does not authorize the subject to assert MUST be listed in `mustExclude`, and where an authorized claim has a defined set of values, `permittedValues` MUST be used to bound them. The baseline claims are always permitted and MUST NOT appear in `mustExclude`.
* Transparency: an embedded Signed Certificate Timestamp as defined in {{I-D.ietf-stir-certificate-transparency}}.
* Validity: a short-lived validity period as described in {{I-D.ietf-stir-certificates-shortlived}}.

## Domain as a Corroborating Trust Credential

Prior STIR specifications establish telephone number authority through the TNAuthList but do not bind that authority to the entity to which the number was assigned. VESPER relies on the binding defined in {{I-D.wendt-stir-tn-domain-binding}} to add a domain identifier as a corroborating signal: a domain the entity controls and for which it holds credentials. Because the domain identifier and the telephone number authority are co-validated at issuance, a relying party that validates a VESPER delegate certificate obtains evidence that a specific entity, identified by its domain, has been assigned the telephone numbers in the certificate. The strength of this signal comes from two independent trust chains, telephone number assignment and domain control, corroborating the same entity.

## Scope of Entity Verification

VESPER binds two mechanically verifiable facts: control of a domain and authority to use a telephone number. Entity verification, often referred to as know-your-customer (KYC), and the legal identity of the entity are out of scope for VESPER. Whatever real-world verification a certificate authority performs at issuance is governed by CA policy and reflected in the domain identifier; VESPER neither defines nor replaces it.

A relying party does not inspect any provider's onboarding process. It verifies the cryptographic binding of domain control to telephone number authority against publicly auditable infrastructure, as the Web PKI does for domain-bound certificates. The domain identifier serves as a persistent, publicly verifiable network identifier to which telephone number authority is bound; the association between that identifier and a real-world entity is established and maintained outside the scope of this profile.

## User Identity and Delegation

The VESPER delegate certificate authorizes the entity that holds it to use the telephone numbers it contains. Within that entity, individual users or automated agents may be further authorized through the entity's own governance, without being identified in the delegate certificate. A single telephone number may be authorized for use by multiple users or agents, as is common in shared lines and call center deployments. Where caller identity at the individual level is desired, mechanisms such as Rich Call Data {{RFC9795}} or other PASSporT extensions provide optional paths for conveying that information.

## Certificate Repository and Domain-Controlled Discovery

The Domain Operator MUST publish its VESPER delegate certificate at a stable HTTPS location under its domain. The specific path is not prescribed; any HTTPS URL whose domain matches the dNSName SubjectAltName of the delegate certificate is valid. The TLS certificate on the hosting server MUST match the dNSName SubjectAltName of the VESPER delegate certificate, validated through standard Web PKI TLS. No cross-signing between the STI delegate certificate and the web TLS certificate is required or defined.

Because the domain in the delegate certificate and the domain hosting it are the same, retrieval of the certificate from its domain provides a convenient discovery path and reinforces the domain association at retrieval time, as described in {{I-D.wendt-stir-tn-domain-binding}}.

## Token Representations

This profile uses two token representations derived from the delegate certificate: a PASSporT as defined in {{RFC8225}} for use in SIP signaling, and a portable Right-to-Use Token, a JWT {{RFC7519}} that provides portable proof of right-to-use for contexts outside of SIP signaling, such as cases where evidence of telephone number association is required. Each is described in the sections below.

# Certificate Issuance

VESPER delegate certificates MUST be issued as bound certificates in accordance with {{I-D.wendt-stir-tn-domain-binding}}, which requires that domain control and telephone number Right-to-Use be co-validated within a single issuance. The telephone number authority is established through an RTU Authority Token, issued by the authority responsible for the right-to-use of those numbers, typically the TNSP that assigned them, and validated via ACME mechanisms ({{RFC9447}}, {{RFC9448}}, {{I-D.ietf-acme-authority-token-jwtclaimcon}}). Where additional PASSporT claims are to be authorized, a JWTClaimConstraints Authority Token {{I-D.ietf-acme-authority-token-jwtclaimcon}} is presented during issuance.

At issuance, the STI Certification Authority MUST submit the certificate to a transparency log as defined in {{I-D.ietf-stir-certificate-transparency}}, so that VESPER delegate certificates are publicly auditable. Transparency is a requirement of the VESPER profile rather than of the underlying binding, which is defined independently of it. The certificate profile is otherwise that of a bound certificate, which conforms to {{RFC8226}} and {{RFC9060}}.

# PASSporT Usage Profile

This section describes how VESPER uses PASSporTs in SIP signaling. The construction and validation steps below apply the procedures of {{RFC8224}} and {{RFC8225}}; the one verification step specific to the telephone-number-to-domain binding is defined in {{I-D.wendt-stir-tn-domain-binding}} and referenced here.

## Authentication Service Behavior

When originating a call or message, the Authentication Service:

- MUST construct a PASSporT containing `orig`, `dest`, `iat`, and any claims authorized by the certificate, as defined in {{RFC8225}}, and MUST NOT include any claim that the certificate's claim constraints do not authorize.
- MUST sign the PASSporT using a VESPER delegate certificate whose TNAuthList authorizes the `orig` telephone number.
- MUST convey the certificate chain inline using the `x5c` header parameter and MUST include the `x5u` header parameter containing the HTTPS URL of the certificate at its domain-hosted repository location.

## Verification Service Behavior

Upon receiving a PASSporT, the Verification Service MUST apply the validation procedures of {{RFC8224}} and {{RFC8226}}, namely validating the PASSporT signature, validating the certificate chain to a trusted STIR trust anchor, confirming the TNAuthList authorizes the `orig` telephone number, validating the embedded SCT, and, where claim constraints are present, confirming that asserted claims conform.

In addition, the Verification Service MUST apply the binding verification rule defined in {{I-D.wendt-stir-tn-domain-binding}}: it confirms that the domain in the `x5u` URL matches the dNSName SubjectAltName of the signing certificate, and treats the domain identifier as the identity of the right-to-use holder only as bound to the TNAuthList. The PASSporT MUST be rejected if any validation fails.

## Connected Identity

When VESPER is used with Connected Identity {{RFC9970}}, the destination party returns a PASSporT of type `rsp` in a SIP 200 OK, signed using a VESPER delegate certificate authorized for the `dest` telephone number. The `rsp` PASSporT includes the original `orig` and `dest` values and a fresh `iat`. The originating party verifies the `rsp` PASSporT using the same validation steps above, applied to the `dest` telephone number and the destination party's certificate.

# Right-to-Use Token

The Right-to-Use (RTU) Token is a JWT {{RFC7519}} signed by the private key of the VESPER delegate certificate, with the certificate chain conveyed in the JOSE header using the `x5c` parameter. The delegate certificate is the trust artifact; the token signature demonstrates that the presenter holds the corresponding private key. The token provides portable evidence of right-to-use outside of SIP signaling. Established practice for demonstrating right-to-use outside of signaling relies largely on documents such as letters of authorization, which are not cryptographically verifiable and cannot be revoked once issued. The RTU Token provides a verifiable and short-lived alternative.

The RTU Token MUST include:

* `iss`: the entity's domain identifier, matching the dNSName SubjectAltName of the signing certificate
* `iat` and `exp`: issuance and expiration times; `exp` is set to a short validity interval to limit the replay surface
* `orig`: the telephone number being asserted, consistent with the TNAuthList of the signing certificate

The token MAY include additional claims authorized by the claim constraints of the signing certificate, such as Rich Call Data {{RFC9795}}, and MUST NOT include any claim that those constraints do not authorize.

# Delivery Outside In-Band Signaling

The VESPER trust artifacts defined in this document, the PASSporT and the Right-to-Use Token, are independent of how they are conveyed. They are signed by the VESPER delegate certificate and verified against the same bound certificate regardless of the path they travel. Where in-band signaling does not carry the artifact end to end, or where there is no in-band path between the parties, the same artifact can be conveyed through other mechanisms, including out-of-band publish-and-retrieve delivery. This is the case, for example, for messaging conveyed over non-SIP transports that cannot carry a PASSporT {{RFC9475}}. Such delivery mechanisms are specified separately and are not required in order to implement VESPER.

# Security Considerations

VESPER provides verifiable evidence that an entity identified by a domain identifier, and validated as holding the right-to-use for one or more telephone numbers, produced a signature over a communication. A successful verification establishes that the PASSporT or Right-to-Use Token was signed by a delegate certificate whose TNAuthList authorizes the asserted telephone number, that the same certificate binds a co-validated domain identifier, and that the certificate is recorded in a transparency log. It does not establish that the content of a communication is legitimate, and it attests to the identity of the entity only to the assurance carried by the domain identifier; the strength of that identification is the strength of the domain validation performed at issuance, as discussed in {{I-D.wendt-stir-tn-domain-binding}}.

The assurance rests on two independent trust chains, the delegation of telephone number right-to-use and the validation of domain control, co-validated into a single certificate. Because they are bound at issuance, an adversary cannot forge the association by compromising only one: a delegate certificate for a telephone number does not confer control of an unrelated domain, and control of a domain does not confer right-to-use for numbers that were not delegated. The security of the co-validation, and the prohibition on issuing a certificate that carries one without the other, are defined in {{I-D.wendt-stir-tn-domain-binding}}.

VESPER requires delegate certificates to be recorded in a transparency log {{I-D.ietf-stir-certificate-transparency}}. A certificate that improperly binds a domain to telephone numbers, through CA error or compromise, is therefore publicly observable, allowing the affected domain holder, the number authority, and independent monitors to detect it. Transparency does not prevent misissuance, but it makes covert misissuance impractical and bounds how long a mistaken or malicious binding can go unnoticed.

VESPER inherits the security properties and considerations of the mechanisms it composes. PASSporT signature and validation, certificate path validation, and handling of the SIP Identity header field are as defined in {{RFC8224}}, {{RFC8225}}, {{RFC8226}}, and {{RFC9060}}; certificate issuance, including validation of the RTU Authority Token, is defined in {{RFC9447}}, {{RFC9448}}, and {{I-D.wendt-stir-tn-domain-binding}}. VESPER neither weakens nor overrides these, and a weakness in any composed mechanism is inherited by the profile.

Replay of a captured PASSporT or Right-to-Use Token is mitigated by the freshness of the `iat` claim, by a short `exp` interval on the Right-to-Use Token, and by the STIR replay mitigations of {{RFC8224}}. VESPER deployments use short-lived certificates {{I-D.ietf-stir-certificates-shortlived}}, which reduce reliance on revocation and bound the interval over which a compromised key or stale binding remains usable; relying parties enforce certificate validity windows.

# IANA Considerations

This document has no IANA actions.

# Acknowledgments

The authors would like to acknowledge Jon Peterson for valuable feedback on this work, and the STIR working group for the foundational specifications on which VESPER builds.

--- back

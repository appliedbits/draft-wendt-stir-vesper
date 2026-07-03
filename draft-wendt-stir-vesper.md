---
title: "VESPER - Verifiable STI Presentation and Evidence for RTU"
abbrev: "VESPER"
category: std

docname: draft-wendt-stir-vesper-08
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
  RFC9795:
  RFC9970:
  I-D.ietf-acme-authority-token-jwtclaimcon:
  I-D.ietf-stir-certificates-shortlived:
  I-D.wendt-stir-cert-tn-attr-ext:

--- abstract

This document defines VESPER (Verifiable STI Presentation and Evidence for RTU), a framework that composes existing STIR mechanisms into a system in which a relying party can verify that a telephone number was assigned to a specific entity and that the same entity controls a specific domain. VESPER builds on the telephone-number-to-domain binding defined in {{I-D.wendt-stir-tn-domain-binding}}, the STIR certificate and PASSporT specifications, ACME-based authority token issuance, and certificate transparency. This document describes the roles, the certificate usage, a domain-hosted certificate repository and discovery model, a PASSporT usage profile for SIP signaling, and a portable Right-to-Use Token for use outside of SIP. It defines the framework and its composition; the new normative binding it relies on is specified in {{I-D.wendt-stir-tn-domain-binding}}.

--- middle

# Introduction

The Secure Telephone Identity (STI) architecture, based on STI certificates {{RFC8226}}, PASSporTs {{RFC8225}}, and the SIP Identity header field {{RFC8224}}, provides cryptographic integrity protection for calling information in real-time communications. These mechanisms verify that a telephone number was not modified in transit and that it was signed using credentials authorized for that number. They do not, on their own, establish that a telephone number is being used by the entity it was assigned to, or carry a verifiable entity identity that a relying party can recognize across channels.

VESPER addresses these gaps not by inventing new cryptographic machinery but by composing mechanisms that already exist. The one genuinely new element VESPER depends on, the binding of telephone number authority to a domain identifier within a single certificate, is specified separately in {{I-D.wendt-stir-tn-domain-binding}}. Everything else in this document describes how that bound certificate, together with STIR PASSporTs, ACME-based authority tokens, certificate transparency, and the existing STIR certificate profile, fit together into a usable trust framework.

The result is a framework in which a delegate certificate serves as a single, auditable trust artifact: it carries the telephone numbers assigned to an entity and the domain that entity controls, and it is recorded in a transparency log. This document defines the roles, the certificate repository and discovery model, the PASSporT usage profile, and the portable Right-to-Use Token, and it points to the binding specification for the underlying credential semantics.

# Conventions and Definitions

{::boilerplate bcp14-tagged}

This document uses terms defined in {{RFC8226}}, {{RFC9060}}, and {{I-D.wendt-stir-tn-domain-binding}}, including TNAuthList, delegate certificate, domain identifier, and bound certificate. The VESPER delegate certificate referred to throughout this document is a bound certificate as defined in {{I-D.wendt-stir-tn-domain-binding}}, used within the framework described here.

# Framework Overview

## The VESPER Delegate Certificate

The VESPER framework is built around a delegate certificate {{RFC9060}} issued to the entity that holds the right-to-use for one or more telephone numbers and that controls a domain. This certificate is a bound certificate as defined in {{I-D.wendt-stir-tn-domain-binding}}: its TNAuthList and its SubjectAltName domain identifier are co-validated at issuance, so the certificate attests that the same entity holds both. VESPER uses this bound certificate as the anchor for all of its trust assertions.

The VESPER delegate certificate is telephone number scoped: the telephone numbers in its TNAuthList represent the subject's right-to-use. It is delegated from a parent certificate held by the authority responsible for that right-to-use, typically the subject's TNSP or a responsible provider or organization that is authoritative in the telephone network and identified by a service provider code (SPC). Following the delegation model of {{RFC9060}}, Section 4.1, the parent certificate may be SPC scoped, and the telephone number scope of the VESPER delegate certificate MUST be encompassed by the parent's scope. The chain therefore expresses that an SPC-identified, network-authoritative provider has delegated the right-to-use of specific telephone numbers to the subject of the VESPER delegate certificate.

The certificate carries the following, all as defined in their respective specifications:

* Telephone number authority: one or more telephone numbers in the TNAuthList extension {{RFC8226}}, representing the entity's right-to-use.
* Optional self-asserted TN attributes: a VESPER delegate certificate MAY carry the TN Attributes extension {{I-D.wendt-stir-cert-tn-attr-ext}}, through which the number holder expresses self-asserted attributes about its own numbers, such as the originating providers it authorizes, do-not-originate status, and text-enabled status. These attributes are carried in a dedicated extension, are distinct from the telephone number authority in the TNAuthList, and do not extend or modify it.
* Domain identifier: a domain name in the SubjectAltName, bound to the telephone number authority as defined in {{I-D.wendt-stir-tn-domain-binding}}.
* Optional claim constraints: JWTClaimConstraints {{RFC8226}} or EnhancedJWTClaimConstraints {{RFC9118}}, authorizing additional PASSporT claims such as Rich Call Data {{RFC9795}}.
* Transparency: an embedded Signed Certificate Timestamp as defined in {{I-D.ietf-stir-certificate-transparency}}.

VESPER deployments use short-lived certificates as described in {{I-D.ietf-stir-certificates-shortlived}}, convey the certificate chain inline using the `x5c` header parameter, and include the `x5u` header parameter referencing the certificate at its domain-hosted repository location.

## Domain as a Corroborating Trust Credential

Prior STIR specifications establish telephone number authority through the TNAuthList but do not bind that authority to the entity to which the number was assigned. VESPER relies on the binding defined in {{I-D.wendt-stir-tn-domain-binding}} to add a domain identifier as a corroborating signal: a domain the entity controls and for which it holds credentials. Because the domain identifier and the telephone number authority are co-validated at issuance, a relying party that validates a VESPER delegate certificate obtains evidence that a specific entity, identified by its domain, has been assigned the telephone numbers in the certificate. The strength of this signal comes from two independent trust chains, telephone number assignment and domain control, corroborating the same entity.

## Relationship to Entity Verification and KYC

A common question is where entity verification, often referred to as know-your-customer (KYC), fits into this framework. The answer is that the domain association VESPER relies on is itself the output of that verification. Establishing that an entity controls a domain, through domain control validation and, at higher assurance, organization or extended validation or correlation of domain-associated channels such as verified email under the domain, is the work that binds a real-world entity to its domain identifier. The domain identifier in the VESPER delegate certificate is the persistent, publicly verifiable result of that work.

VESPER therefore does not add a separate KYC step or treat KYC as a trust signal carried in the certificate. It treats the domain identifier as the artifact that entity verification produces, and binds that artifact to telephone number authority as defined in {{I-D.wendt-stir-tn-domain-binding}}. A relying party never inspects any provider's onboarding process; it verifies the cryptographic binding of domain to telephone number authority against publicly auditable infrastructure. This is the same pattern the Web PKI has long used, where a certificate authority's diligence produces a domain-bound certificate that relying parties verify without appeal to the underlying process. VESPER extends that pattern so that the domain association and the telephone number authority, held by the same entity, are bound together and verified at evaluation time.

## User Identity and Delegation

The VESPER delegate certificate authorizes the entity that holds it to use the telephone numbers it contains. Within that entity, individual users or automated agents may be further authorized through the entity's own governance, without being identified in the delegate certificate. A single telephone number may be authorized for use by multiple users or agents, as is common in shared lines and call center deployments. Where caller identity at the individual level is desired, mechanisms such as Rich Call Data {{RFC9795}} or other PASSporT extensions provide optional paths for conveying that information.

## Certificate Repository and Domain-Controlled Discovery

An entity that holds a VESPER delegate certificate publishes that certificate at a stable HTTPS location under its domain. The specific path is not prescribed; any HTTPS URL whose domain matches the dNSName SubjectAltName of the delegate certificate is valid. The TLS certificate on the hosting server matches the dNSName SubjectAltName of the VESPER delegate certificate, validated through standard Web PKI TLS. No cross-signing between the STI delegate certificate and the web TLS certificate is required or defined.

Because the domain in the delegate certificate and the domain hosting it are the same, retrieval of the certificate from its domain provides a convenient discovery path and reinforces the domain association at retrieval time, as described in {{I-D.wendt-stir-tn-domain-binding}}.

## Token Representations

This framework uses two token representations derived from the delegate certificate: a PASSporT as defined in {{RFC8225}} for use in SIP signaling, and a portable Right-to-Use Token, a JWT {{RFC7519}} that provides portable proof of right-to-use for contexts outside of SIP signaling, such as cases where evidence of telephone number association is required. Each is described in the sections below.

# VESPER Roles

The VESPER framework uses the roles defined for the binding in {{I-D.wendt-stir-tn-domain-binding}} and adds the operational roles needed for the framework.

1. Domain Operator: the entity that controls a domain and holds the right-to-use for one or more telephone numbers. The Domain Operator is the subject of the VESPER delegate certificate, publishes the certificate at a stable HTTPS location under its domain, and uses the certificate's private key to sign PASSporTs and Right-to-Use Tokens.
2. Right-to-Use (RTU) Authority: the responsible provider or organization, authoritative in the telephone network and identified by a service provider code, that allocates telephone numbers and issues RTU Authority Tokens, as described in {{I-D.wendt-stir-tn-domain-binding}}. The RTU Authority holds the SPC-scoped parent certificate from which the VESPER delegate certificate is delegated, and its scope encompasses the telephone numbers in the delegate certificate per {{RFC9060}}, Section 4.1.
3. STI Certification Authority: issues VESPER delegate certificates as bound certificates in accordance with {{I-D.wendt-stir-tn-domain-binding}}.
4. Transparency Log Operator: records issued delegate certificates and returns SCTs, as defined in {{I-D.ietf-stir-certificate-transparency}}.

# Certificate Issuance

VESPER delegate certificates are issued as bound certificates in accordance with {{I-D.wendt-stir-tn-domain-binding}}, which requires that domain control and telephone number Right-to-Use be co-validated within a single issuance. The telephone number authority is established through an RTU Authority Token issued by the RTU Authority and validated via ACME mechanisms ({{RFC9447}}, {{RFC9448}}, {{I-D.ietf-acme-authority-token-jwtclaimcon}}). Where additional PASSporT claims are to be authorized, a JWTClaimConstraints Authority Token {{I-D.ietf-acme-authority-token-jwtclaimcon}} is presented during issuance.

A VESPER delegate certificate is recorded in a transparency log and carries an embedded Signed Certificate Timestamp as defined in {{I-D.ietf-stir-certificate-transparency}}, so that VESPER delegate certificates are publicly auditable. Transparency is a requirement of the VESPER framework rather than of the underlying binding, which is defined independently of it. The certificate profile is otherwise that of a bound certificate, which conforms to {{RFC8226}} and {{RFC9060}}.

# PASSporT Usage Profile

This section describes how VESPER uses PASSporTs in SIP signaling. The construction and validation steps below apply the procedures of {{RFC8224}} and {{RFC8225}}; the one verification step specific to the telephone-number-to-domain binding is defined in {{I-D.wendt-stir-tn-domain-binding}} and referenced here.

## Authentication Service Behavior

When originating a call or message, the Authentication Service:

- Constructs a PASSporT containing `orig`, `dest`, `iat`, and any optional claims authorized by the certificate, as defined in {{RFC8225}}.
- Signs the PASSporT using a VESPER delegate certificate whose TNAuthList authorizes the `orig` telephone number.
- Conveys the certificate chain inline using the `x5c` header parameter and includes the `x5u` header parameter containing the HTTPS URL of the certificate at its domain-hosted repository location.

## Verification Service Behavior

Upon receiving a PASSporT, the Verification Service applies the validation procedures of {{RFC8224}} and {{RFC8226}}, namely validating the PASSporT signature, validating the certificate chain to a trusted STIR trust anchor, confirming the TNAuthList authorizes the `orig` telephone number, validating the embedded SCT, and, where claim constraints are present, confirming that asserted claims conform.

In addition, the Verification Service applies the binding verification rule defined in {{I-D.wendt-stir-tn-domain-binding}}: it confirms that the domain in the `x5u` URL matches the dNSName SubjectAltName of the signing certificate, and treats the domain identifier as the identity of the right-to-use holder only as bound to the TNAuthList. The PASSporT is rejected if any validation fails.

## Connected Identity

When VESPER is used with Connected Identity {{RFC9970}}, the destination party returns a PASSporT of type `rsp` in a SIP 200 OK, signed using a VESPER delegate certificate authorized for the `dest` telephone number. The `rsp` PASSporT includes the original `orig` and `dest` values and a fresh `iat`. The originating party verifies the `rsp` PASSporT using the same validation steps above, applied to the `dest` telephone number and the destination party's certificate.

# Right-to-Use Token

The Right-to-Use (RTU) Token is a JWT {{RFC7519}} signed by the private key of the VESPER delegate certificate, with the certificate chain conveyed in the JOSE header using the `x5c` parameter. The delegate certificate is the trust artifact; the token signature demonstrates that the presenter holds the corresponding private key. The token provides portable evidence of right-to-use outside of SIP signaling.

The RTU Token includes:

* `iss`: the entity's domain identifier, matching the dNSName SubjectAltName of the signing certificate
* `iat` and `exp`: issuance and expiration times; `exp` is set to a short validity interval to limit the replay surface
* `orig`: the telephone number being asserted, consistent with the TNAuthList of the signing certificate

The token may include additional claims authorized by the JWTClaimConstraints extension of the signing certificate, such as Rich Call Data {{RFC9795}}.

# Delivery Outside In-Band Signaling

The VESPER trust artifacts defined in this document, the PASSporT and the Right-to-Use Token, are independent of how they are conveyed. They are signed by the VESPER delegate certificate and verified against the same bound certificate regardless of the path they travel. Where in-band signaling does not carry the artifact end to end, or where there is no in-band path between the parties, the same artifact can be conveyed through other mechanisms, including out-of-band publish-and-retrieve delivery. Such delivery mechanisms are specified separately and are not required in order to implement VESPER.

# Security Considerations

VESPER provides verifiable evidence that an entity identified by a domain identifier, and validated as holding the right-to-use for one or more telephone numbers, produced a signature over a communication. A successful verification establishes that the PASSporT or Right-to-Use Token was signed by a delegate certificate whose TNAuthList authorizes the asserted telephone number, that the same certificate binds a co-validated domain identifier, and that the certificate is recorded in a transparency log. It does not establish that the content of a communication is legitimate, and it attests to the identity of the entity only to the assurance carried by the domain identifier; the strength of that identification is the strength of the domain validation performed at issuance, as discussed in {{I-D.wendt-stir-tn-domain-binding}}.

The assurance rests on two independent trust chains, the delegation of telephone number right-to-use and the validation of domain control, co-validated into a single certificate. Because they are bound at issuance, an adversary cannot forge the association by compromising only one: a delegate certificate for a telephone number does not confer control of an unrelated domain, and control of a domain does not confer right-to-use for numbers that were not delegated. The security of the co-validation, and the prohibition on issuing a certificate that carries one without the other, are defined in {{I-D.wendt-stir-tn-domain-binding}}.

VESPER requires delegate certificates to be recorded in a transparency log {{I-D.ietf-stir-certificate-transparency}}. A certificate that improperly binds a domain to telephone numbers, through CA error or compromise, is therefore publicly observable, allowing the affected domain holder, the number authority, and independent monitors to detect it. Transparency does not prevent misissuance, but it makes covert misissuance impractical and bounds how long a mistaken or malicious binding can go unnoticed.

VESPER inherits the security properties and considerations of the mechanisms it composes. PASSporT signature and validation, certificate path validation, and handling of the SIP Identity header field are as defined in {{RFC8224}}, {{RFC8225}}, {{RFC8226}}, and {{RFC9060}}; certificate issuance, including validation of the RTU Authority Token, is defined in {{RFC9447}}, {{RFC9448}}, and {{I-D.wendt-stir-tn-domain-binding}}. VESPER neither weakens nor overrides these, and a weakness in any composed mechanism is inherited by the framework.

Replay of a captured PASSporT or Right-to-Use Token is mitigated by the freshness of the `iat` claim, by a short `exp` interval on the Right-to-Use Token, and by the STIR replay mitigations of {{RFC8224}}. VESPER deployments use short-lived certificates {{I-D.ietf-stir-certificates-shortlived}}, which reduce reliance on revocation and bound the interval over which a compromised key or stale binding remains usable; relying parties enforce certificate validity windows.

# IANA Considerations

This document has no IANA actions.

# Acknowledgments

The authors would like to acknowledge Jon Peterson for valuable feedback on this work, and the STIR working group for the foundational specifications on which VESPER builds.

--- back

sequenceDiagram
    participant VE as Vetting Entity (VE)
    participant VA as Vetting Agent (VA)
    participant VV as Vetting Verifier (VV)
    participant TS as Transparency Service (TS)

    VE->>VA: Register and submit information
    VA-->>VE: Create authenticated account and entity_id

    Note over VE,VA: VE submits uniquely identifiable information

    VA->>VA: Perform vetting functions and KYC/KYB checks

    opt Key Binding (KB) Setup
        VE->>VA: Generate public/private key pair
        VA-->>VE: Public key registered
    end

    VA->>TS: Encapsulate vetting data in VCM
    TS-->>VA: Append-only log and issue SVT

    VE->>VA: Request Vesper Token
    VA-->>VE: Issue SD-JWT with KYC/KYB info, public key, and transparency receipt

    VE->>VV: Present verifiable token
    VV-->>VE: Verify token signature and optionally validate KB-JWT

    VV->>TS: Verify SVT signature
    TS-->>VV: Verify entity_name in SVT matches token

    Note over VV: Vetting Verification Complete



@startuml
participant "Vetting Entity (VE)" as VE
participant "Vetting Agent (VA)" as VA
participant "Vetting Verifier (VV)" as VV
participant "Transparency Service (TS)" as TS

VE -> VA: Register and submit information
VA -> VE: Create authenticated account and entity_id

note over VE,VA: VE submits uniquely identifiable information

VA -> VA: Perform vetting functions and KYC/KYB checks

alt Key Binding (KB) Setup
    VE -> VA: Generate public/private key pair
    VA -> VE: Public key registered
end

VA -> TS: Encapsulate vetting data in VCM
TS -> VA: Append-only log and issue SVT

VE -> VA: Request Vesper Token
VA -> VE: Issue SD-JWT with KYC/KYB info, public key, and transparency receipt

VE -> VV: Present verifiable token
VV -> VE: Verify token signature and optionally validate KB-JWT

VV -> TS: Verify SVT signature
TS -> VV: Verify entity_name in SVT matches token

note over VV: Vetting Verification Complete
@enduml


---

sequenceDiagram
    participant VE as Vetting Entity (VE)
    participant VA as Vetting Agent (VA)
    participant VV as Vetting Verifier (VV)
    participant TS as Transparency Service (TS)
    participant TNSP as Telephone Number Service Provider (TNSP)

    VE->>VA: Register and submit information
    VA-->>VE: Create authenticated account and entity_id

    Note over VE,VA: VE submits uniquely identifiable information

    VA->>VA: Perform vetting functions and KYC/KYB checks

    opt Key Binding (KB) Setup
        VE->>VA: Generate public/private key pair
        VA-->>VE: Public key registered
    end

    VA->>TS: Encapsulate vetting data in VCM
    TS-->>VA: Append-only log and issue SVT

    VE->>VA: Request KYC/KYB Vesper Token
    VA-->>VE: Issue SD-JWT with KYC/KYB info, public key, and transparency receipt

    VE->>VV: Present KYC/KYB Vesper token
    VV-->>VE: Verify token signature and optionally validate KB-JWT

    VV->>TS: Verify SVT signature
    TS-->>VV: Verify entity_name in SVT matches token

    Note over VV: Vetting Verification Complete

    VE->>TNSP: Request TN assignment and present KYC/KYB Vesper token
    TNSP->>VV: Verify KYC/KYB Vesper token and trust VE

    VE->>TNSP: Request TNSP Vesper token for TN lease and RCD
    TNSP-->>VE: Issue SD-JWT with TN lease, RCD, and transparency receipt

    VE->>VV: Present TNSP Vesper token for TN use
    VV-->>VE: Verify token signature and validate TN lease and RCD

    VV->>TS: Verify SVT signature for TNSP token
    TS-->>VV: Verify entity_name in SVT matches TNSP token

    Note over VV: TN Lease and RCD Verification Complete

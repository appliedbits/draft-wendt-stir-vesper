sequenceDiagram
    participant VE as Vetting Entity (VE)
    participant VA as Vetting Authority (VA)
    participant TS as Transparency Service (TS)
    participant VV as Verification Validator (VV)

    VE->>VA: 1. Register with VA and create entity_id
    VE->>VA: 2. Submit information claims for vetting
    VA->>VA: 3. Perform KYC/KYB checks

    alt Optional Key Binding (KB)
        VE->>VA: 4. Generate and register public key (or VA does it)
        VA->>VA: 5. Register public key
    end

    VA->>VA: 6. Create hash of vetting data/results
    VA->>TS: 7. Log hash and get transparency receipt
    TS-->>VA: 7. Transparency receipt

    alt API service
        VA->>VE: 8. Provide API service
        VE->>VE: 8. Host own API service
    end

    VE->>VA: 9. Request SD-JWT
    VA-->>VE: 9. Issue SD-JWT with KYC/KYB info, public key, transparency receipt

    VE->>VV: 10. Submit token for verification
    VV->>VV: 10. Verify token signature and optionally KB-JWT
    VV->>TS: 11. Verify transparency log signature
    TS-->>VV: 11. Transparency log signature validation
stalwart-cli snapshot \
    Tenant Domain Directory DkimSignature AcmeProvider Certificate DnsServer Role \
    Account Authentication \
    SystemSettings DataRetention BlobStore InMemoryStore SearchStore \
    --allow-unresolved PublicKey \
    --include-secrets \
    --output ".devcontainer/stalwart/settings.ndjson"
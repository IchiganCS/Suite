snapshot_path := justfile_directory() / ".devcontainer/stalwart/settings.ndjson"

db_dir  := justfile_directory() / "App/Database"
seed_db := db_dir / "SuiteDB.seed.sqlite"
dev_db  := db_dir / "SuiteDB.dev.sqlite"

# Load the config snapshot into the mock Stalwart instance.
stalwart-apply-snapshot:
    #!/usr/bin/env bash
    set -euo pipefail

    # Uses recovery mode with a temporary admin if the CLI isn't usable yet
    if ! stalwart-cli describe >/dev/null 2>&1; then
        echo "stalwart-cli not usable, starting recovery mode"
        STALWART_RECOVERY_MODE=1 STALWART_RECOVERY_ADMIN=admin:password \
            docker compose up -d --force-recreate stalwart
        timeout 60 bash -c 'until stalwart-cli describe >/dev/null 2>&1; do sleep 1; done'
    fi

    stalwart-cli apply --file "{{snapshot_path}}" --continue-on-error

    echo "restarting without recovery admin"
    docker compose up -d --force-recreate stalwart

stalwart-make-snapshot:
    #!/usr/bin/env bash
    stalwart-cli snapshot \
        Tenant Domain Directory DkimSignature AcmeProvider Certificate DnsServer Role \
        Account Authentication \
        SystemSettings DataRetention BlobStore InMemoryStore SearchStore \
        --allow-unresolved PublicKey \
        --include-secrets \
        --output "{{snapshot_path}}"

# Reset the dev database to the committed seed.
db-reset:
    rm -f '{{dev_db}}' '{{dev_db}}-wal' '{{dev_db}}-shm'
    cp '{{seed_db}}' '{{dev_db}}'

# Overwrite the committed seed with the dev database.
db-promote:
    test -f '{{dev_db}}'
    sqlite3 '{{dev_db}}' ".backup '{{seed_db}}'"
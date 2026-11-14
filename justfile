snapshot_path := justfile_directory() / ".devcontainer/stalwart/settings.ndjson"

db_dir  := justfile_directory() / "App/Database"
schema_sql := db_dir / "schema.sql"
data_sql   := db_dir / "seed-data.sql"
dev_db     := db_dir / "SuiteDB.sqlite"

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

# Rebuild the dev database from the committed layout and mock data.
db-reset:
    rm -f '{{dev_db}}' '{{dev_db}}-wal' '{{dev_db}}-shm'
    sqlite3 -bail '{{dev_db}}' < '{{schema_sql}}'
    sqlite3 -bail '{{dev_db}}' < '{{data_sql}}'

# Overwrite the committed layout and mock data with the dev database's.
db-dump:
    test -f '{{dev_db}}'
    sqlite3 '{{dev_db}}' .schema > '{{schema_sql}}.tmp'
    sqlite3 '{{dev_db}}' '.dump --data-only' > '{{data_sql}}.tmp'
    mv '{{schema_sql}}.tmp' '{{schema_sql}}'
    mv '{{data_sql}}.tmp' '{{data_sql}}'

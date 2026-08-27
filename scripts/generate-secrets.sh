#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")/.."

if [ -f .env ]; then
    echo "[INFO] .env file already exists. Preserving existing secrets."
    exit 0
fi

DB_PASS=$(openssl rand -hex 16 2>/dev/null || echo "tm3l_postmortem_password")
JWT_SECRET=$(openssl rand -hex 32 2>/dev/null || date +%s | shasum -a 256 | head -c 64)

cat <<ENVEOF > .env
PORT=8083
DATABASE_URL=postgres://tm3l_postmortem:${DB_PASS}@postmortem-db:5432/tm3l_postmortem?sslmode=disable
POSTGRES_USER=tm3l_postmortem
POSTGRES_PASSWORD=${DB_PASS}
POSTGRES_DB=tm3l_postmortem
TM3L_JWT_SECRET=${JWT_SECRET}
ENVEOF

echo "[OK] Generated .env for Postmortem Machine."

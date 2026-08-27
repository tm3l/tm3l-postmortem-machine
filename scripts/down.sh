#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")/.."
echo "==> Stopping TM3L Postmortem Machine stack..."
docker compose down

#!/usr/bin/env bash
set -euo pipefail

echo "=== Checking TM3L Postmortem Machine Service Health ==="

SERVER_HTTP=$(curl -s -o /dev/null -w "%{http_code}" http://localhost:8083/api/health || echo "000")
if [ "$SERVER_HTTP" != "000" ]; then
    echo "[OK] Postmortem Server is responding on http://localhost:8083 (HTTP $SERVER_HTTP)."
else
    echo "[WARN] Postmortem Server is not responding on port 8083."
fi

EXPLORER_HTTP=$(curl -s -o /dev/null -w "%{http_code}" http://localhost:5175/ || echo "000")
if [ "$EXPLORER_HTTP" = "200" ]; then
    echo "[OK] Explorer UI is responding on http://localhost:5175."
else
    echo "[WARN] Explorer UI returned HTTP $EXPLORER_HTTP on port 5175."
fi

echo "=== Health check finished ==="

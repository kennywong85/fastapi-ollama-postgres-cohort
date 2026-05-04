#!/usr/bin/env bash
# verify_module_6.sh — Module 6: /history endpoint; /ask returns history.
# Assumes uvicorn is running on http://localhost:8000.

set -u
ok()   { echo "✓ $1"; }
fail() { echo "✗ $1"; exit 1; }

# GET /history returns a JSON array
resp=$(curl -s http://localhost:8000/history)
echo "$resp" | grep -qE '^\[' \
    || fail "/history did not return a JSON array. Got: $resp"
ok "GET /history returns a JSON array"

# POST /ask response now includes a history field
resp=$(curl -s -X POST http://localhost:8000/ask \
    -H "Content-Type: application/json" \
    -d '{"question":"verify module 6"}')
echo "$resp" | grep -q '"history":' \
    || fail "/ask response missing history field. Got: $resp"
ok "POST /ask response includes history field"

echo
echo "Module 6 verification passed."

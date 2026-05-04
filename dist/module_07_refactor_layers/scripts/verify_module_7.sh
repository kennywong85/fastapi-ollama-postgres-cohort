#!/usr/bin/env bash
# verify_module_7.sh — Module 7: refactor — same behavior, new file structure.
# Run from the dist/module_07_refactor_layers/ folder so the file checks resolve.

set -u
ok()   { echo "✓ $1"; }
fail() { echo "✗ $1"; exit 1; }

# Behavior must match Module 6
resp=$(curl -s -X POST http://localhost:8000/ask \
    -H "Content-Type: application/json" \
    -d '{"question":"verify module 7"}')
echo "$resp" | grep -q '"history":' \
    || fail "/ask response missing history field. Got: $resp"
ok "POST /ask response shape unchanged from Module 6"

# Structural split — the refactor's whole point
[ -f app/schemas.py ] \
    || fail "Expected app/schemas.py — refactor incomplete."
[ -f app/database.py ] \
    || fail "Expected app/database.py — refactor incomplete."
[ -f app/services/ollama_service.py ] \
    || fail "Expected app/services/ollama_service.py."
[ -f app/services/interaction_service.py ] \
    || fail "Expected app/services/interaction_service.py."
ok "app/ split into routes, schemas, database, services"

# get_conn must now live in database.py (Rule of Three satisfied here)
grep -q 'def get_conn' app/database.py \
    || fail "get_conn() not defined in app/database.py."
ok "get_conn() lives in app/database.py"

echo
echo "Module 7 verification passed."

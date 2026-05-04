#!/usr/bin/env bash
# verify_module_8.sh — Module 8: env-driven config; .env.example present.
# Run from the dist/module_08_configuration/ folder so the file checks resolve.
# Assumes uvicorn is running on http://localhost:8000 with .env loaded.

set -u
ok()   { echo "✓ $1"; }
fail() { echo "✗ $1"; exit 1; }

# Behavior still works
resp=$(curl -s -X POST http://localhost:8000/ask \
    -H "Content-Type: application/json" \
    -d '{"question":"verify module 8"}')
echo "$resp" | grep -q '"history":' \
    || fail "/ask response missing history field. Got: $resp"
ok "POST /ask still works with env-loaded config"

# .env.example must ship in the folder
[ -f .env.example ] \
    || fail ".env.example missing — students need this template."
ok ".env.example present"

# DATABASE_URL must be read from os.environ
grep -q 'os.environ\["DATABASE_URL"\]' app/database.py \
    || fail 'DATABASE_URL not read from os.environ in app/database.py.'
ok "DATABASE_URL read from os.environ"

# OLLAMA_BASE_URL and OLLAMA_MODEL must be read from os.environ
grep -q 'os.environ\["OLLAMA_BASE_URL"\]' app/services/ollama_service.py \
    || fail 'OLLAMA_BASE_URL not read from os.environ in app/services/ollama_service.py.'
grep -q 'os.environ\["OLLAMA_MODEL"\]' app/services/ollama_service.py \
    || fail 'OLLAMA_MODEL not read from os.environ in app/services/ollama_service.py.'
ok "OLLAMA_BASE_URL and OLLAMA_MODEL read from os.environ"

echo
echo "Module 8 verification passed."

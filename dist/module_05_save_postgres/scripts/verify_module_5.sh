#!/usr/bin/env bash
# verify_module_5.sh — Module 5: answers persist to Postgres; /healthz reports.
# Assumes uvicorn is running on http://localhost:8000 and Postgres is up.

set -u
ok()   { echo "✓ $1"; }
fail() { echo "✗ $1"; exit 1; }

DSN="postgresql://postgres:postgres@localhost:5432/llm_question_log"

# /healthz reports both services up
resp=$(curl -s http://localhost:8000/healthz)
echo "$resp" | grep -q '"ollama":true' \
    || fail "/healthz reports ollama not reachable. Got: $resp"
echo "$resp" | grep -q '"postgres":true' \
    || fail "/healthz reports postgres not reachable. Got: $resp"
ok "/healthz reports both services up"

# Count rows before/after a POST
before=$(psql "$DSN" -tAc "SELECT COUNT(*) FROM interactions" 2>/dev/null) \
    || fail "Could not count interactions rows — is the database reachable?"
curl -s -X POST http://localhost:8000/ask \
    -H "Content-Type: application/json" \
    -d '{"question":"verify module 5 row insert"}' >/dev/null
after=$(psql "$DSN" -tAc "SELECT COUNT(*) FROM interactions")
[ "$after" = "$((before + 1))" ] \
    || fail "Expected $((before + 1)) rows after POST, got $after."
ok "POST /ask inserts a row into interactions ($before → $after)"

echo
echo "Module 5 verification passed."

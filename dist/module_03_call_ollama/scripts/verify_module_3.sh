#!/usr/bin/env bash
# verify_module_3.sh — Module 3: /ask calls Ollama (no longer echoes).
# Assumes uvicorn is running on http://localhost:8000 and Ollama is up.

set -u
ok()   { echo "✓ $1"; }
fail() { echo "✗ $1"; exit 1; }

resp=$(curl -s -X POST http://localhost:8000/ask \
    -H "Content-Type: application/json" \
    -d '{"question":"reply with the single word: ok"}')

# Should NOT be echoing the question
echo "$resp" | grep -q '"You asked:' \
    && fail "POST /ask is still echoing — Ollama call not in place. Got: $resp"
ok "POST /ask is not echoing (Module 2 behavior is gone)"

# Should have an "answer" field with non-empty content
echo "$resp" | grep -q '"answer":"' \
    || fail "Response has no answer field. Got: $resp"
ok "POST /ask returns an answer from Ollama"

echo
echo "Module 3 verification passed."

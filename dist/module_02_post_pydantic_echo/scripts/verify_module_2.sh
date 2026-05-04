#!/usr/bin/env bash
# verify_module_2.sh — Module 2: POST /ask echoes the question, validates input.
# Assumes uvicorn is running on http://localhost:8000.

set -u
ok()   { echo "✓ $1"; }
fail() { echo "✗ $1"; exit 1; }

# Happy path — typed echo
resp=$(curl -s -X POST http://localhost:8000/ask -H "Content-Type: application/json" -d '{"question":"hello"}')
echo "$resp" | grep -q '"answer":"You asked: hello"' \
    || fail "POST /ask did not echo as expected. Got: $resp"
ok 'POST /ask {"question":"hello"} echoes "You asked: hello"'

# Empty string → 400 (handler business rule)
code=$(curl -s -o /dev/null -w "%{http_code}" -X POST http://localhost:8000/ask \
    -H "Content-Type: application/json" -d '{"question":""}')
[ "$code" = "400" ] || fail "Empty question returned $code, expected 400."
ok 'POST /ask {"question":""} returns 400'

# Missing field → 422 (Pydantic shape error)
code=$(curl -s -o /dev/null -w "%{http_code}" -X POST http://localhost:8000/ask \
    -H "Content-Type: application/json" -d '{}')
[ "$code" = "422" ] || fail "Missing field returned $code, expected 422."
ok 'POST /ask {} returns 422'

echo
echo "Module 2 verification passed."

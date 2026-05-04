#!/usr/bin/env bash
# verify_module_1.sh — Module 1: server serves a static page at /.
# Assumes uvicorn is running on http://localhost:8000.

set -u
ok()   { echo "✓ $1"; }
fail() { echo "✗ $1"; exit 1; }

code=$(curl -s -o /dev/null -w "%{http_code}" http://localhost:8000/)
[ "$code" = "200" ] || fail "GET / returned $code, expected 200. Is uvicorn running?"
ok "GET / returns 200"

echo
echo "Module 1 verification passed."

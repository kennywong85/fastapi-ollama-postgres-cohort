#!/usr/bin/env bash
# verify_module_4.sh — Module 4: system prompt active.
# Soft check: LLMs are non-deterministic. We can verify the SYSTEM_PROMPT
# constant exists in code, and that /ask returns a non-empty answer. We
# cannot strictly enforce the system prompt's "under 80 words" because
# the model may occasionally ignore it.

set -u
ok()   { echo "✓ $1"; }
fail() { echo "✗ $1"; exit 1; }

# SYSTEM_PROMPT must exist somewhere in app/
grep -r "SYSTEM_PROMPT" app/ >/dev/null 2>&1 \
    || fail "SYSTEM_PROMPT constant not found anywhere in app/."
ok "SYSTEM_PROMPT constant present in app/"

# /ask still returns answers
resp=$(curl -s -X POST http://localhost:8000/ask \
    -H "Content-Type: application/json" \
    -d '{"question":"reply with the single word: ok"}')
echo "$resp" | grep -q '"answer":"' \
    || fail "Response has no answer field. Got: $resp"
ok "POST /ask returns an answer"

echo
echo "Module 4 verification passed."
echo "Note: the system prompt is non-deterministic. Manually inspect that"
echo "the model's answers are concise (under ~80 words) when verbose"
echo "answers are not requested."

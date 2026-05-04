#!/usr/bin/env bash
# verify_setup.sh — Module 0 acceptance gate (macOS / Linux).
# Exits 0 only when every dependency is reachable and the venv is active.
# Run from the repo root, after activating the project venv.

set -u

ok()   { echo "✓ $1"; }
fail() { echo "✗ $1"; exit 1; }

# 1. Virtual environment active.
[ -n "${VIRTUAL_ENV:-}" ] \
    || fail "Virtual environment not active. Run: source venv/bin/activate"
ok "Virtual environment active ($VIRTUAL_ENV)"

# 2. Python 3.11+.
py_version=$(python --version 2>&1 | awk '{print $2}')
case "$py_version" in
    3.11.*|3.12.*|3.13.*) ok "Python $py_version" ;;
    *) fail "Python 3.11+ required, found $py_version" ;;
esac

# 3. requirements.txt present at repo root.
[ -f requirements.txt ] \
    || fail "requirements.txt not found in current directory. Run from the repo root."
ok "requirements.txt present"

# 4. Postgres reachable.
pg_isready -h localhost -p 5432 >/dev/null 2>&1 \
    || fail "Postgres not reachable at localhost:5432. Start it: brew services start postgresql@16 (macOS) | sudo systemctl start postgresql (Linux)"
ok "Postgres reachable at localhost:5432"

# 5. Database llm_question_log exists.
psql -lqt | cut -d \| -f 1 | tr -d ' ' | grep -qx llm_question_log \
    || fail "Database 'llm_question_log' not found. Create it: createdb llm_question_log"
ok "Database llm_question_log exists"

# 6. Table interactions exists.
table_exists=$(psql -d llm_question_log -tAc \
    "SELECT 1 FROM information_schema.tables WHERE table_name='interactions'")
[ "$table_exists" = "1" ] \
    || fail "Table 'interactions' not found. Apply schema: psql -d llm_question_log -f sql/001_create_interactions.sql"
ok "Table interactions exists"

# 7. Ollama reachable.
curl -sf http://localhost:11434/api/tags >/dev/null \
    || fail "Ollama not reachable at localhost:11434. Start it: ollama serve"
ok "Ollama reachable at localhost:11434"

# 8. Model llama3.2 available.
curl -s http://localhost:11434/api/tags | grep -q '"name":"llama3.2' \
    || fail "Model 'llama3.2' not pulled. Pull it: ollama pull llama3.2"
ok "Model llama3.2 available"

echo
echo "All checks passed. You're ready for Module 1."

#requires -Version 5.1
# verify_setup.ps1 — Module 0 acceptance gate (Windows).
# Exits 0 only when every dependency is reachable and the venv is active.
# Run from the repo root, after activating the project venv.

$ErrorActionPreference = 'Stop'

function Ok($msg)   { Write-Host "[OK] $msg" -ForegroundColor Green }
function Fail($msg) { Write-Host "[FAIL] $msg" -ForegroundColor Red; exit 1 }

# 1. Virtual environment active.
if (-not $env:VIRTUAL_ENV) {
    Fail "Virtual environment not active. Run: venv\Scripts\Activate.ps1"
}
Ok "Virtual environment active ($env:VIRTUAL_ENV)"

# 2. Python 3.11+.
$pyVersion = (& python --version 2>&1) -replace 'Python ', ''
if ($pyVersion -notmatch '^3\.(11|12|13)\.') {
    Fail "Python 3.11+ required, found $pyVersion"
}
Ok "Python $pyVersion"

# 3. requirements.txt present at repo root.
if (-not (Test-Path requirements.txt)) {
    Fail "requirements.txt not found in current directory. Run from the repo root."
}
Ok "requirements.txt present"

# 4. Postgres reachable.
$pgReady = Test-NetConnection -ComputerName localhost -Port 5432 `
    -InformationLevel Quiet -WarningAction SilentlyContinue
if (-not $pgReady) {
    Fail "Postgres not reachable at localhost:5432. Start the Postgres service via services.msc."
}
Ok "Postgres reachable at localhost:5432"

# 5. Database llm_question_log reachable as the app will connect.
# Use the same connection string the app uses so a green check means
# the app can connect, not just that psql can.
$AppDsn = "postgresql://postgres:postgres@localhost:5432/llm_question_log"
$ping = & psql $AppDsn -tAc "SELECT 1" 2>$null
if ($ping.Trim() -ne '1') {
    Fail "Cannot connect to llm_question_log as user 'postgres'. Either the database is missing (createdb -U postgres llm_question_log) or the postgres role is missing (run as postgres superuser: CREATE USER postgres WITH PASSWORD 'postgres' SUPERUSER)."
}
Ok "Database llm_question_log reachable as user 'postgres'"

# 6. Table interactions exists.
$tableExists = & psql $AppDsn -tAc `
    "SELECT 1 FROM information_schema.tables WHERE table_name='interactions'" 2>$null
if ($tableExists.Trim() -ne '1') {
    Fail "Table 'interactions' not found. Apply schema: psql `"$AppDsn`" -f sql/001_create_interactions.sql"
}
Ok "Table interactions exists"

# 7. Ollama reachable.
try {
    $tags = Invoke-RestMethod -Uri http://localhost:11434/api/tags -TimeoutSec 5
} catch {
    Fail "Ollama not reachable at localhost:11434. Start it: ollama serve"
}
Ok "Ollama reachable at localhost:11434"

# 8. Model llama3.2 available.
$hasLlama = $tags.models | Where-Object { $_.name -like 'llama3.2*' }
if (-not $hasLlama) {
    Fail "Model 'llama3.2' not pulled. Pull it: ollama pull llama3.2"
}
Ok "Model llama3.2 available"

Write-Host ""
Write-Host "All checks passed. You're ready for Module 1." -ForegroundColor Green

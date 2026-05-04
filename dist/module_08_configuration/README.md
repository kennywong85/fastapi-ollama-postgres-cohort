# Module 8 — Configuration via Environment

**Single fundamental:** code describes behaviour. Configuration describes environment. The same code runs against a different database by changing one environment variable.

This is also `v1-final` — the V1 deliverable.

Hardcoded values (`DATABASE_URL`, `OLLAMA_BASE_URL`, `OLLAMA_MODEL`) move to environment variables, loaded from `.env` via `python-dotenv`. `SYSTEM_PROMPT` stays as a hardcoded constant in `services/ollama_service.py` — it's prompt content, not environment.

## Class Flow (5 steps)

1. **Open** this folder (`dist/module_08_configuration/`) in Antigravity.
2. **Run** it — paste the *Run* commands. App still works exactly like Module 7. The config source moved; the behaviour did not.
3. **Read** `app/database.py` and `app/services/ollama_service.py`. Find the `os.environ[...]` reads that replaced Module 7's hardcoded constants. Read `.env.example` and the `.env` you just copied.
4. **Ask Gemini** to explain it — paste the **Primary prompt** under *Ask Gemini* below into the chat panel. Read what Gemini says. Ask follow-ups.
5. **Answer the Defend It question** at the bottom yourself. This is the last Defend It of the course.

(Optional 6th — for hands-on learners: try the *Tweak* suggestion at the end. It's the most important demonstration of the doctrine in the whole course.)

## Run

```bash
source venv/bin/activate
pip install -r requirements.txt   # adds python-dotenv
cp .env.example .env
uvicorn app.main:app --reload
```

## Verify (self-check)

The happy path:

```bash
curl -s http://localhost:8000/healthz
curl -s -X POST http://localhost:8000/ask -H "Content-Type: application/json" -d '{"question":"Hello"}'
```

## Ask Gemini

**Primary prompt** (paste this first into the chat panel):

> Walk me through how `os.environ['DATABASE_URL']` reading works at module load in `app/database.py`. What happens if the variable is missing? Why is failing loudly with a `KeyError` better than reading with a default like `os.environ.get('DATABASE_URL', 'postgresql://...')`?

### More questions if you want to go deeper

This is the last module. By now you should be writing your own prompts more often than pasting these. The three below are starters; the rest is on you.

**Argue against the doctrine:**
> The doctrine forbids using a `Settings` class (e.g., Pydantic `BaseSettings`) for env vars in this curriculum. Build the strongest possible case for why a Settings class would have been better. Then I'll respond with why I think the doctrine was right anyway. We're sparring.

**Make the failure mode visible:**
> Module 8's `KeyError` on a missing env var is intentional, not a bug. Help me write a one-paragraph explanation I could give to a teammate joining this codebase tomorrow that makes them respect the loud-fail rather than "fix" it by adding `.get(..., default)`.

**Write your own next module.** Pick a feature you'd want next — Chat Sessions, RAG, Streaming, whatever — and write a system-prompt-style spec for what its single fundamental should be. Share it with a peer or your instructor.

## Tweak (optional, for hands-on learners — the loud-fail demo)

This is the moment the doctrine becomes visible. Stop uvicorn (`Ctrl+C`), then:

```bash
# macOS / Linux:
mv .env .env.bak
# Windows (PowerShell):
Move-Item .env .env.bak

# Then start uvicorn WITHOUT --reload so the traceback is the first thing you see:
uvicorn app.main:app
```

The server **refuses to start**. The traceback ends with `KeyError: 'DATABASE_URL'`, pointing at the exact line in `app/database.py` that reads `os.environ["DATABASE_URL"]`. **The app told you immediately.** Imagine the alternative — a silent default to a wrong database — and you have hours of debugging instead.

Restore:

```bash
# macOS / Linux:
mv .env.bak .env
# Windows (PowerShell):
Move-Item .env.bak .env

uvicorn app.main:app --reload
```

## Defend It (do not paste into Gemini — answer it yourself)

> Why fail loudly on a missing environment variable instead of falling back to a default?

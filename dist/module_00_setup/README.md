# Module 0 — Setup and Verification

**Single fundamental:** all dependencies must be reachable before any code runs.

There is no `app/` folder yet. This module is verification only. By the end you should have: Python 3.11+, a project venv, Postgres running with the `llm_question_log` database and `interactions` table, and Ollama running with `llama3.2` pulled.

## Class Flow (5 steps)

1. **Open** this folder (`dist/module_00_setup/`) in Antigravity. The file tree on the left shows what's in this module.
2. **Run** the setup commands from the *Run* section below in your terminal.
3. **Read** `sql/001_create_interactions.sql` in your editor — that's the schema your local Postgres now contains.
4. **Ask Gemini** to explain it — paste the **Primary prompt** under *Ask Gemini* below into the chat panel. Read what Gemini says. Ask follow-ups.
5. **Answer the Defend It question** at the bottom yourself before moving to Module 1.

(Optional 6th — for hands-on learners: try the *Tweak* suggestion at the end. Skip if you're moving fast.)

## Run

From this folder, in a terminal inside Antigravity:

```bash
# Windows: run all of these inside your Ubuntu (WSL2) terminal — same commands as macOS / Linux.
python3.11 -m venv venv
source venv/bin/activate
pip install -r requirements.txt   # empty in Module 0; teaches the muscle
createdb llm_question_log
psql -d llm_question_log -f sql/001_create_interactions.sql
```

## Verify (self-check)

```bash
./scripts/verify_setup.sh         # Windows: same command, inside your Ubuntu (WSL2) terminal
```

Expected: eight green ✓ lines ending with *"All checks passed. You're ready for Module 1."*

## Ask Gemini

**Primary prompt** (paste this first into the chat panel):

> Walk me through what each of the eight checks in `verify_setup.sh` is actually proving. Why does each one matter for an app I haven't even written yet?

### More questions if you want to go deeper

**When the script fails on the venv check:**
> The verify script says "Virtual environment not active." What is a virtual environment, why does this project need one, and what does `source venv/bin/activate` actually do to my shell?

**When the script fails on Postgres reachability:**
> The verify script says Postgres is not reachable at localhost:5432. Walk me through diagnosing this on my OS — is it not installed, not running, or not listening on the right port?

**When the script fails connecting to the database (`Cannot connect to llm_question_log as user 'postgres'`):**
> The verify script says it cannot connect to `llm_question_log` as user `postgres`, and offers two possible fixes — either the database is missing, or the role is missing. Walk me through how to figure out which one is true on my machine before I run a fix command. Why does the script suggest two fixes for one symptom?

**When the script fails on the schema check (`Table 'interactions' not found`):**
> The verify script connected to the database but says the `interactions` table does not exist. Open `sql/001_create_interactions.sql` in this folder and walk me through what each column does and why it has the type it has. Then explain what `psql ... -f sql/001_create_interactions.sql` is going to do when I run it.

**When the script fails on the Ollama model:**
> Ollama is reachable but llama3.2 is not pulled. What is `ollama pull llama3.2` actually downloading? Where on my disk does it land? Why is it 2 GB?

**Curiosity / "what if":**
> What would have to be true for me to run this entire app without Postgres? What is Postgres actually doing for the app that a Python list could not?

**Self-check before you move to Module 1:**
> I'm about to start Module 1, which is a "Hello FastAPI" web server. Before I see the code, what do you predict the smallest possible FastAPI app looks like — how many imports, how many lines of `app/main.py`, how many other files? Tell me your prediction. I'll come back after Module 1 and tell you how close you were.

## Tweak (optional, for hands-on learners)

Stop Postgres and re-run the verify script — see what a real failure looks like, then recover:

```bash
# macOS:
brew services stop postgresql@16
./scripts/verify_setup.sh         # observe the ✗ line and its printed fix
brew services start postgresql@16
./scripts/verify_setup.sh         # back to all green
```

(Windows/WSL2: use `sudo systemctl stop postgresql` and `sudo systemctl start postgresql`, or `sudo service postgresql stop` / `sudo service postgresql start` if systemd isn't enabled.)

## Defend It (do not paste into Gemini — answer it yourself)

> Why is "all dependencies reachable" worth a whole module before any application code is written?

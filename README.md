# Local LLM Question Log — cohort repo

A staged, hands-on course that builds the smallest serious AI web application — `Browser → FastAPI → Ollama → Postgres → Browser` — one fundamental at a time, across nine modules.

This repo is your starting point. You'll work through it module-by-module during the live session and on your own afterwards. By the end, you'll have built a working V1 you can publish to your own GitHub as a portfolio piece.

## Welcome

The course is designed for adult mid-career learners. You don't need to be an expert coder — you need to be willing to read code carefully, ask good questions, and build a mental model of how the pieces fit together. The AI partner in your IDE (Gemini in Antigravity) is configured to coach, not to do the work for you.

## What you need on your laptop

| Dependency | Version | Why |
|---|---|---|
| **Python** | 3.11+ | The web server runtime |
| **Postgres** | 16+ | Where the question/answer history lives |
| **Ollama** with `llama3.2` pulled (~2 GB) | latest | The local LLM the app calls |
| **Antigravity** | latest | Your IDE — bundles Gemini as your in-editor AI partner |

The full step-by-step install walk-through (macOS + Windows variants for every command) is in **[`docs/crash_course.md`](docs/crash_course.md) Module 0**. Do this *before* the live session — installs do not scale on a 40-person Zoom call.

Before class, run:

```bash
# macOS / Linux:
./scripts/verify_setup.sh
# Windows (PowerShell):
.\scripts\verify_setup.ps1
```

Eight green ✓ lines means you're ready. Each ✗ line tells you the exact one-line command to fix it.

## The 5-step Class Flow (same pattern in every module)

Every module's README opens with this same sequence. Adult learners find it easier when there's one shape:

1. **Open** the module's folder (`dist/module_NN_<slug>/`) in Antigravity.
2. **Run** it — paste the commands from the README's *Run* section into your terminal. See it work.
3. **Read** the changed file (usually `app/main.py`). The README points at exactly which file.
4. **Ask Gemini** to explain it — paste the README's **Primary prompt** into the Gemini chat panel. Read what Gemini says. Ask follow-ups.
5. **Answer the Defend It question** at the bottom yourself before moving on.

Optional 6th step for hands-on learners: **Tweak one thing** the module's README suggests (e.g. change the system prompt in Module 4, run a different SQL query in Module 5).

## How to use Gemini in Antigravity

Two surfaces, both available all the time:

- **Chat panel** (right side of Antigravity) — paste the **Primary prompt** from each module's README. Gemini explains the code Socratically: it'll usually ask you what you think before delivering the answer. Ask follow-ups freely.
- **Inline autocomplete** — as you type code, Gemini suggests completions. Suggestions stay scoped to whichever `dist/module_NN_*/` folder you have open, so you don't get Module 5's Postgres code while you're typing in Module 3.

Why does Gemini behave this way? Because two files in this repo — [`.agents/rules/doctrine.md`](.agents/rules/doctrine.md) and [`.agents/rules/curriculum-mode.md`](.agents/rules/curriculum-mode.md) — are loaded into Gemini's context whenever Antigravity opens the workspace. They are Gemini's "system prompt" for this course. Module 4 is when you'll build the same kind of file for `llama3.2`. The deepest moment in the course is when you realise you've been living inside one all morning.

## Module map

| Folder | Single fundamental |
|---|---|
| [`dist/module_00_setup/`](dist/module_00_setup/) | All dependencies must be reachable before any code runs |
| [`dist/module_01_hello_fastapi/`](dist/module_01_hello_fastapi/) | A web server is a long-running HTTP-listening process |
| [`dist/module_02_post_pydantic_echo/`](dist/module_02_post_pydantic_echo/) | Typed request/response — validation lives at the boundary |
| [`dist/module_03_call_ollama/`](dist/module_03_call_ollama/) | Your backend is a client of other local services |
| [`dist/module_04_system_prompt/`](dist/module_04_system_prompt/) | An LLM call is a list of messages with roles; the system message shapes every response |
| [`dist/module_05_save_postgres/`](dist/module_05_save_postgres/) | An application persists state in a database |
| [`dist/module_06_read_history/`](dist/module_06_read_history/) | An application reads state back from the database |
| [`dist/module_07_refactor_layers/`](dist/module_07_refactor_layers/) | A maintainable codebase separates concerns |
| [`dist/module_08_configuration/`](dist/module_08_configuration/) | Code = behaviour, env = environment; fail loudly on missing required vars |

The V1 final code lives at the root (`app/`) — it's the same as `dist/module_08_configuration/app/`. Run it from root any time with:

```bash
source venv/bin/activate
cp .env.example .env
uvicorn app.main:app --reload
```

Open <http://localhost:8000>.

## Self-paced reading

[`docs/crash_course.md`](docs/crash_course.md) is the single-file end-to-end narrative tutorial — ~2,000 lines that walk you from `python --version` through the V1 final state. Use it for:

- Pre-class install (Module 0 install walk-through, Windows + macOS inline)
- Catch-up if you miss a session
- Self-study if you're going through the course alone

Each module section in the crash course follows a consistent pattern: notional machine → analogy → full code → trace in execution order → predict before you run → why this design → verify → defend it.

## Publish your work

At the end of Module 8 you have a complete, working V1. The closing step of the course is to publish your version to your own GitHub as a portfolio piece. The walk-through (fresh `git init`, `gh repo create`, push) lives in the crash course's "Publish Your Work" appendix.

## Where to get help

- **In the live session:** ask Gemini first using your module's Primary prompt. If you're still stuck after 10 minutes, post a screenshot of the failing command in the cohort's async help channel and stay on the call.
- **Between sessions:** async help channel + your instructor's office hours.
- **If `verify_setup.sh` fails:** the script prints the exact one-line fix on the failing line. Paste it, re-run.

---

*If you're reading this from a download outside a cohort, welcome — the course works as a self-paced read using `docs/crash_course.md` plus the dist/ checkpoints.*

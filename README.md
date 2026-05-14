# Local LLM Question Log — cohort repo

A staged, hands-on course that builds the smallest serious AI web application — `Browser → FastAPI → Ollama → Postgres → Browser` — one fundamental at a time, across nine modules.

> **License:** [PolyForm Noncommercial 1.0.0](LICENSE). You may use this code freely for personal learning and non-commercial educational use (and you can publish your forked V1 as a portfolio piece per `docs/publish_your_work.md`). You may not use it as the curriculum for a fee-charging course. See [NOTICE.md](NOTICE.md) for plain-English allowed/not-allowed lists.

This repo is your starting point. You'll work through it module-by-module during the live session and on your own afterwards. By the end, you'll have built a working V1 you can publish to your own GitHub as a portfolio piece.

## Welcome

The course is designed for adult mid-career learners. You don't need to be an expert coder — you need to be willing to read code carefully, ask good questions, and build a mental model of how the pieces fit together. The AI partner in your IDE (Gemini in Antigravity) is configured to coach, not to do the work for you.

## Before class

**Do this once, at home, before the live session.** Installs do not scale on a 40-person Zoom call — anyone who arrives without these working will spend the live block catching up instead of learning.

**Single source of truth:** **[`docs/before_class.md`](docs/before_class.md)** is the full checklist — accounts to sign up for, mobile apps to install, AI partner apps, every tool with macOS + Windows commands, Antigravity install and GitHub-from-chat setup, both cohort repo clones, and a night-before verification. Work through it top to bottom; tick each box as you finish.

If anything fails: open the cohort folder in Antigravity, paste the failing line into the Gemini chat panel. Gemini has the doctrine + friction reducers loaded and will walk you through the fix. The live session's instructor is your last resort, not your first.

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

Why does Gemini behave this way? Because [`AGENTS.md`](AGENTS.md) at the root of this repo is loaded into Gemini's context whenever Antigravity opens the workspace. That file is Gemini's "system prompt" for this course. (Cursor and Claude Code also read `AGENTS.md` — same rules, any IDE.) Module 4 is when you'll build the same kind of file for `llama3.2`. The deepest moment in the course is when you realise you've been living inside one all morning.

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

At the end of Module 8 you have a complete, working V1. The closing step of the course is to publish your version to your own GitHub as a portfolio piece — your "I built this" you can show to recruiters and managers.

The walk-through is in **[`docs/publish_your_work.md`](docs/publish_your_work.md)** — ~30 minutes, copy-paste-ready commands for both macOS and Windows, a personal-README template you can adapt, and a list of meaningful next-step extensions (chat sessions, RAG, streaming, deploy).

## Where to get help

- **In the live session:** ask Gemini first using your module's Primary prompt. If you're still stuck after 10 minutes, post a screenshot of the failing command in the cohort's async help channel and stay on the call.
- **Between sessions:** async help channel + your instructor's office hours.
- **If `verify_setup.sh` fails:** the script prints the exact one-line fix on the failing line. Paste it, re-run.

---

*If you're reading this from a download outside a cohort, welcome — the course works as a self-paced read using `docs/crash_course.md` plus the dist/ checkpoints.*

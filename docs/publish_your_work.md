# Publish Your Work

You finished the course. You have a working V1 — `Browser → FastAPI → Ollama → Postgres → Browser`, end-to-end, every line of which you can explain. Now publish it to your own GitHub as a portfolio piece.

This is the closing exercise of the course. Allow about 30 minutes if it's your first GitHub push, faster if you've done one before.

## Why publish

You built something real. It's small, but it's serious — a typed REST API with persistence, a real LLM call, a sane refactor, and config-by-environment. Most "I learned to code" portfolio projects are tutorial clones with no ownership. Yours isn't. **You can defend every line.** That's what hiring managers want to see, and the only way to prove you have it is to put the code somewhere they can read it.

## What to publish

The V1 final code — the contents of your `dist/module_08_configuration/` folder. That's the working app.

- You **don't** publish the whole cohort repo (it's not yours; you cloned it).
- You **don't** publish all nine `dist/` checkpoints (a portfolio piece is one app, not a course archive).
- You publish the one thing you built.

If you tweaked anything during the course — changed `SYSTEM_PROMPT`, added a route, modified a query — keep your changes. They're proof of ownership.

## Pre-publish checklist

Before pushing anything to a public repo, confirm:

- [ ] **No secrets.** `.env` is in `.gitignore` (it is, in this cohort's setup). If you put any API keys or passwords anywhere else in the code, remove them.
- [ ] **The app works.** From the folder you're about to publish: `cp .env.example .env && uvicorn app.main:app --reload`. Open <http://localhost:8000> and ask one question. If it works, you're ready.
- [ ] **A personal README.** This is your portfolio piece's front page; it should explain what the app is, how to run it, and what you learned building it. Template below.
- [ ] **Decide visibility.** Public is the right default for a portfolio piece (recruiters need to read it). If you have a reason to start private, that's fine; flip later.

## Step-by-step

### 1. Move the folder you're publishing OUT of the cohort clone

The folder you've been working in (`<cohort-clone>/dist/module_08_configuration/`) sits inside the cohort's git repo. The cleanest way to publish your own version is to copy the folder somewhere outside the cohort clone first, so the new repo's history starts from scratch.

```bash
# macOS / Linux (Windows: run inside your Ubuntu/WSL2 terminal — same commands):
cp -R <cohort-clone>/dist/module_08_configuration ~/llm-question-log
cd ~/llm-question-log
```

The folder name (`llm-question-log` above) becomes your repo name later. Pick a name that signals "this is mine" — `local-llm-question-log`, `<your-name>-llm-app`, etc.

Confirm the folder has: `app/`, `sql/`, `scripts/`, `requirements.txt`, `.env.example`, `.gitignore`. If anything is missing, you may have copied the wrong folder.

### 2. Replace the README with your own

The current `README.md` is the course's per-module README. Replace it with your portfolio version. Template below — adapt freely:

```markdown
# Local LLM Question Log

A small FastAPI web app that asks a locally-running LLM (Ollama with `llama3.2`) a question and persists the conversation history in Postgres. Built as the capstone of the Local LLM Question Log course.

## What it does

- POST a question to `/ask` → backend calls a local LLM and returns the answer
- Every interaction (question, answer, timestamp, model) persists to Postgres
- The web UI shows the most recent ten interactions
- A `/healthz` endpoint reports reachability of Ollama and Postgres

## Stack

- **FastAPI** + **Uvicorn** — Python web server
- **Ollama** + **llama3.2** — local LLM runtime
- **Postgres** — interaction history
- **Pydantic** — typed request/response validation
- **Jinja2** + vanilla `fetch()` — the web UI

## Run it locally

Requires Python 3.11+, Postgres running on `localhost:5432`, and Ollama with `llama3.2` pulled (~2 GB).

\`\`\`bash
python3.11 -m venv venv
source venv/bin/activate
pip install -r requirements.txt
cp .env.example .env
uvicorn app.main:app --reload
\`\`\`

Open <http://localhost:8000>.

## What I learned

*(One or two paragraphs in your own words. Concrete examples: how a backend can be both a server and a client at the same time; why Pydantic models do double duty as validation AND auto-generated API docs; why failing loudly on a missing env var beats falling back to a default; what a system prompt actually is and how it shapes LLM responses.)*

## What's next

*(Optional. Extensions you're considering — chat sessions, RAG, streaming responses, deploying to Render or Fly.io, etc.)*
```

Save it as `README.md` in your new folder, replacing the existing file.

### 3. Fresh `git init`

You're publishing this folder as its own repo with no inherited history.

```bash
rm -rf .git    # safety net — only present if you copied from inside an existing git repo (Windows/WSL2: same command)

git init
git branch -M main
git add .
git commit -m "Initial commit — Local LLM Question Log V1"
```

### 4. Create the GitHub repo

Two paths — either works.

#### Option A — `gh` CLI (faster if you have it installed)

```bash
gh repo create <your-repo-name> \
  --public \
  --source=. \
  --remote=origin \
  --description "FastAPI + Ollama + Postgres question log — capstone of the Local LLM Question Log course"

git push -u origin main
```

If `gh` isn't installed, use Option B.

#### Option B — GitHub web UI

1. Go to <https://github.com/new>.
2. **Repository name:** `<your-repo-name>` (your choice).
3. **Description:** *"FastAPI + Ollama + Postgres question log — capstone of the Local LLM Question Log course"*
4. **Visibility:** Public.
5. **Initialize this repository with:** leave **all three checkboxes unchecked** — you already have files locally; checking them creates a merge conflict.
6. Click **Create repository**.

GitHub now shows you a "push an existing repository from the command line" snippet. Copy and run those three lines:

```bash
git remote add origin https://github.com/<your-username>/<your-repo-name>.git
git branch -M main
git push -u origin main
```

(The `git branch -M main` line is harmless if you already ran it in step 3.)

### 5. Confirm it's live

Open `https://github.com/<your-username>/<your-repo-name>` in your browser:

- Your README renders as the front page.
- The file tree shows `app/`, `sql/`, `scripts/`, `requirements.txt`, `.env.example`.
- **No `.env` is visible** (it's gitignored — confirm by looking).
- No `venv/`, no `__pycache__/` (also gitignored).

If you see `.env` in the file list, **immediately**:

```bash
git rm --cached .env
git commit -m "Remove accidentally committed .env"
git push
```

…and rotate any secrets that were inside it. (For this course there are no real secrets — `.env.example` is full of localhost defaults — but build the muscle now.)

### 6. Optional polish (~10 extra minutes, recommended)

- **Add a screenshot.** Run the app, ask one question, screenshot the page (textarea + answer + Recent list visible). Save as `screenshot.png` at the repo root. Reference from your README:
  ```markdown
  ![Local LLM Question Log](screenshot.png)
  ```
  Then `git add screenshot.png && git commit -m "Add screenshot" && git push`. Recruiters who skim READMEs spend more time on ones with images.

- **Add GitHub topics.** On the repo page, click the gear icon next to *About* (top right), add topics: `fastapi`, `ollama`, `llm`, `postgres`, `python`, `pydantic`. Makes the repo discoverable.

- **Pin it to your profile.** Go to your GitHub profile → *Customize your pins* → select this repo. Recruiters who land on your profile see it first instead of digging through old experiments.

## What to do next

The V1 you built is the foundation, not the destination. Pick one of these to extend it (each is a meaningful next step, not a tutorial copy-along):

- **Chat sessions.** Right now every question is independent. Add a `session_id`; the LLM sees the previous turns in that session. Teaches: state across requests, multi-message LLM calls.
- **RAG (retrieval-augmented generation).** Add a corpus of your own documents. Chunk, embed (with a local embedding model), store vectors in `pgvector`. Answer questions grounded in the docs. Teaches: vector search, embeddings, the most-asked architecture pattern in production AI apps.
- **Streaming responses.** Right now the user waits for the full answer. Stream tokens as Ollama generates them so the answer appears word by word. Teaches: SSE or WebSockets, browser streaming.
- **Deploy it.** Pick Render, Fly.io, Railway, or your favourite. Get the app running on the public internet at a URL you can share. Teaches: env vars in production, managed Postgres. (You'll discover Ollama is hard to deploy because LLM inference is heavy — that itself is a useful lesson.)

Whichever you pick: **it's a new repo, not this one.** You're building a portfolio of small serious things, not one ever-growing megaproject. Each new repo is another "I built this" you can defend.

---

*Need help mid-publish? Ask Gemini in Antigravity — `AGENTS.md` still applies in your cloned cohort folder. Or post in the cohort async channel.*

# Before Class — Setup Checklist

For two back-to-back courses:

1. **Local LLM Question Log** (FastAPI) — everything runs **LOCALLY** on your laptop: Python, the Postgres database, and the LLM (Ollama with `llama3.2`).
2. **Bedtime Story Generator** — everything runs in the **CLOUD**: Gemini API for the LLM, Render for the FastAPI backend + managed Postgres, Vercel for the frontend.

Setup below is the union for both. Items marked 🧸 apply to the bedtime course only.

Gemini API key creation is done together in class — §8 has the step-by-step for reference.

Tick each box as you finish it.

> **First time installing this stack?** This is the scannable checklist. If you've never installed Python, Postgres, or WSL2 before, read **[`docs/setup_walkthrough.md`](setup_walkthrough.md)** alongside this doc — it's the deeper hand-holding companion with expected-output examples at every step, a "what's a terminal?" pre-flight section, and a Common Failures section with 12+ specific failure modes. The two docs cover the same ground; this is the checklist version.

---

## 1. Accounts (sign up — no installs yet)

- [ ] **GitHub** — <https://github.com/signup>. Pick a sensible username. Turn on two-factor authentication when prompted.
- [ ] **Google** — <https://accounts.google.com/signup>. Skip if you already have one.
- [ ] **Claude** (Anthropic) — <https://claude.ai>. Free tier.
- [ ] **Perplexity** — <https://www.perplexity.ai>. Free tier.
- [ ] **ChatGPT** (OpenAI) — <https://chatgpt.com>. Free tier.
- [ ] 🧸 **Render** — <https://render.com>. Sign up using your GitHub account. **Render hosts both your FastAPI backend AND a managed Postgres database from the same account** — no separate Postgres provider needed. Free Postgres expires 30 days after creation; don't create yours pre-class — you'll create it together during bedtime Module 7.
- [ ] 🧸 **Vercel** — <https://vercel.com/signup>. Sign up using your GitHub account. Free Hobby tier.

## 2. GitHub mobile app (for two-factor authentication)

- [ ] iOS — <https://apps.apple.com/app/github/id1477376905>
- [ ] Android — <https://play.google.com/store/apps/details?id=com.github.android>
- [ ] Sign in with your GitHub account.
- [ ] Approve "use this device for two-factor authentication" when the app prompts.

## 3. AI partner apps (install all four)

- [ ] Claude — <https://claude.ai/download>
- [ ] ChatGPT — <https://chatgpt.com> → top-right menu → Download. Also on App Store / Play Store.
- [ ] Gemini — <https://gemini.google.com>. Sign in with your Google account. Mobile: iOS App Store / Google Play, search "Google Gemini".
- [ ] Perplexity — <https://www.perplexity.ai> → look for the Download link.

## 4. Windows users — install WSL2 first

**macOS users: skip this section — go to §5.**

You'll use WSL2 (Ubuntu inside Windows) as your primary terminal for the entire course. Native Windows PowerShell is used **exactly once** (here, to run `wsl --install`) and then never again — every command from §5 onward runs in your Ubuntu (WSL2) terminal.

- [ ] Open PowerShell **as administrator**: search "PowerShell" → right-click → **Run as administrator**.
- [ ] Run: `wsl --install`
- [ ] **Reboot** when prompted.
- [ ] After reboot, Ubuntu launches automatically. Create a **UNIX username and password** (no characters appear as you type the password — that's normal).
- [ ] Verify in Ubuntu: `uname -a` → output contains `Linux`.

**For every step below labeled "Linux / WSL2"** — open your **Ubuntu (WSL2) terminal** (Start menu → Ubuntu). The prompt ends in `$`. If your prompt ends in `>`, that's PowerShell — switch to Ubuntu.

Deeper walkthrough for WSL2 install + first-launch + the `~/code/` not `/mnt/c/` rule: [`docs/setup_walkthrough.md`](setup_walkthrough.md) §1.

## 5. Tools

### 5.1 Python (3.11, 3.12, or 3.13 — 3.12 is the sweet spot)

If you already have 3.11, 3.12, or 3.13 installed, **keep it** — no need to downgrade. The install commands below assume a fresh 3.12. ⚠ Python 3.14 may work but is bleeding-edge; if `pip install -r requirements.txt` in §7 fails for you with "no matching distribution", install 3.12 alongside and use that.

**macOS**
- [ ] `brew install python@3.12`
- [ ] Verify: `python3 --version` → `Python 3.12.x` (or 3.11.x / 3.13.x if you already had one).

**Linux / WSL2 on Windows** (in your Ubuntu terminal)
- [ ] `sudo apt update && sudo apt install -y python3 python3-venv python3-pip`
- [ ] Verify: `python3 --version` → `Python 3.12.x` (Ubuntu 24.04 default).
- [ ] **Note on PEP 668:** Ubuntu 24.04 blocks `pip install ...` outside a virtual environment by design. You'll always work inside a `venv` — that's what the course teaches.

### 5.2 Postgres 17

**macOS**
- [ ] `brew install postgresql@17`
- [ ] `brew services start postgresql@17`
- [ ] `psql -d postgres -c "CREATE USER postgres WITH PASSWORD 'postgres' SUPERUSER;"`
- [ ] Verify: `pg_isready -h localhost` → `accepting connections`

**Linux / WSL2 on Windows** (in your Ubuntu terminal — three apt commands, run one at a time)
- [ ] `sudo apt install -y postgresql-common`
- [ ] `sudo /usr/share/postgresql-common/pgdg/apt.postgresql.org.sh` (interactive — press **Enter** when prompted)
- [ ] `sudo apt install -y postgresql-17`
- [ ] Start + enable auto-start: `sudo systemctl start postgresql && sudo systemctl enable postgresql`
- [ ] Set the postgres password: `sudo -u postgres psql -c "ALTER USER postgres WITH PASSWORD 'postgres';"`
- [ ] Verify: `pg_isready -h localhost` → `accepting connections`

### 5.3 Ollama + the `llama3.2` model

**macOS**
- [ ] Download the `.dmg` from <https://ollama.com/download>. Requires macOS 14 Sonoma or later. Drag to Applications, open Ollama.
- [ ] `ollama pull llama3.2` (~2 GB download)
- [ ] Verify:
  ```bash
  curl -s -X POST http://localhost:11434/api/chat -H "Content-Type: application/json" \
    -d '{"model":"llama3.2","messages":[{"role":"user","content":"hi"}],"stream":false}' | head -3
  ```
  Expected: JSON response with a `message` field.

**Linux / WSL2 on Windows** (in your Ubuntu terminal)
- [ ] Install: `curl -fsSL https://ollama.com/install.sh | sh`
- [ ] Start + enable: `sudo systemctl start ollama && sudo systemctl enable ollama`
- [ ] `ollama pull llama3.2` (~2 GB download)
- [ ] Verify (same curl as above).

**Want faster inference using your GPU?** See [`docs/setup_walkthrough.md`](setup_walkthrough.md) **Appendix — Optional: Run Ollama on the Windows host for GPU acceleration**. Default WSL2 install is CPU-only but adequate for the course.

### 5.4 Git

**macOS**
- [ ] Pre-installed. Verify: `git --version`

**Linux / WSL2 on Windows** (in your Ubuntu terminal)
- [ ] Verify first: `git --version`. If you see a version, you're done.
- [ ] If missing: `sudo apt install -y git`

### 5.5 GitHub CLI (`gh`)

This is the tool Antigravity uses to authenticate to GitHub for push and pull.

**macOS**
- [ ] `brew install gh`
- [ ] Verify: `gh --version`

**Linux / WSL2 on Windows** (in your Ubuntu terminal)

The current 2026 install requires a multi-line apt setup. **Select the entire code block below, copy it, paste it into your Ubuntu terminal once, then press Enter.** Do not paste line by line.

The `\` at the end of each line is a bash "line continuation" — it tells the shell *"this command continues on the next line, don't execute yet."* Pasted as one block, bash treats the whole thing as a single command and runs the steps one after another. Expect ~30-60 seconds of output as it sets up the GitHub apt repository, downloads the keyring, and installs `gh`.

```bash
(type -p wget >/dev/null || (sudo apt update && sudo apt install wget -y)) \
  && sudo mkdir -p -m 755 /etc/apt/keyrings \
  && out=$(mktemp) && wget -nv -O$out https://cli.github.com/packages/githubcli-archive-keyring.gpg \
  && cat $out | sudo tee /etc/apt/keyrings/githubcli-archive-keyring.gpg > /dev/null \
  && sudo chmod go+r /etc/apt/keyrings/githubcli-archive-keyring.gpg \
  && sudo mkdir -p -m 755 /etc/apt/sources.list.d \
  && echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | sudo tee /etc/apt/sources.list.d/github-cli.list > /dev/null \
  && sudo apt update \
  && sudo apt install gh -y
```

**Escape hatch — if you accidentally pasted line by line:** your prompt changes from `$` to `>` (bash's "continuation prompt", waiting for the rest). Just keep pasting the remaining lines into that `>` prompt. The block still executes when the last line (with no trailing `\`) is reached. If you panic and press `Ctrl+C` to escape, you'll need to start over from the top.

- [ ] Verify: `gh --version` → `gh version 2.x.x`

## 6. Google Antigravity (IDE)

### 6.1 Install and sign in

- [ ] Download — <https://antigravity.google/download>. Latest stable: **v1.23.2** (April 2026). Mac (.dmg), Windows (.exe), Linux.
- [ ] Install. Requires macOS 12+ or Windows 10+.
- [ ] **First-launch wizard** — recommended choices:
  - Setup flow: **Fresh start**
  - Theme: your choice
  - Agent autonomy: **Review-driven** (Gemini suggests changes; you approve each one — matches the course's "see every change" philosophy)
  - Editor configuration: accept defaults
  - Google authentication: sign in with your Google account
  - Terms acceptance: accept
- [ ] Open the chat panel: `Cmd+L` (macOS) or `Ctrl+L` (Windows/Linux).
- [ ] Type `hello` and press Enter. Confirm Gemini replies.

### 6.2 Windows users — connect Antigravity to WSL2

- [ ] In Antigravity, press `Ctrl+Shift+P` → type `wsl` → pick **Remote-WSL: Connect to WSL**.
- [ ] Bottom-left of the window should now show `WSL: Ubuntu`. All file-open and integrated-terminal actions are now in your WSL2 distro.

### 6.3 Connect Antigravity to GitHub (so Gemini can push and pull from chat)

- [ ] Open Antigravity's **integrated terminal** — top menu **View → Terminal**, or `` Ctrl+` `` (backtick). On Windows + WSL2 connected, this is an Ubuntu bash prompt.
- [ ] Run:
  ```bash
  gh auth login
  ```
- [ ] Answer the interactive prompts in this exact order:
  - **What account?** → `GitHub.com`
  - **Preferred protocol?** → `HTTPS`
  - **Authenticate Git with your GitHub credentials?** → `Yes`
  - **How would you like to authenticate?** → `Login with a web browser`
- [ ] The terminal prints an **8-character one-time code** (e.g. `XXXX-XXXX`). Copy it.
- [ ] Browser opens to <https://github.com/login/device>. Paste the code, approve permissions.
- [ ] Your phone buzzes — open the GitHub mobile app and tap **Approve**.
- [ ] Back in the terminal: `✓ Authentication complete` and `✓ Configured git protocol`.

After this, `git push` from the integrated terminal AND Gemini-driven git commands from the chat panel both work without further prompts.

### 6.4 Confirm Gemini can push code from chat (sandbox test)

- [ ] In your **Ubuntu (WSL2) terminal** (Windows) or **macOS Terminal**, create a sandbox:
  ```bash
  mkdir ~/antigravity-test && cd ~/antigravity-test
  echo "hello" > note.txt
  git init && git add . && git commit -m "first"
  ```
- [ ] Open the `antigravity-test` folder in Antigravity (**File → Open Folder**). Windows: confirm Remote-WSL is connected first (see §6.2).
- [ ] Paste into Gemini chat:
  > *"Add a line 'world' to note.txt, commit the change, create a new public GitHub repo for this folder under my account, and push."*
- [ ] Gemini should run the commands directly in the integrated terminal (`gh repo create`, `git remote add`, `git push -u origin main`).
- [ ] Open your GitHub profile in a browser. Confirm the new `antigravity-test` repo exists with two commits.
- [ ] If Gemini only prints commands as text for you to copy-paste, message the instructor before class.
- [ ] (Optional cleanup) `gh repo delete <your-username>/antigravity-test --yes`

## 7. Clone the cohort repos and verify

### 7.1 Pick a path

**macOS**
- [ ] `~/code/` or `~/dev/`. Create if it doesn't exist:
  ```bash
  mkdir -p ~/code && cd ~/code
  ```

**Linux / WSL2 on Windows** (in your Ubuntu terminal)
- [ ] **Use `~/code/` inside Ubuntu, NOT `/mnt/c/...`** — Python on `/mnt/c/` is 10-50x slower.
  ```bash
  mkdir -p ~/code && cd ~/code
  ```

### 7.2 Clone the FastAPI cohort + database + verify

Same commands on both platforms:

- [ ] Clone:
  ```bash
  git clone https://github.com/SwarupSG/fastapi-ollama-postgres-cohort.git
  cd fastapi-ollama-postgres-cohort
  ```
  Your phone will buzz — approve via the GitHub mobile app.
- [ ] Create the database:
  ```bash
  createdb llm_question_log
  ```
- [ ] Apply the schema:
  ```bash
  psql -d llm_question_log -f sql/001_create_interactions.sql
  ```
- [ ] Run the verify script:
  ```bash
  ./scripts/verify_setup.sh
  ```
- [ ] Confirm 8 green ✓ lines ending with **"All checks passed. You're ready for Module 1."**

### 7.3 🧸 Clone the bedtime cohort

- [ ] From the same parent (`~/code/`):
  ```bash
  cd ~/code
  git clone https://github.com/SwarupSG/bedtime-story-generator-cohort.git
  cd bedtime-story-generator-cohort
  ls
  ```
- [ ] Expected: a folder listing similar to the FastAPI cohort — `app/`, `dist/`, `frontend/`, `scripts/`, `README.md`, `AGENTS.md`, etc.
- [ ] **No further pre-class action required.** Bedtime-specific database setup, schema, `.env` file, Gemini API key, and Render+Vercel deploy are all covered live in the bedtime sessions.

## 8. 🧸 Gemini API key (done together in class)

Reference only — created live in the first bedtime session.

1. Open <https://aistudio.google.com/apikey>.
2. Sign in with the same Google account you used for Antigravity.
3. Accept the Terms of Service. AI Studio creates a default Google Cloud project and an API key in one step. **No billing setup needed for free-tier use.**
4. Copy the key. It starts with `AIza...`.
5. **Save it in a password manager.** Don't paste into chats, screenshot it, or commit it to a public repo.
6. Verify the key works (substitute `<YOUR_KEY>`):
   ```bash
   curl -s "https://generativelanguage.googleapis.com/v1beta/models?key=<YOUR_KEY>" | head -5
   ```
   Expected: a JSON list of models.
7. Free-tier rate limits for your account — <https://aistudio.google.com/rate-limit>.

## 9. 🧸 Connect Render and Vercel to GitHub

### Render ↔ GitHub

- [ ] Sign in — <https://dashboard.render.com>
- [ ] Top right: **+ New** → **Web Service**.
- [ ] Click the **GitHub** card → approve the OAuth permissions.
- [ ] You should see a list of your GitHub repos. Back out (no deploy yet).

**What to expect from the Render free Web Service tier in Module 7:** the running FastAPI app sleeps after 15 minutes of inactivity. The first request after sleep takes 30-60 seconds to wake up. This is normal — the bedtime course's deploy guide narrates it. Knowing it's expected prevents mid-class panic.

### Vercel ↔ GitHub

- [ ] Sign in — <https://vercel.com/dashboard>
- [ ] Top right: **Add New** → **Project**.
- [ ] Click **Install** under the GitHub heading → approve the OAuth permissions.
- [ ] Back out (no project yet).

**Bedtime Module 7 deploy walkthrough:** the click-by-click is in your bedtime cohort clone at `dist/module_07_deploy_vercel/README.md` (the 5-phase summary you work from live) plus a deeper PDF (`deploy_guide.pdf`) distributed by the instructor in class — same out-of-band pattern as the crash course PDF.

## 10. Final check (night before the first session)

Run all five. All must pass.

- [ ] **Python on PATH** — `python3 --version` → `3.11.x`, `3.12.x`, or `3.13.x`
- [ ] **Postgres reachable** — `pg_isready -h localhost` → `accepting connections`
- [ ] **Ollama running with model pulled** — the smoke curl from §5.3 returns JSON with a `message` field
- [ ] **Cohort verify** — from inside the FastAPI cohort clone: `./scripts/verify_setup.sh` → 8 green ✓
- [ ] **Antigravity ready** — open the FastAPI cohort folder. (Windows: Remote-WSL connected first, see §6.2.) Type `what's in this folder?` in the Gemini chat panel. Gemini replies with a directory listing.

## 11. If anything fails

1. Open the cohort folder in Antigravity. Paste the failing command + its error into the Gemini chat panel. Gemini has `AGENTS.md` loaded and knows the curriculum's friction reducers.
2. If Gemini's fix doesn't work, post a screenshot of the failing command + error in the cohort async help channel.
3. The live session is the last resort. Arrive ready.

Deeper troubleshooting (12+ specific failure modes with one-line fixes, plus an "if you have 8 GB RAM" appendix once we publish it): [`docs/setup_walkthrough.md`](setup_walkthrough.md) §10.

# Setup Walkthrough — the deep companion to Before Class

This is the **hand-holding** install guide. If you've installed Python and Postgres before and just want a checklist, use [`before_class.md`](before_class.md) — it's the scannable version. If you're new to development tooling, read this top-to-bottom. Every step has an "expected output" line so you can tell whether it actually worked before moving on.

This doc covers two back-to-back courses:

1. **Local LLM Question Log** (FastAPI) — everything runs **LOCALLY** on your laptop: Python, the Postgres database, the LLM (Ollama with `llama3.2`).
2. **Bedtime Story Generator** — everything runs in the **CLOUD**: Gemini API, Render for the backend, Vercel for the frontend.

Items used by the bedtime course only are flagged with **🧸 Bedtime**. The bulk of the setup is shared.

Install commands here were verified against current official sources in May 2026. If a command behaves differently for you, check the upstream docs (linked at each section's end) — the technology stack moves fast.

---

## 0. Pre-flight — what's a terminal?

You'll spend the course in two tools: an editor (Google Antigravity) and a **terminal** (a window where you type commands). If you've never used a terminal before, read this section once.

You'll use **one** terminal throughout the course:

- **macOS students:** Terminal.app — your only terminal.
- **Windows students:** the **Ubuntu (WSL2) terminal** — your only terminal for everything course-related. You'll install it in §1. Once installed, you open it from the Start menu like any other app. PowerShell exists only for **one** moment (the `wsl --install` command in §1.1) — after that you never touch PowerShell again for this course.

Why this matters: WSL2 (Windows Subsystem for Linux 2) gives Windows users a real Ubuntu Linux environment, so Windows and Mac students run identical Linux-style commands (`sudo apt install ...`, `python3 ...`, `psql ...`) once you're in the Ubuntu terminal. No native-Windows installers, no PowerShell-specific syntax, no two-platform-command-versions to remember.

### macOS — opening Terminal.app

- Press `Cmd + Space`, type `Terminal`, press Enter.
- A black window opens with a prompt like `username@MacBook-Pro ~ %`.
- That `%` (or `$`) is the **prompt** — the terminal is waiting for you to type a command.

### Windows — opening your terminals (preview only — install happens in §1)

You'll meet two terminals on Windows. After §1's one-time setup, you only use the second one.

| Terminal | When you use it | How to open it | Prompt looks like |
|---|---|---|---|
| **PowerShell (admin)** | **Exactly once** in §1.1 to run `wsl --install`. Never again. | Search "PowerShell" in Start → right-click → **Run as administrator** | `PS C:\Windows\System32>` |
| **Ubuntu (WSL2) terminal** | **Everywhere else** in this course | Search "Ubuntu" in Start, click it. *Or:* search "Terminal" in Start (Windows Terminal app), click the ⌄ arrow next to the tab + sign, pick **Ubuntu**. | `yourname@yourpc:~$` |

If at any later step you're unsure which terminal you're in, look at the prompt:
- Ends in `$` → Ubuntu/WSL2 ✓
- Ends in `>` → PowerShell ✗ (almost certainly the wrong one — switch to Ubuntu)

### How to paste a command

- **macOS Terminal:** `Cmd + V`
- **Ubuntu (WSL2) terminal:** `Ctrl + Shift + V` (regular `Ctrl + V` does something else in Linux terminals — old habit)
- **Windows PowerShell:** `Ctrl + V` or right-click

### "Command not found" errors

When you type a command and the terminal says `<command>: command not found`, it means the program isn't installed yet OR isn't on your PATH (the list of folders the terminal looks in for programs). Both are fixable — every install step below ends with a verify line that should NOT say "command not found." If yours does, the install didn't complete; redo it.

### Disk space + RAM check

- **macOS:** Apple menu → About This Mac. Confirm at least 5 GB free disk space and 8 GB RAM.
- **Windows:** Settings → System → About. Same numbers.

If you're at 8 GB RAM, finish the main install first; we have an older-hardware addon doc with extra tuning if you need it.

---

## 1. Windows users: install WSL2 first

WSL2 (Windows Subsystem for Linux 2) lets you run a real Ubuntu Linux environment inside Windows. This course uses Linux commands throughout — installing WSL2 means a Windows student follows the same `apt install ...` commands a Linux user would, instead of fighting different native Windows installers per tool.

**macOS users: skip this section — go to §2.**

### 1.1 Install WSL2 + Ubuntu

1. Open PowerShell **as administrator** (right-click → Run as administrator).
2. Run:
   ```powershell
   wsl --install
   ```
3. Expected output: a series of "Installing: ..." lines. The command:
   - Enables the WSL feature in Windows
   - Installs the WSL2 kernel
   - Downloads Ubuntu 24.04 LTS (the current default)
4. **Reboot your laptop** when prompted. The install isn't complete until you reboot.
5. After reboot, Ubuntu launches automatically and asks you to **create a UNIX username and password**. This is a separate account from your Windows login — pick anything you'll remember; the password is what you type for `sudo`. There's no on-screen feedback as you type the password — that's normal in Linux.
6. You should land at a prompt like `swarup@yourpc:~$`. That's your Ubuntu shell.

Verify:
```bash
uname -a
# Expected: Linux ... GNU/Linux (the "Linux" word is what you're looking for)

cat /etc/os-release | head -2
# Expected: PRETTY_NAME="Ubuntu 24.04 LTS" (or similar)
```

Source: [WSL install — Microsoft Learn](https://learn.microsoft.com/en-us/windows/wsl/install)

### 1.2 Where to keep your project files

**Always work in the WSL filesystem**, e.g. `~/code/` inside Ubuntu. NEVER work in `/mnt/c/...` (which is a slow bridge to your Windows drive).

```bash
mkdir -p ~/code
cd ~/code
pwd
# Expected: /home/yourname/code
```

Reasons matter to your time: Python's `pip install`, Postgres data, and any file watching are 10-50x slower when files live on `/mnt/c/`. Stick to `~/code/` and the course will be smooth.

To access your WSL files from Windows File Explorer (when you need to): in the Explorer address bar, paste `\\wsl$\Ubuntu\home\yourname\code` (replace `yourname` with your UNIX username).

### 1.3 How to recognise you're in the Ubuntu (WSL2) terminal

From §2 onward, every command in this doc runs in your **Ubuntu (WSL2) terminal** (Windows students) or **Terminal.app** (macOS students). PowerShell is done with — you used it once in §1.1, and you won't use it again for the course.

If at any later step you're unsure where you are, glance at the prompt:

| Prompt | Where you are | What it's good for |
|---|---|---|
| `yourname@yourpc:~$` (ends in `$`, Linux-style) | **Ubuntu (WSL2) terminal** ✓ | Everything in §3-§11 below |
| `username@MacBook ~ %` (ends in `%`, also fine — that's zsh on macOS Terminal) | **macOS Terminal** ✓ | Everything in §3-§11 below for Mac users |
| `PS C:\Users\yourname>` (starts with `PS`, ends in `>`) | **Windows PowerShell** ✗ | You're in the wrong terminal — switch to Ubuntu |

How to open the Ubuntu (WSL2) terminal again next session: Start menu → click **Ubuntu**. *Or:* open the Windows Terminal app, click the ⌄ arrow next to the tab `+` sign, pick **Ubuntu**.

**One-second test before you paste a command:** prompt ends in `$` (or `%` on Mac) → ✓ paste. Prompt ends in `>` → ✗ switch terminals first.

If you accidentally run an Ubuntu command in PowerShell, you'll see `<command> : The term '<command>' is not recognized as the name of a cmdlet, function, script file, or operable program.` That's PowerShell telling you you're in the wrong place. Switch to Ubuntu and rerun.

---

## 2. macOS users: install Homebrew

Homebrew is the macOS package manager. Skip this section if you already have it (`brew --version` works).

Install one-liner (from <https://brew.sh>):
```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

You'll be asked for your Mac password. The install takes 5-10 minutes.

After install, follow the on-screen "Next steps" — usually two `echo` lines to add Homebrew to your PATH, then `eval "$(/opt/homebrew/bin/brew shellenv)"`. Run those.

Verify:
```bash
brew --version
# Expected: Homebrew 4.x.x
```

**Apple Silicon vs Intel:**
- Apple Silicon (M1, M2, M3, M4): Homebrew installs to `/opt/homebrew/`
- Intel: Homebrew installs to `/usr/local/`

Both work identically once installed; the path just differs. If a later command can't find `brew`, run the `eval ...shellenv` line again or open a fresh Terminal window.

Source: [Homebrew](https://brew.sh)

---

## 3. Python 3.12

**Version policy:** Python **3.11, 3.12, or 3.13** all work for this course. **3.12 is the sweet spot** — Ubuntu 24.04 ships it by default (WSL2 students get it for free), and every pinned package in the course's `requirements.txt` has a binary wheel for 3.12. If you already have 3.11 or 3.13 installed, **keep it — no need to downgrade**. The install commands below assume a fresh 3.12 install; skip to the verify step at the end of your platform's subsection if you already have an acceptable version.

> **⚠ Python 3.14 caveat.** 3.14 is bleeding-edge (released Oct 2025) — some package wheels (notably `psycopg[binary]`) may not be published for 3.14 yet by your cohort start date. If you have 3.14 and want to try it, run `pip install -r requirements.txt` once you've cloned the cohort repo (§8) to test compatibility. If it fails with `no matching distribution`, install Python 3.12 alongside — `brew install python@3.12` on macOS, `sudo apt install python3.12` on Ubuntu/WSL2 — and use that instead.

### macOS

```bash
brew install python@3.12
```

Expected: Homebrew downloads and installs Python. After it finishes:
```bash
python3 --version
# Expected: Python 3.12.x
```

If `python3` doesn't resolve to 3.12 (some Macs have an older Python pre-installed), use `python3.12` explicitly for the verify and in commands later — or run `brew link --force python@3.12` to make `python3` point at the new install.

### Linux / WSL2 on Windows

**Terminal:** Open your **Ubuntu (WSL2) terminal** — Start menu → Ubuntu. The prompt should end in `$` (e.g. `swarup@yourpc:~$`). All commands below run inside this terminal — **NOT** in PowerShell.

```bash
sudo apt update
sudo apt install -y python3 python3-venv python3-pip
```

(When prompted for a password, type your **Ubuntu** password from §1.1 — not your Windows password. No characters appear as you type; that's normal.)

Expected: a list of packages being installed. Ubuntu 24.04 ships Python 3.12.3 as the default `python3`.

Verify (still inside the Ubuntu terminal):
```bash
python3 --version
# Expected: Python 3.12.3 (or later 3.12.x)

python3 -m venv --help | head -1
# Expected: usage: venv [-h] [...]
```

**A note about PEP 668 on Ubuntu 24.04:** if you try `pip install something` outside a virtual environment, Ubuntu blocks it with an "externally-managed-environment" error. This is intentional — it forces you to work inside a `venv`, which is exactly what this course teaches. You'll create a venv in every module.

Source: [Ubuntu 24.04 python3 package](https://packages.ubuntu.com/noble/python3)

---

## 4. Postgres 17

### macOS

```bash
brew install postgresql@17
brew services start postgresql@17
```

Expected: install + a "Successfully started postgresql@17" line.

Then create the `postgres` superuser the course expects (Homebrew Postgres only makes an OS-named role by default):
```bash
psql -d postgres -c "CREATE USER postgres WITH PASSWORD 'postgres' SUPERUSER;"
```

Expected: `CREATE ROLE` (or `ERROR: role "postgres" already exists` — that's harmless, your `postgres` user is already there, move on).

Verify:
```bash
pg_isready -h localhost
# Expected: localhost:5432 - accepting connections
```

### Linux / WSL2 on Windows

**Terminal:** all commands in this section run inside your **Ubuntu (WSL2) terminal** (Start menu → Ubuntu; prompt ends in `$`). **Not PowerShell.**

The official PostgreSQL apt repository gives version-pinned packages. Three commands — run them one at a time and wait for each to finish.

**Command 1 — install the helper package:**
```bash
sudo apt install -y postgresql-common
```
Expected: installs `postgresql-common` and a few dependencies. Takes 10-30 seconds.

**Command 2 — run the official PostgreSQL apt setup script:**
```bash
sudo /usr/share/postgresql-common/pgdg/apt.postgresql.org.sh
```
The script is **interactive** — when it asks `Press Enter to continue or Ctrl-C to cancel`, press **Enter**. It adds the postgresql.org repository to your Ubuntu apt sources.

Expected last line: something like `You can now start installing packages from apt.postgresql.org.`

**Command 3 — install PostgreSQL 17:**
```bash
sudo apt install -y postgresql-17
```
Expected: installs Postgres 17 and its dependencies. Takes 30-60 seconds.

**Start the Postgres service.** Fresh Ubuntu 24.04 from `wsl --install` has systemd enabled by default, so:
```bash
sudo systemctl start postgresql
sudo systemctl enable postgresql
```
Expected: no output (silent success). The second command tells systemd to start Postgres automatically next time you open Ubuntu.

*Fallback:* if the first `systemctl` line errors with `System has not been booted with systemd` — rare on fresh `wsl --install` instances but possible on older WSL2 setups — use this instead:
```bash
sudo service postgresql start
```

**Set the `postgres` user's password to `postgres` (the value the course expects):**
```bash
sudo -u postgres psql -c "ALTER USER postgres WITH PASSWORD 'postgres';"
```
Expected: `ALTER ROLE`.

**Verify (still inside the Ubuntu terminal):**
```bash
pg_isready -h localhost
```
Expected: `localhost:5432 - accepting connections`

Source: [PostgreSQL on Ubuntu](https://www.postgresql.org/download/linux/ubuntu/) · [WSL systemd — Microsoft Learn](https://learn.microsoft.com/en-us/windows/wsl/systemd)

---

## 5. Ollama + the `llama3.2` model

Note on what the course code expects: the FastAPI code (every module) calls Ollama at `http://localhost:11434`. Wherever Ollama runs, as long as it answers on that address from inside the same terminal context as your FastAPI app, the course code is unchanged.

### macOS

**Terminal:** macOS Terminal.app.

1. Download the `.dmg` from <https://ollama.com/download>. Requires macOS 14 Sonoma or later.
2. Drag the Ollama icon to Applications.
3. Open Ollama from Applications. The first launch installs the command-line tool and starts the background service automatically.

Pull the model (one-time, ~2 GB download):
```bash
ollama pull llama3.2
```

Expected: a progress bar, then `success`.

Verify:
```bash
curl -s -X POST http://localhost:11434/api/chat \
  -H "Content-Type: application/json" \
  -d '{"model":"llama3.2","messages":[{"role":"user","content":"hi"}],"stream":false}' \
  | head -3
```

Expected: a JSON response with a `message` field containing text from the model.

### Linux / WSL2 on Windows

**Terminal:** your **Ubuntu (WSL2) terminal** (Start menu → Ubuntu; prompt ends in `$`). All commands below run inside Ubuntu — **NOT** in PowerShell.

Install Ollama inside WSL2 with the official one-liner:
```bash
curl -fsSL https://ollama.com/install.sh | sh
```

Expected: a progress display, then a "Installation complete" message. The installer puts the `ollama` binary on your PATH.

**Start the Ollama service.** Ubuntu 24.04 from `wsl --install` has systemd enabled by default:
```bash
sudo systemctl start ollama
sudo systemctl enable ollama
```

Expected: no output (silent success). The second command makes Ollama auto-start each time you open your Ubuntu terminal — so you don't have to start it manually every session.

*Fallback:* if `systemctl` errors with `System has not been booted with systemd`, use `sudo service ollama start` instead. For auto-start across WSL restarts you'd then need to enable systemd in `/etc/wsl.conf` per §1.

Pull the model (one-time, ~2 GB download):
```bash
ollama pull llama3.2
```

Expected: a progress bar, then `success`.

Verify (still inside the Ubuntu terminal):
```bash
curl -s -X POST http://localhost:11434/api/chat \
  -H "Content-Type: application/json" \
  -d '{"model":"llama3.2","messages":[{"role":"user","content":"hi"}],"stream":false}' \
  | head -3
```

Expected: a JSON response with a `message` field containing text from the model.

A note on performance: Ollama running inside WSL2 uses **CPU only** — no GPU acceleration even if your laptop has an NVIDIA or AMD card. Inference is fine for the course (Module 4 system-prompt experiments, the curl drill) — responses take ~5-20 seconds depending on your CPU. If you have a GPU and want faster inference, see the **Appendix** at the bottom of this doc for the optional "Ollama on Windows host" setup.

Source: [Ollama download](https://ollama.com/download) · [Ollama Linux install](https://ollama.com/install.sh) · [Ollama library — llama3.2](https://ollama.com/library/llama3.2)

---

## 6. Git + GitHub CLI

### Git

**macOS:** pre-installed. Verify:
```bash
git --version
# Expected: git version 2.x.x
```

**Linux / WSL2:** in your **Ubuntu (WSL2) terminal** (Start menu → Ubuntu; prompt ends in `$`), check first:
```bash
git --version
# If you see "git version 2.x.x" — you already have it. Move on.
# If you see "command not found" — install it:
sudo apt install -y git
git --version
```

### GitHub CLI (`gh`)

Used in §7.2 to authenticate Antigravity to GitHub.

**macOS:**
```bash
brew install gh
gh --version
```

**Linux / WSL2:** in your **Ubuntu (WSL2) terminal** (Start menu → Ubuntu; prompt ends in `$`).

The current 2026 apt setup is multi-line. **Select the entire block below, copy it, paste into the terminal once, then press Enter.** Do not paste line by line.

The `\` at the end of each line is a bash *line continuation* — it tells the shell "this command continues on the next line, don't execute yet." Pasted as a single block, bash treats the whole thing as one command and runs the steps in order. Expect ~30-60 seconds of output as it sets up the GitHub apt repository, downloads the keyring, and installs `gh`.

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

**Escape hatch — if you accidentally pasted line by line:** your prompt changes from `$` to `>` (bash's "continuation prompt", waiting for the rest of the command). Just keep pasting the remaining lines into that `>` prompt. The block still executes once you paste the last line (the one with no trailing `\`). If you panic and `Ctrl+C` to escape, restart from the top of the block.

Verify (still in Ubuntu terminal):
```bash
gh --version
# Expected: gh version 2.x.x
```

Source: [gh CLI install_linux.md](https://github.com/cli/cli/blob/trunk/docs/install_linux.md)

---

## 7. Google Antigravity (the IDE you'll use for the course)

### 7.1 Download and install

1. Go to <https://antigravity.google/download>.
2. The page detects your OS and offers a matching installer:
   - **macOS:** `.dmg` file (~150-200 MB). Open it, drag Antigravity to Applications.
   - **Windows:** `.exe` installer. Run it.
   - **Linux:** `.deb` or `.AppImage`. (Cohort students on WSL2 install the Windows `.exe`, NOT the Linux variant — Antigravity runs on Windows and connects to your WSL2 distro via the Remote-WSL feature in §7.4.)
3. Latest stable version is **v1.23.2** (April 2026). The product is in public preview — free, no waitlist.

### 7.2 First-launch wizard

When you open Antigravity for the first time, it walks you through a setup wizard. Recommended choices:

| Wizard screen | Choose | Why |
|---|---|---|
| **Setup flow** | "Fresh start" (don't import from VS Code/Cursor unless you've used them and want your settings carried over) | Avoids carrying old extensions that may conflict |
| **Theme** | Pick what you like — Dark or Light | Cosmetic |
| **Agent autonomy** | **Review-driven** | Gemini suggests changes; you approve each one before it lands. Matches the course's "see every change, defend every line" philosophy. *Avoid Agent-driven for now — it executes autonomously, which is powerful but risky while you're still building intuition.* |
| **Editor configuration** | Accept defaults | Can change later |
| **Google authentication** | Sign in with your personal Google account | Required — gives Antigravity access to Gemini |
| **Terms acceptance** | Accept | Required |

After the wizard you land on the Agent Manager — the main Antigravity surface.

### 7.3 Confirm Gemini is working

Press `Cmd + L` (macOS) or `Ctrl + L` (Windows/Linux) to toggle the chat panel. Type `hello` and press Enter. Gemini should reply within a few seconds.

If you see a sign-in prompt instead, click through it to authenticate.

### 7.4 Windows / WSL2 — connect to your WSL2 distro

Antigravity has built-in WSL2 integration. To open a folder that lives inside Ubuntu (your `~/code/` directory):

1. Press `Ctrl + Shift + P` to open the command palette.
2. Type `wsl` and pick **Remote-WSL: Connect to WSL**.
3. Antigravity reconnects to your Ubuntu distro. The bottom-left corner of the window will show `WSL: Ubuntu`.
4. Now use **File → Open Folder** and navigate to your `code` directory inside Ubuntu (path will look like `/home/yourname/code`).

If `Remote-WSL: Connect to WSL` is missing from the command palette: confirm `wsl --status` works in PowerShell. If it doesn't, redo §1.

**macOS students: skip this step — your filesystem is already directly usable.**

### 7.5 Hook Antigravity up to GitHub

So Gemini can run `git push` / `git pull` from the chat panel without you typing in the terminal.

1. Open Antigravity's **integrated terminal** — top menu **View → Terminal**, or keyboard `` Ctrl + ` `` (backtick). On Windows + WSL2 this opens an Ubuntu bash prompt; on macOS it opens your default shell.
2. In the integrated terminal, run:
   ```bash
   gh auth login
   ```
3. Answer the interactive prompts in this exact order:
   - **What account do you want to log into?** → `GitHub.com`
   - **What is your preferred protocol for Git operations on this host?** → `HTTPS`
   - **Authenticate Git with your GitHub credentials?** → `Yes`
   - **How would you like to authenticate GitHub CLI?** → `Login with a web browser`
4. The terminal prints an **8-character one-time code** (e.g. `XXXX-XXXX`). Copy it.
5. A browser tab opens at <https://github.com/login/device>. If not, open the URL manually.
6. Paste the 8-character code. Click **Continue**.
7. Approve the permissions. Your phone buzzes — open the GitHub mobile app and tap **Approve**.
8. Back in the Antigravity terminal you should see `✓ Authentication complete` and `✓ Configured git protocol`.

After this, `git push` from the integrated terminal AND Gemini-driven git commands from the chat panel both work without further prompts.

### 7.6 What `AGENTS.md` is and why you'll see references to it

The cohort repo (which you'll clone in §8) has a file called `AGENTS.md` at its root. When you open the cohort folder in Antigravity, Gemini reads this file as its system prompt for the entire course — it tells Gemini to coach you rather than solve problems for you, to refuse to skip ahead modules, and to push back on doctrine-violating code suggestions.

You don't configure this yourself. It just works when you open the cohort folder. Module 4 of the course is when you'll notice it — there's a moment where we open `AGENTS.md` together and realise Gemini has been running on the same kind of "system prompt" we're teaching you to write for `llama3.2`.

Source: [Antigravity (Google)](https://antigravity.google) · [AGENTS.md guide](https://agentpedia.codes/blog/user-rules) · [Antigravity Getting Started Codelab](https://codelabs.developers.google.com/getting-started-google-antigravity)

---

## 8. Clone the cohort repo and run the verify script

### 8.1 Open the right terminal and pick a sane location

**macOS:** open **Terminal.app**. Run:
```bash
mkdir -p ~/code
cd ~/code
```

**Windows + WSL2:** open your **Ubuntu (WSL2) terminal** (Start menu → Ubuntu; prompt ends in `$`). Run:
```bash
mkdir -p ~/code
cd ~/code
```

**Important for Windows + WSL2 students:** you MUST clone into the WSL2 filesystem (`~/code/`, which is `/home/yourname/code/` inside Ubuntu), NOT into `/mnt/c/...` (which is a slow bridge to your Windows drive). Python operations on `/mnt/c/` are 10-50x slower.

### 8.2 Clone

Same command on both platforms — run it in the terminal you just opened in §8.1:
```bash
git clone https://github.com/SwarupSG/fastapi-ollama-postgres-cohort.git
cd fastapi-ollama-postgres-cohort
```

If GitHub asks you to authenticate during the clone, your phone will buzz — tap **Approve** in the GitHub mobile app.

Verify you landed in the right folder:
```bash
pwd
# Expected (macOS):       /Users/yourname/code/fastapi-ollama-postgres-cohort
# Expected (Ubuntu/WSL2): /home/yourname/code/fastapi-ollama-postgres-cohort
```

### 8.3 Create the database + apply the schema

Still in the same terminal you used for §8.2:
```bash
createdb llm_question_log
psql -d llm_question_log -f sql/001_create_interactions.sql
```

Expected last line: `CREATE TABLE`.

### 8.4 Run the verify script

Still in the same terminal:
```bash
./scripts/verify_setup.sh
```

Expected: 8 green ✓ lines ending with *"All checks passed. You're ready for Module 1."*

If anything fails, the script prints the exact one-line fix on the failing line. Paste it, re-run. If you can't get green after one attempt, see §10 (Common failures).

*If you're also joining the bedtime cohort, clone that repo too — see §9.1.*

---

## 9. 🧸 Bedtime course — accounts, cohort clone, OAuth wiring

If you're only joining the FastAPI cohort, skip this section. If you're joining bedtime as well, do this pre-class so the bedtime Module 7 deploy session runs smoothly.

The bedtime course rebuilds the FastAPI course's V1 for the cloud — Gemini API replaces local Ollama (Module 1), Render hosts the FastAPI backend with managed Postgres (Module 6+), Vercel hosts the frontend (Module 7). **Modules 1-6 still run locally on your laptop** (same Python + local Postgres setup as the FastAPI course). Only Module 7 deploys to the cloud. So your FastAPI-course setup from §1-§8 carries you through bedtime Modules 1-6 without extra work.

### 9.1 Clone the bedtime cohort

In the same terminal you used in §8 (macOS Terminal or Ubuntu/WSL2):
```bash
cd ~/code        # back to your code parent folder, alongside fastapi-ollama-postgres-cohort
git clone https://github.com/SwarupSG/bedtime-story-generator-cohort.git
cd bedtime-story-generator-cohort
ls
```
Expected: a folder listing similar in shape to the FastAPI cohort — `app/`, `dist/`, `scripts/`, `README.md`, `AGENTS.md`, etc.

Bedtime-specific database setup, schema, `.env` file, and Gemini API key are handled in the first bedtime session — **not** pre-class. Don't run any setup commands inside this folder yet beyond the clone.

### 9.2 Sign up for Render and Vercel

- **Render** — <https://render.com>. Sign up with your **GitHub account** (uses GitHub OAuth, which also wires up the integration in one step).
- **Vercel** — <https://vercel.com/signup>. Sign up with your **GitHub account**.

**About Render's managed Postgres:** Render hosts **both** the FastAPI backend AND a managed Postgres database from the same account — you do NOT need a separate Postgres provider (no Supabase, Neon, ElephantSQL, or postgresql.org account needed). The Web Service and the database are created side-by-side from the Render dashboard during Module 7.

**Important timing note for Render's free Postgres:** the free Postgres database expires **30 days after creation**. Do NOT create your database on Render now (pre-class). You'll create it together during Module 7 of bedtime so the database has the full 30 days for the rest of the course.

### 9.3 Verify Render ↔ GitHub wiring

- Sign in to <https://dashboard.render.com>.
- Top right: **+ New** → **Web Service**.
- You should see a list of your GitHub repos (Render → GitHub OAuth is alive).
- Don't deploy anything yet; back out.

**What to expect from the Render free Web Service tier:** once you deploy in Module 7, the running app spins down after 15 minutes of inactivity. The first request after a sleep takes 30-60 seconds to wake up. This is normal — Module 7's demo covers what it looks like and why. Knowing it's expected prevents mid-class panic when the first call seems hung.

### 9.4 Verify Vercel ↔ GitHub wiring

- Sign in to <https://vercel.com/dashboard>.
- Top right: **Add New** → **Project**.
- You should see a list of your GitHub repos.
- Back out.

### 9.5 Gemini API key — created live in class

We create the bedtime course's Gemini API key together in the first bedtime session. Step-by-step is in `before_class.md` §7 if you want to refresh later.

### 9.6 The Module 7 deploy walkthrough — live in class + PDF reference

When you reach bedtime Module 7 (the final module), you deploy the FastAPI backend + managed Postgres to Render and the static frontend to Vercel. The walkthrough has three reference surfaces, in this order of use during the live session:

1. **`dist/module_07_deploy_vercel/README.md`** inside the bedtime cohort repo you cloned in §9.1 — an inline **5-phase deploy summary** (Render Blueprint → set `GEMINI_API_KEY` → apply schema migration → Vercel project → edit `BACKEND_URL` → verify on a phone). This is what you work from during the live session; it's already on your machine after §9.1.
2. **The instructor walks the cohort through it live**, narrating each Render and Vercel dashboard click in real time. Plan to share-screen your Render and Vercel tabs alongside Antigravity.
3. **`deploy_guide.pdf`** — a separate hand-holding reference (click-by-click with prose-as-screenshots, every dashboard button labelled, plus a **Common Gotchas table** capturing the issues we hit during the build: Vercel auto-detecting the Python backend and trying to deploy it as a serverless function, `BACKEND_URL` typos producing "Failed to fetch", CORS preflight blocked, schema migration not applied, `GEMINI_API_KEY` forgotten, free-tier cold-start mistaken for a bug, Render External URL leak rotation, etc.). The instructor distributes this PDF to you in class, same out-of-band way the crash course PDF is shared. **It is not in this cohort repo** — it's a master-side artifact, given to enrolled students only.

You do not need to read any deploy material pre-class. §9.1-§9.5 above is the full pre-class scope; the rest happens live in Module 7.

The cohort repo also ships three deploy-config files at its root — `Procfile`, `render.yaml`, `vercel.json` — plus a `.vercelignore`. These are configured so that Render and Vercel auto-detect the right deploy shape (Render builds the FastAPI backend + provisions Postgres from `render.yaml`; Vercel deploys only the `frontend/` folder as static, refusing to deploy the backend even though `requirements.txt` is at the root). You don't edit these files; they exist so the deploy "just works."

---

## 10. Common failures + recovery

If you hit any of these during setup, the fix is here. If your error isn't listed: open the cohort folder in Antigravity, paste your failing command and its error message into the Gemini chat panel — Gemini has `AGENTS.md` loaded and knows the curriculum's friction reducers.

### `brew: command not found` (macOS)

Homebrew isn't installed yet or isn't on your PATH. Re-run §2's install. If install ran fine, you missed the "Next steps" — re-run the `eval "$(/opt/homebrew/bin/brew shellenv)"` line shown at the end of the install output.

### `python: command not found` (Linux/WSL2)

Ubuntu installs `python3`, not `python`. Always use `python3` in commands. (If a Module's docs say `python`, that's a Windows-native command — on WSL2 substitute `python3`.)

### `pip install ... error: externally-managed-environment` (Ubuntu 24.04)

You're trying to pip install outside a virtual environment. This is blocked by design on Ubuntu 24.04 (PEP 668). Create a venv first:
```bash
python3 -m venv venv
source venv/bin/activate
pip install ...
```

### `pg_isready` says `no response` (any platform)

Postgres isn't running.
- **macOS:** `brew services start postgresql@17`
- **WSL2:** `sudo systemctl start postgresql` (or `sudo service postgresql start` if systemd isn't on)

### `ERROR: role "postgres" does not exist` (macOS)

Homebrew Postgres makes an OS-named role by default. Run:
```bash
psql -d postgres -c "CREATE USER postgres WITH PASSWORD 'postgres' SUPERUSER;"
```

### `psql: error: connection to server at "localhost" ... Connection refused`

The Postgres service died. Restart it (see two failures up).

### Ollama smoke curl returns `Connection refused` (Linux/WSL2)

The Ollama service isn't running in your WSL2 session. Start it:
```bash
sudo systemctl start ollama
# or, if systemd isn't on:
sudo service ollama start
```

If `sudo systemctl enable ollama` was run during install, Ollama auto-starts each time you open your Ubuntu terminal — so this should only bite you in fresh sessions where you skipped the `enable` step.

### Ollama smoke curl says `model not found`

You haven't pulled `llama3.2` yet. In the same Ubuntu (WSL2) terminal — or macOS Terminal — where Ollama is installed:
```bash
ollama pull llama3.2
```

### Antigravity opens to Windows paths, not WSL2

You forgot the Remote-WSL connect step. In Antigravity: `Ctrl + Shift + P` → **Remote-WSL: Connect to WSL**. Bottom-left should then show `WSL: Ubuntu`. THEN do File → Open Folder.

### `gh auth login` says "Permission denied" / browser doesn't open

Paste the URL the terminal shows (`https://github.com/login/device`) into your browser manually. Enter the 8-character code. Approve.

### `git push` says `Permission denied (publickey)`

You're trying SSH but `gh auth login` configured you for HTTPS. Either change your remote to HTTPS:
```bash
git remote set-url origin https://github.com/yourname/yourrepo.git
```
…or re-run `gh auth login` and pick SSH as the protocol.

### `verify_setup.sh: Permission denied`

The script lost its executable bit during clone (rare; happens with certain Windows configs). Restore it:
```bash
chmod +x scripts/verify_setup.sh
./scripts/verify_setup.sh
```

---

## 11. Your first prompt to Gemini (success-state moment)

You're done with install. Before closing the doc, prove your AI partner is alive and configured.

1. Open the cohort folder in Antigravity (Remote-WSL connected if on Windows).
2. Press `Cmd + L` / `Ctrl + L` to open the chat panel.
3. Paste exactly:
   > *"Look at the AGENTS.md file at the root of this workspace. Walk me through what it tells you about how to behave on this course. What's the most important thing it says about how you should help me?"*
4. Gemini should reply with a Socratic, course-aware answer that mentions doctrine, coaching not solving, refusing Defend-It questions, and module-scoping.

If you get a generic chat response that doesn't mention any of those things, `AGENTS.md` may not have loaded. Confirm:
- You opened the cohort repo *folder* in Antigravity (not just a single file)
- The folder contains an `AGENTS.md` file at its root (`ls AGENTS.md` from the integrated terminal)
- Remote-WSL is connected (Windows + WSL2 only)

If it's all there and Gemini still acts generic: restart Antigravity (File → Close Window, reopen), reopen the folder. The system prompt loads at workspace-open time.

---

*This walkthrough was last verified against current official sources on 2026-05-18. If a command behaves differently for you, check the linked source pages at the end of each section — the technology stack moves fast and 2026 has been a heavy year for installer changes (PEP 668 on Ubuntu 24.04, the gh CLI keyring path, WSL2 networking modes, the Antigravity wizard). Tell the instructor if you discover drift; we'll update the doc.*

---

# Appendix — Optional: Run Ollama on the Windows host for GPU acceleration

**For Windows + WSL2 students only. Optional. Skip unless you have a GPU and want faster Ollama inference.**

The main §5 has you install Ollama inside your Ubuntu (WSL2) terminal — CPU-only inference, ~5-20 seconds per response. That's the default and is fine for the course.

If you have an NVIDIA or AMD GPU on your laptop and want to use it, you can install Ollama on the **Windows host** instead. Inference goes to ~3-7 seconds per response. The course code does not change — the FastAPI app still calls `http://localhost:11434`. What changes is *where* that address resolves to (the Windows-host Ollama instead of WSL2-host Ollama), reached via WSL2's "mirrored networking" mode.

**Prerequisites:**
- **Windows 11 22H2 or later.** Mirrored networking is not available on Windows 10 — students on Windows 10 must stay with the §5 WSL2 install.
- A supported GPU with up-to-date drivers (NVIDIA 452.39+ or current AMD Radeon Driver).
- You have completed §1 of this doc (WSL2 installed, Ubuntu running) and §5 of this doc (Ollama installed inside WSL2 and verified working).

---

## A.1 Uninstall the WSL2 Ollama first (prevents conflicts on port 11434)

**Terminal:** your Ubuntu (WSL2) terminal. Stop and remove the in-WSL2 Ollama install you set up in §5:

```bash
sudo systemctl stop ollama
sudo systemctl disable ollama
sudo rm /usr/local/bin/ollama
sudo rm /etc/systemd/system/ollama.service
sudo userdel ollama  # may say "user not found" — that's fine
```

Verify the in-WSL2 Ollama is gone:
```bash
which ollama
# Expected: nothing (the command should not be found)
```

The model files at `~/.ollama/models/...` can be left in place — they're harmless. Or delete them to recover ~2 GB of disk:
```bash
rm -rf ~/.ollama
```

## A.2 Install Ollama on the Windows host

1. Open a **regular browser on Windows** (not Antigravity) and download the Windows `.exe` from <https://ollama.com/download>.
2. Run the installer on Windows. Accept defaults.
3. After install, Ollama runs as a tray app — look for its icon in the Windows system tray (bottom-right of the taskbar). It auto-starts on Windows login.

## A.3 Pull the model on Windows

**Terminal:** open a **regular Windows PowerShell** (not admin, not Ubuntu) for this step. Search "PowerShell" in Start, click the regular one. The prompt should look like `PS C:\Users\yourname>`.

```powershell
ollama pull llama3.2
```

Expected: a progress bar, then `success`. The model now lives in your Windows user's `.ollama` folder (not in WSL).

Verify Ollama works from the Windows side:
```powershell
curl.exe -X POST http://localhost:11434/api/chat -H "Content-Type: application/json" -d '{\"model\":\"llama3.2\",\"messages\":[{\"role\":\"user\",\"content\":\"hi\"}],\"stream\":false}'
```

Expected: a JSON response. (Note: the PowerShell escape syntax for the JSON body uses `\"` — the Linux-style single-quoted JSON doesn't work in PowerShell.)

## A.4 Configure WSL2 mirrored networking

So your WSL2 FastAPI code can reach the Windows-host Ollama at `localhost:11434`.

1. **Close** any open Ubuntu (WSL2) windows.
2. Open Windows File Explorer. In the address bar, paste `%UserProfile%` and press Enter — you land in `C:\Users\yourname\`.
3. Create a new text file named exactly `.wslconfig` (no extension). If Windows insists on a filename, use Notepad → File → Save As → set "Save as type" to "All Files" and name it `.wslconfig`.
4. Open `.wslconfig` in Notepad and paste:
   ```ini
   [wsl2]
   networkingMode=mirrored
   ```
5. Save. Close the file.
6. Open a PowerShell window and run:
   ```powershell
   wsl --shutdown
   ```
7. Re-open your Ubuntu (WSL2) terminal from the Start menu.

## A.5 Verify WSL2 reaches the Windows-host Ollama

**Terminal:** your Ubuntu (WSL2) terminal (the freshly reopened one).

```bash
curl -s -X POST http://localhost:11434/api/chat \
  -H "Content-Type: application/json" \
  -d '{"model":"llama3.2","messages":[{"role":"user","content":"hi"}],"stream":false}' \
  | head -3
```

Expected: a JSON response with a `message` field, the same as §5's verify but answered by the GPU-accelerated Windows-host Ollama. If you see `Connection refused`, mirrored networking didn't take effect — recheck `%UserProfile%\.wslconfig` contains the exact two lines, then run `wsl --shutdown` from PowerShell and re-open Ubuntu.

## A.6 Trade-offs and reversal

What you gained:
- ~3-7 second responses (GPU) vs ~5-20 second responses (CPU)
- Ollama auto-starts with Windows; no `sudo systemctl start ollama` per WSL session

What you traded for it:
- You now manage Ollama on the Windows side (`ollama pull <model>` runs in PowerShell, not Ubuntu) — slight extra cognitive load
- Mirrored networking is a `.wslconfig` setting that affects all WSL networking on your machine; if you join a corporate VPN that doesn't tolerate mirrored mode, you may need to flip back to NAT
- One extra moving part to debug if Ollama ever stops responding

To revert to the §5 default (Ollama inside WSL2):
1. Uninstall Windows-host Ollama (Settings → Apps → Ollama → Uninstall).
2. Remove the `[wsl2] networkingMode=mirrored` lines from `%UserProfile%\.wslconfig` (or delete the file).
3. `wsl --shutdown` from PowerShell.
4. Reinstall Ollama inside Ubuntu (WSL2) per §5.

Source: [WSL networking — Microsoft Learn](https://learn.microsoft.com/en-us/windows/wsl/networking) · [Ollama Windows docs](https://docs.ollama.com/windows)

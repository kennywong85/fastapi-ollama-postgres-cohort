# Module 7 — Refactor into Layers

**Single fundamental:** a maintainable codebase separates concerns. Each file has one reason to change.

**No user-visible change.** The acceptance test is that every Module 6 verification still passes byte-for-byte. The single `app/main.py` from Modules 1–6 is split into:

```
app/
├── main.py              # FastAPI app, routes only
├── schemas.py           # AskRequest, AskResponse, Interaction
├── database.py          # DATABASE_URL, get_conn (introduced HERE)
└── services/
    ├── ollama_service.py        # OLLAMA_URL, OLLAMA_MODEL, SYSTEM_PROMPT, call_ollama()
    └── interaction_service.py   # save_interaction, fetch_recent_history
```

`SYSTEM_PROMPT` migrates from `app/main.py` into `services/ollama_service.py`, alongside the function that uses it.

## Class Flow (5 steps)

1. **Open** this folder (`dist/module_07_refactor_layers/`) in Antigravity.
2. **Run** it — paste the *Run* command. The page works exactly the same as Module 6. *That's the point.*
3. **Read** `app/main.py` (now short — just routes), `app/services/ollama_service.py` (everything Ollama-related), `app/services/interaction_service.py` (everything DB-related), `app/schemas.py`, `app/database.py`. Each file has one job.
4. **Ask Gemini** to explain it — paste the **Primary prompt** under *Ask Gemini* below into the chat panel. Read what Gemini says. Ask follow-ups.
5. **Answer the Defend It question** at the bottom yourself before moving to Module 8.

(Optional 6th — for hands-on learners: try the *Tweak* suggestion at the end. This one is the most instructive in the course.)

## Run

```bash
source venv/bin/activate
uvicorn app.main:app --reload
```

## Verify (self-check)

Run every Module 6 verification — all responses must be byte-identical to Module 6. The structural diff is the proof we're done. Open `dist/module_06_read_history/app/` and `dist/module_07_refactor_layers/app/` side by side in your editor. Same behaviour, different shape — that's the lesson.

(Maintainer aside: if you have the source-of-truth tag history in your clone, `git diff --stat v1-module-6-complete v1-module-7-complete -- app/` shows the same picture as a stat summary.)

## Ask Gemini

**Primary prompt** (paste this first into the chat panel):

> Behaviour is identical to Module 6. So what changed? Open `app/main.py` and `app/services/ollama_service.py` side by side. Coach me through what 'separation of concerns' means here — what does this refactor make easier to do tomorrow that Module 6's single file made hard?

### More questions if you want to go deeper

The build phase is winding down. By now you have your own way of asking. The prompts below are starters, not a script.

**Articulate the gain:**
> This refactor changed nothing the user can see. Convince me — using maintainability arguments only, no hand-waving — that this work was worth doing. If I push back, push back harder.

**Pick something that surprised you in the refactor and explore it.** Open one of the new files (`schemas.py`, `database.py`, `services/ollama_service.py`, or `services/interaction_service.py`). Pick one design choice that surprised you. Write a prompt to ask Gemini about it. Share what Gemini said with a peer in your cohort.

## Tweak (optional, for hands-on learners)

Move `SYSTEM_PROMPT` from `app/services/ollama_service.py` back into `app/main.py` (where it lived in Modules 4–6). Save. Restart uvicorn. Notice **nothing changed for the user** — the app still works. Now revert. Ask yourself: why is the refactored location better, given both work? Hint: the next time you swap LLM providers, which file do you want to touch?

## Defend It (do not paste into Gemini — answer it yourself)

> We didn't change any behaviour. What did we gain?
We gained clearer organisation and easier maintenance. Each file now has one main responsibility, so future changes to Ollama, PostgreSQL, or the data models can be made in the relevant file without digging through one large main.py.
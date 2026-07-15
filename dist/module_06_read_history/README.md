# Module 6 — Read Recent History

**Single fundamental:** an application reads state back from the database to inform what the user sees.

The page now shows the ten most recent interactions on load and after each ask. A `GET /history` endpoint returns the same data as JSON.

## Class Flow (5 steps)

1. **Open** this folder (`dist/module_06_read_history/`) in Antigravity.
2. **Run** it — paste the *Run* command. Refresh the browser. The Recent section shows previous interactions (carried over from Module 5's writes — same Postgres database).
3. **Read** `app/main.py` in your editor. Look for `fetch_recent_history`, the new `/history` route, and the change to `/ask` that now returns history alongside the answer.
4. **Ask Gemini** to explain it — paste the **Primary prompt** under *Ask Gemini* below into the chat panel. Read what Gemini says. Ask follow-ups.
5. **Answer the Defend It question** at the bottom yourself before moving to Module 7.

(Optional 6th — for hands-on learners: try the *Tweak* suggestion at the end.)

## Run

```bash
source venv/bin/activate
uvicorn app.main:app --reload   # no new packages
```

Open **http://localhost:8000** in your browser. The Recent section shows interactions; ask a new question and watch the list update.

## Verify (self-check)

```bash
curl -s http://localhost:8000/history | python3 -m json.tool

curl -s -X POST http://localhost:8000/ask \
  -H "Content-Type: application/json" \
  -d '{"question":"reply with: history works"}' | python3 -m json.tool
```

## Ask Gemini

**Primary prompt** (paste this first into the chat panel):

> Walk me through how `/history` works in `app/main.py`. The browser refreshes the Recent list how? What's the relationship between `/ask` and `/history` — why does `/ask` also return history, given `/history` exists?

### More questions if you want to go deeper

**About the helper extraction:**
> The function `fetch_recent_history` is called from two places: `/ask` and `/history`. The doctrine usually says to wait for three call sites before extracting a helper (Rule of Three). Coach me through why this case is justified anyway. What's the cost-benefit?

**About the date format:**
> `Interaction.created_at` is typed as `str` and the SQL uses `to_char(...)`. Why not type it as `datetime` and let Pydantic serialize it? What would the alternative code look like? Which version is simpler — and what does "simpler" even mean here?

**Try a what-if:**
> Right now history is `LIMIT 10`. Change it to `LIMIT 100` and hammer `/history`. Did anything get slower? What does that tell you about when this design will break?

**Self-check before you move to Module 7:**
> Module 7 is "refactor into layers" — splitting the single `app/main.py` into routes, schemas, database, and services. Predict the file structure. Predict which existing function moves to which file.

## Tweak (optional, for hands-on learners)

Change the `LIMIT 10` in the SQL query to `LIMIT 3`. Save (uvicorn auto-reloads). Refresh the page. Confirm only three rows show in the Recent list. Try `/history` in `/docs` "Try it out" — same three rows in the JSON. Then revert.

## Defend It (do not paste into Gemini — answer it yourself)

> Why does `/ask` return the history bundled with the answer instead of letting the browser call `/history` separately?
Returning the answer and updated history together lets the browser refresh everything with one request. If the browser called /history separately, it would need another network request and extra code after every question.
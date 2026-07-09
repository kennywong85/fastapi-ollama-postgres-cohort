# Explain It Yourself — Written Assignment

You've been answering **Defend-It** out loud. This is the short written version.

Every module is really built around **one key line** — the line that *is* the new idea; everything else is scaffolding. For each module below we show you a small slice of the real code, with that key line marked **`# ← EXPLAIN THIS LINE`**. **Your job is to explain what the marked line does, in your own words** — the way you'd explain it to a classmate who's stuck.

The full file for each module is in your cohort folder (the path is in the comment at the top of each snippet) — open it in Antigravity if you want the whole picture. That's the whole assignment: read the marked line in context, understand it, explain it. Eight lines, eight short explanations.

> **How this is handed in.** This is a **graded assignment**. Your instructor gives you an editable copy — **`explain_it_yourself.docx`** — on the learning portal. Fill it in (Word, Google Docs, or Pages) and **upload the completed `.docx` back to the portal** as a single submission by the deadline.

---

## What a good explanation looks like

- **In your own words** — don't copy the README back. Explain it like you're helping a classmate.
- **Say what it does *and* why it matters** — what would be missing or broken without this line?
- **2–4 sentences is plenty.** Short and clear beats long.

You may ask Gemini to *check* your explanation ("is this right?") — but write your own version first.

---

## Module 01 — Hello FastAPI

```python
# app/main.py   (full file: dist/module_01_hello_fastapi/app/main.py)
app = FastAPI(title="Local LLM Question Log")
# ...
@app.get("/", response_class=HTMLResponse)   # ← EXPLAIN THIS LINE
def index(request: Request):
    return templates.TemplateResponse("index.html", {"request": request})
```

**Your explanation (2–4 sentences):**



## Module 02 — Post + Pydantic Echo

```python
# app/main.py   (full file: dist/module_02_post_pydantic_echo/app/main.py)
class AskRequest(BaseModel):
    question: str

@app.post("/ask", response_model=AskResponse)
def ask(payload: AskRequest):   # ← EXPLAIN THIS LINE  (focus on `payload: AskRequest`)
    question = payload.question.strip()
    if not question:
        raise HTTPException(status_code=400, detail="Please enter a question.")
    return AskResponse(answer=f"You asked: {question}")
```

**Your explanation (2–4 sentences):**



## Module 03 — Call Ollama

```python
# app/main.py — inside ask()   (full file: dist/module_03_call_ollama/app/main.py)
    with httpx.Client(timeout=60.0) as client:
        r = client.post(OLLAMA_URL, json={   # ← EXPLAIN THIS LINE
            "model": OLLAMA_MODEL,
            "messages": [{"role": "user", "content": question}],
            "stream": False,
        })
        answer = r.json()["message"]["content"]
```

**Your explanation (2–4 sentences):**



## Module 04 — System Prompt

```python
# app/main.py   (full file: dist/module_04_system_prompt/app/main.py)
SYSTEM_PROMPT = (
    "You are a concise, helpful assistant. "
    "Answer in one short paragraph (under 80 words). "
    "If you don't know, say so plainly."
)
# ... later, in the call to the model:
            "messages": [
                {"role": "system", "content": SYSTEM_PROMPT},   # ← EXPLAIN THIS LINE
                {"role": "user", "content": question},
            ],
```

**Your explanation (2–4 sentences):**



## Module 05 — Save to Postgres

```python
# app/main.py — after Ollama returns the answer   (full file: dist/module_05_save_postgres/app/main.py)
    with psycopg.connect(DATABASE_URL) as conn:
        with conn.cursor() as cur:
            cur.execute(
                "INSERT INTO interactions (question, answer, model_name) "   # ← EXPLAIN THIS LINE
                "VALUES (%s, %s, %s)",
                (question, answer, OLLAMA_MODEL),
            )
        conn.commit()
```

**Your explanation (2–4 sentences):**



## Module 06 — Read History

```python
# app/main.py — the fetch_recent_history() function   (full file: dist/module_06_read_history/app/main.py)
def fetch_recent_history(limit: int = 10) -> list[Interaction]:
    with psycopg.connect(DATABASE_URL) as conn:
        with conn.cursor(row_factory=dict_row) as cur:
            cur.execute(
                "SELECT id, question, answer, model_name, "   # ← EXPLAIN THIS LINE
                "       to_char(created_at, 'YYYY-MM-DD HH24:MI:SS') AS created_at "
                "FROM interactions ORDER BY id DESC LIMIT %s",
                (limit,),
            )
            return [Interaction(**row) for row in cur.fetchall()]
```

**Your explanation (2–4 sentences):**



## Module 07 — Refactor into Layers

The app does exactly what Module 6 did — but `main.py` now imports the work from other files, so the `ask` function became tiny.

```python
# app/main.py   (full file: dist/module_07_refactor_layers/app/main.py)
from app.services.ollama_service import call_ollama
from app.services.interaction_service import save_interaction, fetch_recent_history
# ...
@app.post("/ask", response_model=AskResponse)
def ask(payload: AskRequest):
    question = payload.question.strip()
    if not question:
        raise HTTPException(status_code=400, detail="Please enter a question.")
    answer = call_ollama(question)      # ← EXPLAIN THESE TWO LINES
    save_interaction(question, answer)  # ← (compare with Module 6's long ask())
    return AskResponse(answer=answer, history=fetch_recent_history())
```

*Nothing the app DOES changed. Explain what changed instead — and why that's worth doing.*

**Your explanation (2–4 sentences):**



## Module 08 — Configuration

```python
# app/database.py — the whole file   (full file: dist/module_08_configuration/app/database.py)
import os
import psycopg
from contextlib import contextmanager

DATABASE_URL = os.environ["DATABASE_URL"]   # ← EXPLAIN THIS LINE

@contextmanager
def get_conn():
    with psycopg.connect(DATABASE_URL) as conn:
        yield conn
```

**Your explanation (2–4 sentences):**



---

**Submitting — one upload, all eight modules.** When every module is filled in, **upload this completed document (`explain_it_yourself.docx`) to the learning portal** as your single submission. It also doubles as your own revision sheet later — eight lines, the whole app.

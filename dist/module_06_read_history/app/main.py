import httpx
import psycopg
from psycopg.rows import dict_row
from fastapi import FastAPI, HTTPException, Request
from fastapi.responses import HTMLResponse
from fastapi.templating import Jinja2Templates
from fastapi.staticfiles import StaticFiles
from pydantic import BaseModel

OLLAMA_URL = "http://localhost:11434/api/chat"
OLLAMA_MODEL = "llama3.2"
SYSTEM_PROMPT = (
    "You are a concise, helpful assistant. "
    "Answer in one short paragraph (under 80 words). "
    "If you don't know, say so plainly."
)
DATABASE_URL = "postgresql://postgres:postgres@localhost:5432/llm_question_log"

app = FastAPI(title="Local LLM Question Log")

app.mount("/static", StaticFiles(directory="app/static"), name="static")
templates = Jinja2Templates(directory="app/templates")


class AskRequest(BaseModel):
    question: str


class Interaction(BaseModel):
    id: int
    question: str
    answer: str
    model_name: str
    created_at: str


class AskResponse(BaseModel):
    answer: str
    history: list[Interaction]


def fetch_recent_history(limit: int = 10) -> list[Interaction]:
    with psycopg.connect(DATABASE_URL) as conn:
        with conn.cursor(row_factory=dict_row) as cur:
            cur.execute(
                "SELECT id, question, answer, model_name, "
                "       to_char(created_at, 'YYYY-MM-DD HH24:MI:SS') AS created_at "
                "FROM interactions ORDER BY id DESC LIMIT %s",
                (limit,),
            )
            return [Interaction(**row) for row in cur.fetchall()]


@app.get("/", response_class=HTMLResponse)
def index(request: Request):
    return templates.TemplateResponse("index.html", {"request": request})


@app.post("/ask", response_model=AskResponse)
def ask(payload: AskRequest):
    question = payload.question.strip()
    if not question:
        raise HTTPException(status_code=400, detail="Please enter a question.")

    try:
        with httpx.Client(timeout=60.0) as client:
            r = client.post(OLLAMA_URL, json={
                "model": OLLAMA_MODEL,
                "messages": [
                    {"role": "system", "content": SYSTEM_PROMPT},
                    {"role": "user", "content": question},
                ],
                "stream": False,
            })
            r.raise_for_status()
            answer = r.json()["message"]["content"]
    except httpx.HTTPError:
        raise HTTPException(status_code=502, detail="Ollama is not reachable.")

    try:
        with psycopg.connect(DATABASE_URL) as conn:
            with conn.cursor() as cur:
                cur.execute(
                    "INSERT INTO interactions (question, answer, model_name) "
                    "VALUES (%s, %s, %s)",
                    (question, answer, OLLAMA_MODEL),
                )
            conn.commit()
    except psycopg.Error:
        raise HTTPException(
            status_code=502,
            detail="Postgres is not reachable. Check your database connection."
        )

    return AskResponse(answer=answer, history=fetch_recent_history())


@app.get("/history", response_model=list[Interaction])
def history():
    return fetch_recent_history()


@app.get("/healthz")
def healthz():
    status = {"ollama": False, "postgres": False}
    try:
        with httpx.Client(timeout=5.0) as client:
            client.get("http://localhost:11434/api/tags").raise_for_status()
        status["ollama"] = True
    except httpx.HTTPError:
        pass
    try:
        with psycopg.connect(DATABASE_URL) as conn:
            with conn.cursor() as cur:
                cur.execute("SELECT 1")
        status["postgres"] = True
    except psycopg.Error:
        pass
    return status

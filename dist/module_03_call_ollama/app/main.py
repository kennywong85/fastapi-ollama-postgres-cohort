import httpx
from fastapi import FastAPI, HTTPException, Request
from fastapi.responses import HTMLResponse
from fastapi.templating import Jinja2Templates
from fastapi.staticfiles import StaticFiles
from pydantic import BaseModel

OLLAMA_URL = "http://localhost:11434/api/chat"
OLLAMA_MODEL = "qwen3.5:9b"

app = FastAPI(title="Local LLM Question Log")

app.mount("/static", StaticFiles(directory="app/static"), name="static")
templates = Jinja2Templates(directory="app/templates")


class AskRequest(BaseModel):
    question: str


class AskResponse(BaseModel):
    answer: str


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
                "messages": [{"role": "user", "content": question}],
                "stream": False,
            })
            r.raise_for_status()
            answer = r.json()["message"]["content"]
    except httpx.HTTPError:
        raise HTTPException(
            status_code=502,
            detail="Ollama is not reachable. Check that Ollama is running locally."
        )
    return AskResponse(answer=answer)


# Open an HTTP client.
# 
# Send a POST request to Ollama.
# 
# Tell Ollama:
# - use qwen3.5:9b
# - here is the user’s message
# - give me the whole answer at once
# 
# Wait for Ollama’s response.
# 
# If Ollama returned an error,
# do not pretend it worked.
# 
# Take only the generated answer text.

# Browser
# customer
# 
# FastAPI
# = waiter
# 
# Ollama
# = kitchen
# 
# qwen3.5:9b
# = chef
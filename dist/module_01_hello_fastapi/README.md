# Module 1 — Hello FastAPI

**Single fundamental:** a web server is a long-running process that listens on a port and responds to HTTP requests.

The app at the end of this module is the smallest serious FastAPI app: a static page rendered by Jinja2, served at `/`. No form, no LLM, no database.

## Class Flow (5 steps)

1. **Open** this folder (`dist/module_01_hello_fastapi/`) in Antigravity. The file tree shows `app/` for the first time.
2. **Run** it — paste the *Run* commands below into your terminal. Open the URL it prints. See the page render.
3. **Read** `app/main.py` in your editor. Four FastAPI lines plus one route.
4. **Ask Gemini** to explain it — paste the **Primary prompt** under *Ask Gemini* below into the chat panel. Read what Gemini says. Ask follow-ups.
5. **Answer the Defend It question** at the bottom yourself before moving to Module 2.

(Optional 6th — for hands-on learners: try the *Tweak* suggestion at the end. Skip if you're moving fast.)

## Run

```bash
source venv/bin/activate
pip install -r requirements.txt
uvicorn app.main:app --reload
```

Open **http://localhost:8000** in your browser. You should see the title and a paragraph saying the server is running.

## Verify (self-check)

```bash
curl -s -o /dev/null -w "HTTP %{http_code}\n" http://localhost:8000/
# Expected: HTTP 200
```

## Ask Gemini

**Primary prompt** (paste this first into the chat panel):

> Walk me through `app/main.py` line by line. What does each FastAPI line do? Why do we need uvicorn and not just `python app/main.py`?

### More questions if you want to go deeper

**About uvicorn vs python:**
> If I run `python app/main.py` instead of `uvicorn app.main:app --reload`, what happens? Why does FastAPI need uvicorn at all — what is uvicorn doing that Python alone is not?

**About `--reload`:**
> The run command has `--reload`. Try removing it, edit `app/templates/index.html`, refresh the browser. Tell me what you observe and explain why `--reload` exists in development but not in production.

**About the route function:**
> The `index` function takes `request: Request` as a parameter even though my code never uses `request` directly. Why does FastAPI require it? What would break if I removed the parameter?

**About the static mount:**
> Try changing `app.mount("/static", StaticFiles(directory="app/static"), name="static")` to mount at `/assets` instead. What URL would I now use to fetch `style.css`? What other file would I need to update?

**Curiosity / "what if":**
> Add a second route at `/about` that returns plain text "About this app." Show me the code. Then explain what FastAPI did differently between this route and the `/` route.

**Self-check before you move to Module 2:**
> Module 2 introduces a textarea and an Ask button that posts JSON to `/ask`. Before I see the code, predict how the request and response will be shaped. What HTTP method? What body shape? What response shape?

## Tweak (optional, for hands-on learners)

Add a second route at `/about` that returns the plain text `"About this app."`. Save, watch uvicorn auto-reload, visit `http://localhost:8000/about` in your browser. Then visit `http://localhost:8000/docs` and notice your new route appears in the auto-generated API page — you wrote no documentation for it.

## Defend It (do not paste into Gemini — answer it yourself)

> Why `uvicorn app.main:app` and not `python app/main.py`?

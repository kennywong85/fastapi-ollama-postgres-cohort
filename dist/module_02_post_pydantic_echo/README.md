# Module 2 — POST and Pydantic Echo

**Single fundamental:** a request-response cycle has typed input and typed output. Validation lives at the boundary.

The page now has a textarea and an Ask button. Submitting sends a JSON `POST /ask` to the backend. The backend validates the body with Pydantic and **echoes the question back as the answer**. No LLM yet — Module 3 introduces it.

## Class Flow (5 steps)

1. **Open** this folder (`dist/module_02_post_pydantic_echo/`) in Antigravity.
2. **Run** it — paste the *Run* commands below into your terminal. Use the page in your browser.
3. **Read** `app/main.py` in your editor. Two Pydantic classes (`AskRequest`, `AskResponse`) and one POST route — that's the typing in action.
4. **Ask Gemini** to explain it — paste the **Primary prompt** under *Ask Gemini* below into the chat panel. Read what Gemini says. Ask follow-ups.
5. **Answer the Defend It question** at the bottom yourself before moving to Module 3.

(Optional 6th — for hands-on learners: try the *Tweak* suggestion at the end.)

## Run

```bash
source venv/bin/activate
uvicorn app.main:app --reload
```

Open **http://localhost:8000**, type something in the textarea, click Ask.

## Verify (the three-error-codes drill — self-check)

```bash
# 200 — happy path, typed response
curl -s -X POST http://localhost:8000/ask \
  -H "Content-Type: application/json" -d '{"question":"hello"}'

# 400 — value error (handler's business rule: empty after strip)
curl -s -w "\nHTTP %{http_code}\n" -X POST http://localhost:8000/ask \
  -H "Content-Type: application/json" -d '{"question":""}'

# 422 — shape error (Pydantic: missing field)
curl -s -w "\nHTTP %{http_code}\n" -X POST http://localhost:8000/ask \
  -H "Content-Type: application/json" -d '{}'
```

## Interactive API documentation (a free outcome of typing)

While `uvicorn` is still running, open **http://localhost:8000/docs** in your browser. FastAPI auto-generates this page from the Pydantic models and route signatures in `app/main.py` — you wrote zero documentation.

What to look at:

- **Endpoint list** — POST `/ask` is listed automatically. GET `/` (the HTML page) is also there.
- **Click POST `/ask`** → see the request body schema with `question: string`, marked **required** because `AskRequest` defines no default.
- **Responses section** — 200 returns `AskResponse` (`answer: string`). 422 is the validation error schema you saw in the curl drill above.
- **"Try it out"** — click the button, fill the `question` field, hit Execute. The response panel shows the same 200 / 422 / 400 you got with curl, without typing curl. Try body `{}` for 422; try `{"question":"   "}` for 400.
- **Schemas section** at the bottom — every Pydantic model in the app, browsable.

From Module 3 onwards, `/docs` is also your fastest debug tool: when something looks wrong in the browser, paste the same payload into "Try it out" and see what the server actually returned — body, status, and headers. There is also `/redoc` (a read-only, magazine-style version) — bookmark whichever you prefer.

## Ask Gemini

**Primary prompt** (paste this first into the chat panel):

> Open `app/main.py`. Compare it to the Module 1 version. Walk me through everything that changed and tell me which changes are "the same idea expressed in two places" vs "two different responsibilities". Don't tell me which is which — ask me to guess first.

### More questions if you want to go deeper

**About the two error codes:**
> A request with `{"question":""}` returns 400. A request with `{}` returns 422. They look like the same kind of "the request was bad" failure to me. Make me articulate the difference between them.

**About the Pydantic models:**
> `AskResponse` has only one field: `answer: str`. Why bother defining a class for one field instead of just returning `{"answer": ...}` directly? Coach me into seeing what `response_model=AskResponse` is doing for me.

**The "where does validation live" question:**
> Pydantic validates the request body before my function runs. What would my code look like if Pydantic didn't exist and I had to do the same validation by hand inside `ask()`? Show me. Then tell me which version is easier to maintain and why.

**About the JavaScript:**
> Open `app/templates/index.html`. The `fetch()` call sends `Content-Type: application/json`. Try removing that header in the JavaScript and submit the form. What error do you predict? Now actually try it. Were you right?

**About the auto-generated `/docs` page:**
> Open http://localhost:8000/docs. Walk me through how FastAPI knew that the request body has a required `question: string` field, that the response has an `answer: string` field, and that 422 is a possible status code. What in `app/main.py` generated each of those things? What would I have to write by hand if I were using a framework that didn't auto-generate this?

**Curiosity / "what if":**
> What if I wanted `/ask` to accept either JSON or a plain HTML form post? What would I have to change? Is that a doctrine-compliant change for Module 2? Why or why not?

**Self-check before you move to Module 3:**
> Module 3 replaces the echo with a real call to the local Ollama LLM. Predict: what's the smallest amount of new code that has to land in `/ask` to make this happen? What new package will need to be installed?

## Tweak (optional, for hands-on learners)

Add a second field to `AskRequest`, e.g. `mood: str`. Save (uvicorn auto-reloads). Submit the form — does it still work? Now open `/docs` and notice your new field is documented with `mood` marked **required**. Send a request without it via "Try it out" — observe the 422 error message. Then revert.

## Defend It (do not paste into Gemini — answer it yourself)

> Why is 422 different from 400 here? Couldn't they both be 400?
422 means the request failed Pydantic validation because the required question field is missing or has the wrong type. 400 means the request has the correct structure, but the value is invalid, such as an empty question after trimming spaces. They could both broadly be called bad requests, but using different codes shows which layer rejected the request and makes debugging clearer.

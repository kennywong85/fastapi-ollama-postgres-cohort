# Module 4 — System Prompt

**Single fundamental:** an LLM call is a list of messages with **roles**. The system message shapes every response and is independent of the user's question.

Every question is now sent to the LLM alongside a fixed system message that constrains how it answers. The same question — *"What is 2 + 2?"* — produces visibly different output depending on the system prompt. The user never sees the system message; they only see the question they typed.

## Class Flow (5 steps)

1. **Open** this folder (`dist/module_04_system_prompt/`) in Antigravity.
2. **Run** it — paste the *Run* command into your terminal. Use the page in your browser. Notice the answers are now shorter and more constrained than Module 3.
3. **Read** `app/main.py` in your editor. Find `SYSTEM_PROMPT` and the changed `messages` array — that's the entire feature.
4. **Ask Gemini** to explain it — paste the **Primary prompt** under *Ask Gemini* below into the chat panel. Read what Gemini says. Ask follow-ups.
5. **Answer the Defend It question** at the bottom yourself before moving to Module 5.

(Optional 6th — for hands-on learners: try the *Tweak* suggestion at the end. This module's tweak is the most fun in the course.)

## Run

```bash
source venv/bin/activate
uvicorn app.main:app --reload   # no new packages
```

## Verify (self-check)

```bash
# Concise, ≤80 words:
curl -s -X POST http://localhost:8000/ask \
  -H "Content-Type: application/json" \
  -d '{"question":"What is 2 + 2?"}'

# Demo the constraint live: ask something the model cannot know.
curl -s -X POST http://localhost:8000/ask \
  -H "Content-Type: application/json" \
  -d '{"question":"What did I have for breakfast yesterday?"}'
# Expected: a short answer that admits it does not know, per the system prompt.
```

## Ask Gemini

**Primary prompt** (paste this first into the chat panel):

> Walk me through what `SYSTEM_PROMPT` does in `app/main.py`. Compare the messages list before this module (just `[{"role": "user", ...}]`) and after (system message added). What does the LLM see differently? Why does this small change visibly shape every answer?

### More questions if you want to go deeper

You're entering the build-phase of the curriculum. The prompts here are mixed — some closed, some open. Mix and match.

**The before/after demo:**
> I'm about to add a system prompt. Before I do, predict three concrete differences I should see in the model's output. Be specific. (After I run it, I'll tell you which predictions held.)

**About the messages array order:**
> The system message goes BEFORE the user message in the messages array. What would change if I reversed the order? Form a hypothesis, then test it by editing the code and re-running. Tell me what you observed and what you now believe.

**Iterate on the prompt itself:**
> Help me write three different system prompts: one that makes the model answer in haiku format, one that makes it always cite a date, and one that constrains it to one-word answers. For each, predict what will happen, then we'll test together.

**The meta moment** — your instructor will probably tell you to ask this:
> Open `AGENTS.md` at the workspace root in the file tree. That's the system prompt that has been shaping you (Gemini) for this entire course. Walk me through how that file is doing the same job for you that `SYSTEM_PROMPT` is doing for `llama3.2`. What's the same? What's different?

**Self-check before you move to Module 5:**
> I'm about to be asked: *"Why does the system prompt go into the same `messages` array as the user's question? Why isn't it a separate API parameter?"* Don't answer it. Ask me what I think the answer is. Then tell me whether my reasoning holds together.

## Tweak (optional, for hands-on learners)

Change the `SYSTEM_PROMPT` constant in `app/main.py` to demand all answers as **haiku** (5-7-5 syllables). Save (uvicorn auto-reloads). Ask the same question you asked above. Observe how dramatically the answer changes — without changing the user's question, the LLM call, or anything else. Then revert. **This is the most visible "small code change, big behaviour change" moment in the whole course.**

## Defend It (do not paste into Gemini — answer it yourself)

> Why does the system prompt go into the same `messages` array as the user's question? Why isn't it a separate API parameter?
The system prompt belongs in the same messages array because it is part of the context the model reads before generating a reply. The role tells the model that it is an instruction rather than a user question, while keeping everything in one ordered conversation format

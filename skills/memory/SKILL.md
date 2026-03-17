---
name: memory
description: Persists agent state, decisions, and execution plans across sessions using a Write-Ahead Log protocol. WHEN to use it - starting multi-session tasks, when context window is filling, before pausing work for review, or resuming work in a new chat session.
license: MIT
metadata:
  category: meta
  handoff-from:
    - task-decomposition
  handoff-to:
    - context-strategy
  version: 1.0.0
compatibility:
  claude-versions:
    - opus-4.6
    - sonnet-4.6
---

# @memory — State Persistence & Working Buffer

**Philosophy:** Never lose context during long-running or multi-session tasks. Write down what you've done, what you're doing, and what's next.

## When to invoke
- When starting a task that will require multiple tool calls or take a long time
- When the context window is getting full and you need to restart the session
- Before pausing work or asking the user to review a large PR
- When resuming work on an existing task in a new chat session

## Responsibilities
- Create and maintain a persistent "Working Buffer"
- Write down the execution plan, current state, and next steps
- Read the memory file upon resuming to regain context instantly
- Ensure the memory file doesn't pollute the project structure inappropriately (use `.ai-memory.md` in the project root, or `docs/AI_MEMORY.md` if the project prefers docs/ for AI assets)

## The WAL (Write-Ahead Log) Protocol
When acting autonomously on complex tasks, treat your memory file like a WAL:
1. **Plan:** Before taking action, write your step-by-step plan to the memory file.
2. **Execute:** Execute the first step.
3. **Commit:** Update the memory file, marking the step as complete and documenting any findings or roadblocks.
4. **Repeat:** Move to the next step.

## Memory File Structure
Your memory file should be concise and structured. Default to `.ai-memory.md` in the project root.

```markdown
# Session Memory

## Goal
[1-2 sentences describing the overarching objective]

## Current Status
- [x] Step 1: Initialized database schema
- [ ] Step 2: Build auth routes (CURRENT)
- [ ] Step 3: Write tests for auth routes

## Context & Findings
- Discovered that the User model needs a `last_login` field (added in Step 1).
- The `bcrypt` library is throwing a warning, need to update the version in Step 3.
```

## Resuming Work
When a new session starts and the user says "@memory resume" or "Continue where we left off":
1. Read the memory file (`.ai-memory.md`).
2. Identify the `CURRENT` step.
3. Review the `Context & Findings`.
4. State what you are going to do next and immediately begin execution.

## Handoffs
- **From `@task-decomposition`** → Take the decomposed tasks and write them into the memory file to begin tracking them.
- **To `@context-strategy`** → Use the memory file to decide which files actually need to be loaded into the current context window.

## Must ask before
- Adding the memory file to source control (it should almost always be `.gitignore`d, ask the user before committing).

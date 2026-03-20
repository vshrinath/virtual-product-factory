# @project — Project State Manager

**Philosophy:** A shared, persistent record of what's being built, who it's for, and where it stands. Every skill reads from it. No skill re-asks what's already been answered.

## When to invoke
- At the start of any new project or feature track
- When any skill needs to know what stories are in scope
- When checking overall project status (`@project status`)
- After `@pm` completes scoping (to initialize or update state)
- When `@qa` marks stories complete or needs to log bugs

## Responsibilities
- Initialize `.project/` state files from templates if they don't exist
- Display current project status at a glance
- Update story status (`[ ]` → `[x]`) when `@qa` confirms acceptance criteria
- Log bugs to `.project/bugs.md` with severity and status
- Serve as the single source of truth for scope and progress across all skills

---

## State files

These three files live at the project root and persist across all sessions and skills:

```
.project/
  requirements.md   ← problem, target user, success criteria, in/out of scope
  stories.md        ← user stories with [ ] / [x] completion status
  bugs.md           ← bug log with severity, status, and resolution
```

**These files are the handoff surface between skills.** `@pm` writes them. `@arch` and `@dev` read them. `@qa` updates them.

---

## Initialization protocol

**Step 1 — Check for existing state**

Before doing anything, check if `.project/` already exists:
- If `.project/requirements.md` exists → display current status (do not overwrite)
- If `.project/` does not exist → proceed to Step 2

**Step 2 — Confirm with user**

> "I'll create `.project/` with `requirements.md`, `stories.md`, and `bugs.md` to track this project's state. Shall I proceed?"

**DO NOT create any files until the user confirms.**

**Step 3 — Create state files**

Load `product/assets/requirements-template.md`, `product/assets/stories-template.md`, and `product/assets/bugs-template.md`. Create the corresponding files in `.project/`. Add `.project/` to `.gitignore` unless the user explicitly asks to track it.

---

## Status display

When invoked for a status check, read all three state files and output:

```
## Project Status

### Requirements
[1-sentence summary of the problem and target user]

### Stories — [X/Y complete]
- [x] Story 1 ← done 2024-01-15
- [x] Story 2 ← done 2024-01-16
- [ ] Story 3 (in progress)
- [ ] Story 4

### Bugs — [X open / Y resolved]
- 🔴 BUG-003: [title] (error, open)
- 🟡 BUG-002: [title] (warning, in-progress)
- ✅ BUG-001: [title] (resolved)
```

---

## Updating story status

When `@qa` confirms all acceptance criteria for a story:

1. Open `.project/stories.md`
2. Change `- [ ]` to `- [x]` for the completed story
3. Append the completion date: `- [x] Story name ← done YYYY-MM-DD`
4. Update the status summary line at the top of `stories.md`

**DO NOT mark a story complete unless `@qa` has explicitly confirmed all acceptance criteria pass.**

---

## Logging bugs

When `@qa` or `@dev` discovers a bug:

1. Open `.project/bugs.md`
2. Assign the next BUG-XXX number
3. Add entry at the top of the open bugs section (most recent first)
4. Follow the format defined in `bugs.md`

Severity levels:
- **error** — blocks the story from completing; must fix before marking done
- **warning** — should fix; does not block story completion
- **info** — note for future improvement

---

## Handoffs

- **From `@pm`** → After scoping, `@pm` populates `.project/requirements.md` and `.project/stories.md`, then invokes `@project` to confirm state is initialized and display status
- **To `@arch`** → `@arch` reads `.project/requirements.md` before designing
- **To `@dev`** → `@dev` reads `.project/stories.md` to confirm which story is in scope before implementing
- **From `@qa`** → After tests pass, `@qa` invokes `@project` to mark stories complete and/or log bugs

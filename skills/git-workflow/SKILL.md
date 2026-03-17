---
name: git-workflow
description: Enforces commit message format, changelog discipline, and file organization. Ensures git history is useful and documentation is current. WHEN to use it - before committing code, when creating or updating documentation, when organizing project files, or during code reviews involving git history.
license: MIT
metadata:
  category: coding
  handoff-from:
    - dev
  handoff-to:
    - guard
    - qa
  version: 1.0.0
compatibility:
  claude-versions:
    - opus-4.6
    - sonnet-4.6
---

# @git-workflow — Git Workflow and Documentation

**Philosophy:** Every commit tells a story. Make it worth reading six months from now.

## When to invoke
- Before committing code
- When creating or updating documentation
- When organizing project files
- During code reviews involving git history

## Responsibilities
- Write clear, informative commit messages
- Maintain project changelog
- Organize files according to project structure
- Ensure git history is useful for future developers

## Scope
- Commit message formatting and content
- Changelog maintenance
- File organization and documentation placement
- Git best practices

---

## Commit Messages

**Every commit message should explain what changed and why, in a format that's useful when scanning `git log` months later.**

### Format
```
<type>: <what changed — plain English, specific>

<Why this change was needed. 1-2 sentences.>
```

### Types
- `fix` — Bug fixes
- `feat` — New features
- `refactor` — Code restructuring without behavior change
- `docs` — Documentation only
- `chore` — Maintenance tasks (dependencies, config)
- `test` — Test additions or modifications

### Good Examples
- `fix: search returns 500 when index is empty, now falls back to DB query`
- `feat: add bookmark toggle to article header, syncs with auth provider`
- `refactor: split 82KB API file into per-content-type modules`

### Bad Examples
- `update files` — Too vague
- `fix bug` — Which bug? What was fixed?
- `WIP` — Not a commit message
- `address review comments` — What changed?

### Guidelines
- First line: 50-72 characters, imperative mood ("add" not "added")
- Body: Explain WHY, not WHAT (code shows what)
- Reference issue numbers if applicable: `fixes #123`
- Break unrelated changes into separate commits

---

## Changelog Maintenance

**If the project maintains a manual `CHANGELOG.md`, append significant features and fixes to it. If the project uses automated release notes (e.g., semantic-release), ensure your commit messages comply with its standards.**

### Format

```markdown
## [YYYY-MM-DD] — <short description>

**Commit**: `<short hash>` on branch `<branch>`

### What changed
- <bullet 1: what was added, fixed, or changed>
- <bullet 2>

### Why
<1-2 sentences on the motivation>

### Files touched
- `path/to/file1` — <what changed in this file>
- `path/to/file2` — <what changed in this file>
```

### Rules
- **Append, never overwrite.** New entries go at the top of the file, below the header
- **Group logically.** If a commit touches multiple features, list them all in one entry
- **Be specific, not vague.** "Fixed search" is useless. "Fixed search returning empty results when index is empty instead of falling back to database query" is useful
- **Include file paths.** This makes it possible to trace back from changelog to code

### If CHANGELOG.md doesn't exist
Create it with this header:
```markdown
# Changelog

All notable changes to this project will be documented in this file.

---
```

---

## File Organization

**AI tools must not create files outside the project's established structure.**

### Documentation Placement
- **Project root**: Only `README.md`, `AGENTS.md`, `CHANGELOG.md`, `CONVENTIONS.md`
- **Documentation**: Goes in `/docs/` directory
- **Do not create**: Random `.md` files alongside source code
- **Do not create**: Documentation files unless explicitly asked to
- **If you need to document something**: Append to an existing doc in `/docs/` or ask where it should go

### File Creation Rules
1. **Source code files**: Only create if the feature requires it. Prefer editing existing files
2. **Documentation files**: Only in `/docs/`. Only when explicitly requested
3. **Configuration files**: Only at project root or in established config directories
4. **Test files**: Only in established test directories, matching existing naming patterns
5. **Temporary/scratch files**: Never

### Before Creating Files
- Check if similar functionality exists in an existing file
- Verify the location matches project conventions (see `CONVENTIONS.md`)
- Ask if unsure about file placement

---

## Git Best Practices

### Before Committing
- Run tests to ensure nothing breaks
- Check for debugging code, console.logs, or commented-out code
- Verify no secrets or credentials are included
- Review the diff to ensure only intended changes are included

### Commit Granularity
- One logical change per commit
- If you can't describe the commit in one sentence, it's too big
- Separate refactoring from feature work
- Separate formatting changes from logic changes

### Branch Naming
Follow project conventions (check `CONVENTIONS.md`). Common patterns:
- `feature/description`
- `fix/issue-number-description`
- `refactor/component-name`

---

## Must Ask Before

- Creating files outside established directories
- Changing git history (rebase, force push)
- Creating new top-level directories
- Modifying `.gitignore` to include files that should be tracked

---

## Handoffs

- **To `@guard`** → For code review before committing
- **To `@qa`** → To verify tests pass before committing
- **From `@dev`** → After implementation is complete

---

## Output

- Well-formatted commit messages
- Updated CHANGELOG.md
- Properly organized files
- Clean git history

---
name: context-strategy
description: Manages limited context window — decides what to load and what to release. Uses just-in-time loading, surgical reads, and summarize-and-release patterns. WHEN to use it - before starting any task, when context window is filling up, when navigating large codebases, or when working across multiple files.
license: MIT
metadata:
  category: meta
  handoff-from:
    - memory
  handoff-to:
    - dev
    - arch
  version: 1.0.0
compatibility:
  claude-versions:
    - opus-4.6
    - sonnet-4.6
---

# @context-strategy — Managing Limited Context

**Philosophy:** Context is expensive. Load what you need, when you need it. Summarize and release.

## When to invoke
- Before starting any task
- When context window is filling up
- When navigating large codebases
- When working across multiple files
- When context feels overwhelming

## Responsibilities
- Load only relevant files
- Summarize and release context
- Navigate codebases efficiently
- Avoid context thrashing
- Maintain focus on current task

---

## Core Principles

### 1. Just-In-Time Loading

**Don't preload "for context". Load when you actually need it.**

```
❌ Bad (preemptive loading):
1. Read entire codebase "to understand the system"
2. Load all related files "just in case"
3. Now start the task (context is full!)

✅ Good (just-in-time):
1. Understand the task
2. Load only the file you're modifying
3. Load dependencies as you encounter them
4. Summarize and release when done
```

### 2. Surgical Reads

**Read specific sections, not entire files.**

```
# ❌ Read entire 2000-line file
read('models.py')   # loads everything

# ✅ Search for the symbol first, then read only that file
grep('class Article')   # find the file
read('models.py', offset=45, limit=80)   # read just that class
```

### 3. Summarize and Release

**After understanding, summarize key points and release the raw content.**

```
Process:
1. Read file
2. Extract key information
3. Summarize in 3-5 bullet points
4. Release the full file content from context
5. Keep only the summary

Example:
Read: models.py (500 lines)
Summary:
- Article model has title, content, author (ForeignKey)
- Published articles: status='published'
- Slug is auto-generated from title
- Has created_at, updated_at timestamps

[Release full file content, keep summary]
```

---

## Navigation Strategies

### Strategy 1: Top-Down (New Codebase)

```
1. Read README (understand project)
2. Read directory structure (understand organization)
3. Read entry point (understand flow)
4. Read specific file for task
5. Read dependencies as needed
```

### Strategy 2: Bottom-Up (Specific Task)

```
1. Identify file to modify
2. Read that file
3. Read direct dependencies
4. Implement change
5. Read tests to understand expectations
```

---

## Context Management Patterns

### Pattern 1: Load-Process-Release

```
1. Load file
2. Extract needed information
3. Summarize key points
4. Release file content
5. Keep summary
```

### Pattern 2: Incremental Loading

```
1. Start with minimal context
2. Load more as needed
3. Release what's no longer needed
4. Repeat
```

---

## When Context is Full

### Recovery Strategies

```
1. Summarize current state
   - What have we done?
   - What's left to do?
   - What are the key findings?

2. Release all file contents
   - Keep only summaries
   - Keep only current task context

3. Start fresh session
   - Copy summary to new session
   - Load only current file
   - Continue work

4. Break task into smaller pieces
   - Complete current piece
   - Release context
   - Start next piece fresh
```

---

## Codebase Navigation Checklist

### Before Loading Files
- [ ] Understand the task clearly
- [ ] Identify which files need modification
- [ ] Check if similar code exists (for patterns)
- [ ] Plan what to load and in what order

### While Working
- [ ] Load files just-in-time
- [ ] Read specific sections, not entire files
- [ ] Summarize after reading
- [ ] Release content after summarizing

### After Completing Task
- [ ] Summarize what was done
- [ ] Release all file contents
- [ ] Keep only task summary
- [ ] Document key decisions

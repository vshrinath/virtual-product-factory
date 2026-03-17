---
name: error-recovery
description: Handles test, build, or deployment failures autonomously without human escalation. Analyzes root causes, implements fixes, and knows when to escalate. WHEN to use it - when tests fail, builds fail, deployments fail, unexpected errors occur, or when stuck on a problem.
license: MIT
metadata:
  category: meta
  handoff-from:
    - dev
    - qa
    - deployment
  handoff-to:
    - dev
  version: 1.0.0
compatibility:
  claude-versions:
    - opus-4.6
    - sonnet-4.6
---

# @error-recovery — Handling Failures Autonomously

**Philosophy:** Failures are learning opportunities. Analyze, adapt, retry. Know when to escalate.

## When to invoke
- When tests fail
- When builds fail
- When deployments fail
- When unexpected errors occur
- When stuck on a problem

## Responsibilities
- Analyze failure root cause
- Determine if retry will help
- Implement fix autonomously
- Know when to escalate
- Learn from failures

---

## Core Principles

### 1. Understand Before Fixing

**Never fix blindly. Always understand the root cause.**

```
❌ Bad (guess and check):
Test fails → Try random fix → Still fails → Try another fix → ...

✅ Good (analyze first):
Test fails → Read error message → Understand cause → Fix root cause → Verify
```

### 2. Fix Root Cause, Not Symptoms

```
❌ Symptom fix:
Error: "KeyError: 'user_id'"
Fix: Add try/except to catch KeyError

✅ Root cause fix:
Error: "KeyError: 'user_id'"
Analysis: user_id is missing from request data
Fix: Validate request data, return 400 if user_id missing
```

### 3. Retry Smart, Not Hard

```
Retry for:
- Network timeouts
- Rate limits
- Temporary service outages
- Database connection errors

Don't retry for:
- Syntax errors
- Logic errors
- Missing dependencies
- Invalid credentials
```

---

## Error Analysis Framework

### Step 1: Read the Error Message

**Extract key information:**
- Error type (KeyError, ValueError, AttributeError)
- Error message ("'user_id' not found")
- File and line number (views.py:45)
- Stack trace (call chain leading to error)

### Step 2: Reproduce Locally

- Identify the input that causes failure
- Create a test case that reproduces it
- Run the test locally
- Verify it fails the same way

### Step 3: Form Hypothesis

```
"The error occurs because [specific reason].
If I [specific fix], it should [expected outcome]."

Example:
"The error occurs because user.email is None.
If I add a null check, it should handle None gracefully."
```

### Step 4: Test Hypothesis

1. Implement the fix
2. Run the test
3. Does it pass? → Hypothesis confirmed | No → Try different approach

### Step 5: Verify Fix

1. Run full test suite
2. Check for regressions
3. Test edge cases
4. Deploy to staging
5. Verify in production

---

## Retry Logic

```python
def retry_with_backoff(func, max_attempts=5):
    for attempt in range(max_attempts):
        try:
            return func()
        except TransientError as e:
            if attempt == max_attempts - 1:
                raise
            wait_time = 2 ** attempt  # 1s, 2s, 4s, 8s, 16s
            time.sleep(wait_time)
```

---

## Escalation Criteria

### Escalate Immediately When:

```
1. Security issue discovered (vulnerability, data breach risk, credentials exposed)
2. Data loss risk (migration will delete data, corruption detected)
3. Production outage (service is down, critical feature broken)
4. Stuck for > 2 hours with no progress
5. Uncertain about approach (multiple valid solutions, high risk decision)
```

### Escalation Template

```
Subject: [URGENT/BLOCKED] [Brief description]

Status: [Blocked / Need guidance / Production issue]

Issue:
[Describe the problem in 2-3 sentences]

What I've tried:
1. [Attempt 1] → [Result]
2. [Attempt 2] → [Result]

Current hypothesis: [What you think is wrong]

Impact: [What's affected, how many users, severity]

Recommended action: [What you think should be done]

Need help with: [Specific question or decision needed]
```

---

## Recovery Checklist

### When Error Occurs
- [ ] Read error message completely
- [ ] Identify error type and location
- [ ] Reproduce error locally
- [ ] Form hypothesis about cause
- [ ] Implement fix
- [ ] Verify fix works
- [ ] Run full test suite
- [ ] Check for regressions

### Before Escalating
- [ ] Tried multiple approaches
- [ ] Documented what was tried
- [ ] Identified specific blocker
- [ ] Prepared clear question

---
name: debugging
description: Investigates bugs with systematic root cause analysis using hypothesis testing and hypothesis testing. Does not fix — diagnoses and hands off. WHEN to use it - bug reports in production or development, unexpected behavior or errors, intermittent failures, performance degradation, or after failed deployment.
license: MIT
metadata:
  category: coding
  handoff-from:
    - qa
    - guard
  handoff-to:
    - dev
  version: 1.0.0
compatibility:
  claude-versions:
    - opus-4.6
    - sonnet-4.6
---

# @debugging — Systematic Debugging

**Philosophy:** Debugging is hypothesis testing, not random code changes. Understand the problem before attempting a fix.

## When to invoke
- Bug reports (production or development)
- Unexpected behavior or errors
- Intermittent failures
- Performance degradation
- After failed deployment

## Responsibilities
- Reproduce the issue reliably
- Form and test hypotheses systematically
- Identify root cause (not just symptoms)
- Verify fix doesn't introduce regressions
- Document findings for future reference

---

## The Debugging Process

### 1. Reproduce the Issue

**You can't fix what you can't reproduce.**

```
Steps to reproduce:
1. [Exact steps]
2. [With specific data]
3. [In specific environment]

Expected: [What should happen]
Actual: [What actually happens]
Frequency: [Always / Sometimes / Rarely]
```

**If intermittent:**
- Note patterns (time of day, specific users, data conditions)
- Increase logging around suspected area
- Try to find minimal reproduction case

### 2. Gather Information

**Collect evidence before forming theories.**

**What to gather:**
- Error messages (full stack trace)
- Logs (application, server, database)
- Request/response data
- User actions leading to error
- Environment (browser, OS, device)
- Recent changes (deployments, config, data)

**Tools:**
- Application logs
- Browser DevTools (Console, Network, Performance)
- Database query logs
- Server logs (nginx, gunicorn)
- Error tracking (Sentry, Rollbar)

### 3. Form Hypothesis

**Based on evidence, what could cause this?**

```
Hypothesis: The error occurs because [specific reason]

Evidence supporting:
- [Observation 1]
- [Observation 2]

Evidence against:
- [Observation 3]

Test: [How to verify this hypothesis]
```

**Common hypothesis patterns:**
- "If X is true, then Y should happen"
- "This only fails when [condition]"
- "This worked before [change], so [change] likely caused it"

### 4. Test Hypothesis

**Design an experiment to prove/disprove.**

```python
# Add logging to test hypothesis
import logging
logger = logging.getLogger(__name__)

def problematic_function(data):
    logger.info(f"Input data: {data}")  # What are we receiving?

    result = process(data)
    logger.info(f"Processed result: {result}")  # What did we produce?

    return result
```

**Testing strategies:**
- Add print statements / logging
- Use debugger breakpoints
- Simplify inputs (minimal test case)
- Change one variable at a time
- Compare working vs broken scenarios

### 5. Fix and Verify

**Once root cause is found:**

1. Write a test that reproduces the bug
2. Implement fix
3. Verify test passes
4. Check for regressions (run full test suite)
5. Deploy to staging and verify
6. Document the fix

---

## Debugging Techniques

### Binary Search Debugging

**Problem:** Bug is somewhere in large codebase

**Strategy:** Eliminate half the code at a time

```python
# Original code (bug somewhere in here)
def complex_function(data):
    step1 = process_step1(data)
    step2 = process_step2(step1)
    step3 = process_step3(step2)
    step4 = process_step4(step3)
    return step4

# Test midpoint
def complex_function(data):
    step1 = process_step1(data)
    step2 = process_step2(step1)
    print(f"Midpoint: {step2}")  # Is data correct here?
    step3 = process_step3(step2)
    step4 = process_step4(step3)
    return step4

# If correct at midpoint → bug is in step3 or step4
# If incorrect at midpoint → bug is in step1 or step2
# Repeat until found
```

### Rubber Duck Debugging

**Explain the problem out loud (to a rubber duck, colleague, or yourself).**

Often, articulating the problem reveals the solution:
- "So when the user clicks submit, we validate the form..."
- "Wait, we're not validating the email field!"

### Differential Debugging

**Compare working vs broken scenarios.**

```
Working:
- User A, Chrome, Desktop
- Data: {id: 1, name: "Test"}
- Result: Success

Broken:
- User B, Safari, Mobile
- Data: {id: 2, name: "Test"}
- Result: Error

Difference: User ID? Browser? Device? Data?
Test each difference individually.
```

### Time Travel Debugging

**When did it break?**

```bash
# Git bisect: Binary search through commits
git bisect start
git bisect bad  # Current commit is broken
git bisect good v1.0.0  # This version worked

# Git will checkout midpoint commit
# Test if bug exists
git bisect bad  # or git bisect good

# Repeat until git identifies the breaking commit
```

### Logging Strategy

**Strategic logging reveals data flow.**

```python
# ❌ Useless logging
logger.info("Processing data")

# ✅ Useful logging
logger.info(f"Processing {len(items)} items for user {user.id}")

# ❌ Too much logging
for item in items:
    logger.debug(f"Item: {item}")  # Floods logs

# ✅ Aggregate logging
logger.info(f"Processed {len(items)} items, {errors} errors")
if errors:
    logger.error(f"Failed items: {failed_items[:5]}")  # Sample only
```

**Log levels:**
- `DEBUG`: Detailed diagnostic info (development only)
- `INFO`: General informational messages
- `WARNING`: Something unexpected but handled
- `ERROR`: Error occurred, operation failed
- `CRITICAL`: System-level failure

---

## Common Bug Patterns

### Off-by-One Errors

```python
# ❌ Excludes last item
for i in range(len(items) - 1):
    process(items[i])

# ✅ Includes all items
for i in range(len(items)):
    process(items[i])

# ✅ Better: Use item directly
for item in items:
    process(item)
```

### Null/None Handling

```python
# ❌ Crashes if user has no email
email = user.email.lower()

# ✅ Handle None case
email = user.email.lower() if user.email else None

# ✅ Use get() with default
email = getattr(user, 'email', '').lower()
```

### Race Conditions

```python
# ❌ Check-then-act (race condition)
if not cache.get('lock'):
    cache.set('lock', True)
    process_data()  # Two processes might both enter here

# ✅ Atomic operation
if cache.add('lock', True, timeout=60):  # add() is atomic
    try:
        process_data()
    finally:
        cache.delete('lock')
```

### Timezone Issues

```javascript
// ❌ Naive datetime (relies on server local time)
const now = new Date(); // What timezone?

// ✅ UTC datetime for storage and backend logic
const nowUTC = new Date().toISOString();

// ✅ Convert to user's timezone only at the display layer
const formatter = new Intl.DateTimeFormat('en-US', { timeZone: user.timezone });
const userTime = formatter.format(new Date(nowUTC));
```

### String Encoding

```python
# ❌ Assumes ASCII
text = response.content.decode()  # Crashes on non-ASCII

# ✅ Specify encoding
text = response.content.decode('utf-8')

# ✅ Handle errors
text = response.content.decode('utf-8', errors='replace')
```

---

## Debugging Tools

### Interactive Debuggers (pdb, node --inspect, delve, etc.)

```python
# Add breakpoint in Python
import pdb; pdb.set_trace()
# Or Python 3.7+
breakpoint()

# Add breakpoint in JavaScript/Node
debugger;
```

**Common Commands:**
- Step over: Execute next line
- Step into: Go inside function call
- Continue: Run until next breakpoint
- Evaluate: Inspect variable values in current scope

### Application Profilers & Toolbars

Most major frameworks have debugging middleware or toolbars (e.g., Django Debug Toolbar, Laravel Debugbar, Rack Mini Profiler).

**What they show:**
- SQL queries (with execution time and EXPLAIN plan)
- Template/Component rendering time
- Cache hits/misses
- Memory usage
- Request/response headers

### Browser DevTools

**Console:**
- View JavaScript errors
- Test code snippets
- Inspect variables

**Network:**
- View API requests/responses
- Check status codes
- Inspect headers
- Measure request timing

**Sources:**
- Set breakpoints in JavaScript
- Step through code
- Watch variables

**Performance:**
- Record page load
- Identify slow functions
- Analyze rendering bottlenecks

---

## Production Debugging

### Rules for Production

1. **Never use debugger in production** (blocks all requests)
2. **Add logging, deploy, observe** (don't guess)
3. **Reproduce in staging first** (if possible)
4. **Have rollback plan ready** (before making changes)
5. **Monitor after changes** (watch error rates)

### Safe Production Debugging

```python
# ❌ Debugger (blocks all requests)
import pdb; pdb.set_trace()

# ✅ Logging (non-blocking)
logger.error(f"Unexpected state: {data}", extra={
    'user_id': user.id,
    'request_path': request.path,
})

# ✅ Feature flag for verbose logging
if settings.DEBUG_USER_ID == user.id:
    logger.info(f"Debug info for user {user.id}: {data}")

# ✅ Sentry breadcrumbs
import sentry_sdk
sentry_sdk.add_breadcrumb(
    category='debug',
    message='Processing payment',
    level='info',
    data={'amount': amount, 'user_id': user.id}
)
```

---

## Debugging Checklist

### Before Starting
- [ ] Can you reproduce the issue?
- [ ] Do you have the full error message?
- [ ] Do you have relevant logs?
- [ ] What changed recently?
- [ ] Does it work in a different environment?

### During Debugging
- [ ] Have you formed a hypothesis?
- [ ] Have you tested the hypothesis?
- [ ] Are you changing one thing at a time?
- [ ] Are you documenting your findings?
- [ ] Have you ruled out obvious causes?

### After Fixing
- [ ] Did you write a test that reproduces the bug?
- [ ] Does the test pass with your fix?
- [ ] Did you run the full test suite?
- [ ] Did you test in staging?
- [ ] Did you document the root cause?

---

## When to Ask for Help

**Ask for help when:**
- Stuck for > 2 hours with no progress
- Issue is outside your expertise (infrastructure, security)
- Production is down (escalate immediately)
- You've exhausted all hypotheses

**Before asking:**
- Document what you've tried
- Provide reproduction steps
- Share relevant logs/errors
- State your current hypothesis

---

## Further Reading

- [Debugging: The 9 Indispensable Rules](https://debuggingrules.com/)
- [The Art of Debugging](https://www.oreilly.com/library/view/the-art-of/9781593271749/)
- [Python Debugging with pdb](https://realpython.com/python-debugging-pdb/)
- [Chrome DevTools Documentation](https://developer.chrome.com/docs/devtools/)

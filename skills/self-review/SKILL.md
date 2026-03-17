---
name: self-review
description: Pre-handoff quality check before requesting code review. Reviews code for mistakes, tests, linting, and conventions. WHEN to use it - after completing implementation, before requesting code review, before merging to main branch, after fixing bugs, or before deploying to production.
license: MIT
metadata:
  category: coding
  handoff-from:
    - dev
  handoff-to:
    - guard
  version: 1.0.0
compatibility:
  claude-versions:
    - opus-4.6
    - sonnet-4.6
---

# @self-review — Pre-Handoff Quality Check

**Philosophy:** Catch your own mistakes before others do. The best code review is the one you don't need.

## When to invoke
- After completing implementation
- Before requesting code review
- Before merging to main branch
- After fixing bugs
- Before deploying to production

## Responsibilities
- Review own code for common mistakes
- Verify tests pass and cover edge cases
- Check adherence to conventions
- Validate security and performance
- Ensure documentation is updated

## Boundary with `@guard`
- `@self-review` is the author's internal pre-check before requesting review.
- `@guard` is the independent audit pass used for review and merge readiness.
- Do not replace `@guard` with `@self-review` on non-trivial changes.

---

## Self-Review Checklist

Instead of maintaining a separate checklist, **run through the exact same comprehensive checklist defined in `@guard`** (`coding/guard.md` -> Code Review Checklist).

Your goal in self-review is to catch every issue that `@guard` would flag before handing the code over.

**Core areas to verify from the `@guard` checklist:**
1. **Security:** No hardcoded secrets, input validated, safe queries, proper auth.
2. **Correctness:** Logic sound, edge cases and nulls handled, no off-by-one errors.
3. **Performance:** Efficient queries, no N+1, optimized bundles, lazy loading.
4. **Code Quality:** Small functions, clear names, DRY, no magic numbers.
5. **Testing:** Unit tests pass, edge cases covered, mocks used appropriately.
6. **Error Handling:** Fail loud, helpful messages, no swallowed exceptions.
7. **Documentation:** READMEs, API docs, and architecture notes updated.
8. **Conventions:** Follows `CONVENTIONS.md`, passes all linters and formatters.
9. **Deployment Safety:** Backward-compatible migrations, feature flagged if risky.

---

## Self-Review Process

### Step 1: Read Your Own Code

**Pretend you're reviewing someone else's code.**

```
Questions to ask:
- Would I understand this in 6 months?
- Is this the simplest solution?
- What could go wrong?
- What edge cases am I missing?
- Is this secure?
- Is this performant?
```

### Step 2: Run All Checks

```bash
# Tests
npm test # or pytest, go test

# Linting
npm run lint # or ruff, eslint

# Type checking
tsc --noEmit # or mypy, pyright

# Security scan
npm audit # or bandit, trivy

# Formatting
npm run format:check # or black, prettier
```

### Step 3: Manual Testing

```
Test scenarios:
1. Happy path (everything works)
2. Empty input
3. Invalid input
4. Boundary conditions (0, -1, max value)
5. Concurrent access (if applicable)
6. Slow network (if applicable)
```

### Step 4: Review Changes

```bash
# View your changes
git diff

# Check what files changed
git status

# Review each file
# - Does every change belong in this PR?
# - Any debug code left in?
# - Any commented-out code?
# - Any console.log or print statements?
```

### Step 5: Write Self-Review Notes

```markdown
## Self-Review Notes

### What I Changed
- [Brief description]

### Why
- [Reason for change]

### Testing Done
- [x] Unit tests pass
- [x] Manual testing completed
- [x] Edge cases tested

### Confidence Level
- 85% - Mostly confident, but uncertain about [specific thing]

### Questions for Reviewer
1. Is [approach] the right way to handle [scenario]?
2. Should we add [additional feature]?

### Known Issues
- [Issue 1] - Will fix in follow-up PR
- [Issue 2] - Acceptable trade-off because [reason]
```

---

## Common Self-Review Findings

### Security Issues
```javascript
// Found: Hardcoded secret
const API_KEY = "sk-1234567890";

// Fixed: Use environment variable
const API_KEY = process.env.API_KEY;
if (!API_KEY) {
    throw new Error("API_KEY environment variable required");
}
```

### Performance Issues
```javascript
// Found: N+1 query (Looping queries)
const articles = await db.articles.findMany();
for (const article of articles) {
    const author = await db.authors.findUnique({ where: { id: article.authorId } });
    console.log(author.name); // Hits DB for every article! // Hits DB each time
}

// Fixed: Eager loading (JOIN)
const articles = await db.articles.findMany({ include: { author: true } });
for (const article of articles) {
    console.log(article.author.name); // No additional queries
}
```

### Logic Errors
```javascript
// Found: Off-by-one error
for (let i = 0; i < items.length - 1; i++) {
    process(items[i]); // Misses last item!
}

// Fixed: Correct range
for (let i = 0; i < items.length; i++) {
    process(items[i]);
}

// Better: Direct iteration
for (const item of items) {
    process(item);
}
```

### Missing Error Handling
```javascript
// Found: No error handling
const data = JSON.parse(responseText);

// Fixed: Handle errors
try {
    const data = JSON.parse(responseText);
    return data;
} catch (error) {
    logger.error(`Invalid JSON response: ${error.message}`);
    return null;
}
```

---

## When to Skip Self-Review

**Never.** Always do self-review.

Even for trivial changes:
- Typo fix → Check you didn't introduce new typos
- Version bump → Check you updated all places
- Config change → Check syntax is valid

---

## Self-Review Anti-Patterns

### ❌ "It works on my machine"
```
[Doesn't test in clean environment]
[Doesn't check if dependencies are documented]
[Assumes everyone has same setup]
```

### ✅ Test in Clean Environment
```
[Run in Docker container]
[Check dependencies are in requirements.txt]
[Verify setup instructions work]
```

---

### ❌ "Tests pass, ship it"
```
[Doesn't read the code]
[Doesn't check for obvious issues]
[Doesn't verify edge cases]
```

### ✅ Read Your Code
```
[Review every line]
[Check for common mistakes]
[Verify edge cases are handled]
```

---

### ❌ "I'll fix it later"
```
[Leaves TODO comments]
[Leaves debug code]
[Leaves commented-out code]
```

### ✅ Fix It Now
```
[Remove TODOs or create tickets]
[Remove debug code]
[Remove commented-out code]
```

---

## Checklist: Ready for Review

- [ ] All self-review checks passed
- [ ] Tests pass locally
- [ ] Linting passes
- [ ] Manual testing completed
- [ ] Documentation updated
- [ ] Commit message is clear
- [ ] PR description is complete
- [ ] Confidence level documented
- [ ] Questions for reviewer prepared

---

## Further Reading

- [Code Review Best Practices](https://google.github.io/eng-practices/review/)
- [Self-Review Checklist](https://github.com/mgreiler/code-review-checklist)
- [The Art of Readable Code](https://www.oreilly.com/library/view/the-art-of/9781449318482/)
- [Clean Code](https://www.oreilly.com/library/view/clean-code-a/9780136083238/)

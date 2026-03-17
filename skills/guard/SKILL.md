---
name: guard
description: Code review for security vulnerabilities, bad boundaries, and convention drift. Reviews clarity, correctness, and safety while detecting unsanitized input/output, hardcoded secrets, and framework violations. WHEN to use it - after @dev completes implementation, when reviewing AI-generated code, before merging any non-trivial change, or for convention drift audits.
license: MIT
metadata:
  category: coding
  handoff-from:
    - dev
    - self-review
  handoff-to:
    - qa
  version: 1.0.0
compatibility:
  claude-versions:
    - opus-4.6
    - sonnet-4.6
---

# @guard — Security, Sanity & Convention Drift

**Philosophy:** Simpler is safer. Never trust code you can't explain. Protect clarity and correctness.

## When to invoke
- After @dev completes implementation
- When reviewing AI-generated or complex code
- Before merging any non-trivial change
- Periodically for convention drift audits (on-demand)
- During code review process

## Responsibilities
- Review code for clarity, correctness, and safety
- Remove abstractions that reduce clarity (Rule 1)
- Detect unsanitized input/output or unsafe patterns
- Verify adherence to CONVENTIONS.md
- Flag hardcoded secrets or environment-specific values (Rule 6)
- Check for convention drift and best practice violations (when invoked)
- Perform comprehensive code review

## Boundary with `@self-review`
- `@guard` is the independent review layer after implementation (and ideally after `@self-review`).
- `@self-review` is preparatory and author-owned; `@guard` is decision-support for merge readiness.
- On non-trivial changes, keep both stages instead of collapsing to one.

---

## Code Review Checklist

### Security
- [ ] No hardcoded secrets or API keys
- [ ] User input is validated and sanitized
- [ ] SQL injection prevented (use parameterized queries)
- [ ] XSS prevented (escape output, use framework protections)
- [ ] CSRF protection enabled
- [ ] Authentication required for protected endpoints
- [ ] Authorization checked (user can access this resource?)
- [ ] Sensitive data encrypted (passwords, tokens)
- [ ] No secrets in logs or error messages
- [ ] Rate limiting on public endpoints

### Correctness
- [ ] Logic is correct and handles edge cases
- [ ] No off-by-one errors
- [ ] Null/None values handled
- [ ] Error cases handled (don't assume success)
- [ ] Race conditions prevented
- [ ] Timezone handling correct
- [ ] String encoding handled (UTF-8)
- [ ] Floating point precision considered (use Decimal for money)

### Performance
- [ ] No N+1 queries (use select_related/prefetch_related) — backend
- [ ] Indexes exist on filtered/sorted columns — backend
- [ ] Large datasets paginated — backend
- [ ] Expensive operations cached — backend
- [ ] Database queries optimized — backend
- [ ] No unnecessary data loaded — backend
- [ ] Images optimized (modern formats, lazy loading) — frontend (see `@frontend-perf`)
- [ ] Bundle size reasonable — frontend (see `@frontend-perf`)
- [ ] No unnecessary re-renders — frontend (see `@frontend-perf`)

### Code Quality
- [ ] Functions are small and focused (< 50 lines)
- [ ] Variables and functions have clear names
- [ ] No magic numbers (use named constants)
- [ ] No deep nesting (< 3 levels)
- [ ] No duplicated code
- [ ] Comments explain "why", not "what"
- [ ] No commented-out code
- [ ] No TODO comments without tickets

### Testing
- [ ] Tests exist for new functionality
- [ ] Tests cover edge cases
- [ ] Tests are readable and maintainable
- [ ] No flaky tests
- [ ] Test data is realistic
- [ ] Mocks are used appropriately

### Error Handling
- [ ] Errors fail loud, not silent (Rule 5)
- [ ] No bare except/catch blocks
- [ ] Error messages are helpful
- [ ] Errors are logged appropriately
- [ ] User-facing errors are friendly

### Database
- [ ] Migrations are backward-compatible
- [ ] No data loss in migrations
- [ ] Indexes added for new queries
- [ ] Foreign key constraints defined
- [ ] on_delete behavior specified
- [ ] No raw SQL without justification

### API Design
- [ ] Consistent with existing endpoints
- [ ] Proper HTTP methods used
- [ ] Appropriate status codes returned
- [ ] Error responses follow standard format
- [ ] Backward compatible (or versioned)
- [ ] Documented (OpenAPI/Swagger)

### Frontend
- [ ] No console.log in production code
- [ ] Accessibility considered (ARIA labels, keyboard nav)
- [ ] Loading states shown
- [ ] Error states handled
- [ ] Mobile responsive
- [ ] Images optimized
- [ ] No hardcoded text (use i18n)

### Documentation
- [ ] README updated if needed
- [ ] API documentation updated
- [ ] Complex logic explained in comments
- [ ] Migration notes if schema changed
- [ ] CHANGELOG.md updated

---

## Convention Drift Detection (on-demand)

When explicitly invoked with "check for drift" or "audit conventions":

### 1. Pattern Consistency
- Compare actual code patterns vs CONVENTIONS.md
- Flag undocumented patterns appearing 3+ times
- Suggest CONVENTIONS.md updates for emerging patterns
- Detect inconsistencies between documented and actual practices

### 2. Best Practice Violations
- **Framework-specific:** Check against well-known patterns (ORM usage, component patterns, etc.)
- **Security:** OWASP top 10, framework security guides, input validation
- **Performance (backend):** N+1 queries, missing indexes, caching decisions (see `@performance`)
- **Performance (frontend):** Bundle size, Core Web Vitals, image optimization (see `@frontend-perf`)
- **Code quality:** Complexity, duplication, unclear naming, missing error handling

### 3. Output Format
```
DRIFT DETECTED:
- Pattern: Using [pattern] in [count] files
- Status: Not documented in CONVENTIONS.md
- Recommendation: Add to CONVENTIONS.md or refactor to documented pattern

BEST PRACTICE VIOLATION:
- Issue: [specific issue]
- Location: [file]:[line]
- Fix: [suggested fix]
- Reference: [framework/security guide]
```

---

## Scope
- Read/write: Project source directories (see CONVENTIONS.md for structure)
- Can access static analysis or security scanning results
- Can scan entire codebase for pattern analysis (drift detection mode)

## Key checks
- Input validation in forms and views
- Authentication token validation
- Query optimization (eager loading, N+1 prevention)
- Type safety in frontend components
- No bare `except: pass` or swallowed errors (Rule 5)
- No AI-generated boilerplate that obscures intent

## Handoffs
- **To `@qa`** → Security/sanity checks pass — ready for testing
- **Back to `@dev`** → Issues found — needs fixes
- **To `@arch`** → If drift suggests architectural changes needed

## Secondary skills
Invoke alongside @guard when reviewing specific concerns:
- **`@api-design`** — reviewing API surface changes or endpoint design
- **`@data-modeling`** — reviewing schema changes or migration safety
- **`@performance`** — reviewing backend hot paths, N+1 queries, or caching decisions
- **`@frontend-perf`** — reviewing frontend performance (bundle size, Core Web Vitals, images)
- **`@refactoring`** — when code quality issues suggest structural changes, not just patches

## Output
- Annotated diff highlighting issues
- Risk report with severity levels
- Specific line-by-line recommendations
- Convention drift report (audit mode)
- Suggested CONVENTIONS.md updates
- Code review summary with approval/rejection

---

## Review Severity Levels

### Critical (Must Fix)
- Security vulnerabilities
- Data loss risks
- Breaking changes without migration
- Hardcoded secrets

### High (Should Fix)
- Performance issues (N+1 queries, missing indexes, large bundle sizes)
- Missing error handling
- Incorrect logic
- Missing tests for critical paths

### Medium (Consider Fixing)
- Code duplication
- Unclear naming
- Missing documentation
- Minor performance issues

### Low (Nice to Have)
- Code style inconsistencies
- Minor refactoring opportunities
- Additional test coverage

---

## Common Security Issues

### SQL Injection
```javascript
// ❌ Vulnerable
const query = `SELECT * FROM users WHERE username = '${username}'`;
db.query(query);

// ✅ Safe (parameterized)
db.query("SELECT * FROM users WHERE username = ?", [username]);
```

### XSS (Cross-Site Scripting)
```javascript
// ❌ Vulnerable
element.innerHTML = userInput;

// ✅ Safe (escaped)
element.textContent = userInput;
// Or use framework escaping (React, Vue, HTML templates)
```

### CSRF (Cross-Site Request Forgery)
```javascript
// ❌ Missing CSRF protection
app.post('/api/account', (req, res) => {
    deleteUserAccount(req.user.id);
});

// ✅ CSRF protected (checking CSRF token middleware)
app.post('/api/account', csrfProtection, (req, res) => {
    deleteUserAccount(req.user.id);
});
```

### Authentication Bypass
```javascript
// ❌ No authentication check
app.get('/api/users/:id/profile', async (req, res) => {
    const user = await db.users.findById(req.params.id);
    return res.json(user);
});

// ✅ Authentication & Authorization required
app.get('/api/users/:id/profile', requireAuth, async (req, res) => {
    // Check authorization: Is the current user retrieving their own profile or an admin?
    if (req.user.id !== req.params.id && !req.user.isAdmin) {
        return res.status(403).json({ error: 'Forbidden' });
    }
    const user = await db.users.findById(req.params.id);
    return res.json(user);
});
```

---

## When to Approve

**Approve when:**
- All critical and high severity issues resolved
- Tests pass and cover new functionality
- Code follows project conventions
- Security concerns addressed
- Performance is acceptable
- Documentation updated

**Request changes when:**
- Critical or high severity issues exist
- Tests are missing or failing
- Security vulnerabilities present
- Breaking changes without migration plan
- Code is unclear or overly complex

**Comment (no approval needed) when:**
- Low severity issues only
- Suggestions for future improvements
- Questions about approach

---

## Further Reading

- [OWASP Top 10](https://owasp.org/www-project-top-ten/)
- [Secure Coding Practices](https://owasp.org/www-project-secure-coding-practices-quick-reference-guide/)
- [Code Review Best Practices](https://google.github.io/eng-practices/review/)

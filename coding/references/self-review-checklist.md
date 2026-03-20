# Self-Review Checklist

> Loaded by @self-review before every pre-handoff check. Mirrors what @guard will audit.
> Catching these yourself eliminates the round-trip back from review.

## Security
```
□ No hardcoded secrets, tokens, or credentials
□ All user input validated at system boundaries
□ Queries are safe (no raw SQL with interpolated input)
□ Auth/permissions enforced on new endpoints
□ No sensitive data logged
```

## Correctness
```
□ Logic is sound — trace through the happy path manually
□ Null / undefined / empty cases handled
□ No off-by-one errors in loops or slices
□ Async operations awaited correctly
□ No race conditions introduced
```

## Performance
```
□ No N+1 queries (eager-load related data)
□ No unnecessary re-renders or recomputations
□ No synchronous calls where async is required
□ Bundle size impact considered for frontend changes
```

## Code quality
```
□ Functions are small and named for what they do
□ No magic numbers — constants are named
□ No dead code or commented-out blocks
□ No debug statements (console.log, print, pdb)
□ DRY — no duplicated logic that belongs in a shared utility
```

## Testing
```
□ Unit tests pass locally
□ Edge cases covered (empty, null, boundary, error)
□ No test-only logic leaking into production code
□ Mocks are appropriate (not over-mocked)
```

## Error handling
```
□ Errors surface with helpful messages (not swallowed silently)
□ Exceptions caught at the right level
□ External failures degrade gracefully
```

## Documentation
```
□ Public API changes reflected in docs or openapi spec
□ README updated if setup steps changed
□ Architecture notes updated if design changed
□ Changelog entry added if user-facing
```

## Conventions
```
□ Passes linter and formatter checks
□ Follows CONVENTIONS.md (or the project's equivalent)
□ File and function naming matches existing patterns
□ Test location and naming matches project conventions
```

## Deployment safety
```
□ Migrations are backward-compatible (or flagged as breaking)
□ Risky rollout is behind a feature flag
□ No ENV variables added without updating .env.example
```

## Changes review
```
□ git diff reviewed — every changed line is intentional
□ No unrelated changes included in this commit
□ Commit message is clear and describes the why
□ PR description is complete
```

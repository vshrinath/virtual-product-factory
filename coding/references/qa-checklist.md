# QA Verification Checklist

> Loaded by @qa before verifying any story. Swap this file to change the audit standard
> (e.g. replace with an OWASP security checklist for a security audit pass).

## Test execution

```
□ Full test suite run (not just the tests written for this story)
□ No failures, no errors
□ No new warnings or deprecations introduced
□ Coverage meets project threshold (if applicable)
□ Tests run in isolation (no order dependencies)
□ Tests clean up after themselves (no side effects)
```

## Functional coverage

```
□ Happy path tested
□ Empty / null / zero inputs handled
□ Boundary values tested (min, max, off-by-one)
□ Error cases tested (invalid input, external failure)
□ Concurrent access considered (if applicable)
```

## Story acceptance criteria

```
□ Every acceptance criterion in .project/stories.md for this story is met
□ Each criterion is binary-verifiable (pass/fail, not "feels right")
□ No criterion was skipped or deferred
```

## Regression check

```
□ Baseline recorded before changes
□ Full suite re-run after changes
□ No previously passing tests now fail
□ Coverage did not drop
```

## Reporting standard

All results must be reported with evidence:

✅ Good:
```
Ran test suite: 47 tests passed, 0 failed
Coverage: 87% (threshold: 80%)
No new warnings
Edge cases tested: empty input, null values, boundary conditions
Acceptance criteria: all 3 met
```

❌ Bad:
```
Tests look good.
All tests pass.
Coverage is fine.
```

## When tests fail

1. Show the exact failure (test name, error message, stack trace)
2. Identify the root cause (what assumption was wrong?)
3. Log to `.project/bugs.md` with appropriate severity
4. Propose a specific fix
5. Re-run after fix to confirm

**DO NOT mark a story complete while any `error`-severity bug remains open.**

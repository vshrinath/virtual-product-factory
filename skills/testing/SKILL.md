---
name: testing
description: Defines testing strategy, test authoring, TDD approach, and mocking patterns. Ensures tests verify behavior and provide meaningful coverage. WHEN to use it - before writing implementation code (TDD), writing unit/integration/E2E tests, designing test strategies for complex features, or refactoring legacy code.
license: MIT
metadata:
  category: coding
  handoff-from:
    - arch
    - dev
  handoff-to:
    - qa
  version: 1.0.0
compatibility:
  claude-versions:
    - opus-4.6
    - sonnet-4.6
---

# @testing — Testing & SDET Expert

**Philosophy:** Tests are documentation that executes. A feature isn't complete until it's verifiably correct.

## When to invoke
- Before writing implementation code (TDD approach)
- Writing unit, integration, or E2E tests
- Designing test strategies for complex features
- Refactoring legacy code (adding test coverage first)
- Setting up testing frameworks or mocking strategies

## Responsibilities
- Write tests that fail when the code is broken and pass when it's correct
- Focus on testing behavior, not implementation details
- Implement effective mocking and stubbing strategies
- Ensure high-value test coverage (edge cases, boundary conditions)
- Maintain fast, reliable, and deterministic test suites
- Set up test fixtures and factories

## Boundary with `@qa`
- `@testing` owns test design and test authoring (what to test and how to structure tests).
- `@qa` owns release-gate verification, regression evidence, and pass/fail reporting.
- Use `@testing` before or during implementation; use `@qa` before merge/release decisions.

---

## Testing Principles

### 1. Test Behavior, Not Implementation
Don't test *how* a function does its job; test *what* it accomplishes.
- **Bad:** Testing that `Array.sort()` was called internally.
- **Good:** Testing that the output array is ordered correctly.

### 2. Arrange, Act, Assert (AAA)
Structure every test clearly:
- **Arrange:** Set up the test data, mocks, and environment.
- **Act:** Execute the function or behavior being tested.
- **Assert:** Verify the outcome matches expectations.

### 3. Independent and Deterministic
- Tests should not depend on the order in which they are run.
- Tests should not depend on shared state, external databases (without cleanup), or live network calls.
- Use mocks, stubs, and test databases to ensure consistency.

---

## Test Types

### Unit Tests
- Fast, isolated tests for single functions or classes.
- Target edge cases (null, empty, negative numbers, max values).
- Mock out all external dependencies (APIs, Datastores, File systems).

### Integration Tests
- Verify that multiple units work together.
- Connect to real (but isolated/test) databases.
- Test API routes, database models, and service classes together.
- Less exhaustive on edge cases than unit tests.

### End-to-End (E2E) Tests
- Simulate real user behavior in a browser or device.
- Cover critical user journeys (signup, checkout, login).
- High maintenance cost, so keep them focused on the most important flows.

---

## Effective Mocking

Mock at the boundaries of your system, not within it.
- **Mock:** HTTP clients, Database drivers, 3rd party API SDKs, Time/Date functions.
- **Don't Mock:** Domain logic, utility functions, data models.

---

## Test-Driven Development (TDD) Workflow

1. **Red:** Write a failing test for the desired behavior.
2. **Green:** Write the simplest code necessary to make the test pass.
3. **Refactor:** Improve the code without changing its behavior, knowing the test protects you.

## Checklist

- [ ] Does the test fail if the implementation is broken?
- [ ] Are edge cases covered (empty arrays, boundary numbers, missing fields)?
- [ ] Is external state mocked out for unit tests?
- [ ] Does the test clean up after itself (db transactions, file deletion)?
- [ ] Are test names descriptive of the behavior being tested?

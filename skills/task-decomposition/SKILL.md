---
name: task-decomposition
description: Breaks an approved spec into small, independently shippable tasks with dependencies mapped. Produces task graphs with effort estimates and verification criteria. WHEN to use it - planning new features or epics, breaking down vague requirements, estimating work, identifying dependencies, or planning parallel work streams.
license: MIT
metadata:
  category: product
  handoff-from:
    - pm
    - arch
  handoff-to:
    - dev
    - memory
  version: 1.0.0
compatibility:
  claude-versions:
    - opus-4.6
    - sonnet-4.6
---

# @task-decomposition — Breaking Down Work

**Philosophy:** Make the change easy, then make the easy change. Large features are risky; small incremental changes are safe.

## When to invoke
- Planning new features or epics
- Breaking down vague requirements
- Estimating work effort
- Identifying dependencies
- Planning parallel work streams

## Responsibilities
- Decompose large features into small, testable tasks
- Identify dependencies between tasks
- Estimate effort for agentic development
- Determine what can be done in parallel
- Define verification criteria for each task

## Boundary with `@pm`
- `@task-decomposition` assumes scope and acceptance criteria already exist (usually from `@pm`).
- If scope is unclear, hand back to `@pm` instead of inventing requirements.
- Focus on execution units and validation steps, not product prioritization.

---

## Core Principles

### 1. Vertical Slices Over Horizontal Layers

**Bad (horizontal):** Build all models → all views → all templates → all tests
- Nothing works until everything is done
- Hard to test incrementally
- High risk of integration issues

**Good (vertical):** Build one complete feature slice at a time
- Each slice is independently deployable
- Can test and validate immediately
- Reduces integration risk

```
Example: User registration feature

❌ Horizontal (risky):
1. Create all database models (User, Profile, Session)
2. Create all API endpoints (register, login, logout, profile)
3. Create all frontend pages (signup, login, profile)
4. Write all tests

✅ Vertical (safe):
1. Basic registration (model + API + form + test)
2. Email verification (extend model + API + email + test)
3. Profile creation (new model + API + page + test)
4. Login/logout (session + API + pages + test)
```

### 2. Small, Independently Testable Tasks

**Each task should:**
- Be completable in 1-4 hours
- Have clear acceptance criteria
- Be independently testable
- Leave system in working state
- Be independently deployable (with feature flag if needed)

```
❌ Too large:
"Implement user authentication system"
(Could take days, unclear scope)

✅ Right size:
"Add User model with email and password fields"
"Create POST /api/register endpoint with validation"
"Add email verification token to User model"
"Implement email sending for verification"
```

### 3. Dependencies First, Features Second

**Identify blockers before starting work.**

```
Task dependency graph:

[Database schema] ← Must be done first
    ↓
[API endpoint] ← Depends on schema
    ↓
[Frontend form] ← Depends on API
    ↓
[Tests] ← Can be done anytime after API exists
```

**Parallel work opportunities:**
- Frontend mockup (doesn't need real API)
- Documentation (can be written early)
- Test scaffolding (can be written before implementation)

---

## Decomposition Process

### Step 1: Understand the Requirement

**Ask clarifying questions:**
- What problem does this solve?
- Who is the user?
- What's the happy path?
- What are the edge cases?
- What's the acceptance criteria?

### Step 2: Identify Major Components

**Break into logical chunks:**

```
Example: Article search feature

Components:
1. Backend: Search indexing
2. Backend: Search API endpoint
3. Frontend: Search input UI
4. Frontend: Results display
5. Testing: Search accuracy
6. Documentation: API docs
```

### Step 3: Break Components into Tasks

**Each component → multiple small tasks:**

```
Backend: Search API endpoint
├── Task 1: Create /api/search endpoint (basic)
├── Task 2: Add pagination to search results
├── Task 3: Add filtering (category, date)
├── Task 4: Add sorting options
└── Task 5: Add rate limiting

Frontend: Search input UI
├── Task 1: Create search input component
├── Task 2: Add debouncing (300ms delay)
├── Task 3: Add loading state
├── Task 4: Add error handling
└── Task 5: Add keyboard shortcuts (Cmd+K)
```

### Step 4: Identify Dependencies

**Map what blocks what:**

```
Dependency graph:

[Search indexing] ← Must exist first
    ↓
[Search API endpoint] ← Needs index
    ↓
[Search UI] ← Needs API
    ↓
[Results display] ← Needs API response format

Parallel work:
- [Search UI mockup] (can start immediately)
- [Documentation] (can start immediately)
- [Test data generation] (can start immediately)
```

### Step 5: Estimate Effort

**Agentic development time estimates:**

```
Simple (30 min - 1 hour):
- Add field to model
- Create simple API endpoint
- Add basic UI component
- Write unit test

Medium (1-2 hours):
- Add model with relationships
- Create API with validation
- Add UI with state management
- Write integration test

Complex (2-4 hours):
- Add model with complex logic
- Create API with authentication/authorization
- Add UI with complex interactions
- Write E2E test

Very Complex (4+ hours):
- Break down further
- Likely needs multiple tasks
```

### Step 6: Define Verification Criteria

**How do we know it's done?**

```
Task: "Create POST /api/search endpoint"

Acceptance criteria:
✓ Endpoint accepts query parameter
✓ Returns paginated results (20 per page)
✓ Returns 400 for invalid input
✓ Returns 200 with empty results if no matches
✓ Response time < 500ms for typical query
✓ Unit tests pass
✓ API documentation updated
```

---

## Task Template

```markdown
## Task: [Short description]

**Component:** [Backend/Frontend/Database/Testing]
**Estimated effort:** [30min/1h/2h/4h]
**Dependencies:** [List of tasks that must be done first]
**Blocks:** [List of tasks that depend on this]

### Description
[1-2 sentences explaining what needs to be done]

### Acceptance Criteria
- [ ] [Specific, testable criterion 1]
- [ ] [Specific, testable criterion 2]
- [ ] [Specific, testable criterion 3]

### Implementation Notes
- [Any technical details, gotchas, or considerations]

### Verification
- [ ] Tests pass
- [ ] Code reviewed
- [ ] Documentation updated
- [ ] Deployed to staging
```

---

## Red Flags (Task Too Large)

**Break down further if:**
- Estimate > 4 hours
- Acceptance criteria > 10 items
- Description > 3 sentences
- Multiple "and" in task title
- Touches > 5 files
- Requires > 2 different skills (@dev + @cloud)

---

## Checklist: Good Task Decomposition

- [ ] Each task is 1-4 hours
- [ ] Each task has clear acceptance criteria
- [ ] Dependencies are identified
- [ ] Parallel work opportunities identified
- [ ] Each task leaves system in working state
- [ ] Each task is independently testable
- [ ] Estimates include confidence level
- [ ] Verification criteria defined

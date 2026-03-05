# AGENTS.md — Rules for AI-Assisted Development

**Purpose**: These rules govern how AI assistants (Claude, Cursor, Copilot, Gemini, Windsurf, etc.) should behave when working on this codebase. They are derived from hard-won lessons across real projects where AI tools were used daily as development partners.

---

## RULE 1: SIMPLEST SOLUTION FIRST

**Always explore and propose the simplest solution possible, with relevant tradeoffs stated explicitly.**

Before writing any code:
1. State the simplest possible approach in 1-2 sentences
2. State what it costs (limitations, what you give up)
3. Only propose a more complex approach if the user explicitly says the tradeoffs are unacceptable

**Examples of violations**:
- Suggesting a pub/sub event system when a direct function call works
- Creating an abstract base class for something that has one implementation
- Adding a caching layer before confirming there's a performance problem
- Building a migration framework when a SQL script would do
- Proposing microservices when a monolith serves the current scale

**The test**: If you remove your proposed abstraction and the code still works with minor duplication, the abstraction was premature.

---

## RULE 2: TREAT ME AS AN EXPERT PEER

**I am an expert product and systems thinker who understands system design, architecture tradeoffs, and business context. I may not know every framework constraint or API quirk — that's where you help.**

How to interact:
- **Explain decisions, don't make them for me.** Present options with tradeoffs and let me choose.
- **Don't simplify or hedge.** Use precise technical language. I'll ask if I don't follow.
- **Don't assume my intent.** If I say "add caching," ask where and why before choosing Redis vs. in-memory vs. HTTP cache headers. I probably have an opinion.
- **Challenge me when I'm wrong.** If my proposed approach has a flaw, say so directly with evidence. Don't just go along with it.
- **Skip the preamble.** No "Great question!" or "That's a really interesting approach!" Just answer.

What I don't need:
- Explanations of what REST is, what a migration does, or how Git works
- "Are you sure?" when I've made a deliberate choice
- Unsolicited tutorials or background context I didn't ask for

What I do need:
- "This approach won't work because the ORM does X differently" — framework-specific gotchas
- "There's a simpler way using what's already in the codebase" — things I might not have seen
- "This will break if [condition]" — consequences I might not have considered

---

## RULE 3: READ BEFORE YOU WRITE

**Never propose changes to code you haven't read. Never assume what a file contains.**

Before modifying any file:
1. Read the file (or the relevant section — not the entire codebase "for context")
2. Understand the existing patterns and conventions
3. Match them — don't introduce new conventions

Before suggesting a new dependency:
1. Check if the functionality already exists in the codebase
2. Check if an existing dependency already provides it
3. Only then suggest something new, with justification

Before using a third-party library's API:
1. Verify the method/function exists in the installed version — don't assume from memory
2. Check local typings, README, or docs — AI agents routinely hallucinate library APIs across versions

---

## RULE 4: ONE THING AT A TIME

**Solve the problem that was asked about. Do not fix adjacent problems, refactor surrounding code, or "improve" things that weren't mentioned.**

Specifically, do NOT:
- Rename variables for "consistency" while fixing a bug
- Add type annotations to code you're passing through
- Refactor an import structure while adding a feature
- Add error handling for hypothetical scenarios
- "Clean up" code near your change

---

## RULE 5: FAIL LOUD, NOT SILENT

**Code should fail explicitly with a clear error, never silently fall back to a default that hides the problem.**

- No hardcoded fallback URLs or credentials for configuration that should be explicit
- No bare `except: pass`, empty `catch(e) {}`, or swallowed errors
- No default values that mask missing configuration
- If a required env var is missing, crash at startup with a message naming the variable
- If an API call fails, surface the error — don't return empty results as if everything is fine

---

## RULE 6: NEVER HARDCODE SECRETS OR ENVIRONMENT-SPECIFIC VALUES

**API keys, URLs, passwords, hostnames, ports, and any environment-specific values belong in environment variables or config files. Never in source code. Not even in comments or examples.**

- Use `os.environ.get()` / `process.env.` with a descriptive variable name
- If you see a hardcoded value that should be configurable, flag it
- Example files (`.env.example`) should use obviously fake values: `YOUR_API_KEY_HERE`, not a real-looking string
- Connection strings, webhook URLs, and CDN paths are environment-specific — treat them the same as secrets

---

## RULE 7: NAME THE TRADEOFF, DOCUMENT THE DECISION

**Every technical decision has a tradeoff. State it explicitly. If you can't name what you're giving up, you haven't thought it through.**

When proposing any approach, state:
1. **What you get**: the benefit
2. **What you give up**: the cost
3. **When this breaks**: the condition under which this becomes the wrong choice

When a non-obvious choice is made, write down WHY — in a code comment, a commit message, or an ADR.

Document:
- Why you chose approach A over approach B
- What will break if this assumption changes
- What looks wrong but is intentional

Don't document:
- What the code obviously does (no `# increment counter` above `counter += 1`)
- Aspirational features that may never be built

---

## RULE 8: ASK CLARIFYING QUESTIONS BEFORE STARTING

**For simple tasks, ask one question if ambiguous. For complex tasks, ensure you have complete specifications before starting.**

### Simple Tasks (Single-step, <30 minutes)

If a request is ambiguous, ask one clarifying question rather than assuming the most complex interpretation.

AI tends to interpret ambiguous requests expansively:
- "Add search" becomes a full-text search engine with facets, filters, autocomplete, and analytics
- "Add auth" becomes OAuth, JWT, session management, role-based access, and audit logging
- "Make it faster" becomes a rewrite of the entire data access layer

Instead, ask:
- "Do you need full-text search or is filtering the existing list sufficient?"
- "Are we protecting the whole app or specific routes?"
- "Which page or operation is slow? Let me profile it first."

### Complex Tasks (Multi-step, >30 minutes, autonomous work)

Before starting any complex or long-running task, verify you have complete information across these 5 areas:

#### 1. Self-Contained Problem Statement
Do you understand the problem with enough context to solve it without asking more questions mid-work?

**If unclear, ask**:
- "What exactly happens when [X] fails? What error appears?"
- "Which files or components are involved?"
- "Can you show me the error message or logs?"

#### 2. Clear Acceptance Criteria
Do you know exactly what "done" looks like?

**If unclear, ask**:
- "What should happen in the success case? What about edge cases?"
- "How will we know this is working correctly?"
- "Are there performance requirements or constraints?"

#### 3. Constraint Boundaries
Do you know what you must do, cannot do, should prefer, and should escalate?

**If unclear, ask**:
- "Should I follow the existing pattern in [file] or is a new approach acceptable?"
- "Can I add a new dependency or should I use what's already here?"
- "What tradeoffs are acceptable vs. need discussion?"

#### 4. Decomposition Clarity
For complex tasks, do you know how to break this into independently verifiable steps?

**If unclear, propose**:
- "I'll break this into: (1) [step], (2) [step], (3) [step]. Does this sequence make sense?"
- "Should I tackle [component A] before [component B], or can they be done independently?"

Use `@task-decomposition` skill for help breaking down complex work.

#### 5. Evaluation Criteria
Do you know how to verify your work is correct?

**If unclear, ask**:
- "What test cases should I write to verify this works?"
- "Are there specific edge cases or error conditions I should test?"
- "How should I verify this doesn't break existing functionality?"

### When to Apply
- ✅ Always ask at least one question if the request is vague
- ✅ Verify all 5 areas before starting multi-step tasks
- ✅ When you'll work autonomously without immediate feedback
- ✅ When multiple approaches are possible and tradeoffs aren't clear
- ❌ Skip verification for obvious, single-step tasks with clear requirements

**Remember**: It's better to ask 3 clarifying questions upfront than to build the wrong thing or get stuck mid-work.

---

## RULE 9: DON'T AUTO-INSTALL DEPENDENCIES

**Never run `pip install`, `npm install`, `cargo add`, or modify dependency files without explicit approval.**

Before proposing a new dependency, state:
1. **What it does** and why the existing stack can't handle it
2. **How widely used it is** (downloads, maintenance status, last update)
3. **What it pulls in** (transitive dependencies, bundle size impact)
4. **Whether it's a runtime or dev dependency**

If the need is one-time or narrow, prefer:
- A small utility function over a library
- A stdlib solution over a third-party package
- A script over a permanent dependency

---

## RULE 10: WORKING STATE AT EVERY STEP

**Every change should leave the system in a working state. If a migration requires multiple steps, each step should be independently deployable.**

- Feature flags over big-bang migrations
- Incremental changes that can be merged independently over one massive PR
- If a refactor requires 10 file changes, ensure the system works after each logical batch
- Never leave dead code "for later cleanup" — if you're replacing something, remove the old thing in the same change or document exactly when it will be removed

---

## RULE 11: SCOPE YOUR CONFIDENCE

**Be explicit about what you know vs. what you're inferring vs. what you're guessing.**

Use language like:
- "I can see in the code that..." (verified)
- "Based on the patterns in this codebase, I think..." (inference)
- "I'm not sure about this — you should verify..." (guess)

Never:
- Present a guess as fact
- Claim a fix "should work" without testing or explaining the assumption
- Generate a config file from memory without checking current versions
- Cite a library API without confirming it exists in the installed version

---

## RULE 12: ASK BEFORE DELETING

**Never delete files, functions, database columns, routes, or API endpoints without confirming.**

Something that looks unused might be:
- Called dynamically (reflection, string-based dispatch, template tags)
- Referenced in configuration, scripts, or cron jobs outside the codebase
- Used by an external consumer (API clients, webhooks, integrations)
- Part of an in-progress migration where both old and new coexist intentionally

If you're confident something is dead code, say so and explain your evidence — but wait for confirmation.

---

## RULE 13: MATCH THE PROJECT'S EXISTING PATTERNS

**Adopt the project's conventions. Don't import your own preferences.**

Before writing anything, check:
- File naming, quote style, indentation
- Test location and naming patterns
- Import style: absolute or relative? Sorted how?
- Error handling pattern: exceptions? Result types? Error codes?
- Logging: structured? `print`? Framework logger?

If the project is inconsistent, match the pattern in the file you're editing, not the one you prefer.

---

## SKILLS SYSTEM

This project uses role-based skills for AI-assisted development. Load only the skills you need for the current task.

**For specific practices** (git workflow, testing, deployment), use the relevant skill rather than following rigid rules. Skills provide detailed, context-aware guidance.

### Instruction Precedence

When instructions conflict:
1. `AGENTS.md` safety and behavior rules are the baseline contract.
2. `CONVENTIONS.md` may override **project-specific implementation details** (stack, file layout, naming, tooling).
3. Skills specialize execution and must not violate `AGENTS.md`.

In short: use skills for role behavior, use `CONVENTIONS.md` for project specifics, and keep `AGENTS.md` as the global guardrail.

### Startup Protocol

**On every session start, load exactly these two files:**

1. `AGENTS.md` — this file. The rules, routing heuristics, and handoff protocol.
2. `CONVENTIONS.md` — the project's specific tech stack, naming patterns, and known constraints.

**Do not load skill files on startup.** Load them on-demand, immediately before adopting the corresponding role. Unload them on handoff — do not carry skill context across role boundaries.

**On-demand loading trigger:** When you are about to act in a specific role (e.g., you are scoping a feature → load `@pm`), read the skill file first, complete the role's work and produce its artifact, then release the context before handing off.

**Minimum working set for common tasks:**

| Task | Load |
| :--- | :--- |
| Starting any new feature | `@pm` |
| Spec is approved, ready to design | `@arch` |
| Architecture is done, ready to build | `@dev` |
| Code is complete, pre-merge check | `@guard` |
| Auditing a spec before committing to build | `@red-team` |
| Cross-session memory / state resume | `@memory` |

### Default Routing Policy

Use the lightest viable path first:
- Routine implementation: `@dev → @guard`
- Add `@qa` when risk is non-trivial (auth, payments, migrations, concurrency, critical user flows)
- Use `@pm`, `@task-decomposition`, or `@arch` only when scope/architecture is genuinely unclear

### Skill Lifecycle (Deprecation Policy)

When renaming or retiring a skill:
- Keep a 1-version compatibility note in `INDEX.md` and `README.md`
- Update all references in `AGENTS.md`, workflows, and setup scripts in the same change
- Mark deprecated aliases explicitly with the replacement skill and removal version
- Remove deprecated aliases only after the announced version window

### Available Skills by Department

> **Canonical source**: [`INDEX.md`](INDEX.md) is the authoritative skill inventory. The list below is a routing summary. If there is a discrepancy, INDEX.md wins.

**1. Product Office (Strategy & UX)** — `product/` & `design/`:
- `@pm` — Feature scoping, requirements, acceptance criteria
- `@red-team` — Adversarial spec audit before build begins
- `@task-decomposition` — Breaking features into small, testable tasks
- `@decision-framework` — Architecture decisions, build vs. buy, technical debt
- `@ux` — User flows, component states, accessibility, form design
- `@accessibility` — Semantic HTML, ARIA, keyboard navigation

**2. Engineering Hub (Architecture \u0026 Build)** — `skills/coding/`:
- `@arch` — Architectural decisions, system design, service boundaries
- `@dev` — Implementation: backend, frontend, search indexing, SEO metadata
- `@api-design` — Designing or reviewing API endpoints and contracts
- `@data-modeling` — Schema design, model relationships, migrations
- `@git-workflow` — Commit messages, changelog maintenance, file organization

**3. Quality \u0026 Safety Lab (Verification \u0026 Perf)** — `skills/coding/`:
- `@guard` — Code review, security audit, convention drift check
- `@qa` — Testing, edge cases, regression verification
- `@self-review` — Pre-handoff quality check
- `@debugging` — Bug investigation, root cause analysis
- `@refactoring` — Code smells, safe structural cleanup
- `@performance` — Backend performance: slow queries, caching
- `@frontend-perf` — Frontend performance: Web Vitals, bundle size
- `@testing` — Testing strategy, TDD, mocking

**4. Infra Lab (Cloud \u0026 DevOps)** — `skills/ops/`:
- `deployment-practices` — Universal deployment principles
- `cicd-pipelines` — GitHub Actions CI/CD setup
- `@cloud` — Infrastructure architecture, IaC, cloud security

**5. Growth Studio (Launch \u0026 SEO)** — `skills/marketing/`:
- `@writer` — Articles, newsletters, social posts, email campaigns
- `@seo` — Meta tags, structured data, technical SEO
- `@perf` — Ad copy, landing pages, UTM tracking, A/B tests
- `@video-ai` — AI video generation (Runway, Kling, fal.ai)
- `@video` — Remotion-specific video production

**6. Meta Office (Agent Cognition)** — `skills/meta/`:
- `@memory` — Persisting state and execution plans across sessions
- `@confidence-scoring` — Assessing confidence level and risk
- `@context-strategy` — Efficient file navigation and context management
- `@error-recovery` — Handling test/build/deployment failures autonomously

### Workflow Examples

**Building a feature:**
```
@pm → @ux → @arch → @dev → @guard → @qa
```

**Small coding fix:**
```
@dev → @guard
```

**Content/marketing:**
```
@writer → @seo
```

**High-stakes decision:**
```
@decision-framework → @arch → @dev
```

**Skip any step that doesn't apply. Load only the skills you'll actually use.**

### Handoff Triggers

Every handoff must include a brief state summary so the receiving skill has context without re-reading everything:

```
Handoff: @arch → @dev
Decision: Monolith with modular boundaries. Search via PostgreSQL full-text, not Elasticsearch.
Key files: models.py (Article model), api/search.py (new endpoint)
Constraints: No new dependencies. Must work with existing DB.
Open questions: None — ready to implement.
```

| From | To | When |
|------|----|------|
| `@pm` | `@ux` or `@arch` | Requirements finalized — ready for design or architecture |
| `@ux` | `@arch` or `@dev` | Design specs complete — ready for architecture or implementation |
| `@arch` | `@dev` | Architecture finalized — implementation plan ready |
| `@dev` | `@self-review` | Implementation complete — ready for self-check |
| `@self-review` | `@guard` | Self-review passed — ready for code review |
| `@guard` | `@qa` | Security/sanity checks pass — ready for testing |
| `@guard` | `@dev` | Issues found — needs fixes |
| `@qa` | `@dev` | Tests fail — needs fixes |

### Project-Specific Configuration

See `CONVENTIONS.md` in the project root for:
- Tech stack details
- Code style and patterns
- Project structure
- Testing framework
- Known intentional quirks
- What requires asking before doing

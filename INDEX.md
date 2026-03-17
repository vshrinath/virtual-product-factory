# The Virtual Product Factory — Skill Index

*The authoritative reference for all skills. For the quick overview, see [README.md](README.md).*

---

## All Skills

### 1. Product Office

| Skill | What it does | Produces |
|-------|-------------|---------|
| [`@pm`](skills/pm/SKILL.md) | Translates vague ideas into scoped, testable specs. Asks clarifying questions. Marks in/out of scope explicitly. | `spec.md` |
| [`@red-team`](skills/red-team/SKILL.md) | Adversarial audit of a spec before build. Identifies second-order risks, unsupported assumptions, and adoption failure points. | `red-team-audit-<feature>.md` |
| [`@task-decomposition`](skills/task-decomposition/SKILL.md) | Breaks an approved spec into small, independently shippable tasks with dependencies mapped. | Task graph (appended to `spec.md` or standalone) |
| [`@decision-framework`](skills/decision-framework/SKILL.md) | Evaluates competing technical or product options using explicit criteria. Forces a documented decision. | ADR (Architecture Decision Record) |
| [`@ux`](skills/ux/SKILL.md) | Produces user flows, component states, and interaction specs. Catches usability issues before build. | UX spec / annotated flow |
| [`@accessibility`](skills/accessibility/SKILL.md) | Enforces semantic HTML, ARIA, keyboard navigation, and WCAG compliance. | Accessibility audit + fixes |

### 2. Engineering Hub

| Skill | What it does | Produces |
|-------|-------------|---------|
| [`@arch`](skills/arch/SKILL.md) | Designs system structure, data flows, and service boundaries. Runs Technical Feasibility Check before any design work. | `tech-spec.md` |
| [`@dev`](skills/dev/SKILL.md) | Implements backend, frontend, or full-stack tasks. Follows the Logic → API → UI sequence. | Code diff + verification proof |
| [`@api-design`](skills/api-design/SKILL.md) | Designs or reviews API endpoints, request/response contracts, and versioning. | API contract document |
| [`@data-modeling`](skills/data-modeling/SKILL.md) | Designs schemas, model relationships, and migration strategies. | Schema definition + migration plan |
| [`@git-workflow`](skills/git-workflow/SKILL.md) | Enforces commit message format, changelog discipline, and file organization. | Structured commit + changelog entry |

### 3. Quality & Safety Lab

| Skill | What it does | Produces |
|-------|-------------|---------|
| [`@guard`](skills/guard/SKILL.md) | Code review for security vulnerabilities, bad boundaries, and convention drift. | `risk-report.md` or explicit "Pass" |
| [`@qa`](skills/qa/SKILL.md) | Tests edge cases, regressions, and coverage gaps. Defines what "done" looks like in tests. | Test plan + pass/fail report |
| [`@self-review`](skills/self-review/SKILL.md) | Pre-handoff quality check before requesting code review. Catches obvious issues before `@guard` sees them. | Annotated diff (inline) |
| [`@debugging`](skills/debugging/SKILL.md) | Investigates bugs with root cause analysis. Does not fix — diagnoses and hands off to `@dev`. | Debug report (inline annotation) |
| [`@refactoring`](skills/refactoring/SKILL.md) | Structural cleanup without behavior change. Identifies code smells and removes them safely. | Refactored code (in-place) |
| [`@performance`](skills/performance/SKILL.md) | Identifies slow queries, caching opportunities, and backend bottlenecks. | Performance report |
| [`@frontend-perf`](skills/frontend-perf/SKILL.md) | Improves Web Vitals, bundle size, and rendering performance. | Frontend performance report |
| [`@testing`](skills/testing/SKILL.md) | Defines testing strategy, TDD approach, and mocking patterns. | Test strategy doc + test files |

### 4. Infra Lab

| Skill | What it does | Produces |
|-------|-------------|---------|
| [`@deployment`](skills/deployment/SKILL.md) | Universal deployment principles — rollout strategies, environment parity, rollback plans. | Deployment runbook |
| [`@cicd`](skills/cicd/SKILL.md) | GitHub Actions CI/CD setup and configuration. | Pipeline config files |
| [`@cloud`](skills/cloud/SKILL.md) | Infrastructure architecture, IaC, and cloud security posture. | IaC files + infrastructure diagram |

### 5. Growth Studio

| Skill | What it does | Produces |
|-------|-------------|---------|
| [`@writer`](skills/writer/SKILL.md) | Articles, newsletters, social posts, and email campaigns. Matches tone to audience. | Draft content |
| [`@seo`](skills/seo/SKILL.md) | Meta tags, structured data, technical SEO, and crawlability. | SEO audit + implementation checklist |
| [`@perf`](skills/perf/SKILL.md) | Ad copy, landing pages, UTM tracking, and A/B test design. | Campaign assets |
| [`@video-ai`](skills/video-ai/SKILL.md) | AI video generation using Runway, Kling, and fal.ai. | Video brief + generated output |
| [`@video`](skills/video/SKILL.md) | Remotion-specific video production (code-driven video). | Remotion component |

### 6. Meta Office

| Skill | What it does | Produces |
|-------|-------------|---------|
| [`@memory`](skills/memory/SKILL.md) | Persists agent state, decisions, and execution plans across sessions. | `memory.md` (chronological log) |
| [`@confidence-scoring`](skills/confidence-scoring/SKILL.md) | Assesses confidence level and risk before acting on low-certainty tasks. | Confidence report (inline) |
| [`@context-strategy`](skills/context-strategy/SKILL.md) | Manages limited context window — decides what to load and what to release. | Pruned context summary |
| [`@error-recovery`](skills/error-recovery/SKILL.md) | Handles test, build, or deployment failures autonomously without human escalation. | Recovery log (inline) |

---

## When to Pair Skills

Secondary skills are invoked *alongside* a primary skill, not instead of one.

| If you're doing... | Also invoke |
|--------------------|-------------|
| Implementation touching the API | `@api-design` |
| Implementation changing models or schema | `@data-modeling` |
| Backend implementation on hot paths | `@performance` |
| Frontend implementation with perf concerns | `@frontend-perf` |
| Any implementation before handoff | `@self-review` |
| Investigating a bug | `@debugging` |
| Cleaning up code as part of a task | `@refactoring` |
| Planning work breakdown | `@task-decomposition` |
| High-stakes decisions with unclear tradeoffs | `@decision-framework` |
| Assessing task risk or complexity | `@confidence-scoring` |
| Large codebase navigation | `@context-strategy` |
| Handling failures mid-task | `@error-recovery` |
| Multi-day or complex tasks | `@memory` |

---

## Handoff Chain

```
@pm          →  spec.md: problem, acceptance criteria, in/out of scope
  @red-team  →  red-team-audit.md: PASS / REVISE / ABANDON (gate — required)
    @ux       →  UX spec: user flows, component states
      @arch   →  tech-spec.md: system design, service boundaries
        @dev  →  Working implementation
          @self-review  →  Pre-handoff quality check
            @guard  →  risk-report.md: security, correctness, conventions
              @qa   →  Test report: edge cases, coverage, regressions
```

**Skip steps that don't apply.** A bug fix starts at `@debugging → @dev → @guard`. A content task starts at `@writer → @seo`. `@error-recovery` is not sequential — invoke it any time a build, test, or deployment fails.

---

MIT License • 2026 The Virtual Product Factory

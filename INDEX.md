# The Virtual Product Factory — Skill Index

*The authoritative reference for all skills. For the quick overview, see [README.md](README.md).*

---

## All Skills

### 1. Product Office

| Skill | What it does | Produces |
|-------|-------------|---------|
| [`@pm`](product/pm.md) | Translates vague ideas into scoped, testable specs. Asks clarifying questions. Marks in/out of scope explicitly. | `spec.md` |
| [`@red-team`](product/red-team.md) | Adversarial audit of a spec before build. Identifies second-order risks, unsupported assumptions, and adoption failure points. | `red-team-audit-<feature>.md` |
| [`@metrics`](product/metrics.md) | Defines the north star metric, activation event, instrumentation spec, and success threshold before build. Measures actual vs. expected after launch. | `.project/metrics.md` + launch report |
| [`@task-decomposition`](product/task-decomposition.md) | Breaks an approved spec into small, independently shippable tasks with dependencies mapped. | Task graph (appended to `spec.md` or standalone) |
| [`@decision-framework`](product/decision-framework.md) | Evaluates competing technical or product options using explicit criteria. Forces a documented decision. | ADR (Architecture Decision Record) |
| [`@ux`](design/ux.md) | Produces user flows, component states, and interaction specs. Catches usability issues before build. | UX spec / annotated flow |
| [`@accessibility`](design/accessibility.md) | Enforces semantic HTML, ARIA, keyboard navigation, and WCAG compliance. | Accessibility audit + fixes |

### 2. Engineering Hub

| Skill | What it does | Produces |
|-------|-------------|---------|
| [`@arch`](coding/arch.md) | Designs system structure, data flows, and service boundaries. Runs Technical Feasibility Check before any design work. | `tech-spec.md` |
| [`@dev`](coding/dev.md) | Implements backend, frontend, or full-stack tasks. Follows the Logic → API → UI sequence. | Code diff + verification proof |
| [`@api-design`](coding/api-design.md) | Designs or reviews API endpoints, request/response contracts, and versioning. | API contract document |
| [`@data-modeling`](coding/data-modeling.md) | Designs schemas, model relationships, and migration strategies. | Schema definition + migration plan |
| [`@git-workflow`](coding/git-workflow.md) | Enforces commit message format, changelog discipline, and file organization. | Structured commit + changelog entry |

### 3. Quality & Safety Lab

| Skill | What it does | Produces |
|-------|-------------|---------|
| [`@guard`](coding/guard.md) | Code review for security vulnerabilities, bad boundaries, and convention drift. | `risk-report.md` or explicit "Pass" |
| [`@qa`](coding/qa.md) | Tests edge cases, regressions, and coverage gaps. Defines what "done" looks like in tests. | Test plan + pass/fail report |
| [`@self-review`](coding/self-review.md) | Pre-handoff quality check before requesting code review. Catches obvious issues before `@guard` sees them. | Annotated diff (inline) |
| [`@debugging`](coding/debugging.md) | Investigates bugs with root cause analysis. Does not fix — diagnoses and hands off to `@dev`. | Debug report (inline annotation) |
| [`@refactoring`](coding/refactoring.md) | Structural cleanup without behavior change. Identifies code smells and removes them safely. | Refactored code (in-place) |
| [`@performance`](coding/performance.md) | Identifies slow queries, caching opportunities, and backend bottlenecks. | Performance report |
| [`@frontend-perf`](coding/frontend-performance.md) | Improves Web Vitals, bundle size, and rendering performance. | Frontend performance report |
| [`@testing`](coding/testing.md) | Defines testing strategy, TDD approach, and mocking patterns. | Test strategy doc + test files |

### 4. Infra Lab

| Skill | What it does | Produces |
|-------|-------------|---------|
| [`@deployment`](ops/deployment-practices.md) | Universal deployment principles — rollout strategies, environment parity, rollback plans. | Deployment runbook |
| [`@cicd`](ops/cicd-pipelines.md) | GitHub Actions CI/CD setup and configuration. | Pipeline config files |
| [`@cloud`](ops/cloud.md) | Infrastructure architecture, IaC, and cloud security posture. | IaC files + infrastructure diagram |

### 5. Growth Studio

| Skill | What it does | Produces |
|-------|-------------|---------|
| [`@writer`](marketing/writer.md) | Articles, newsletters, social posts, and email campaigns. Matches tone to audience. | Draft content |
| [`@seo`](marketing/seo.md) | Meta tags, structured data, technical SEO, and crawlability. | SEO audit + implementation checklist |
| [`@perf`](marketing/perf.md) | Ad copy, landing pages, UTM tracking, and A/B test design. | Campaign assets |
| [`@video-ai`](marketing/video-ai.md) | AI video generation using Runway, Kling, and fal.ai. | Video brief + generated output |
| [`@video`](marketing/video.md) | Remotion-specific video production (code-driven video). | Remotion component |

### 6. Meta Office

| Skill | What it does | Produces |
|-------|-------------|---------|
| [`@memory`](meta/memory.md) | Persists agent state, decisions, and execution plans across sessions. | `memory.md` (chronological log) |
| [`@confidence-scoring`](meta/confidence-scoring.md) | Assesses confidence level and risk before acting on low-certainty tasks. | Confidence report (inline) |
| [`@context-strategy`](meta/context-strategy.md) | Manages limited context window — decides what to load and what to release. | Pruned context summary |
| [`@error-recovery`](meta/error-recovery.md) | Handles test, build, or deployment failures autonomously without human escalation. | Recovery log (inline) |
| [`@postmortem`](meta/postmortem.md) | Blameless retrospective after incidents or underperforming features. 5 Whys root cause → concrete process changes. | `postmortem-YYYY-MM-DD-<slug>.md` |

---

## When to Pair Skills

Secondary skills are invoked *alongside* a primary skill, not instead of one.

| If you're doing... | Also invoke |
|--------------------|-------------|
| Scoping any new feature | `@metrics` (define success before build) |
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
| Feature underperformed or incident occurred | `@postmortem` |

---

## Handoff Chain

```
@pm          →  .project/: requirements, stories
  @metrics   →  .project/metrics.md: north star, instrumentation spec, threshold
    @red-team  →  red-team-audit.md: PASS / REVISE / ABANDON (gate — required)
      @ux       →  UX spec: user flows, component states
        @arch   →  tech-spec.md: system design, service boundaries
          @dev  →  Working implementation (reads instrumentation spec)
            @self-review  →  Pre-handoff quality check
              @guard  →  risk-report.md: security, correctness, conventions
                @qa   →  Test report + .project/ story status updated

                  [ship]

                @metrics  →  Post-launch measurement: actual vs. threshold
                  @postmortem  →  (if ❌ / ⚠️) Root cause → process changes
```

**Skip steps that don't apply.** A bug fix starts at `@debugging → @dev → @guard`. A content task starts at `@writer → @seo`. `@error-recovery` is for real-time unblocking — `@postmortem` is for learning after the fact. Both can run; neither replaces the other.

---

MIT License • 2026 The Virtual Product Factory

# The Virtual Product Factory Index

**28 highly transferable skills (85%+ portability) + 1 framework-specific skill (Remotion)**

---

## Quick Reference

### Standard workflow (full feature)
```
@pm → @ux → @arch → @dev → @guard → @qa
```

### Small coding fix
```
@dev → @guard
```

### Content / marketing
```
@writer → @seo
```

### Bug investigation
```
@debugging → @dev → @guard
```

### High-stakes decision
```
@decision-framework → @arch → @dev
```

---

## All Skills

### 1. Product Office (Strategy \u0026 UX)

| Skill | File | Use when | Transferability |
|-------|------|----------|----------------|
| `@pm` | `product/pm.md` | Feature scoping, requirements, acceptance criteria | 100% |
| `@task-decomposition` | `product/task-decomposition.md` | Breaking features into small, testable tasks with dependencies | 100% |
| `@decision-framework` | `product/decision-framework.md` | Architecture decisions, high-stakes trade-offs | 100% |
| `@ux` | `design/ux.md` | User flows, component states, form design | 90% |
| `@accessibility` | `design/accessibility.md` | Semantic HTML, ARIA, WCAG compliance | 95% |

### 2. Engineering Hub (Architecture \u0026 Build)

| Skill | File | Use when | Transferability |
|-------|------|----------|----------------|
| `@arch` | `coding/arch.md` | Architectural decisions, system design, service boundaries | 90% |
| `@dev` | `coding/dev.md` | Any implementation task — backend, frontend, or both | 90% |
| `@api-design` | `coding/api-design.md` | Designing or reviewing API endpoints and contracts | 90% |
| `@data-modeling` | `coding/data-modeling.md` | Schema design, model relationships, migrations | 90% |
| `@git-workflow` | `coding/git-workflow.md` | Commit messages, changelog maintenance, file organization | 100% |

### 3. Quality \u0026 Safety Lab (Verification \u0026 Perf)

| Skill | File | Use when | Transferability |
|-------|------|----------|----------------|
| `@guard` | `coding/guard.md` | Code review, security audit, convention drift check | 95% |
| `@qa` | `coding/qa.md` | Testing, edge cases, regression verification | 95% |
| `@self-review` | `coding/self-review.md` | Pre-handoff quality check before requesting code review | 95% |
| `@debugging` | `coding/debugging.md` | Bug investigation and root cause analysis | 95% |
| `@performance` | `coding/performance.md` | Backend performance and caching | 90% |
| `@frontend-perf` | `coding/frontend-performance.md` | Frontend performance and Web Vitals | 95% |
| `@testing` | `coding/testing.md` | Testing strategy, TDD, mocking | 95% |
| `@refactoring` | `coding/refactoring.md` | Code smells and structural cleanup | 95% |

### 4. Infra Lab (Cloud \u0026 DevOps)

| Skill | File | Use when | Transferability |
|-------|------|----------|----------------|
| `@deployment` | `ops/deployment-practices.md` | Universal deployment principles (any stack) | 100% |
| `@cicd` | `ops/cicd-pipelines.md` | GitHub Actions CI/CD setup and configuration | 95% |
| `@cloud` | `ops/cloud.md` | Infrastructure architecture, IaC, cloud security | 90% |

### 5. Growth Studio (Launch \u0026 SEO)

| Skill | File | Use when | Transferability |
|-------|------|----------|----------------|
| `@writer` | `marketing/writer.md` | Articles, newsletters, social posts, campaigns | 95% |
| `@seo` | `marketing/seo.md` | Meta tags, structured data, technical SEO | 90% |
| `@perf` | `marketing/perf.md` | Ad copy, landing pages, UTM tracking | 85% |
| `@video-ai` | `marketing/video-ai.md` | AI video generation (Runway, Kling, fal.ai) | 100% |
| `@video` | `marketing/video.md` | Remotion video production | Remotion-spec |

### 6. Meta Office (Agent Cognition)

| Skill | File | Use when | Transferability |
|-------|------|----------|----------------|
| `@memory` | `meta/memory.md` | Persisting state and plans across long sessions | 100% |
| `@confidence-scoring` | `meta/confidence-scoring.md` | Assessing confidence level and risk | 100% |
| `@context-strategy` | `meta/context-strategy.md` | Managing limited context window | 100% |
| `@error-recovery` | `meta/error-recovery.md` | Handling failures autonomously | 100% |

---

## Secondary Skills — When to Pair

Secondary skills are invoked *alongside* a primary skill, not instead of one.

| If you're doing... | Also invoke |
|--------------------|-------------|
| Implementing features that touch the API | `@api-design` |
| Implementing features that change models/schema | `@data-modeling` |
| Implementing backend features on hot paths or with caching | `@performance` |
| Implementing frontend features with performance concerns | `@frontend-perf` |
| Completing implementation before handoff | `@self-review` |
| Reviewing API surface changes | `@api-design` |
| Reviewing schema changes or migrations | `@data-modeling` |
| Reviewing backend performance-critical code | `@performance` |
| Reviewing frontend performance-critical code | `@frontend-perf` |
| Investigating a bug | `@debugging` |
| Cleaning up code as part of a task | `@refactoring` |
| Planning work breakdown | `@task-decomposition` |
| High-stakes decisions with unclear tradeoffs | `@decision-framework` |
| Assessing task difficulty | `@confidence-scoring` |
| Managing large codebase navigation | `@context-strategy` |
| Handling failures or errors | `@error-recovery` |
| Working on complex, multi-step, or multi-day tasks | `@memory` |

---

## Handoff Chain

```
@pm          →  Scoped requirements with acceptance criteria
  @ux        →  User flows and component specs
    @arch    →  System design and implementation plan
      @dev   →  Working implementation
        @self-review → Pre-handoff quality check
          @guard →  Code review: security, correctness, conventions
            @qa  →  Testing: edge cases, coverage, regressions
```

**Skip any step that doesn't apply.** A bug fix doesn't need `@pm` or `@ux`. A content task doesn't need `@arch`.

---

## Autonomous Workflow

For fully autonomous AI development:

```
1. @task-decomposition  →  Break feature into small, testable tasks
2. @confidence-scoring  →  Assess confidence for each task; ask before low-confidence ones
3. @context-strategy    →  Load only what's needed for the current task
4. @arch                →  Design system structure if needed
5. @dev                 →  Implement
6. @self-review         →  Check own work before handoff
7. @guard               →  Security/convention review
8. @qa                  →  Test
```

**`@error-recovery` is not a sequential step** — invoke it at any point when a test, build, or deployment fails.

**`@confidence-scoring` applies per task**, not just once at the start. Re-assess before each task in the decomposed list.

---

---

## Usage Examples

### Loading Skills in Different AI Assistants

**Claude/Cursor:**
```
Load skills: @pm, @ux, @arch, @dev, @guard, @qa

Task: Add user authentication to the dashboard
```

**GitHub Copilot Chat:**
```
#file:skills/product/pm.md
#file:skills/coding/arch.md
#file:skills/coding/dev.md
#file:skills/coding/guard.md

Help me scope and implement user authentication
```

**Windsurf:**
```
@pm @arch @dev @guard

I need to add user authentication. Help me scope it first, then design and implement securely.
```

### Project Setup

```bash
# New project setup
git submodule add https://github.com/vshrinath/virtual-product-factory.git skills
git submodule update --init

# Load core skills for any project
echo "Skills available: @pm @task-decomposition @decision-framework @arch @dev @guard @qa @self-review @debugging @refactoring @api-design @data-modeling @performance @frontend-perf @testing @video-ai @writer @seo @perf @ux @accessibility @deployment @cicd @cloud @memory"
```

---

MIT License • 2026 The Virtual Product Factory

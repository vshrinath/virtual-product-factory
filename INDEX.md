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

### Product & Planning

| Skill | File | Use when | Transferability |
|-------|------|----------|----------------|
| `@pm` | `product/pm.md` | Feature scoping, requirements, acceptance criteria | 100% |
| `@task-decomposition` | `product/task-decomposition.md` | Breaking features into small, testable tasks with dependencies | 100% |
| `@decision-framework` | `product/decision-framework.md` | Architecture decisions, build vs. buy, technical debt, any high-stakes decision with unclear tradeoffs | 100% |

### Meta (Autonomous Operation)

| Skill | File | Use when | Transferability |
|-------|------|----------|----------------|
| `@confidence-scoring` | `meta/confidence-scoring.md` | Assessing confidence level, determining when to ask for help | 100% |
| `@context-strategy` | `meta/context-strategy.md` | Managing limited context window, efficient file navigation | 100% |
| `@error-recovery` | `meta/error-recovery.md` | Handling test/build/deployment failures autonomously | 100% |
| `@memory` | `meta/memory.md` | Persisting state and execution plans across long sessions using a working buffer | 100% |

### Coding

| Skill | File | Use when | Transferability |
|-------|------|----------|----------------|
| `@arch` | `coding/arch.md` | Architectural decisions, system design, service boundaries | 90% |
| `@dev` | `coding/dev.md` | Any implementation task — backend, frontend, or both | 90% |
| `@git-workflow` | `coding/git-workflow.md` | Commit messages, changelog maintenance, file organization | 100% |
| `@guard` | `coding/guard.md` | Code review, security audit, convention drift check | 95% |
| `@qa` | `coding/qa.md` | Testing, edge cases, regression verification | 95% |
| `@self-review` | `coding/self-review.md` | Pre-handoff quality check before requesting code review | 95% |
| `@debugging` | `coding/debugging.md` | Bug investigation, intermittent failures, root cause analysis | 95% |
| `@refactoring` | `coding/refactoring.md` | Code smells, safe structural cleanup, tech debt reduction | 95% |
| `@api-design` | `coding/api-design.md` | Designing or reviewing API endpoints and contracts | 90% |
| `@data-modeling` | `coding/data-modeling.md` | Schema design, model relationships, migrations | 90% |
| `@performance` | `coding/performance.md` | Backend performance: slow queries, caching, API optimization | 90% |
| `@frontend-perf` | `coding/frontend-performance.md` | Frontend performance: Core Web Vitals, bundle size, image optimization | 95% |
| `@testing` | `coding/testing.md` | Testing strategy, TDD, mocking, unit/integration/E2E tests | 95% |

### Marketing

| Skill | File | Use when | Transferability |
|-------|------|----------|----------------|
| `@video-ai` | `marketing/video-ai.md` | AI video generation with cinematography knowledge (Runway, Pika, Luma, Kling, fal.ai) | 100% |
| `@video` | `marketing/video.md` | Remotion video production (requires React/TypeScript) | Remotion-specific |
| `@writer` | `marketing/writer.md` | Articles, newsletters, social posts, email campaigns | 95% |
| `@seo` | `marketing/seo.md` | Meta tags, structured data, technical SEO | 90% |
| `@perf` | `marketing/perf.md` | Ad copy, landing pages, UTM tracking, A/B tests | 85% |

### Design

| Skill | File | Use when | Transferability |
|-------|------|----------|----------------|
| `@ux` | `design/ux.md` | User flows, component states, accessibility, form design | 90% |
| `@accessibility` | `design/accessibility.md` | Semantic HTML, ARIA, keyboard navigation, WCAG compliance | 95% |

### Operations

| Skill | File | Use when | Transferability |
|-------|------|----------|----------------|
| — | `ops/deployment-practices.md` | Universal deployment principles (any stack) | 100% |
| — | `ops/cicd-pipelines.md` | GitHub Actions CI/CD setup and configuration | 95% |
| `@cloud` | `ops/cloud.md` | Infrastructure architecture, IaC, cloud security | 90% |

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
echo "Skills available: @pm @task-decomposition @decision-framework @arch @dev @guard @qa @self-review @debugging @refactoring @api-design @data-modeling @performance @frontend-perf @testing @video-ai @writer @seo @perf @ux @accessibility @cloud @memory"
```

---

## Related AI Skills & Resources

External libraries and reference material.

| Resource | Description | Source |
|----------|-------------|--------|
| **[marketingskills](https://github.com/coreyhaines31/marketingskills)** | Granular marketing skills for AI agents. | [GitHub](https://github.com/coreyhaines31/marketingskills) |
| **[AI Skills & Reference](https://notebooklm.google.com/notebook/4aa485e0-c976-44d2-8ced-2e6c90c68ce5)** | Curated NotebookLM vault for deep AI references. | [NotebookLM](https://notebooklm.google.com/notebook/4aa485e0-c976-44d2-8ced-2e6c90c68ce5) |

---

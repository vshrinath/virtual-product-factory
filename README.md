# The Virtual Product Factory

**Build at the Speed of Decision.**

A coherence layer for multi-tool AI development. When you switch between Claude Code, Cursor, Codex, and Windsurf on the same codebase, each tool makes decisions independently — and the codebase drifts. VPF solves this by giving every AI tool a shared rulebook: 32 specialized skills, a single `CONVENTIONS.md` customization point, and a handoff protocol that keeps artifacts consistent from spec to deployment.

Built for technical founders and developers who ship with multiple AI tools and need the output to look like one team built it — not five.

Built by [Shrinath V](https://www.linkedin.com/in/shrinathv). Want a deeper dive into the philosophy behind this? Read the manifesto at [Blindspots & Big Bets](https://blindspotsbigbets.substack.com).

**Contributions welcome!** Found a way to improve a skill or have a new one to add? Open a PR.
Run into a problem or have a question? Open an issue — we're happy to help.

---

## Why this exists

AI coding tools are genuinely useful individually. The problem is compound: when you use Claude Code for architecture, Cursor for feature work, and Codex for refactoring, each one makes stylistic and structural decisions in isolation. After a few weeks, the codebase carries the fingerprints of five different "opinions" — inconsistent naming, conflicting patterns, architecture that no single tool fully understands.

VPF started as an abstraction from solving this problem on real projects. The solution is a shared context layer — `AGENTS.md` as a tool-agnostic rulebook that every major AI tool reads natively, `CONVENTIONS.md` as a single file capturing your stack's specific decisions, and skills as scoped role definitions that prevent an agent from overstepping into territory it shouldn't touch.

The artifact chain (`spec.md → tech-spec.md → implementation-notes.md → risk-report.md`) acts as a state machine: any tool that picks up the project can detect where it is in the pipeline and proceed without being retold the full history.

---

## ⚡ Quick Start

Add the factory to your project, then use one of these prompts with your AI agent:

| I want to... | Say this |
| :--- | :--- |
| Turn a vague idea into a buildable spec | `Scope this for me: [your idea]` |
| Audit a spec before committing to build | `Red-team this spec: [paste spec.md]` |
| Design the architecture for an approved spec | `Design the system for: [paste spec.md]` |
| Get a security review before merging | `Review this diff for issues: [paste diff]` |
| Write release notes for a shipped feature | `Draft release notes for: [description]` |
| Resume a session where you left off | `Resume from memory.md` |

For setup instructions, see [Integration & Onboarding](#-integration--onboarding) below.

---

## 🏗️ Departmental Overview
*One glance at the Factory's capabilities.*

```text
 ┌───────────────────────┐   ┌───────────────────────┐   ┌───────────────────────┐
 │ 1. PRODUCT OFFICE     │   │ 2. ENGINEERING HUB    │   │ 3. QUALITY & SAFETY   │
 │    (Strategy & UX)    │   │    (Build)            │   │    (Verify & Perf)    │
 ├───────────────────────┤   ├───────────────────────┤   ├───────────────────────┤
 │ @pm                   │   │ @arch                 │   │ @guard                │
 │ @task-decomposition   │   │ @dev                  │   │ @qa                   │
 │ @decision-framework   │   │ @api-design           │   │ @testing              │
 │ @ux                   │   │ @data-modeling        │   │ @self-review          │
 │ @accessibility        │   │ @git-workflow         │   │ @performance          │
 └───────────────────────┘   └───────────────────────┘   │ @frontend-perf        │
                                                         │ @debugging            │
                                                         │ @refactoring          │
 ┌───────────────────────┐   ┌───────────────────────┐   └───────────────────────┘
 │ 4. INFRA LAB          │   │ 5. GROWTH STUDIO      │               
 │    (Cloud & DevOps)   │   │    (Launch & SEO)     │               
 ├───────────────────────┤   ├───────────────────────┤   ┌───────────────────────┐
 │ @cloud                │   │ @writer               │   │ 6. META OFFICE        │
 │ @cicd                 │   │ @seo                  │   │    (Agent Cognition)  │
 │ @deployment           │   │ @perf                 │   ├───────────────────────┤
 └───────────────────────┘   │ @video-ai             │   │ @memory               │
                             │ @video                │   │ @error-recovery       │
                             └───────────────────────┘   │ @confidence-scoring   │
                                                         │ @context-strategy     │
                                                         └───────────────────────┘
```

## 📖 The Skills Directory
*What they do and where to find them. For the authoritative inventory including transferability scores, see [INDEX.md](INDEX.md).*

| Skill | Department | What it does |
| :--- | :--- | :--- |
| **[@pm](skills/pm/SKILL.md)** | Product Office | Defines scope, translates ideas to specs, and explicitly marks what is *out* of scope. |
| **[@red-team](skills/red-team/SKILL.md)** | Product Office | Audits `spec.md` before build: surfaces second-order risks, unsupported assumptions, and adoption failure points. |
| **[@task-decomposition](skills/task-decomposition/SKILL.md)** | Product Office | Breaks large features into small, independently deployable iterative slices. |
| **[@decision-framework](skills/decision-framework/SKILL.md)** | Product Office | Evaluates technical/product decisions using rigid criteria (Cost, Benefit, Reversible). |
| **[@ux](skills/ux/SKILL.md)** | Product Office | Enforces UI/UX consistency, mobile-first design, and interactive states. |
| **[@accessibility](skills/accessibility/SKILL.md)** | Product Office | Ensures semantic HTML, ARIA labels, and keyboard navigation compliance. |
| **[@arch](skills/arch/SKILL.md)** | Engineering Hub | Designs the technical blueprint (`tech-spec.md`), choosing architecture and boundaries. |
| **[@dev](skills/dev/SKILL.md)** | Engineering Hub | Writes working code following the architecture, prioritizing simplicity and testing. |
| **[@api-design](skills/api-design/SKILL.md)** | Engineering Hub | Standardizes REST/GraphQL APIs with strict request/response contracts and error handling. |
| **[@data-modeling](skills/data-modeling/SKILL.md)** | Engineering Hub | Designs resilient database schemas, indexes, and normalizes/denormalizes data. |
| **[@git-workflow](skills/git-workflow/SKILL.md)** | Engineering Hub | Enforces atomic commits, conventional commit messages, and clean branching. |
| **[@guard](skills/guard/SKILL.md)** | Quality Lab | The first line of defense: checks for security, sanity, and convention drift. |
| **[@qa](skills/qa/SKILL.md)** | Quality Lab | Writes and executes extreme testing scenarios, hunting for edge cases. |
| **[@testing](skills/testing/SKILL.md)** | Quality Lab | Implements the standardized testing frameworks and asserts test coverage. |
| **[@self-review](skills/self-review/SKILL.md)** | Quality Lab | Forces the agent to critique its own code *before* declaring a task finished. |
| **[@performance](skills/performance/SKILL.md)** | Quality Lab | Optimizes backend execution, algorithmic tradeoffs, and resource allocation. |
| **[@frontend-perf](skills/frontend-perf/SKILL.md)** | Quality Lab | Audits bundle sizes, render cycles, and Core Web Vitals. |
| **[@debugging](skills/debugging/SKILL.md)** | Quality Lab | Methodical, scientific-method-based approach to isolating and squashing bugs. |
| **[@refactoring](skills/refactoring/SKILL.md)** | Quality Lab | CLEANS up debt without changing behavior, aiming for simpler abstractions. |
| **[@cloud](skills/cloud/SKILL.md)** | Infra Lab | Designs IaC (Terraform/Bicep), serverless scaling, and cloud security architecture. |
| **[@cicd](skills/cicd/SKILL.md)** | Infra Lab | Automates GitHub Actions, build matrices, and continuous integration gates. |
| **[@deployment](skills/deployment/SKILL.md)** | Infra Lab | Executes safe rollouts (blue/green, canary) and environment synchronizations. |
| **[@writer](skills/writer/SKILL.md)** | Growth Studio | Drafts technical documentation, release notes, and product marketing copy. |
| **[@seo](skills/seo/SKILL.md)** | Growth Studio | Implements technical SEO, semantic metadata, and structured data schemas. |
| **[@perf](skills/perf/SKILL.md)** | Growth Studio | (Marketing Perf) Tracks analytics, conversion hooks, and growth metrics. |
| **[@video-ai](skills/video-ai/SKILL.md)** | Growth Studio | Scripts and generates AI-driven video assets or feature walk-throughs. |
| **[@video](skills/video/SKILL.md)** | Growth Studio | General video editing, pacing, and programmatic video creation (e.g. Remotion). |
| **[@memory](skills/memory/SKILL.md)** | Meta Office | Maintains a persistent chronological log (`memory.md`) across multiple agent sessions. |
| **[@error-recovery](skills/error-recovery/SKILL.md)** | Meta Office | Steps back when stuck, analyzes failure loops, and proposes alternative solutions. |
| **[@confidence-scoring](skills/confidence-scoring/SKILL.md)** | Meta Office | Forces the agent to explicitly state its confidence level before making risky assumptions. |
| **[@context-strategy](skills/context-strategy/SKILL.md)** | Meta Office | Optimizes the context window by ruthlessly summarizing and dropping irrelevant files. |

---

## ⚡ The Operational Engine
*How to drive the Factory from Start to Finish.*

The Factory operates as a **closed-loop system**. Every prompt initiates a workflow that doesn't end until a **Baton of State** (Artifact) is verified and committed.

### 1. The Fuzzy Start (Ideation ➔ Grounding)
- **Primary Department**: Product Office
- **Trigger**: The user provides a vague idea ("I have a new idea, but I'm not sure where to start").
- **Workflow**: The agent adopts the `@pm` and `@ux` roles to explicitly define the intent, scope out the feature, and determine binary acceptance criteria.
- **The Result**: A `spec.md` file that defines exactly what "Done" looks like.

### 2. Architectural Rigor (Blueprint ➔ Implementation)
- **Primary Department**: Engineering Hub + Quality Lab
- **Trigger**: The user provides an approved spec ("I have a spec and I'm ready to build it").
- **Workflow**: The agent adopts the `@arch` role to draft the system architecture, transitions to `@dev` to implement it sequentially, and finishes by executing `@self-review`.
- **The Result**: Working code that passes all `getDiagnostics` and local tests.

### 3. The Security Sentry (Audit ➔ Approval)
- **Primary Department**: Quality & Safety Lab
- **Trigger**: The user requests a pre-merge inspection ("The code is written, I need to ensure it's safe to merge").
- **Workflow**: The agent adopts the `@guard` role to crawl the latest diffs, scanning strictly for security vulnerabilities, bad boundaries, and convention drift.
- **The Result**: A `risk-report.md` or a "Pass" score in the pull request.

### 4. The Growth Engine (Launch ➔ SEO)
- **Primary Department**: Growth Studio
- **Trigger**: The user desires a public push ("The feature is verified. Let's tell the world").
- **Workflow**: The agent assumes the `@seo` role to optimize route metadata, and uses the `@writer` role to draft marketing launch materials or release notes.
- **The Result**: Meta tags implemented + Launch blog/newsletter drafted.

### 5. The Deploy Loop (Verification ➔ Live)
- **Primary Department**: Infra Lab
- **Trigger**: The user authorizes production push ("Everything is approved. Deploy to staging/production").
- **Workflow**: The agent consults `deployment-practices` and `@cloud` frameworks to execute the deployment pipelines, verify the live environment, and sync any infrastructure-as-code adjustments.
- **The Result**: A live URL + "Deployment Successful" status.

---

## 🤝 The Handoff Protocol

Each transition between departments is powered by a **Handoff Artifact**.

| Handoff | The "Baton" (Artifact) | Explicit Output |
| :--- | :--- | :--- |
| **Product ➔ Arch** | `spec.md` | Scoped features + Acceptance criteria. |
| **Red-Team ➔ PM** | `red-team-audit.md` | PASS / REVISE / ABANDON verdict + critical flaws. |
| **Arch ➔ Dev** | `tech-spec.md` | Model schemas + Service boundaries. |
| **Dev ➔ Guard** | `implementation.diff` | Working code + Verification proof. |
| **Guard ➔ QA** | `risk-report.md` | Audited code + Performance metrics. |

---

## 📄 Artifact Registry
*Every skill has a finish line. This is what each one produces.*

| Skill | Artifact | Format |
| :--- | :--- | :--- |
| `@pm` | `spec.md` | Feature brief with problem, acceptance criteria, in/out of scope |
| `@red-team` | `red-team-audit.md` | Adversarial audit with PASS / REVISE / ABANDON verdict |
| `@task-decomposition` | Task graph | Dependency DAG appended to `spec.md` or as standalone |
| `@decision-framework` | ADR | Architecture Decision Record with option comparison and verdict |
| `@arch` | `tech-spec.md` | Component diagram, data flow map, tradeoffs |
| `@dev` | Code + proof | Implementation diff + verification results |
| `@api-design` | API contract | Request/response schemas, error codes, versioning notes |
| `@data-modeling` | Schema definition | ERD, migration plan, indexing strategy |
| `@guard` | `risk-report.md` | Severity-ranked findings, or explicit "Pass" |
| `@qa` | Test report | Test plan + pass/fail results |
| `@cloud` | IaC files | Terraform/Bicep configs + infrastructure diagram |
| `@deployment` | Deployment runbook | Rollout steps, rollback procedure, smoke test results |
| `@seo` | SEO report | Audit findings + implementation checklist (meta, schema) |
| `@writer` | Draft content | Article, release notes, or documentation page |
| `@memory` | `memory.md` | Chronological session log, persistent across runs |

> **In-place annotators** — these skills don't produce a new file; they annotate or modify existing artifacts:
> `@self-review` (critiques the current diff), `@debugging` (annotates the error), `@refactoring` (modifies the code in-place), `@performance` (adds findings inline or to an existing report), `@context-strategy` (summarizes and prunes the active context window).



## 🦾 Integration & Onboarding

### 1. One-liner: npx (Recommended)
No install needed. Run from your project root:

```bash
npx virtual-product-factory
```

This sets up the factory as a git submodule and configures all AI tools (Cursor, Copilot, Windsurf, Claude, Gemini, Kiro) in one shot.

**Options:**

```bash
# Use a plain clone instead of a git submodule
npx virtual-product-factory init --clone

# Configure Kiro only
npx virtual-product-factory init --tools kiro

# Show all options
npx virtual-product-factory help
```

### 2. Production Method: Git Submodule
Add the factory as a submodule for project-specific version control.

```bash
git submodule add https://github.com/vshrinath/virtual-product-factory.git .vpf
git submodule update --init --recursive
```

### 3. Quick Start: Curl
Use the setup script for rapid prototyping or global utility.

```bash
curl -sSL https://raw.githubusercontent.com/vshrinath/virtual-product-factory/main/setup.sh | bash
```

---

## 🗺️ Navigation
- **[AGENTS.md](AGENTS.md)**: The full operational manual and rules.
- **[CONVENTIONS.md](CONVENTIONS.md)**: Your project's unique "Source of Truth."
- **[INDEX.md](INDEX.md)**: Technical reference of all 32 skills.

---

MIT License • 2026 The Virtual Product Factory

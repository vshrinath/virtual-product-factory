# The Virtual Product Factory

**Build at the Speed of Decision.**

The Virtual Product Factory is an autonomous product engineering department in a box. It transforms raw requirements into launched products by grounding agents in a rigorous, role-simulated lifecycle.

---

## ❓ What are Skills?

Skills are high-signal markdown files that provide AI agents (Cursor, Windsurf, Claude, etc.) with **specialized knowledge, expert workflows, and guardrails**.

Standard LLMs are generalists. Adding these skills to your project workspace transforms them into **specialists** who:
- **Simulate Roles**: They act as PMs, Architects, or SEO experts based on the task.
- **Enforce Rigor**: They follow established best practices (TDD, safety reviews, decomposition).
- **Maintain Context**: They know *how* to build within the boundaries of your **CONVENTIONS.md**.

---

## 🏗️ Departmental Overview
*One glance at the Factory's capabilities.*

```mermaid
graph TD
    %% Departments
    subgraph PO ["PRODUCT OFFICE"]
        S1["@pm<br/>@task-decomposition<br/>@decision-framework"]
    end

    subgraph EH ["ENGINEERING HUB"]
        S2["@arch<br/>@dev<br/>@qa<br/>@guard<br/>@git-workflow<br/>@debugging<br/>@refactoring"]
        S2B["@api-design<br/>@data-modeling<br/>@performance<br/>@frontend-perf<br/>@testing<br/>@self-review"]
    end

    subgraph GS ["GROWTH STUDIO"]
        S3["@writer<br/>@seo<br/>@perf<br/>@video-ai<br/>@video"]
    end

    subgraph MO ["META OFFICE"]
        S4["@memory<br/>@error-recovery<br/>@confidence-scoring<br/>@context-strategy"]
    end

    subgraph DX ["DESIGN \u0026 OPS"]
        S5["@ux<br/>@accessibility<br/>@cloud<br/>cicd-pipelines<br/>deployment-practices"]
    end

    %% Positioning
    PO --- EH
    EH --- GS
    MO --- DX
    PO --- MO
    GS --- DX

    %% Styling
    style PO fill:#f9f,stroke:#333,stroke-width:2px
    style EH fill:#bbf,stroke:#333,stroke-width:2px
    style GS fill:#bfb,stroke:#333,stroke-width:2px
    style MO fill:#fdb,stroke:#333,stroke-width:2px
    style DX fill:#eee,stroke:#333,stroke-width:2px
```

---

## ⚡ Operational Playbooks (The Flow)

How the Factory moves from ideation to launch.

### 1. The Fuzzy Start (Ideation ➔ Backlog)
The **Product Office** grounds loose requirements into a structured backlog using `@pm` and `@task-decomposition`.

```mermaid
graph LR
    FUZ[("Fuzzy<br/>Requirement")] --> PM["@pm"] --> DEC{"Trade-offs?"}
    DEC -- Yes --> DF["@decision-framework"] --> PM
    DEC -- No --> TDC["@task-decomposition"] --> BACKLOG[("Grounded<br/>Backlog")]
```

### 2. Architectural Rigor (Blueprint ➔ TDD)
The **Engineering Hub** architects the solution (`@arch`), creates a test plan (`@qa`), and builds via TDD (`@dev`).

```mermaid
graph LR
    BACKLOG --> ARC["@arch"] --> CONV["CONVENTIONS.md"] --> QA["@qa"] --> DEV["@dev"] --> GDR["@guard"] --> CODE[("Verified Code")]
```

### 3. The Growth Engine (Code ➔ Market)
The **Growth Studio** handles the transition from "code complete" to "market ready" via `@writer`, `@seo`, and marketing assets.

```mermaid
graph TD
    CODE --> WRT["@writer"] --> SEO["@seo"] --> PERF["@perf"] --> VID["@video-ai"] --> LAUNCH[("Market Launch")]
```

---

## 🦾 Integration & Onboarding

### 1. Production Method: Git Submodule (Recommended)
Add the factory as a submodule for project-specific version control and easy updates.

```bash
# Add the factory to your project
git submodule add https://github.com/vshrinath/virtual-product-factory.git .vpf
git submodule update --init --recursive
```

### 2. Quick Start: Curl
Use the setup script for rapid prototyping or global utility.

```bash
curl -sSL https://raw.githubusercontent.com/vshrinath/virtual-product-factory/main/setup.sh | bash
```

### 🛠️ How `setup.sh` Works
The script **symlinks** the factory's canonical rules into your agent's configuration:
- **Cursor**: Symlinks to `.cursorrules`.
- **Windsurf**: Symlinks to `.windsurfrules`.
- **General**: Connects any agent to your **AGENTS.md** steering layer.

---

## 🗺️ Navigation
- **[CONVENTIONS.md](CONVENTIONS.md)**: Your project's unique "Source of Truth."
- **[AGENTS.md](AGENTS.md)**: The principles and handoff rules for your factory.
- **[INDEX.md](INDEX.md)**: A complete technical reference of all 28+ skills.
- **[CHANGELOG.md](CHANGELOG.md)**: Record of factory updates and improvements.

---

MIT License • 2026 The Virtual Product Factory

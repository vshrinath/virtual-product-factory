---
name: decision-framework
description: Evaluates competing technical or product options using explicit criteria. Extracts assumptions, maps risk surfaces, and forces a documented decision. WHEN to use it - architecture decisions with long-term consequences, build vs buy decisions, deployment strategy changes, or any decision with irreversible or high-cost consequences.
license: MIT
metadata:
  category: product
  handoff-from:
    - arch
    - pm
  handoff-to:
    - arch
    - pm
    - cloud
  version: 1.0.0
compatibility:
  claude-versions:
    - opus-4.6
    - sonnet-4.6
---

# @decision-framework — Structured Decision Analysis

**Philosophy:** Most bad decisions fail at the assumption layer, not the execution layer. Sharpen assumptions before deciding.

## When to invoke
- Architecture decisions with long-term consequences
- Feature prioritization with unclear tradeoffs
- Technical debt decisions (refactor vs. ship)
- Build vs. buy decisions
- Deployment strategy changes
- Any decision with irreversible or high-cost consequences
- When a decision "feels wrong" but you can't articulate why

## Responsibilities
- Extract and challenge hidden assumptions
- Map risk surface across multiple dimensions
- Generate adversarial counterfactuals
- Identify second-order effects and system coupling
- Surface cognitive distortions and misaligned incentives
- Produce a decision brief with explicit tradeoffs

## Boundary with `@arch`
- `@decision-framework` decides **which option** to choose under uncertainty and tradeoffs.
- `@arch` defines **how to implement** the chosen architecture (boundaries, interfaces, rollout path).
- Use `@decision-framework` when choices are contested or high-stakes; use `@arch` when the decision is already made.

## Decision Analysis Process

### Step 1: Decision Clarification

Before analyzing anything, define the decision precisely:

```markdown
## Decision: <name>

### What exactly is being decided?
<One sentence. If you can't state it in one sentence, the decision is too vague.>

### Time horizon
<When does this decision take effect? When is it reversible? When do consequences appear?>

### Success definition
<What does success look like? Measurable, observable outcomes.>

### Failure definition
<What does failure look like? What are we trying to avoid?>
```

**If this is unclear, everything downstream is noise.** Stop and clarify with stakeholders.

---

### Step 2: Assumption Extraction

List every assumption required for this decision to be correct.

```markdown
## Assumptions

### Empirical (verifiable)
- <Assumption that can be tested or measured>

### Speculative (unverified)
- <Assumption based on belief, not data>

### Reversible
- <Assumption that can be changed later without major cost>

### Irreversible
- <Assumption that locks us in>
```

**Flag these patterns:**
- Unverified dependencies ("We assume X team will deliver Y by Z date")
- Implicit constraints ("We can't do X because of Y" — is Y actually a constraint?)
- "Everyone knows" beliefs (often wrong)

---

### Step 3: Distortion & Incentive Scan

```markdown
## Distortion Check

### Are we extrapolating from limited data?
### Are we defending sunk effort?
### Is leadership identity tied to this bet?
### Are incentives pushing optimism?
### Are we underweighting tail risks?
### Are we anchored on the first solution proposed?
```

---

### Step 4: Adversarial Counterfactual

Generate the strongest case *against* this decision:

```markdown
## Adversarial Counterfactual

### Strongest skeptical argument
<What would a smart, informed critic say about this decision?>

### Future retrospective failure narrative (12–24 months later)
"We failed because..."
<Write 2-3 sentences as if you're explaining the failure to your team in the future.>
```

---

### Step 5: Risk Surface Mapping

```markdown
## Risk Surface

| Risk Type | Probability | Impact | Detectability | Mitigation |
|-----------|-------------|--------|---------------|------------|
| Technical risk | Low/Med/High | Low/Med/High | Early/Late | <action> |
| Market risk | Low/Med/High | Low/Med/High | Early/Late | <action> |
| Execution risk | Low/Med/High | Low/Med/High | Early/Late | <action> |
| Organizational risk | Low/Med/High | Low/Med/High | Early/Late | <action> |
| Governance/compliance risk | Low/Med/High | Low/Med/High | Early/Late | <action> |
| Reputational risk | Low/Med/High | Low/Med/High | Early/Late | <action> |
```

**Priority:** Late-detectable, high-impact risks get priority. These are the ones that kill projects.

---

### Step 6: Second-Order & System Effects

```markdown
## Second-Order Effects

### What new constraints appear if this succeeds?
### What dependencies increase over time?
### Where does this create coupling or lock-in?
### What becomes harder to reverse?
### What does this make easier? What does it make harder?
```

---

### Step 7: Decision Brief (Output)

```markdown
## Decision Brief: <name>

### Decision
<One sentence: what are we deciding?>

### Recommendation
<What should we do? State it clearly.>

### Why
<2-3 sentences: why is this the right choice?>

### Tradeoffs
**What we gain:**
- <benefit 1>
- <benefit 2>

**What we give up:**
- <cost 1>
- <cost 2>

### Key Assumptions
- <assumption 1> (empirical/speculative, reversible/irreversible)

### Top Risks
- <risk 1> — <mitigation>

### Failure Mode
"We fail if..."
<1-2 sentences: most likely failure scenario>

### Reversibility
<Can we undo this? At what cost? By when?>

### Open Questions
- <unresolved question 1>
```

---

## Rules

- **Empirical assumptions must be verified.** Don't proceed on speculation when you can test.
- **Irreversible assumptions must be challenged.** These are the ones that lock you in.
- **Late-detectable, high-impact risks are the killers.** Prioritize mitigation here.
- **The failure narrative should be specific.** "We failed because we didn't plan well" is useless.
- **The decision brief must fit on one page.** If it's longer, the decision is too complex or poorly scoped.

## Handoffs
- **To `@arch`** → When the decision is architectural (system design, service boundaries, data models)
- **To `@pm`** → When the decision is about scope or prioritization
- **To `@cloud`** → When the decision is about deployment, infrastructure, or operational risk
- **Back to stakeholders** → When assumptions can't be verified without their input

## Output
- Decision brief with explicit tradeoffs, assumptions, risks, and failure modes
- Risk surface map with mitigation plans
- Adversarial counterfactual (failure narrative)
- Second-order effects analysis

## When NOT to use this framework

- **Small, reversible decisions:** Don't over-analyze. If you can undo it in a day, just try it.
- **Decisions with obvious answers:** If there's no real tradeoff, don't force one.
- **Decisions where speed matters more than correctness:** Sometimes you need to move fast and accept risk.

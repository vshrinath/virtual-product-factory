---
name: confidence-scoring
description: Assesses confidence level and risk before acting on low-certainty tasks. Provides a structured scoring framework and escalation criteria. WHEN to use it - before starting any task, after completing implementation, when encountering unexpected behavior, when making architectural decisions, or when uncertain about approach.
license: MIT
metadata:
  category: meta
  handoff-from:
    - dev
    - arch
  handoff-to:
    - dev
  version: 1.0.0
compatibility:
  claude-versions:
    - opus-4.6
    - sonnet-4.6
---

# @confidence-scoring — When to Ask for Help

**Philosophy:** Know what you don't know. Confidence without competence is dangerous; competence without confidence wastes time.

## When to invoke
- Before starting any task
- After completing implementation
- When encountering unexpected behavior
- When making architectural decisions
- When uncertain about approach

## Responsibilities
- Assess confidence level for each task
- Identify knowledge gaps
- Determine when to ask for clarification
- Escalate when confidence is too low
- Document uncertainty for review

---

## Confidence Levels

### High Confidence (90-100%)
**Characteristics:** Similar to previous work, clear requirements, well-understood tech stack
**Action:** Proceed autonomously

### Medium Confidence (70-89%)
**Characteristics:** Some new territory, minor ambiguity, multiple valid approaches
**Action:** Proceed with caution, document assumptions

### Low Confidence (50-69%)
**Characteristics:** Unfamiliar territory, significant ambiguity, multiple unknowns
**Action:** Ask for clarification before proceeding

### Very Low Confidence (< 50%)
**Characteristics:** Completely unfamiliar, vague requirements, high complexity
**Action:** Stop and ask for help

---

## Confidence Assessment Framework

Score each dimension 0-10:

1. **Requirement Clarity** — 10: Crystal clear | 5: Significant ambiguity | 2: Very vague
2. **Technical Familiarity** — 10: Done this before | 5: Understand concept | 2: Completely new
3. **Complexity** — 10: Trivial (<10 lines) | 5: Medium (<200 lines) | 2: Complex (>200 lines)
4. **Risk Level** — 10: No risk (reversible) | 5: Medium risk (hard to reverse) | 2: High risk (irreversible)

```
Confidence % = (Clarity + Familiarity + (10 - Complexity) + (10 - Risk)) / 40 × 100

Example:
Clarity: 8, Familiarity: 7, Complexity: 6 → inverted: 4, Risk: 8 → inverted: 2
Confidence = (8 + 7 + 4 + 2) / 40 × 100 = 52.5%
Action: Low confidence → Ask for clarification before proceeding
```

---

## When to Ask for Clarification

### Always Ask When:
- Confidence < 70%
- Requirements are vague
- Multiple valid interpretations exist
- High risk of breaking production
- Irreversible changes (data deletion, schema changes)
- Security implications unclear

### Questions to Ask:

**For vague requirements:**
```
"I understand you want [X], but I need clarification on:
1. [Specific question 1]
2. [Specific question 2]

My current understanding is [assumption]. Is this correct?"
```

**For technical uncertainty:**
```
"I can implement this, but I'm uncertain about:
1. [Technical decision 1] - Options: A, B, C

My recommendation is [option] because [reason]. Does this align with your expectations?"
```

---

## Documenting Uncertainty

### In Commit Messages

```
feat: add rate limiting to API endpoints

Assumptions:
- Rate limit is per authenticated user (not per IP)
- 100/hour is acceptable (not specified in requirements)
- 429 status code is appropriate response

Confidence: 75%
Please review assumptions before merging.
```

---

## Escalation Criteria

### Escalate Immediately When:
- Confidence < 50%
- Security implications unclear
- Data loss risk
- Production outage risk
- Conflicting requirements
- Estimated time > 2x original estimate

---

## Checklist: Before Proceeding

- [ ] Confidence level assessed (0-100%)
- [ ] If < 70%, clarification questions prepared
- [ ] Assumptions documented
- [ ] Risks identified
- [ ] Verification criteria defined
- [ ] Escalation plan ready (if needed)

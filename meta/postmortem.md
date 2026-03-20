# @postmortem — Blameless Retrospective

**Philosophy:** Every failure is a process failure, not a people failure. The goal is not to assign fault — it is to change the system so the failure cannot happen again.

## When to invoke
- After any production incident (outage, data loss, security breach)
- After `@metrics` post-launch verdict is ❌ or ⚠️ (feature underperformed)
- After a story was marked complete but users reported it broken
- After a sprint where stories were consistently not finished
- Any time the team asks "how did this happen and how do we prevent it?"

## Responsibilities
- Build a blameless, factual timeline of events
- Apply 5 Whys to reach the systemic root cause
- Classify the failure type (technical / process / spec / assumption)
- Produce concrete action items — not observations
- Identify which skills or handoff steps failed and propose improvements
- Write the postmortem to `postmortem-YYYY-MM-DD-<slug>.md`

## Boundary with `@error-recovery`
- `@error-recovery` unblocks a stuck task in real time — it is tactical.
- `@postmortem` analyzes a completed failure after the fact — it is strategic.
- Do not use `@error-recovery` as a substitute for a postmortem. Recovering from a failure is not the same as learning from it.

---

## Step 0: Establish blameless framing

Before writing a single word, state this explicitly:

> "This postmortem is blameless. Its purpose is to understand the system failure, not to evaluate individuals. Anyone who surfaced information honestly or escalated correctly did the right thing, regardless of outcome."

**DO NOT include any language that attributes failure to a person's competence, attention, or judgment.** If you find yourself writing "X should have caught this" — rewrite it as "the process did not make it easy to catch this."

---

## Step 1: Incident summary

Answer these in 3–5 sentences:

```
What happened: [observable impact — what users or the system experienced]
When: [start time → detection time → resolution time]
Duration: [how long was the system degraded or the feature broken]
Impact: [who was affected, how many users, what data or functionality was lost]
Severity: P1 (critical, wide impact) | P2 (significant, recoverable) | P3 (limited, low impact)
```

---

## Step 2: Timeline

Reconstruct the chronological sequence. Be precise. Use timestamps where available.

```
YYYY-MM-DD HH:MM  [Actor / system]  [What happened — factual, not interpretive]
YYYY-MM-DD HH:MM  [Actor / system]  [What happened]
...
YYYY-MM-DD HH:MM  Resolution        [What action restored normal state]
```

**DO NOT skip the timeline.** A postmortem without a timeline is an opinion, not an analysis.

Rules for the timeline:
- One event per line
- Fact only — no "should have", "forgot to", "missed"
- Include detection lag (time between failure occurring and being noticed)
- Include any actions taken that made things worse

---

## Step 3: Root cause — 5 Whys

Start from the immediate trigger and ask "Why?" five times or until you reach a systemic cause.

```
Trigger: [the immediate observable cause — e.g. "deploy went to production with a broken migration"]

Why 1: [Why did the migration break?] → [answer]
Why 2: [Why was that possible?] → [answer]
Why 3: [Why wasn't it caught?] → [answer]
Why 4: [Why didn't the process prevent it?] → [answer]
Why 5: [Why does that process gap exist?] → [root cause]

Root cause: [1-2 sentence systemic statement — not a person, a process gap]
```

**DO NOT stop at Why 1 or Why 2.** Shallow root cause analysis produces shallow fixes.

---

## Step 4: Classify the failure

Identify which layer the root cause lives in:

| Type | Description | Primary fix lives in |
|---|---|---|
| **Technical** | Code, infra, or dependency failed | `@dev`, `@arch`, `@guard`, `@qa` |
| **Process** | A handoff, gate, or check was skipped or didn't exist | Skill update or new gate |
| **Spec** | The feature was built correctly but solved the wrong problem | `@pm`, `@red-team`, `@metrics` |
| **Assumption** | A belief about users or systems turned out to be wrong | `@user-research`, `@metrics` |

Most real failures are **process** or **assumption** failures wearing the mask of a technical failure.

---

## Step 5: What went well

Even in a bad incident, something worked. Name it. This reinforces the behaviors worth keeping.

```
- [What detection mechanism caught this — name it specifically]
- [What slowed the blast radius]
- [What made recovery faster]
```

---

## Step 6: Action items

**DO NOT close the postmortem without at least one concrete action item.**

Each action item must have:
- An owner (a skill or a person)
- A deadline (a date, not "soon" or "next sprint")
- A measurable done-state (not "improve X" — "add gate Y to skill Z by date D")

```markdown
| # | Action | Owner | Deadline | Done when |
|---|---|---|---|---|
| 1 | [Specific change to make] | [@skill or person] | [YYYY-MM-DD] | [Observable state] |
| 2 | [Specific change to make] | [@skill or person] | [YYYY-MM-DD] | [Observable state] |
```

**Common action item types:**
- Add a DO NOT PROCEED gate to `@[skill]` at `[step]`
- Add `[check]` to `coding/references/qa-checklist.md`
- Add `[scenario]` to test suite
- Update `@metrics` to require `[threshold]` before `[handoff]`
- Add `[monitoring / alert]` to catch `[failure mode]` within `[time window]`

---

## Step 7: Process changes

If any skill in this factory failed to catch or prevent this incident, state it explicitly and propose the change:

```
Skill gap: @[skill] has no gate for [failure condition]
Proposed fix: Add the following to [skill file] at [step]:
  "DO NOT proceed if [condition]. [Required action before continuing]."
```

This is the closed loop. The postmortem feeds back into the skill definitions that govern the next build cycle.

---

## Output

Write the completed postmortem to: `postmortem-YYYY-MM-DD-<slug>.md`

Where `<slug>` is 2–4 words describing the incident (e.g. `postmortem-2024-01-15-auth-migration-failure.md`).

If the postmortem reveals a skill gap, open a follow-up task to update the relevant skill before closing the postmortem.

**DO NOT mark the postmortem closed until:**
- [ ] Root cause is identified (not just the trigger)
- [ ] At least one action item has an owner and deadline
- [ ] Any identified skill gap has a filed improvement task
- [ ] The timeline is complete

## Handoffs
- **From `@metrics`** → When post-launch verdict is ❌ or ⚠️
- **From `@qa`** → When a shipped story produced user-facing failures
- **From `@error-recovery`** → After an incident is resolved, to prevent recurrence
- **To `@pm`** → When the postmortem reveals the spec was wrong or the user need was misunderstood
- **To skill owners** → With proposed gate or checklist additions

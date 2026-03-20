# Metrics

> Managed by @project. Written by @metrics. Read by @dev (for instrumentation) and @postmortem (for verdict).

## North star metric
[One sentence: the single number that proves this feature is working]

- **Baseline:** [current value, or "unknown — new feature"]
- **Target:** [threshold value] by [date or cohort window]
- **Failure floor:** [below this value after X days → trigger @postmortem]

## Activation event
**Event name:** `[feature]_activated`
**Trigger:** [observable moment user gets core value]
**Required properties:**
- `user_id`
- `session_id`
- `timestamp`
- [feature-specific property]

## Funnel events

| Step | Event name | Trigger |
|---|---|---|
| 1 | `[feature]_step_1_entered` | [user action] |
| 2 | `[feature]_step_2_entered` | [user action] |
| — | `[feature]_abandoned` | session ends without activation |

## Retention signal
**Definition:** user triggers `[activation_event]` again within [D7 / D14 / D30]
**Target:** [X]% retention at D[N]

## Instrumentation spec

| Event | File / Component | Notes |
|---|---|---|
| `[event_name]` | `[path/to/file]` | [any caveats] |

## Do not track
- [PII fields to exclude]
- [Out-of-scope interactions]

---

## Post-launch results

> Filled in by @metrics after launch. Used by @postmortem if verdict is ❌ or ⚠️.

**Measured on:** [date]

| Metric | Target | D7 | D30 |
|---|---|---|---|
| North star | [target] | — | — |
| D7 retention | [target] | — | — |

**Funnel drop-off:**
- Step 1 → Activation: [X]%
- Biggest drop: [step] — [hypothesis]

**Verdict:** ✅ Met | ⚠️ Below target | ❌ Failed

---
name: harness-audit
description: >
  This skill should be used when reviewing, designing, or modifying any agent
  harness, plugin, hook, or gated workflow — for example "review the harness",
  "is the loop safe", "audit this plugin", or before shipping changes to
  hooks/, agents/, or verify scripts. It gives the claim-vs-enforcement audit
  procedure: every property the system asserts about itself must be traced to
  the mechanism that enforces it, or declared prose-only.
metadata:
  version: "0.1.0"
---

Audit any harness, plugin, or gated workflow by tracing claims to mechanisms, not by summarising documentation.

## The core rule
Build a two-column table: every self-claim the system makes about itself (in READMEs, SKILL.md files, agent descriptions, command text — "nothing finishes without X", "capped at N retries", "tracked in Y") against the code that enforces it. Three verdicts only:
- **Enforced** — point to the exact line.
- **Convention** — asserted in prose, no mechanism; relies on the model reading and obeying it.
- **Contradicted** — the code does the opposite of what the prose claims.

A claim with no enforcing mechanism is a finding, not documentation. Do not accept "the agent is instructed to..." as enforcement.

## Lifecycle walk
Simulate first use end-to-end, in order: install → first command run → hook firing → sub-agent spawn → turn end. At each step ask "which component is actually live right now, for which actor, and what is the user told versus what is true." Specifically check:
- Which hook events cover which actors (a main-session `Stop` hook does not cover a sub-agent's turn ending — that's `SubagentStop`, a separate registration).
- What a mid-session plugin install/update leaves stale (hooks bind at session start; skills/agents/commands can appear mid-session — these are different registration paths, verify both, don't assume they behave alike).
- What the first-run user is told (a setup command's own text) against what is actually true at that point in the lifecycle.

## Actor and tool topology check
Enumerate every tool actually exposed in the target environment, including platform-specific ones (e.g. a `PowerShell` tool alongside `Bash` on Windows), and verify every guard/hook matcher covers all of them. A deny-list on `Bash` only is not a deny-list if a `PowerShell` tool exists in the same session.

## Falsifiable-gate check
For every stage in a verify/gate script, ask: "can this stage actually return non-zero, today, as written?" A stage that is a placeholder (`Write-Host "would run X"`) cannot fail — report it as absent, not as implemented. A gate that cannot fail is not a gate.

## Output
Order findings: claims contradicted by code > guarantees asserted but unenforced > coverage gaps (topology/lifecycle) > tuning/style. Cite exact file and line for every finding. Do not soften a contradicted claim into a "suggestion" — say plainly that the documentation is wrong.

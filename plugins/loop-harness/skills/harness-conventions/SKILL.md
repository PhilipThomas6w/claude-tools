---
name: harness-conventions
description: >
  This skill should be used whenever working in a repository that uses the
  loop-engineering harness, or when the user mentions "the harness", "the loop",
  "verify", "STATE.md", "VISION.md", the maker/checker split, or asks how to work
  in a harnessed project. It explains the loop discipline and how the pieces fit.
metadata:
  version: "0.1.0"
---

Apply these conventions in any repository that carries the loop-engineering harness.

## The four things
- Goal: `docs/VISION.md` is the standing spec (mission, constraints, the current increment's acceptance criteria). Reread it at the start of every session.
- State: the nearest `STATE.md` records Done / In progress (exactly one) / Next / Blocked / Log. Read it first, update it before finishing.
- Verifier: `build/verify` is the single definition of done. Done means it exits 0, never that the work looks right.
- Critic: the maker never grades its own work; the checker (or the gate) decides.

## Loop mechanics
- Work one scoped item at a time. Follow the repo's own skills and `CLAUDE.md`; match existing patterns; change only what was asked.
- The Stop hook (and SubagentStop, so a maker sub-agent's own turn is gated too) runs `build/verify` and refuses to finish until it passes. It's skipped automatically when the tree has no uncommitted changes, so a pre-existing red repo doesn't block unrelated read-only turns. If it blocks, fix and re-run; do not argue with the gate.
- Brakes: the round-trip cap (5 consecutive verify failures, per session) is enforced in `run-verify.ps1` itself, not just asserted — on the 5th failure it stops blocking and tells you to write the blocker to `STATE.md` and stop. Watch for no progress (same failing tests or same tool call twice) and stop rather than spin even before the hard cap hits.

## Context and memory
- Context is a budget, not a bucket. Offload large output to files; keep only the slice you need; hand messy subtasks to a sub-agent so only the clean result returns.
- The agent forgets; the repo does not. Durable memory lives on disk: `VISION.md`, `STATE.md`, ADRs, and the `openwiki/` codebase wiki. Read `openwiki/` first for codebase context.

## Sub-agents
- explorer (read-only mapping, haiku, low effort), maker (one scoped change, isolated, sonnet at medium effort — not inherited session effort), checker (runs the gate, reviews the diff, sonnet by default — escalate to opus for security-relevant, architectural, or twice-bounced changes), verifier (deterministic gate run, haiku, low effort). Use them to keep the main session clean and the maker and checker separate.
- `/work-next` drives one full maker-then-checker cycle off the top of `STATE.md`'s queue automatically, stopping on the round-trip cap — use it instead of invoking maker/checker by hand when you just want the queue worked.

## Safety
- Never commit secrets; use Key Vault or env references. Never deploy from the session; deployment is pipeline-gated. Ask before destructive actions. Read generated diffs and generated docs before trusting them.

## Metric
- Track cost per accepted change in `docs/harness/LEDGER.csv`. Below 50% acceptance for a task class, narrow the task or fix the skill rather than looping.

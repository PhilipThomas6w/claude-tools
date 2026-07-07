---
description: Drive one full maker-then-checker cycle off STATE.md's queue, stopping on the round-trip cap
allowed-tools: Read, Task
---

Work exactly one item off the loop: the current `## In progress` entry in the nearest `STATE.md` if one is already set, otherwise the top of `## Next`.

1. Read `docs/VISION.md` (or `VISION.md`) and the nearest `STATE.md`. If `## In progress` already holds an item, use it. Otherwise move the top of `## Next` into `## In progress` and save that update before delegating — `STATE.md` must reflect reality before you hand off, not after.
2. Delegate implementation to the `maker` sub-agent (Task tool) for that one item only.
3. Delegate review to the `checker` sub-agent (Task tool) against the maker's diff. Use the default Sonnet checker unless the item is security-relevant or architectural, or has already bounced back to the maker twice — escalate to Opus for those (see the checker's own Escalation section).
4. If the checker returns FAIL, hand its ordered findings back to a fresh `maker` invocation and repeat from step 2.
5. The Stop/SubagentStop hooks enforce the real round-trip cap (5 consecutive verify failures) automatically. If a sub-agent's turn ends with a "cap reached, write the blocker" instruction instead of a normal block, stop the loop immediately: write the blocker to `STATE.md` under "Blocked / needs decision" exactly as instructed, and end here. Do not keep invoking maker past that point — the cap exists so you don't.
6. On checker PASS, confirm `STATE.md` actually shows the item moved to `## Done` with its commit SHA and gate evidence (the maker should have done this already — verify it rather than assume it).
7. Report a short summary: what the item was, how many maker/checker round-trips it took, and whether it finished Done or Blocked.

This is the harness's minimal automation layer — one state file, one gate, one command driving maker→checker off the queue, instead of invoking each sub-agent by hand every time. It does not replace `/init-harness` (project scaffolding) or manual work on a single change; use it when you want the next queued item worked end-to-end.

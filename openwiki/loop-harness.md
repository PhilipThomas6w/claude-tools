# loop-harness

**Path:** `plugins/loop-harness/` · **Version:** 0.5.0 (per marketplace.json)

Stack-agnostic loop-engineering harness. Scaffolds the per-project files that make "done" mechanically checkable, and wires three hooks (see `hooks/hooks.json`) that are portable machinery, not per-project config.

## Hooks (`hooks/hooks.json`, scripts are pwsh)
- **SessionStart** → `scripts/session-context.ps1` — prints `docs/VISION.md` (or `VISION.md`) and the nearest `STATE.md` as plain text; this text is added to Claude's context automatically. Also nudges toward `openwiki/` if present. This is the anti-drift brake: the standing spec and current state are reread every session without being asked.
- **PreToolUse(Bash)** → `scripts/guard-bash.ps1` — blocks a fixed deny-list (`az deployment`, `az group create/delete`, force git push, `rm -rf /`, `terraform apply`, `kubectl apply/delete`, `helm install/upgrade`, etc.) with exit code 2 and an explanatory stderr message. Deployment is pipeline-only with a human gate; this hook keeps that boundary out of the session.
- **Stop** → `scripts/run-verify.ps1` — runs `build/verify.ps1 -Fast` if it exists; on non-zero exit, emits `{decision: block, reason: ...}` with the failing tail, which prevents Claude from finishing the turn. On pass, or when no verify script exists, it's silent.

**Known gotcha (confirmed empirically):** these hooks are registered once when a session starts. Installing or updating the plugin mid-session does not retroactively wire its hooks into the already-running session — a fresh session is required to pick them up. Skills/agents/commands, by contrast, did show up mid-session in the one case this was tested. If a hook that should fire doesn't, check whether the session predates the plugin install before assuming the hook itself is broken.

## Command: `/loop-harness:init-harness [stack]`
Scaffolds the per-project layer: `docs/VISION.md` and `STATE.md` from the templates in `templates/`, `build/verify.ps1` from the matching stack template in `templates/verify/` (dotnet, node, python, al, static — all PowerShell), a repo `CLAUDE.md` "Project law" section, and `docs/harness/LEDGER.csv` for cost-per-accepted-change tracking. Seeds from existing design docs if present (interviews the user otherwise).

**Known bug (found by review, not yet fixed):** Step 6 currently tells the user the hooks "are already active because the plugin is installed" — this is false in the common case where the plugin was installed and `/init-harness` run in the same session, per the hook-registration gotcha above. A proposed fix is a self-test canary (run a harmless command matching the deny-list; if it's blocked, hooks are live, if it executes, tell the user to restart) rather than asserting either way.

## Command: `/loop-harness:doc-refresh`
Maintains the Karpathy/OpenWiki-pattern codebase wiki at `openwiki/`. If the `openwiki` CLI is on PATH, runs it; otherwise maintains `openwiki/` pages directly (this is how this very page was produced). Ensures the repo `CLAUDE.md` has the "check openwiki/ first" pointer. Always presented as a diff for review — generated docs carry the same review duty as generated code.

## Sub-agents (the maker/checker split, see [[architecture]])
- **explorer** (haiku, read-only: Read/Grep/Glob) — reads `openwiki/` first if present, then confirms against the real tree; returns a short brief, never edits.
- **maker** (sonnet: Read/Write/Edit/Bash/Grep/Glob) — implements exactly one scoped change from `STATE.md`'s in-progress item or top of Next; runs `build/verify` itself before calling anything done; never grades its own work.
- **checker** (sonnet: Read/Grep/Glob/Bash) — runs `build/verify` in full mode, reviews the diff for what tests can't see (naming, convention fit, missed edge cases, ungated consequential writes); PASS only if gate is green and review is clean.
- **verifier** (haiku: Bash/Read) — cheap, deterministic gate re-run with no side effects; reports pass/fail and the failing tail only.

## Skills
- **harness-conventions** — explains the "four things" (Goal=VISION.md, State=STATE.md, Verifier=build/verify, Critic=checker), the round-trip cap (default 5) before writing a blocker to STATE.md and stopping, and the cost-per-accepted-change metric in the ledger. Note: as of the Fable-5 review below, the round-trip cap and the ledger-writing are both prose-only — nothing in the scripts enforces or populates them yet.
- **add-change** — the contract-first/test-first procedure for implementing one scoped change: contract change + failing test first, implement, verify to green, one commit per concern, hand to checker.
- **harness-audit** — claim-vs-enforcement audit procedure for any harness/hook/gate: trace every self-claim to its enforcing mechanism (or mark it convention/contradicted), walk the install→hook→sub-agent→turn-end lifecycle, check tool/matcher topology, check every verify stage can actually fail. Distilled from a dedicated review of this plugin (see below).
- **claude-code-hook-facts** — verified facts about Claude Code hook registration timing, output schema per event (SessionStart/PreToolUse/Stop/SubagentStop), the Stop-hook 8-block override and `stop_hook_active`, and event/actor coverage (main session vs sub-agent vs tool call).
- **verify-gate-authoring** — what makes a verify stage real: falsifiability (a stage that can't return non-zero isn't a stage), the fast/full split, real secret scanning, per-stack reference commands including AL.

## Fable-5 review (2026-07-07)

A dedicated review (run on the Fable 5 model, commissioned specifically to surface gaps the day-to-day Opus/Sonnet routing might miss) audited this plugin against Anthropic's public Claude Code guidance and found the architecture sound but several claims enforced only in prose: the round-trip cap, the ledger, and — most importantly — the Stop gate does not cover `SubagentStop`, so the `maker` sub-agent's own turn can end without the verify gate running. The Bash deny-list guard also doesn't cover the `PowerShell` tool, and `templates/verify/verify.al.ps1` (and `verify.static.ps1`) ship with placeholder stages that always exit 0. None of these are fixed yet — this page records the finding; the three skills above are the distilled review method and hook/gate facts, so the audit is repeatable without needing that model again.

# loop-harness

**Path:** `plugins/loop-harness/` · **Version:** 0.4.0 (per marketplace.json)

Stack-agnostic loop-engineering harness. Scaffolds the per-project files that make "done" mechanically checkable, and wires three hooks (see `hooks/hooks.json`) that are portable machinery, not per-project config.

## Hooks (`hooks/hooks.json`, scripts are pwsh)
- **SessionStart** → `scripts/session-context.ps1` — prints `docs/VISION.md` (or `VISION.md`) and the nearest `STATE.md` as plain text; this text is added to Claude's context automatically. Also nudges toward `openwiki/` if present. This is the anti-drift brake: the standing spec and current state are reread every session without being asked.
- **PreToolUse(Bash)** → `scripts/guard-bash.ps1` — blocks a fixed deny-list (`az deployment`, `az group create/delete`, force git push, `rm -rf /`, `terraform apply`, `kubectl apply/delete`, `helm install/upgrade`, etc.) with exit code 2 and an explanatory stderr message. Deployment is pipeline-only with a human gate; this hook keeps that boundary out of the session.
- **Stop** → `scripts/run-verify.ps1` — runs `build/verify.ps1 -Fast` if it exists; on non-zero exit, emits `{decision: block, reason: ...}` with the failing tail, which prevents Claude from finishing the turn. On pass, or when no verify script exists, it's silent.

**Known gotcha (confirmed empirically):** these hooks are registered once when a session starts. Installing or updating the plugin mid-session does not retroactively wire its hooks into the already-running session — a fresh session is required to pick them up. Skills/agents/commands, by contrast, did show up mid-session in the one case this was tested. If a hook that should fire doesn't, check whether the session predates the plugin install before assuming the hook itself is broken.

## Command: `/loop-harness:init-harness [stack]`
Scaffolds the per-project layer: `docs/VISION.md` and `STATE.md` from the templates in `templates/`, `build/verify.ps1` from the matching stack template in `templates/verify/` (dotnet, node, python, al, static — all PowerShell), a repo `CLAUDE.md` "Project law" section, and `docs/harness/LEDGER.csv` for cost-per-accepted-change tracking. Seeds from existing design docs if present (interviews the user otherwise). Does not touch settings.json — the hooks are already active via the plugin itself.

## Command: `/loop-harness:doc-refresh`
Maintains the Karpathy/OpenWiki-pattern codebase wiki at `openwiki/`. If the `openwiki` CLI is on PATH, runs it; otherwise maintains `openwiki/` pages directly (this is how this very page was produced). Ensures the repo `CLAUDE.md` has the "check openwiki/ first" pointer. Always presented as a diff for review — generated docs carry the same review duty as generated code.

## Sub-agents (the maker/checker split, see [[architecture]])
- **explorer** (haiku, read-only: Read/Grep/Glob) — reads `openwiki/` first if present, then confirms against the real tree; returns a short brief, never edits.
- **maker** (sonnet: Read/Write/Edit/Bash/Grep/Glob) — implements exactly one scoped change from `STATE.md`'s in-progress item or top of Next; runs `build/verify` itself before calling anything done; never grades its own work.
- **checker** (sonnet: Read/Grep/Glob/Bash) — runs `build/verify` in full mode, reviews the diff for what tests can't see (naming, convention fit, missed edge cases, ungated consequential writes); PASS only if gate is green and review is clean.
- **verifier** (haiku: Bash/Read) — cheap, deterministic gate re-run with no side effects; reports pass/fail and the failing tail only.

## Skills
- **harness-conventions** — explains the "four things" (Goal=VISION.md, State=STATE.md, Verifier=build/verify, Critic=checker), the round-trip cap (default 5) before writing a blocker to STATE.md and stopping, and the cost-per-accepted-change metric in the ledger.
- **add-change** — the contract-first/test-first procedure for implementing one scoped change: contract change + failing test first, implement, verify to green, one commit per concern, hand to checker.

# loop-harness

**Path:** `plugins/loop-harness/` · **Version:** 0.6.0 (per marketplace.json)

Stack-agnostic loop-engineering harness. Scaffolds the per-project files that make "done" mechanically checkable, and wires four hooks (see `hooks/hooks.json`) that are portable machinery, not per-project config.

## Hooks (`hooks/hooks.json`, scripts are pwsh — no `.sh` counterparts any more, see below)
- **SessionStart** → `scripts/session-context.ps1` — prints `docs/VISION.md` (or `VISION.md`) and the nearest `STATE.md` as plain text; this text is added to Claude's context automatically. Also nudges toward `openwiki/` if present. This is the anti-drift brake: the standing spec and current state are reread every session without being asked.
- **PreToolUse(Bash|PowerShell)** → `scripts/guard-bash.ps1` — blocks a deny-list (deployment commands, destructive git/terraform/kubectl/helm/az operations, root/home/wildcard `rm -rf`, drive-root `Remove-Item`, etc. — see the script for the full list) with exit code 2 and an explanatory stderr message. Matches on both the `Bash` and `PowerShell` tools. Framed as a convention fence, not a security wall — unattended/headless runs should also pin `--allowedTools` or use sandboxing.
- **Stop and SubagentStop** → `scripts/run-verify.ps1` — registered on both events, so a `maker` sub-agent's own turn is gated, not only the main session's. Skips the gate entirely when the working tree has no uncommitted changes (`git status --porcelain`), so a pre-existing red repo doesn't block unrelated read-only turns or a read-only `explorer`/`verifier` sub-agent. When it does run `build/verify.ps1 -Fast`: on pass, resets the round-trip counter and appends a `pass` row to `docs/harness/LEDGER.csv`; on failure, appends a `fail` row and blocks with `{decision: block, reason: ...}` up to 5 consecutive failures (tracked per `session_id` in a temp counter file); on the 6th, it stops blocking and instead attaches `additionalContext` instructing Claude to write the blocker to `STATE.md` and stop, rather than looping forever.

**Known gotcha (confirmed empirically, still true):** hooks are registered once when a session starts. Installing or updating the plugin mid-session does not retroactively wire its hooks into the already-running session — a fresh session is required to pick them up. Skills/agents/commands, by contrast, did show up mid-session in the one case this was tested. `/init-harness` Step 6 now self-tests this with a canary rather than asserting hooks are active (see below).

## Command: `/loop-harness:init-harness [stack]`
Scaffolds the per-project layer: `docs/VISION.md` and `STATE.md` from the templates in `templates/`, `build/verify.ps1` from the matching stack template in `templates/verify/` (dotnet, node, python, al, static — all PowerShell, and all fail loudly on any unwired stage rather than silently passing), a repo `CLAUDE.md` "Project law" section, and `docs/harness/LEDGER.csv` for cost-per-accepted-change tracking. Seeds from existing design docs if present (interviews the user otherwise). Step 6 runs a hook self-test canary (a harmless command matching the deny-list) instead of asserting hooks are active, and tells the user to restart the session if it turns out they aren't.

## Command: `/loop-harness:doc-refresh`
Maintains the Karpathy/OpenWiki-pattern codebase wiki at `openwiki/`. If the `openwiki` CLI is on PATH, runs it; otherwise maintains `openwiki/` pages directly (this is how this very page was produced). Ensures the repo `CLAUDE.md` has the "check openwiki/ first" pointer. Always presented as a diff for review — generated docs carry the same review duty as generated code.

## Command: `/loop-harness:work-next`
The harness's minimal automation layer, added after the Fable-5 review flagged its absence: takes the current `## In progress` item in `STATE.md` (or the top of `## Next`), delegates to `maker`, then `checker`, loops on FAIL, and stops the moment the Stop/SubagentStop round-trip cap surfaces a "write the blocker" instruction instead of a normal block. Turns "you invoke maker and checker by hand" into "one command drives the queue."

## Sub-agents (the maker/checker split, see [[architecture]])
- **explorer** (haiku, low effort, read-only: Read/Grep/Glob) — reads `openwiki/` first if present, then confirms against the real tree; returns a short brief, never edits.
- **maker** (sonnet, medium effort, `maxTurns: 20`: Read/Write/Edit/Bash/Grep/Glob) — implements exactly one scoped change from `STATE.md`'s in-progress item or top of Next; runs `build/verify` itself before calling anything done; never grades its own work. Effort is pinned to medium rather than inheriting the session's (often higher) effort, matching "Sonnet 5 at medium is the workhorse."
- **checker** (sonnet by default, `maxTurns: 20`: Read/Grep/Glob/Bash) — runs `build/verify` in full mode, reviews the diff for what tests can't see (naming, convention fit, missed edge cases, ungated consequential writes); PASS only if gate is green and review is clean. Escalate to Opus (override the `model` parameter on invocation) for security-relevant, architectural, or twice-bounced changes — see its Escalation section.
- **verifier** (haiku, low effort: Bash/Read) — cheap, deterministic gate re-run with no side effects; reports pass/fail and the failing tail only.

## Skills
- **harness-conventions** — explains the "four things" (Goal=VISION.md, State=STATE.md, Verifier=build/verify, Critic=checker), the round-trip cap (now enforced in `run-verify.ps1` itself, not just asserted), and the cost-per-accepted-change metric in the ledger (now populated automatically).
- **add-change** — the contract-first/test-first procedure for implementing one scoped change: contract change + failing test first, implement, verify to green, one commit per concern, hand to checker.
- **harness-audit** — claim-vs-enforcement audit procedure for any harness/hook/gate: trace every self-claim to its enforcing mechanism (or mark it convention/contradicted), walk the install→hook→sub-agent→turn-end lifecycle, check tool/matcher topology, check every verify stage can actually fail.
- **claude-code-hook-facts** — verified facts about Claude Code hook registration timing, output schema per event (SessionStart/PreToolUse/Stop/SubagentStop), the Stop-hook 8-block override and `stop_hook_active`, and event/actor coverage (main session vs sub-agent vs tool call).
- **verify-gate-authoring** — what makes a verify stage real: falsifiability (a stage that can't return non-zero isn't a stage), the fast/full split, real secret scanning, per-stack reference commands including AL.

## Fable-5 review (2026-07-07) and its fixes

A dedicated review (run on the Fable 5 model, commissioned specifically to surface gaps the day-to-day Opus/Sonnet routing might miss) audited this plugin against Anthropic's public Claude Code guidance and found the architecture sound but several claims enforced only in prose. All eleven of its numbered proposals have since been applied:

- **P1** real round-trip cap (was: prose only, relying on Claude Code's own 8-block override) — done, see the Stop hook description above.
- **P2/P3** `SubagentStop` registered, gate skipped on a clean tree — done.
- **P4** `/init-harness` Step 6 self-tests hooks with a canary instead of asserting — done.
- **P5** guard matcher covers `PowerShell` too; deny-list extended (terraform destroy, helm uninstall/delete, az resource/webapp/sql/storage delete, azd up/down, git reset --hard/clean -f/--delete/force-refspec, gh repo delete, whole-root/home/wildcard rm -rf, drive-root Remove-Item with either flag order) — done, regex-tested against both true and false positives.
- **P6** `effort: medium` on maker, `effort: low` on explorer/verifier, `maxTurns` on maker/checker — done.
- **P7** checker escalation rule (Sonnet default, Opus for security/architectural/twice-bounced) — done, documented in `checker.md`.
- **P8** ledger mechanised (`run-verify.ps1` appends a row on every gated run; best-effort token count from the transcript, honest `n/a` fallback); STATE.md's Log no longer asks for self-estimated tokens — done.
- **P9** AL and static verify templates fail loudly on unwired stages instead of always passing; secret-scan stages prefer `gitleaks`, falling back to a regex with `node_modules`/test/fixture exclusions — done, runtime-tested.
- **P10** the unreachable `.sh` hook scripts (which also had output-schema bugs) deleted rather than fixed, since PowerShell is this plugin's stated requirement — done.
- **P11** `/work-next` automation layer added — done, see above.

The three skills above are the distilled review method and hook/gate facts, so this audit is repeatable on Opus/Sonnet without needing that model again. Full findings and reasoning are preserved in the personal knowledge vault at `sources/decisions/2026-07-07-loop-harness-fable5-review.md`.

---
name: claude-code-hook-facts
description: >
  This skill should be used whenever writing, editing, or debugging Claude
  Code hooks (hooks.json, PreToolUse/Stop/SessionStart/SubagentStop scripts),
  or when a hook "should have fired" and didn't. It records the verified
  behavioural facts: registration timing, output schemas per event, the Stop
  hook 8-block override and stop_hook_active, and event/actor coverage.
metadata:
  version: "0.1.0"
---

Verified facts about Claude Code hook behaviour. Read this before writing or debugging any hook; do not guess at schemas or timing.

## Registration timing
- Plugin hooks (`hooks.json`) bind when a session starts. Installing or updating a plugin mid-session does not wire its hooks into the already-running session — confirmed empirically: a PreToolUse guard silently failed to block a matching command in a session that predated the plugin install, then worked correctly from a fresh session.
- Skills, agents, and commands from the same plugin can appear mid-session (confirmed via `/context` showing them loaded after a mid-session install) — do not assume hooks behave the same way just because other plugin content did.
- Settings-file hook edits (`.claude/settings.json` etc.) are picked up by a file watcher, but only for directories that had a settings file when the session started — a brand new `.claude/` directory created mid-session is not watched.
- The fix in every case above is a fresh session. To verify a hook is actually live rather than assuming: run a harmless command that matches the hook's trigger (e.g. a PreToolUse Bash guard: run the exact deny-list phrase) and check whether it blocks. If it executes normally, the hook is stale, not broken — restart before relying on it.

## Output schema per event (do not mix these up)
- **SessionStart**: plain stdout is added to context, or use `hookSpecificOutput.additionalContext`. There is no `decision` field for this event — packing content into a `reason` field does nothing.
- **PreToolUse**: block via exit code 2 with stderr (shown to the model), or via `hookSpecificOutput.permissionDecision: "allow"|"deny"|"ask"` with `permissionDecisionReason`. `decision: "approve"|"block"` is not the current schema for this event — do not use it.
- **Stop**: emit `{"decision": "block", "reason": "..."}` (JSON on stdout, exit 0) to prevent the turn from ending; omit or exit 0 with no output to allow it.
- **SubagentStop**: a distinct event from `Stop` — a hook registered only on `Stop` does not fire when a sub-agent's turn ends. Register both if sub-agent completions need gating.

## Stop-hook discipline
- Claude Code force-ends a turn after a Stop hook blocks 8 consecutive times without progress, as a safety backstop — do not rely on this as your actual retry cap if you need a smaller, deliberate one.
- Every Stop hook should parse the JSON on stdin and check `stop_hook_active` — but do not simply exit early whenever it's true, or you defeat the point of a Stop gate (which is to keep blocking until the work is actually green). Implement a counted brake instead: track consecutive blocks per `session_id` (a temp file keyed by session id works), keep blocking with the failure reason up to your chosen N, and only on the Nth failure stop blocking and instead instruct the model to record the blocker and stop. Reset the counter on a passing run.

## Event/actor coverage table
| Actor's turn ends | Hook event |
|---|---|
| Main session | `Stop` |
| Sub-agent | `SubagentStop` |
| Tool about to run (any actor) | `PreToolUse`, matcher = tool name |

Match the matcher to every tool actually present in the target environment — a Windows session commonly exposes both `Bash` and `PowerShell` as distinct tools; a matcher of `"Bash"` alone does not cover the second.

## Other facts worth knowing
- Hook timeouts are per-hook (set via the `timeout` field); a slow hook can starve the turn.
- Hook stdout has practical size limits when injected into context — keep SessionStart output to what's actually needed each session (e.g. `VISION.md` + nearest `STATE.md`, not the whole `docs/` tree).

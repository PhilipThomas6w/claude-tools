# loop-harness

A stack-agnostic loop-engineering harness for any coding project. Agents are config, tools are code, and nothing finishes without the gate. Works for a website, a web app or an AI platform; AI-specific build tooling lives in the separate `ai-agent-pack` plugin.

## Requirements

PowerShell 7+ (`pwsh`) on the PATH. The hooks and the verify entrypoint (`build/verify.ps1`) are PowerShell, chosen to be native to a .NET/Windows environment and independent of Git Bash.

## What it installs

- **Hooks** (active while enabled):
  - SessionStart injects `docs/VISION.md` and the nearest `STATE.md`, and points the agent at `openwiki/` if present (the anti-drift brake).
  - PreToolUse(Bash) blocks deploy and destructive commands (deployment is pipeline-gated).
  - Stop runs `build/verify.ps1 -Fast` and refuses to finish until it passes (the Ralph Wiggum defence).
- **Sub-agents**: `explorer` (read-only mapping), `maker` (one scoped change, isolated), `checker` (runs the gate, reviews the diff), `verifier` (deterministic gate run). The maker never grades its own work.
- **Commands**: `/init-harness [stack]` scaffolds the per-project files; `/doc-refresh` maintains the codebase wiki (OpenWiki / Karpathy pattern).
- **Skills**: `harness-conventions` (the loop discipline), `add-change` (the gated change procedure), `harness-audit` (claim-vs-enforcement review of any harness/hook/gate), `claude-code-hook-facts` (verified hook registration timing and output schemas), `verify-gate-authoring` (what makes a verify stage real vs a placeholder).
- **Templates**: `VISION.md`, `STATE.md`, `LEDGER.csv`, and per-stack `verify.ps1` scripts (dotnet, node, python, al, static).

## Setup

1. Install the plugin (via your marketplace or locally). Ensure `pwsh` is on the PATH.
2. In a repository, run `/init-harness` (or `/init-harness dotnet`). If design docs already exist in `docs/` (for example from a discovery/design process), it distils `docs/VISION.md` and the `STATE.md` queue from them and asks you to confirm; otherwise it interviews you. It then generates `build/verify.ps1` wired to your commands, a repo `CLAUDE.md` project-law section, and `docs/harness/LEDGER.csv`.
3. Fill the goal and the first queue in `STATE.md`. Work one item at a time; the gate does the rest.

## Notes

- Keep personal preferences in your global `CLAUDE.md`; this harness adds only project law and loop mechanics.
- `/doc-refresh` prefers the OpenWiki CLI if installed, else maintains `openwiki/` directly. Point OpenWiki at your own model endpoint; do not depend on its GitHub Action if you use Azure DevOps.

## Metric

Track cost per accepted change in `docs/harness/LEDGER.csv`. Below 50% acceptance for a task class, narrow the task or fix the skill rather than looping.

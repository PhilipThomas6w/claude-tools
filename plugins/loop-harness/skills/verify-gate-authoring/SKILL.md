---
name: verify-gate-authoring
description: >
  This skill should be used when creating or editing a project's build/verify
  script (build/verify.ps1, /init-harness Step 3, or any "definition of done"
  gate) — for example "wire the verify gate", "add a stage", "the gate always
  passes". It defines what a real gate is: every stage falsifiable, fast/full
  split, real secret scanning, and per-stack reference commands including AL.
metadata:
  version: "0.1.0"
---

Author a verify gate that can actually fail. A gate that always passes is not a gate.

## The falsifiability rule
Every stage must be able to return non-zero, today, as written, on this project. A placeholder like `Write-Host "would run compile here"` is not a stage — it's a comment that will report success forever. Either wire the real command before the gate is considered done, or make the stage fail loudly until wired (`Write-Error "compile stage not wired"; exit 1`) so an unwired gate cannot be mistaken for a green baseline.

## Fast/full split
- `-Fast`: seconds, not minutes — compile/build, unit tests, lint, secret scan. This is what the Stop hook runs on every turn end, so it must fit comfortably inside the hook's timeout budget.
- Full (no flag): everything else — e2e tests, evals, accessibility/lighthouse, anything slow. Run on demand or in CI, not on every turn.

## Secret scanning
Prefer a real scanner (e.g. `gitleaks detect --no-git --redact`) over a hand-rolled regex. If a regex is the only option, exclude `node_modules`/vendor/test-fixture paths and cover more than one pattern family — a scan for `AKIA` alone misses most real secrets, and a scan with no exclusions will both waste time and false-positive on fixtures containing the literal string `password =`.

## Per-stack reference points
- **.NET**: `dotnet build`, `dotnet test`.
- **Node**: `npm run build --if-present`, `npm test`.
- **Python**: the project's test runner (pytest), plus a linter (ruff/flake8).
- **AL (Business Central)**: the compile step is the load-bearing check — wire the actual AL compiler (`alc.exe`, or an AL-Go/container-based compile task) and the BC Test Toolkit runner for tests; app.json version-bump checks belong here too. Do not ship this stack's gate with the compile stage stubbed — AL projects have no other cheap correctness signal before the compiler runs.
- **Static sites**: real build command, a link checker, and (in full mode) Lighthouse/accessibility checks — not `Write-Host` placeholders for any of them.

## Evidence discipline
Print stage names and enough tail output that a failure's cause is visible in the Stop hook's blocked-reason and in the checker's review — "verify OK" with no stage output tells nobody what was actually checked.

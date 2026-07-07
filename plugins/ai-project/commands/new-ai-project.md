---
description: Start a new in-house AI project — scaffold the docs/ working structure, then run requirements gathering, capturing every decision as markdown. Render the branded gate package later with /render-gate-package.
---

You are kicking off a **new in-house AI project**. Follow the `ai-poc-docs` skill and its `references/gate-taxonomy.md`.

1. **Turn 1 — scaffold.** Create the `docs/` working structure (requirements/, design/, evaluation/, governance/, adr/), `delivery-plan.md`, `glossary.md`, a seeded `CLAUDE.md` (operating principles), and a short `README.md`, with placeholder files (single H1 + `Status: not yet started`). Commit it.
2. **Then — discovery.** Ask focused questions (one at a time unless I ask for batches; no questionnaire dump). Push back when my answers are vague or when I conflate requirements with solutions — name the conflation. **Capture every agreed decision into the relevant `docs/` markdown file in the same turn.** Establish the project name, a 3–5 letter document code, and the **document style pack** (default `generic-docx`; or your own) — record it in `CLAUDE.md`.
3. **Do not pick an architecture or write code until I confirm.** Surface tradeoffs; record options and rejected alternatives as ADRs (Nygard format).
4. **Verify, don't assert** — use the Microsoft Learn MCP tools for Microsoft topics and cite sources.
5. **Gate packages are rendered later** from the markdown with `/render-gate-package poc` (and `production` at the production gate). Do not hand-author any `.docx`.

Start with turn 1: scaffold and commit, then ask your first requirements question.

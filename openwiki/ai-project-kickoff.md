# ai-project-kickoff

**Path:** `plugins/ai-project-kickoff/` · **Version:** 3.0.0 (per marketplace.json — verify against `plugin.json` before relying on it, they can drift)

Brand-neutral standard process for kicking off an in-house AI project: gated requirements capture in version-controlled markdown, rendered to a branded document package at each review gate. See [[architecture]] for how it relates to `generic-docx`.

## Entry points
- `/new-ai-project` command — scaffolds `docs/` (requirements/, design/, evaluation/, governance/, adr/), `delivery-plan.md`, `glossary.md`, a seeded `CLAUDE.md`, then runs discovery one focused question at a time.
- `/render-gate-package poc|production` command — delegates to the `gate-renderer` agent to render the current gate's `.docx` package from `docs/`.

## Agents
- **discovery** (model: opus) — facilitates requirements gathering. Never renders documents or picks an architecture; only elicits and records decisions into `docs/` in the same turn.
- **gate-renderer** (model: sonnet, tools: Read/Write/Edit/Bash/Glob/Grep/Skill) — token-heavy generation kept off the main session's context and off the reasoning model for cost. Reads the gate taxonomy, consolidates working markdown, invokes the declared style pack's Skill to produce `.docx` into `gates/<gate>/`. Marks gaps `[TBC – owner]` rather than inventing content.
- **design-reviewer** — reviews a finished design against `references/standards.md` and, for Microsoft stacks, live Microsoft Learn docs (cited). Returns `APPROVE` or `RECOMMEND CHANGES` with prioritised (Critical/Important/Optional) findings. Never modifies documents.

## Skill: ai-poc-docs
The process definition. Key references (read as needed, not all at once):
- `references/gate-taxonomy.md` — the two-layer model and which documents belong to which gate (PoC gate includes the LLD).
- `references/standards.md` — mandatory: ISO/IEC 42001, NIST AI RMF, ISO/IEC 23894, ISO/IEC/IEEE 29148 & 42010, ISO/IEC 27001, UK GDPR/EU AI Act as relevant.
- `references/discovery-questionnaire.md`, `references/document-specs.md`.

## Document style pack contract
The project declares its pack in `CLAUDE.md` (e.g. `Document style pack: generic-docx`). `gate-renderer` invokes that pack's Skill via the Skill tool — this plugin never hard-codes a renderer. `none` skips rendering entirely (markdown-only). See [[generic-docx]] for the default pack and how to clone it into a branded one.

## Operating rules worth remembering
- No decision exists until it's written to the relevant `docs/` file, same turn.
- Never hand-edit a rendered `.docx` — it's always regenerated from markdown.
- Verify, don't assert: Microsoft topics go through the Microsoft Learn MCP tools, cited.

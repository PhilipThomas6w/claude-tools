---
name: software-design-docs
description: Standard process for starting a new general software project (non-AI; for AI projects use ai-project). Run requirements gathering, capture every decision as granular working markdown in docs/ (the version-controlled source of truth), and at each review gate render the branded document package (.docx) from that markdown using the selected document style pack. Use when starting a new software project, kicking off discovery/requirements for a general delivery, or when the user runs /new-software-project. The design gate package includes the LLD; delivery-only documents are produced at the delivery gate.
---

# Software project kickoff - two-layer documentation standard

A repeatable, gated process with **two layers** (full detail in `references/gate-taxonomy.md`):

- **Working layer** - granular markdown in `docs/`. The source of truth: version-controlled, updated in the *same turn* a decision is made, read directly by build sessions. All authoring happens here.
- **Gate package** - branded `.docx` in `gates/<gate>/`, **rendered from the markdown** at each review gate (design, then delivery) with the selected document style pack. Never hand-authored.

## Scope: this plugin vs ai-project

This skill is for **general software projects**: web and desktop applications, APIs and integrations, Business Central extensions, platform and infrastructure work, and anything else whose deliverable is not itself an AI/ML capability. If the project's purpose is to build AI capability (agents, copilots, model-backed features with evaluation needs), use the `ai-project` plugin instead - it adds AI design, evaluation and AI-governance documents this skill deliberately omits. A conventional project that merely *calls* an AI service as one feature among many still belongs here; record that integration as an FR and an ADR like any other dependency.

## Operating rules

- Precise, structured, **UK English**, serious and concise. Do not fabricate - mark unknowns `[TBC – owner]`.
- **Persist every decision in the relevant `docs/` markdown file in the same turn it is made.** No decision exists until it is written down; never let the docs and the conversation drift.
- Do not pick an architecture or write code until the engineer confirms. Record options and rejected alternatives as ADRs (Nygard format).
- Adhere to `references/standards.md`; cite the relevant standard where it applies.
- **Verify, don't assert** - for Microsoft technologies use the Microsoft Learn MCP tools and check before advising; cite the URLs.
- Render gate packages **only** with the selected document style pack. If it is not installed, tell the user and stop.

## Step 1 - Scaffold (turn 1, before discussion)

Create the working structure from `references/gate-taxonomy.md` with placeholder files (a single H1 + `Status: not yet started`), the `adr/` folder, a seeded `CLAUDE.md` (operating principles below), and a short `README.md` pointing into `docs/`. Commit it, so the index is real from the start.

Seed `CLAUDE.md` with at least: verify-don't-assert (name the Microsoft Learn MCP and web search as the verification path); persist decisions in `docs/` in the same turn; requirements before solutions (name any conflation); the declared document style pack. Extend it whenever a principle worth preserving is agreed.

## Step 2 - Discovery & capture (ongoing)

Gather requirements (topics in `references/discovery-questionnaire.md`). **Elicitation style is flexible** - one focused question at a time, or grouped batches, as the engineer prefers - but **capture each agreed point into the relevant `docs/` markdown file in the same turn**. Push back on vague answers and on requirements/solution conflation; name the conflation. Surface tradeoffs. Establish the project name and a 3–5 letter document code `<CODE>`.

## Step 3 - Gate render (at each review gate)

When a gate is reached, render the branded package from the working markdown per the taxonomy and roll-up mapping in `references/gate-taxonomy.md` and the section outlines in `references/document-specs.md`. Output to `gates/<gate>/`. The design gate **includes the LLD**. Re-render the whole package from current markdown; never edit a `.docx` by hand. (The `/render-gate-package` command performs this.)

## Handoff

Once the `design-reviewer` agent returns APPROVE on the design gate package, hand over to `loop-harness`: run `/init-harness <stack>` in the repository. It distils `docs/VISION.md` and the `STATE.md` queue from the existing `docs/` content. This skill covers discovery and design only; implementation is loop-harness's job.

## Scope of this skill

This skill covers discovery → working markdown → design gate package, with the delivery-gate taxonomy defined for later. Delivery-only documents (full test results, UAT report, operations pack, release/rollback) are produced at the delivery gate.

## References (read as needed)

- `references/gate-taxonomy.md` - the two-layer model, working structure, gate taxonomy and roll-up rules (**read first**).
- `references/standards.md` - industry standards and best practices to adhere to (**mandatory**).
- `references/discovery-questionnaire.md` - discovery topics.
- `references/document-specs.md` - required sections for each rendered document.

## Document style pack (brand)

Rendering is delegated to a **document style pack** chosen per project - this plugin is brand-neutral. Declare the project's style pack at kickoff and record it in `CLAUDE.md` (for example `Document style pack: generic-docx`):

- `generic-docx` - neutral, unbranded (**default**).
- `personal-docx` or another pack - your own or a client's brand.
- `none` - markdown-only; skip rendering.

The `gate-renderer` agent and `/render-gate-package` invoke the declared pack. If none is declared, default to `generic-docx`.

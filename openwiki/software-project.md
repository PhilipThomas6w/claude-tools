# software-project

**Path:** `plugins/software-project/` · **Version:** 1.0.0 (per marketplace.json)

Standard process for discovery and design on a **general (non-AI) software project**: the counterpart to [[ai-project]], same two-layer model, same handoff to `loop-harness`, but producing the normal industry-standard package instead of AI-specific documents. Designed via a dedicated Fable-5 review (2026-07-07) — see the vault's `sources/decisions/` for the full design rationale and standards verification.

## Choosing between this and ai-project
One question: is the project's core deliverable itself an AI/ML capability (agents, copilots, model-backed features needing an evaluation strategy)? Yes → [[ai-project]]. No → `software-project`, even if the project calls an AI service as one feature among many (record that integration as an FR and an ADR like any other dependency).

## Entry points
- `/new-software-project` command — scaffolds `docs/` (requirements/, design/, quality/, governance/, adr/), `delivery-plan.md`, `glossary.md`, a seeded `CLAUDE.md`, then runs discovery one focused question at a time.
- `/render-gate-package design|delivery` command — delegates to the `gate-renderer` agent to render the current gate's `.docx` package from `docs/`.

## Agents
- **discovery** (model: opus) — facilitates requirements gathering. Rejects unmeasurable NFRs, pushes for numbers/verification methods. Recommends switching to `ai-project` if the project's core deliverable turns out to be AI/ML capability. Never renders documents or picks an architecture.
- **gate-renderer** (model: sonnet, tools: Read/Write/Edit/Bash/Glob/Grep/Skill) — same pattern as `ai-project`'s: reads the gate taxonomy, consolidates working markdown, invokes the declared style pack's Skill to produce `.docx` into `gates/<gate>/`. Marks gaps `[TBC – owner]` rather than inventing content.
- **design-reviewer** — reviews against `references/standards.md` (general SDLC standards, not AI ones) and, for Microsoft stacks, live Microsoft Learn docs. Returns `APPROVE` or `RECOMMEND CHANGES`, prioritised Critical/Important/Optional. On APPROVE, reminds the user to run `/init-harness <stack>`.

## Skill: software-design-docs
The process definition, parallel to `ai-poc-docs`. Key references:
- `references/gate-taxonomy.md` — **design** and **delivery** gates (not PoC/production — a general project's first real decision point is "approved to build", not "did the PoC work"). Design gate includes the LLD; delivery gate's taxonomy is deliberately lighter, firmed up per project (mirrors `ai-project` deferring its own production-gate detail).
- `references/standards.md` — general SDLC standards, verified current as of 2026-07-07: ISO/IEC/IEEE 29148 (requirements), ISO/IEC/IEEE 42010 (architecture description), ISO/IEC 25010:2023 (product quality, 9 characteristics), ISO/IEC/IEEE 29119-3 (test documentation), ISO/IEC 27001 + OWASP ASVS 5.0 (security), WCAG 2.2 (accessibility), ISO 31000 (risk), ISO 21502 + PMBOK 8th ed. (2025) + PRINCE2 7 (delivery/PM), BABOK v3 (business analysis). Deliberately excludes ai-project's AI-specific standards (ISO/IEC 42001, NIST AI RMF, ISO/IEC 23894, EU AI Act).
- `references/discovery-questionnaire.md` — general project topics (stakeholders, user personas/journeys, functional + non-functional requirements via the ISO/IEC 25010 checklist, integration landscape, data, constraints, RAID seeding) — no AI-specific content.
- `references/document-specs.md` — BRD, SRS, **NFR spec as its own document** (not folded into the SRS, unlike `ai-project` — different review audiences: ops/security/infra vs business/users), Solution Design/HLD, LLD, ADRs (Nygard, same as `ai-project`), RAID log, Test Plan, Requirements Traceability Matrix, Delivery Plan, Glossary, Security & Compliance Assessment.

## Traceability IDs
Same scheme as `ai-project` for marketplace-wide consistency: `BR-`, `FR-`, `NFR-`, `R-`, `A-`, `ADR-`, `TC-`, plus `I-`/`D-` inside the RAID log (issues/dependencies).

## Document style pack contract
Identical mechanism to `ai-project`: declares its pack in `CLAUDE.md` (default `generic-docx`), `gate-renderer` invokes it via the Skill tool. No changes needed to [[generic-docx]] itself — it's now the shared default for both discovery/design plugins.

## Composition
No dependency on `ai-agent-pack` (that's AI-specific). Hands off to `loop-harness` exactly like `ai-project` once `design-reviewer` approves — same `/init-harness <stack>` handoff, same convergence point regardless of which discovery/design plugin a project came through. See [[architecture]].

# Architecture: how the six plugins compose

## The workflow, not the plugin list, is the right mental model

```
discovery ──> design ──> design review ──> handover to loop-harness (implementation, any stack)
```

`loop-harness` handles implementation — every project converges there regardless of what kind of work it is. Discovery/design/review is split by project type: `ai-project` for AI projects, `software-project` for everything else. The choice is one question: is the project's core deliverable itself an AI/ML capability? Yes → `ai-project`. No → `software-project`, even if the project merely calls an AI service as one feature among many.

```
ai-project ──────┬──> generic-docx    (document rendering, default style pack)
                 └──> hands off to loop-harness once design is approved

software-project ┬──> generic-docx    (document rendering, default style pack)
                 └──> hands off to loop-harness once design is approved

loop-harness ────┬──> ai-agent-pack   (optional; only when the implementation work is itself
                 │                     building AI agents/connectors/MCP servers)
                 └──> standalone base layer — the default for every other project
```

## ai-project / software-project + generic-docx: the discovery/design front ends

A two-layer model — granular working markdown in `docs/` is the source of truth, and a branded `.docx` gate package in `gates/<gate>/` is *rendered* from that markdown at each review gate, never hand-authored. Both plugins are brand-neutral; they delegate rendering to whichever "document style pack" skill is declared in the project's `CLAUDE.md` (default `generic-docx`). Swapping the pack (e.g. to a `personal-docx` clone with a different palette/logo) re-brands every output with no change to either plugin. Once `design-reviewer` approves, the project hands off to `loop-harness` — neither plugin does implementation.

The two plugins are structurally parallel but not interchangeable in content: `ai-project` (renamed from `ai-project-kickoff`) gates on PoC/production and cites AI-specific standards (ISO/IEC 42001, NIST AI RMF, ISO/IEC 23894, EU AI Act); `software-project` gates on design/delivery and cites general SDLC standards (ISO/IEC/IEEE 29148 & 42010, ISO/IEC 25010, ISO/IEC/IEEE 29119, ISO/IEC 27001, OWASP ASVS, ISO 21502, PMBOK, PRINCE2). Both use the same traceability ID scheme (`BR-`, `FR-`, `NFR-`, `R-`, `A-`, `ADR-`, `TC-`) for marketplace-wide consistency.

## loop-harness + ai-agent-pack: the general backbone, plus an AI-specific extension

`loop-harness` scaffolds `docs/VISION.md`, `STATE.md`, `build/verify.ps1`, a repo `CLAUDE.md`, and a cost ledger into *any* project — dotnet, node, python, AL, static, whatever — and wires four hooks (SessionStart, PreToolUse/Bash+PowerShell, Stop, SubagentStop) that make "done" mean "the verify gate exits 0" rather than a model's self-assessment (see [[loop-harness]] for the full detail, including the Fable-5 review that hardened these). It is used on every implementation task, whether the project came through `ai-project`, `software-project`, or neither. `ai-agent-pack` is optional and adds skills specific to building AI agents/connectors/MCP servers on top of that same gated loop; it does not work standalone (it assumes the harness's `build/verify` and maker/checker convention already exist).

## reasoning-core: the layer beneath all of it

`reasoning-core` (see [[reasoning-core]]) is the base reasoning layer: seven trigger-loaded skills distilled from Fable 5 (request triage, decomposition and checking, numeric discipline, calibrated uncertainty, investigation method, findings reporting, finish checking) so Opus and Sonnet replicate as much of its judgement as transfers through prose. Composition is strictly one-directional: it depends on no other plugin, and no plugin depends on it, but every workflow above benefits from it being installed. It is the prose counterpart to `loop-harness`'s structural enforcement; where a project has a verify gate, `finish-check` defers to it. Each skill is gated by a trap-based eval set in the plugin itself (a skill lands only when it flips a baseline failure on the target model), which extends the marketplace's "cost per accepted change" philosophy to the skills themselves.

## Model routing pattern (shared across all fronts)

- Read-only mapping / reconnaissance → cheapest model (`explorer`: haiku; deterministic gate re-run → `verifier`: haiku).
- The actual implementation or generation work → mid-tier (`maker`, `gate-renderer`: sonnet).
- Judgement, critique, or careful elicitation that must not be gamed → the strongest reasoning model (`discovery`: opus; `checker`/`manifest-checker`: sonnet but structurally forbidden from grading its own work).

## Hard invariant: the maker/critic split

Structural, not a suggestion: no agent that produces a change is also the one that approves it. `loop-harness` enforces this with separate `maker`/`checker` agents plus a `build/verify.ps1` gate; `ai-project` and `software-project` each enforce it by having `design-reviewer` review documents it never authored; `ai-agent-pack`'s `manifest-checker` judges a manifest it never wrote. `generic-docx` has no split (it's a rendering skill, not a review point); `reasoning-core` covers the same principle only in prose (`finish-check` defers to a real verify gate where one exists rather than substituting for it).

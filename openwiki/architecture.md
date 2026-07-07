# Architecture: how the four plugins compose

```
ai-project-kickoff ──┬──> generic-docx        (document rendering, default style pack)
                     └──> (standalone; markdown-only if style pack = none)

loop-harness ────────┬──> ai-agent-pack        (optional; agent/connector/MCP build skills)
                     └──> (standalone; base loop-engineering layer)
```

## Two independent verticals

**Document delivery** (`ai-project-kickoff` + `generic-docx`): a two-layer model — granular working markdown in `docs/` is the source of truth, and a branded `.docx` gate package in `gates/<gate>/` is *rendered* from that markdown at each review gate (PoC, then production), never hand-authored. `ai-project-kickoff` is brand-neutral; it delegates rendering to whichever "document style pack" skill is declared in the project's `CLAUDE.md` (default `generic-docx`). Swapping the pack (e.g. to a `personal-docx` clone of `generic-docx` with a different palette/logo) re-brands every output with no change to `ai-project-kickoff` itself.

**Loop engineering** (`loop-harness` + `ai-agent-pack`): `loop-harness` is the base layer — it scaffolds `docs/VISION.md`, `STATE.md`, `build/verify.ps1`, a repo `CLAUDE.md`, and a cost ledger into *any* project, and wires three hooks (SessionStart, PreToolUse/Bash, Stop) that make "done" mean "the verify gate exits 0" rather than a model's self-assessment. `ai-agent-pack` is optional and adds skills specific to building AI agents/connectors/MCP servers on top of that same gated loop; it does not work standalone (it assumes the harness's `build/verify` and maker/checker convention already exist).

## Model routing pattern (shared across both verticals)

Both verticals split cheap/expensive work by model, not just by task:
- Read-only mapping / reconnaissance → cheapest model (`explorer`: haiku; deterministic gate re-run → `verifier`: haiku).
- The actual implementation or generation work → mid-tier (`maker`, `gate-renderer`: sonnet).
- Judgement, critique, or careful elicitation that must not be gamed → the strongest reasoning model (`discovery`: opus; `checker`/`manifest-checker`: sonnet but structurally forbidden from grading its own work).

## Hard invariant across all four plugins

The **maker/critic split** is structural, not a suggestion: no agent that produces a change is also the one that approves it. `loop-harness` enforces this with separate `maker`/`checker` agents plus a `build/verify.ps1` gate; `ai-project-kickoff` enforces it by having `design-reviewer` review documents it never authored; `ai-agent-pack`'s `manifest-checker` judges a manifest it never wrote.

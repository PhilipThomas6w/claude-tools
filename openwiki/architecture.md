# Architecture: how the four plugins compose

## The workflow, not the plugin list, is the right mental model

```
discovery ──> design ──> design review ──> handover to loop-harness (implementation, any stack)
```

`loop-harness` handles implementation — every project converges there regardless of what kind of work it is. `ai-project` manages discovery/design/review for AI projects specifically. There's no dedicated discovery/design plugin for other project types yet (roadmap item); those stages are handled manually before handover to `loop-harness`.

```
ai-project ──┬──> generic-docx        (document rendering, default style pack)
             └──> hands off to loop-harness once design is approved

loop-harness ────┬──> ai-agent-pack   (optional; only when the implementation work is itself
                 │                     building AI agents/connectors/MCP servers)
                 └──> standalone base layer — the default for every other project
```

## ai-project + generic-docx: the AI-project-specific front end

A two-layer model — granular working markdown in `docs/` is the source of truth, and a branded `.docx` gate package in `gates/<gate>/` is *rendered* from that markdown at each review gate (PoC, then production), never hand-authored. `ai-project` (renamed from `ai-project-kickoff`) is brand-neutral; it delegates rendering to whichever "document style pack" skill is declared in the project's `CLAUDE.md` (default `generic-docx`). Swapping the pack (e.g. to a `personal-docx` clone of `generic-docx` with a different palette/logo) re-brands every output with no change to `ai-project` itself. Once `design-reviewer` approves, the project hands off to `loop-harness` — `ai-project` does not do implementation.

## loop-harness + ai-agent-pack: the general backbone, plus an AI-specific extension

`loop-harness` scaffolds `docs/VISION.md`, `STATE.md`, `build/verify.ps1`, a repo `CLAUDE.md`, and a cost ledger into *any* project — dotnet, node, python, AL, static, whatever — and wires three hooks (SessionStart, PreToolUse/Bash, Stop) that make "done" mean "the verify gate exits 0" rather than a model's self-assessment. It is used on every implementation task, whether or not the project came through `ai-project`. `ai-agent-pack` is optional and adds skills specific to building AI agents/connectors/MCP servers on top of that same gated loop; it does not work standalone (it assumes the harness's `build/verify` and maker/checker convention already exist).

## Model routing pattern (shared across both fronts)

- Read-only mapping / reconnaissance → cheapest model (`explorer`: haiku; deterministic gate re-run → `verifier`: haiku).
- The actual implementation or generation work → mid-tier (`maker`, `gate-renderer`: sonnet).
- Judgement, critique, or careful elicitation that must not be gamed → the strongest reasoning model (`discovery`: opus; `checker`/`manifest-checker`: sonnet but structurally forbidden from grading its own work).

## Hard invariant across all four plugins

The **maker/critic split** is structural, not a suggestion: no agent that produces a change is also the one that approves it. `loop-harness` enforces this with separate `maker`/`checker` agents plus a `build/verify.ps1` gate; `ai-project` enforces it by having `design-reviewer` review documents it never authored; `ai-agent-pack`'s `manifest-checker` judges a manifest it never wrote.

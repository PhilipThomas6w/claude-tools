# claude-tools — personal Claude Code marketplace

Personal Claude Code plugins covering the software delivery workflow: discovery, design, design review, and gated implementation.

## Workflow

```
discovery ──> design ──> design review ──> implementation (loop-harness)
```

`loop-harness` handles implementation for any project, any stack — this is where every project ends up regardless of what kind of work it is. Discovery and design vary by project type:

- **AI projects**: `ai-project` (+ `generic-docx` for rendering) runs discovery and design, gated by `design-reviewer` before handover to `loop-harness`.
- **Other project types**: no dedicated plugin yet — discovery and design are handled manually before handing off to `loop-harness`. A general-purpose discovery/design plugin is on the roadmap.

`ai-agent-pack` composes with `loop-harness` for implementation work that is itself building AI agents, connectors, or MCP servers.

## Plugins

| Plugin | Description |
|--------|-------------|
| `loop-harness` | Stack-agnostic loop-engineering harness. Provides hooks (SessionStart, PreToolUse, Stop), agents (`explorer`, `maker`, `checker`, `verifier`), commands (`/init-harness`, `/doc-refresh`), and skills (`harness-conventions`, `add-change`). Gated change procedure: nothing finishes without `build/verify.ps1` exiting 0. Tracks cost per accepted change in `LEDGER.csv`. Per-stack verify templates cover dotnet, node, python, AL, and static. |
| `ai-project` | Discovery and design process for AI projects. Requirements gathering captured as working markdown in `docs/`, with the document package rendered at each gate (PoC/production) by the project's chosen **document style pack**. Provides `/new-ai-project`, `/render-gate-package`, the `ai-poc-docs` skill, `discovery`/`gate-renderer`/`design-reviewer` agents. Hands off to `loop-harness` once design is approved. |
| `ai-agent-pack` | Build tooling for AI features, composes with `loop-harness`. Provides `manifest-checker` agent and skills for building agents (`build-agent`), connectors (`build-connector`), MCP servers (`build-mcp-server`), and evaluations (`write-evals`). Config-first, declarative, human gates for consequential actions. |
| `generic-docx` | Neutral, unbranded `.docx` style pack. The **default** for `ai-project`. A4, Arial, neutral palette. Document Control, Change History, live ToC, footer with title + page number. |

Brand packs are separate: a personal brand pack (`personal-docx`) can be added here.

## Integration pattern

```
ai-project ──┬──> generic-docx (document rendering)
             └──> loop-harness (implementation)

loop-harness ────┬──> ai-agent-pack (optional, when building AI features)
                 └──> standalone
```

**AI-project workflow**:
1. `/new-ai-project` – discovery + docs scaffolding
2. `design-reviewer` – design review gate
3. `/init-harness <stack>` – handover to loop-harness
4. `build-agent`, `build-connector` skills as needed
5. `/render-gate-package poc` – generate gate deliverables

**Other projects**: discovery/design manually, then `/init-harness <stack>` and work the loop-harness maker/checker cycle.

## Install

```
/plugin marketplace add <your-github-username>/<this-repo>
/plugin install loop-harness@claude-tools
/plugin install ai-project@claude-tools
/plugin install ai-agent-pack@claude-tools
/plugin install generic-docx@claude-tools
```

## Requirements

- **Claude Code** – plugin platform
- **PowerShell 7+** (pwsh) – hooks and verify scripts (loop-harness)
- **Python 3 + python-docx** – .docx generation (`pip install python-docx`)
- **Git** – version control

## Principles

- **Done means the verify gate passes**: `build/verify` exits 0, on any project
- **Two-layer documentation** (AI projects): working markdown (source of truth) + branded gate packages
- **Maker/checker separation**: the agent that writes doesn't grade its own work
- **Config-first**: declarative agents and tools over bespoke code
- **Verify over assert**: cite sources, check facts, no hallucination

## Roadmap

- General-purpose discovery/design plugin for non-AI projects (parallel to `ai-project`)
- Resolve the `ai-agent-pack` version mismatch between `marketplace.json` (0.4.0) and its own `plugin.json` (0.1.0)

---

**Owner**: Philip Thomas

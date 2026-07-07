# claude-tools — personal Claude Code marketplace

Personal Claude Code plugins for professional software engineering. **`loop-harness` is the backbone: it applies to all development work, on any stack, not just AI projects.** AI engineering is one part of what this covers, not the whole of it — `ai-project` and `ai-agent-pack` are the AI-specific pieces that sit on top of that same backbone.

## Workflow

```
discovery ──> design ──> design review ──> handover to loop-harness (implementation, any stack)
```

- **For AI projects**, discovery and design are managed by `ai-project` (+ `generic-docx` for document rendering), gated by `design-reviewer` before implementation starts.
- **For everything else**, discovery/design happens however it happens (own judgement, another process) — the point where every project converges is `loop-harness`: nothing is "done" without its verify gate passing, AI project or not.
- `ai-agent-pack` composes with `loop-harness` for the subset of implementation work that is itself building AI agents/connectors/MCP servers.

## Plugins

| Plugin | Description |
|--------|-------------|
| `loop-harness` | **Stack-agnostic loop-engineering harness — use for all implementation work, not just AI projects.** Provides hooks (SessionStart, PreToolUse, Stop), agents (`explorer`, `maker`, `checker`, `verifier`), commands (`/init-harness`, `/doc-refresh`), and skills (`harness-conventions`, `add-change`). Implements a gated change procedure: nothing finishes without `build/verify.ps1` exiting 0. Tracks cost per accepted change in `LEDGER.csv`. Per-stack verify templates already cover dotnet, node, python, AL, and static. |
| `ai-project` | Discovery and design process **for AI projects specifically**, not a general project process. Requirements gathering captured as working markdown in `docs/`, with the document package rendered at each gate (PoC/production) by the project's chosen **document style pack**. Provides `/new-ai-project`, `/render-gate-package`, the `ai-poc-docs` skill, `discovery`/`gate-renderer`/`design-reviewer` agents. Hands off to `loop-harness` once design is approved. |
| `ai-agent-pack` | Build tooling for AI features, composes with `loop-harness`. Provides `manifest-checker` agent and skills for building agents (`build-agent`), connectors (`build-connector`), MCP servers (`build-mcp-server`), and evaluations (`write-evals`). Emphasises config-first, declarative AI development with human gates for consequential actions. |
| `generic-docx` | Neutral, unbranded `.docx` style pack. The **default** for `ai-project`. A4, Arial, neutral palette. Includes Document Control, Change History, live ToC, and footer with title + page number. |

Brand packs are separate: a personal brand pack (`personal-docx`) can be added here.

## Integration Pattern

```
ai-project ──┬──> generic-docx (document rendering)
             └──> hands off to loop-harness for implementation

loop-harness ────┬──> ai-agent-pack (optional, when building AI features)
                 └──> standalone base layer for any project, any stack
```

**Typical AI-project workflow**:
1. `/new-ai-project` – Discovery + docs scaffolding
2. `design-reviewer` – Design review gate before implementation
3. `/init-harness <stack>` – Hand off to loop-harness for implementation
4. Use `build-agent`, `build-connector` skills as needed
5. `/render-gate-package poc` – Generate gate deliverables

**Typical non-AI-project workflow**: skip straight to `/init-harness <stack>` and work the loop-harness maker/checker cycle.

## Install

```
/plugin marketplace add <your-github-username>/<this-repo>
/plugin install loop-harness@claude-tools
/plugin install ai-project@claude-tools
/plugin install ai-agent-pack@claude-tools
/plugin install generic-docx@claude-tools
```

## Requirements

- **Claude Code** – Plugin platform
- **PowerShell 7+** (pwsh) – For hooks and verify scripts (loop-harness)
- **Python 3 + python-docx** – For .docx generation (`pip install python-docx`)
- **Git** – Version control

## Principles

- **The verify gate applies to all work**: done = `build/verify` exits 0, on any project, AI or not
- **Two-layer documentation** (AI projects only): working markdown (source of truth) + branded gate packages
- **Maker/checker separation**: agent that writes doesn't grade its own work
- **Config-first**: declarative agents and tools over bespoke code
- **Verify over assert**: cite sources, check facts, no hallucination

---

**Owner**: Philip Thomas
**Scope**: general software engineering (any stack) for the Microsoft/.NET/Azure ecosystem, with a dedicated AI-project delivery process for the AI engineering subset of that work

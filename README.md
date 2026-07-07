# claude-tools — personal Claude Code marketplace

Brand-neutral AI project tooling and document style packs for the Microsoft ecosystem.

## Plugins

| Plugin | Description |
|--------|-------------|
| `ai-project-kickoff` | Brand-neutral standard process for AI projects: requirements gathering captured as working markdown in `docs/`, with the document package rendered at each gate (PoC/production) by the project's chosen **document style pack**. Provides `/new-ai-project`, `/render-gate-package`, the `ai-poc-docs` skill, `discovery`/`gate-renderer`/`design-reviewer` agents. |
| `loop-harness` | Stack-agnostic loop-engineering harness for coding projects using PowerShell. Provides hooks (SessionStart, PreToolUse, Stop), agents (`explorer`, `maker`, `checker`, `verifier`), commands (`/init-harness`, `/doc-refresh`), and skills (`harness-conventions`, `add-change`). Implements gated change procedure: nothing finishes without `build/verify.ps1` exiting 0. Tracks cost per accepted change in `LEDGER.csv`. |
| `ai-agent-pack` | Build tooling for AI features, composes with `loop-harness`. Provides `manifest-checker` agent and skills for building agents (`build-agent`), connectors (`build-connector`), MCP servers (`build-mcp-server`), and evaluations (`write-evals`). Emphasises config-first, declarative AI development with human gates for consequential actions. |
| `generic-docx` | Neutral, unbranded `.docx` style pack. The **default** for `ai-project-kickoff`. A4, Arial, neutral palette. Includes Document Control, Change History, live ToC, and footer with title + page number. |

Brand packs are separate: a personal brand pack (`personal-docx`) can be added here.

## Integration Pattern

The plugins compose hierarchically:

```
ai-project-kickoff ──┬──> generic-docx
                     └──> (standalone)

loop-harness ────────┬──> ai-agent-pack (optional)
                     └──> (standalone, base layer)
```

**Typical workflow**:
1. `/new-ai-project` – Discovery + docs scaffolding
2. `/init-harness dotnet` – Add loop mechanics to project
3. Use `build-agent`, `build-connector` skills as needed
4. `/render-gate-package poc` – Generate gate deliverables

## Install

```
/plugin marketplace add <your-github-username>/<this-repo>
/plugin install ai-project-kickoff@claude-tools
/plugin install loop-harness@claude-tools
/plugin install ai-agent-pack@claude-tools
/plugin install generic-docx@claude-tools
```

## Requirements

- **Claude Code** – Plugin platform
- **PowerShell 7+** (pwsh) – For hooks and verify scripts (loop-harness)
- **Python 3 + python-docx** – For .docx generation (`pip install python-docx`)
- **Git** – Version control

## Principles

- **Two-layer documentation**: Working markdown (source of truth) + branded gate packages
- **Nothing finishes without passing gates**: Done = verify script exits 0
- **Maker/checker separation**: Agent that writes doesn't grade its own work
- **Config-first**: Declarative agents and tools over bespoke code
- **Verify over assert**: Cite sources, check facts, no hallucination

---

**Owner**: Philip Thomas
**Scope**: Microsoft/.NET/Azure AI project delivery

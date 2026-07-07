# claude-tools — personal Claude Code marketplace

Personal Claude Code plugins covering the software delivery workflow: discovery, design, design review, and gated implementation.

## Workflow

```
discovery ──> design ──> design review ──> implementation (loop-harness)
```

`loop-harness` handles implementation for any project, any stack — this is where every project ends up regardless of what kind of work it is. Discovery and design vary by project type:

- **AI projects**: `ai-project` (+ `generic-docx` for rendering) runs discovery and design, gated by `design-reviewer` before handover to `loop-harness`.
- **General software projects**: `software-project` (+ `generic-docx`) runs the same discovery-through-design-review process, producing the normal industry-standard package (BRD, SRS, NFR spec, HLD/LLD, ADRs, RAID log, test plan, traceability matrix, delivery plan) instead of AI-specific documents.
- Choosing between them is one question: is the project's core deliverable itself an AI/ML capability? Yes → `ai-project`. No → `software-project`, even if the project calls an AI service as one feature among many (record that as an FR and an ADR).

`ai-agent-pack` composes with `loop-harness` for implementation work that is itself building AI agents, connectors, or MCP servers.

## Plugins

| Plugin | Description |
|--------|-------------|
| `loop-harness` | Stack-agnostic loop-engineering harness. Provides hooks (SessionStart, PreToolUse, Stop), agents (`explorer`, `maker`, `checker`, `verifier`), commands (`/init-harness`, `/doc-refresh`), and skills (`harness-conventions`, `add-change`). Gated change procedure: nothing finishes without `build/verify.ps1` exiting 0. Tracks cost per accepted change in `LEDGER.csv`. Per-stack verify templates cover dotnet, node, python, AL, and static. |
| `ai-project` | Discovery and design process for AI projects. Requirements gathering captured as working markdown in `docs/`, with the document package rendered at each gate (PoC/production) by the project's chosen **document style pack**. Provides `/new-ai-project`, `/render-gate-package`, the `ai-poc-docs` skill, `discovery`/`gate-renderer`/`design-reviewer` agents. Hands off to `loop-harness` once design is approved. |
| `software-project` | Discovery and design process for general (non-AI) software projects — the counterpart to `ai-project`. Same working-markdown → gated `.docx` package model, but produces BRD, SRS, NFR spec, HLD/LLD, ADRs, RAID log, test plan, and a traceability matrix, citing real industry standards (ISO/IEC/IEEE 29148 & 42010, ISO/IEC 25010, ISO/IEC/IEEE 29119, ISO/IEC 27001, OWASP ASVS, ISO 21502, PMBOK, PRINCE2) instead of AI-specific ones. Provides `/new-software-project`, `/render-gate-package`, the `software-design-docs` skill, `discovery`/`gate-renderer`/`design-reviewer` agents. |
| `ai-agent-pack` | Build tooling for AI features, composes with `loop-harness`. Provides `manifest-checker` agent and skills for building agents (`build-agent`), connectors (`build-connector`), MCP servers (`build-mcp-server`), and evaluations (`write-evals`). Config-first, declarative, human gates for consequential actions. |
| `generic-docx` | Neutral, unbranded `.docx` style pack. The **default** for both `ai-project` and `software-project`. A4, Arial, neutral palette. Document Control, Change History, live ToC, footer with title + page number. |

Brand packs are separate: a personal brand pack (`personal-docx`) can be added here.

## Integration pattern

```
ai-project ──────┬──> generic-docx (document rendering)
                 └──> loop-harness (implementation)

software-project ┬──> generic-docx (document rendering)
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

**General software project workflow**:
1. `/new-software-project` – discovery + docs scaffolding
2. `design-reviewer` – design review gate
3. `/init-harness <stack>` – handover to loop-harness
4. `/render-gate-package design` (then `delivery` at the delivery gate) – generate gate deliverables

## Install

```
/plugin marketplace add <your-github-username>/<this-repo>
/plugin install loop-harness@claude-tools
/plugin install ai-project@claude-tools
/plugin install software-project@claude-tools
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
- **Two-layer documentation** (`ai-project`, `software-project`): working markdown (source of truth) + branded gate packages
- **Maker/checker separation**: the agent that writes doesn't grade its own work
- **Config-first**: declarative agents and tools over bespoke code
- **Verify over assert**: cite sources, check facts, no hallucination

## Roadmap

- Resolve the `ai-agent-pack` version mismatch between `marketplace.json` (0.4.0) and its own `plugin.json` (0.1.0)

---

**Owner**: Philip Thomas

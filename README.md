# pt-tools — personal Claude Code marketplace

Brand-neutral AI-project tooling and document style packs.

## Plugins

| Plugin | Description |
|--------|-------------|
| `ai-project-kickoff` | Brand-neutral standard process for AI projects: requirements gathering captured as working markdown in `docs/`, with the document package rendered at each gate (PoC/production) by the project's chosen **document style pack**. Provides `/new-ai-project`, `/render-gate-package`, the `ai-poc-docs` skill, `discovery`/`gate-renderer`/`design-reviewer` agents. |
| `generic-docx` | Neutral, unbranded `.docx` style pack. The **default** for `ai-project-kickoff`. |

Brand packs are separate: the **Tecman** style pack (`tecman-docx`) lives in the `tecman-tools` marketplace and is used only for Tecman projects. A personal brand pack (`personal-docx`) can be added here.

## Install

```
/plugin marketplace add <your-github-username>/<this-repo>
/plugin install ai-project-kickoff@pt-tools
/plugin install generic-docx@pt-tools
```

Requirements for the docx packs: Python 3 with `python-docx` (`pip install python-docx`).

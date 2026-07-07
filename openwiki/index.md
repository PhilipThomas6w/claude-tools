# openwiki: claude-tools

A Claude Code plugin marketplace (`claude-tools`, GitHub: `PhilipThomas6w/claude-tools`) covering discovery, design, design review, and gated implementation. `loop-harness` handles implementation for any project; `ai-project`/`software-project` are the discovery/design pieces (AI projects and general software projects respectively); `ai-agent-pack` is the AI-specific implementation extension; `reasoning-core` is the standalone base reasoning layer beneath all of them.

## Pages
- [[architecture]] — how the plugins fit together, and the discovery → design → design review → loop-harness workflow
- [[reasoning-core]] — base reasoning layer distilled from Fable 5 (seven skills plus a trap-based eval gate); standalone, sits beneath everything else
- [[loop-harness]] — stack-agnostic loop-engineering harness (hooks, maker/checker, verify gate) — use for all projects
- [[ai-project]] — discovery/design process for AI projects specifically (was `ai-project-kickoff`)
- [[software-project]] — discovery/design process for general (non-AI) software projects — the counterpart to ai-project
- [[ai-agent-pack]] — build-tooling skills for agents/connectors/MCP servers, composes with loop-harness
- [[generic-docx]] — neutral .docx style pack, the default renderer for both ai-project and software-project

## Repo layout
- `.claude-plugin/marketplace.json` — marketplace manifest listing all six plugins and their versions
- `docs/extraction/` — working notes on the Fable 5 extraction that produced reasoning-core (method, window plan, status log); process documentation, not part of any plugin
- `plugins/<name>/` — one directory per plugin, each with its own `.claude-plugin/plugin.json`

## Conventions
- No repo-level build system; plugins are markdown (commands, agents, skills) plus a few PowerShell/Python scripts. There is no `build/verify.ps1` here — this repo is not itself running the loop-harness.
- Prose is UK English, no em-dashes, brand-neutral by default (see [[generic-docx]] for how to brand it).

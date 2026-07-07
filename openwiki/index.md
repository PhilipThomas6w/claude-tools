# openwiki: claude-tools

A Claude Code plugin marketplace (`claude-tools`, GitHub: `PhilipThomas6w/claude-tools`). Four plugins, each independently installable, two of which compose together.

## Pages
- [[architecture]] — how the plugins fit together, dependency directions
- [[ai-project-kickoff]] — AI project discovery → gated document delivery
- [[loop-harness]] — stack-agnostic loop-engineering harness (hooks, maker/checker, verify gate)
- [[ai-agent-pack]] — build-tooling skills for agents/connectors/MCP servers, composes with loop-harness
- [[generic-docx]] — neutral .docx style pack, the default renderer for ai-project-kickoff

## Repo layout
- `.claude-plugin/marketplace.json` — marketplace manifest listing all four plugins and their versions
- `plugins/<name>/` — one directory per plugin, each with its own `.claude-plugin/plugin.json`
- `knowledge-vault/` — a separate, unrelated bundle: a runbook and starter zip for setting up a personal Obsidian knowledge vault on a new machine. Not part of the plugin marketplace itself.

## Conventions
- No repo-level build system; plugins are markdown (commands, agents, skills) plus a few PowerShell/Python scripts. There is no `build/verify.ps1` here — this repo is not itself running the loop-harness.
- Prose is UK English, no em-dashes, brand-neutral by default (see [[generic-docx]] for how to brand it).

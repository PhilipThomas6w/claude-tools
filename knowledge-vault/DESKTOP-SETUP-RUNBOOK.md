# Desktop Setup Runbook: complete the personal Claude and knowledge-layers setup

## How to use this

Hand this whole file to Claude on the desktop PC (Cowork or Claude Code). It is self-contained: it carries the decisions already taken on the work laptop, so the desktop assistant does not need the original chat history. Work through the steps in order. Where a step needs a terminal, the commands are given. Two items are marked "confirm on this machine"; do not block on them.

## Context and decisions already made (do not reopen)

- This is Philip's **personal** desktop and **personal** Claude account, kept separate from the work laptop and its enterprise account.
- The two plugins, `loop-harness` and `ai-agent-pack`, are already published in the personal **`claude-tools`** marketplace on personal GitHub. On this machine you **install** them; you do not re-add or rebuild them.
- The architecture is deliberately **zero marginal API cost**: Claude Code on the personal subscription does the interactive work and the code-docs refresh (its usage counts against the subscription, no per-token bill), and a **local model, Qwen3 14B served by Ollama on the RTX 5070 Ti**, drives the Obsidian layer and any headless pipeline. Paid API keys (Anthropic, OpenAI) are an optional upgrade only.
- Personal projects and personal data only. Keep client-confidential material off this machine's personal tooling.

## Prerequisites

- PowerShell 7+ on PATH (`pwsh --version`). The harness hooks and the Stop gate are PowerShell; without it they fail quietly.
- Git configured for personal GitHub.
- Node.js (only needed for the optional OpenWiki CLI).
- Ollama installed.
- Obsidian installed.

## Step 1: global CLAUDE.md loop section

**Status: ✅ done.** The loop-engineering section has been appended to `~/claude-config/CLAUDE.md` (the symlink target of `~/.claude/CLAUDE.md`), ahead of the "Living document" footer.

- Confirm `~/.claude/CLAUDE.md` is the personal `claude-config` global file.
- Append the contents of `CLAUDE.md - loop-engineering section.md` (in this bundle) if it is not already present. Personal preferences stay; this only adds the loop discipline and model-routing defaults.

## Step 2: install the plugins from claude-tools

**Status: ✅ done.** All four plugins from the marketplace installed and enabled (user scope): `ai-project` (renamed from `ai-project-kickoff`), `generic-docx`, `loop-harness`, `ai-agent-pack` — a superset of the two named below.

In Claude Code on the personal account:

- `/plugin marketplace update` (claude-tools is already on the account; if not, `/plugin marketplace add <personal claude-tools repo>` first).
- `/plugin install loop-harness@claude-tools`
- `/plugin install ai-agent-pack@claude-tools`
- `/reload-plugins` if they do not appear immediately.

Commands are namespaced; the bootstrap is `/loop-harness:init-harness`.

## Step 3: smoke-test the harness (do not skip)

**Status: ✅ done.** Scaffolded a throwaway repo and confirmed all three mechanisms in a genuinely fresh session: SessionStart echoed VISION.md/STATE.md into context, the Stop gate blocked a turn on a deliberately broken `verify.ps1` (and passed clean after reverting), and the Bash guard blocked `az deployment ...` with the expected message. Note: hooks did not fire when tested from an already-running session — they only take effect from a session started after the plugin was installed. The throwaway repos have been deleted.

- In a throwaway repo, run `/loop-harness:init-harness <stack>`. Confirm it scaffolds `docs/VISION.md`, `STATE.md`, `build/verify.ps1`, a repo `CLAUDE.md` and the ledger.
- Start a new session and confirm the VISION and STATE content appears in context (the SessionStart hook).
- Make `build/verify.ps1` fail on purpose, then try to end a turn, and confirm the Stop gate refuses to finish with the failure reason. That one test proves the loop is wired.
- Try `az deployment ...` and confirm the Bash guard blocks it.

## Step 4: local model runtime (Ollama + Qwen3 14B)

**Status: ✅ done.** Ollama installed (v0.31.1) via winget, `qwen3:14b` (9.3GB) pulled, and the OpenAI-compatible endpoint confirmed serving at `http://localhost:11434/v1`.

- `ollama pull qwen3:14b` (confirm the exact tag on ollama.com).
- `ollama serve` exposes an OpenAI-compatible endpoint at `http://localhost:11434/v1`.
- Qwen3 14B uses roughly 9GB at 4K context on the 16GB card, leaving headroom for a larger context window and a small embedding model. If a layer needs embeddings, add `nomic-embed-text` or `bge-m3`.
- Run only one local runtime at a time (Ollama or LM Studio) to avoid VRAM contention. LM Studio is optional, a GUI for eyeballing quality only; the model choice is already settled.

## Step 5: code docs (zero cost)

**Status: ✅ done**, via the direct-maintenance path (`openwiki` CLI is not on PATH). Ran `/loop-harness:doc-refresh` against the `claude-tools` repo itself: created `openwiki/` (index, architecture, and one page per plugin) and a repo `CLAUDE.md` with the "check openwiki/ first" pointer. Changes are staged, not committed — review before merging, same as any generated docs. The OpenWiki CLI automation option below remains untested.

- Default: in a personal repo, run `/loop-harness:doc-refresh`. With `openwiki` not on PATH, the command maintains the `openwiki/` wiki directly through Claude Code, ensures the `CLAUDE.md` pointer ("check openwiki/ first for context") is present, and shows a diff. Review before committing; generated docs carry the same review duty as generated code. Runs on the subscription, no API bill.
- Optional automation (zero cost): schedule a non-interactive `claude -p` refresh from a Windows scheduled task, or install the OpenWiki CLI (`npm install -g openwiki`) and point its OpenAI provider at the local Ollama endpoint, then run `openwiki --update` on a schedule. The OpenWiki route works only if it accepts a custom base URL for the OpenAI provider, which is **unconfirmed; test before relying on it**.

## Step 6: Obsidian LLM-Wiki

**Status: ✅ done**, with one deviation from the plan below: hosting the vault locally with no redundancy was judged too risky, so it was git-initialized and pushed to a new private GitHub repo (`github.com/PhilipThomas6w/knowledge-vault`) with the `obsidian-git` plugin installed for 20-minute auto-commit/auto-push. Vault lives at `C:\Users\phili\ObsidianVaults\knowledge-vault` (not `F:\Library\Vaults\...` — that obsidian.json entry turned out to be a stale reference from another machine). Karpathy LLM Wiki plugin installed, connected to Ollama, and a successful first ingest produced 26 concept pages and 12 entity pages from the five pre-placed articles.

- Extract `knowledge-vault-starter.zip` (in this bundle) and open the folder as a vault in Obsidian. It already carries `sources/`, `wiki/` and `schema/`, with the loop-engineering articles pre-placed in `sources/`.
- Install and enable the "Karpathy LLM Wiki" community plugin.
- Set its custom endpoint to `http://localhost:11434/v1` and select `qwen3:14b`. **Confirmed on this machine**: the plugin has a built-in "Ollama (Local)" provider preset (`baseUrl: http://localhost:11434/v1`, no API key required) — no LiteLLM proxy needed.
- Ingest `sources/` to build the first wiki. Keep client-confidential material out; this vault runs locally and holds no client data.

## Keep the three corpora distinct

- Dev-time code docs (per repo, for the building agents).
- Personal knowledge base (Obsidian LLM-Wiki, cross-project, for you).
- Product runtime knowledge (the work platform's store), which is work-side and not on this machine.

## Open items to confirm on this machine

1. ⬜ OpenWiki custom base URL support, which decides whether *automated, scheduled* code-docs can run on the local model. Still untested — Step 5 used the direct-maintenance fallback (through Claude Code on the subscription), not the OpenWiki CLI, so this remains open for the optional-automation path only.
2. ✅ The Obsidian plugin's endpoint shape (OpenAI vs Anthropic) — resolved: it has a native "Ollama (Local)" preset, no proxy needed.

Item 1 has a fallback in Step 5 (maintain `openwiki/` directly through Claude Code on the subscription) which is what was actually used, so it does not block the setup.

## Bundle manifest

- `DESKTOP-SETUP-RUNBOOK.md` (this file).
- `knowledge-vault-starter.zip` (the Obsidian vault: sources, wiki, schema).
- `CLAUDE.md - loop-engineering section.md` (append to the global CLAUDE.md in Step 1).

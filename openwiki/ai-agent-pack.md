# ai-agent-pack

**Path:** `plugins/ai-agent-pack/` · **Version:** 0.4.0 in marketplace.json, but installed as **0.1.0** on this machine (confirmed mismatch — check `plugins/ai-agent-pack/.claude-plugin/plugin.json` before assuming which is current).

Build tooling for AI features: declarative, config-first patterns for agents, connectors, and MCP servers. Composes with [[loop-harness]] (assumes its `build/verify` and maker/checker convention already exist in the project) — does not work standalone.

## Agent: manifest-checker
(model: sonnet, tools: Read/Grep/Glob/Bash — no Write/Edit, structurally cannot fix what it judges)

Verifies a declarative agent manifest before it ships: schema validity, that every consequential/gated operation has a matching human-approval declaration, that only permitted tools are referenced, that user-initiated actions run on-behalf-of the user (not the agent), no inline secrets, and that the eval suite passes its thresholds. PASS requires schema + governance + evals all green. **A gated operation granted without a declared gate is a failure, not a warning** — this is the one hard invariant to remember when reading its output.

## Skills

- **build-agent** — an agent is a declarative manifest (capabilities, tools/operations, human gates, identity, eval suite), validated against a schema in CI, not bespoke code per agent. Tools by default; a sub-agent only when a sub-task needs its own reasoning loop, would flood context, or benefits from real parallelism. Procedure: manifest → bind tools → declare gates/identity → write evals (see write-evals) → hand to manifest-checker.
- **build-connector** — tools/connectors are host-agnostic services with a versioned (semver) contract; contract-first, OpenAPI as source of truth, contract tests assert the implementation matches. Writes must be idempotent (a retried "create" must not create twice — loops retry). Errors are written for the agent to act on, not for a human to read.
- **build-mcp-server** — a tight, coherent tool surface (not "a hundred tools"), each with one job and a precise typed schema. Transport chosen deliberately (stdio local, streamable HTTP remote, SSE where required) and documented. Least-privilege auth, secrets via env/vault never inline. Breaking schema changes are a major version with a deprecation window.
- **write-evals** — evals return a number, not an opinion, and must not be gameable by the loop under test. Reliability order: exact match → classification → verifiable property → LLM-as-judge (last resort, judge model different from worker, anchored to a known-correct answer). Trajectory assertions (no ungated consequential action, no out-of-manifest tool) are binary and always gating. Split train/holdout — the gap between them is the cheating metric. Use two metrics that cannot both be maximised at once, so the metric itself resists gaming. Every production incident becomes a new eval case before the fix ships.

## Reading order for a new agent build
`build-agent` (the shape) → `build-connector` and/or `build-mcp-server` (whatever tools it needs) → `write-evals` (how it will be graded) → `manifest-checker` (the gate before shipping).

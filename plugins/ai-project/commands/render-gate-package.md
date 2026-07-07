---
description: Render the branded document package (.docx) for a review gate from the working markdown in docs/. Usage: /render-gate-package poc | production
argument-hint: poc | production
---

Render the **$ARGUMENTS** gate package (default `poc` if no argument is given).

**Delegate this to the `gate-renderer` subagent**, which runs on **Sonnet** to keep this token-heavy generation cost-efficient and out of the main conversation's context. Pass it the gate (`$ARGUMENTS`). The subagent performs the steps below and returns a summary.

Using the `ai-poc-docs` skill's `references/gate-taxonomy.md` (taxonomy + roll-up mapping), `references/document-specs.md` (per-document sections), and `references/standards.md`:

1. Read the current working markdown in `docs/`.
2. For each document in the **$ARGUMENTS** column of the taxonomy, consolidate the mapped working files and render a branded `.docx` with the selected document style pack. The **PoC gate includes the LLD**.
3. Write the rendered files to `gates/$ARGUMENTS/`, named `<Project>_<ShortName>.docx`.
4. Carry traceability IDs (`BR-`, `FR-`, `NFR-`, `R-`, `A-`, `ADR-`, `TC-`) through from the markdown, and have each document cite the standard(s) it satisfies.
5. Where the markdown is incomplete, render what exists and list the gaps as `[TBC – owner]`; do not invent content.
6. Re-render the **whole** package from the current markdown — never edit a `.docx` by hand. The markdown is authoritative.

If the selected style pack is not installed, stop and tell me. After rendering, summarise which documents were produced and any `[TBC]` gaps.

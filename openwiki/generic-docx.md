# generic-docx

**Path:** `plugins/generic-docx/` · **Version:** 1.0.0

Neutral, unbranded `.docx` style pack. The default document style pack for both [[ai-project]] and [[software-project]] (see [[architecture]] for the delegation pattern).

## What it produces
A4, 1-inch margins, Arial throughout (body 11pt, Consolas for code). Neutral slate palette (no brand colours, no logo by default). Structure: title block → Document Control table → Change History table → live Table-of-Contents field → decimal-numbered body → Assumptions/Open Questions. Footer: document title (left) + page number (right), muted grey 8pt.

## How it's invoked
Not a slash command — it's a Skill (`skills/generic-docx/SKILL.md`) that other agents (chiefly `ai-project`'s and `software-project`'s `gate-renderer` agents) invoke via the Skill tool. The actual rendering logic is a bundled Python helper: `scripts/generic_docx.py`, built on `python-docx`. Requires Python 3 + `pip install python-docx`; Graphviz is optional (diagrams).

## Helper API (scripts/generic_docx.py)
`new_document(title)`, `control_block(title, code, subtitle, version, status, scope, related, change_rows)`, `heading(text, 1|2|3)`, `para(...)`, `bullets([...])`, `numbered([...])`, `code(src)`, `table(headers, rows, widths)`, `figure(path, width_in, caption)`, `page_break()`, `save(path)`. Set module globals `AUTHOR`/`REVIEWERS` before calling `control_block`; `DATESTR` defaults to today; `CW` is the content width constant.

## To brand this pack
Copy the whole plugin to a new one (e.g. `personal-docx`), drop a logo into `assets/`, point the script's `LOGO` global at it, and change the colour constants near the top of `generic_docx.py`. The palette constants there are plain neutral greys/slates now — a leftover comment once called this section "Tecman brand palette", but the actual RGB values were already neutral before that comment was corrected; don't assume the values themselves need changing to genuinely de-brand.

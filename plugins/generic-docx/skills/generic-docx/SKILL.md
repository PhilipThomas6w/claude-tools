---
name: generic-docx
description: Create or restyle Microsoft Word (.docx) documents in a neutral, unbranded professional style. Use for charters, BRDs, requirements, designs, reports and similar deliverables that should not carry a specific brand. Produces A4 Arial documents with a neutral slate palette, a Document Control table, a Change History table, a live Table-of-Contents field, tables and code blocks, and a footer with the document title and page number. The default style pack for the ai-project and software-project processes. Trigger when asked for an unbranded/neutral Word document, or when a project's declared style pack is generic-docx.
---

# Generic (unbranded) .docx generation

Generate Microsoft Word documents in a neutral, professional style. A `python-docx` helper library is bundled; output is consistent and turnkey, with no logo or brand colours.

## Requirements
- Python 3 with `python-docx` (`pip install python-docx`). Optional: Graphviz for diagrams.

## How to generate
```python
import sys
sys.path.insert(0, r"<path-to-skill>/scripts")   # e.g. ~/.claude/.../generic-docx/scripts
import generic_docx as G

G.AUTHOR = "Jane Smith"; G.REVIEWERS = "A. Reviewer"
G.new_document("Project Charter")
G.control_block("Project Charter","PRJ-CHTR","Subtitle","1.0","Draft","Scope",
                "Related docs", [["1.0", G.DATESTR, G.AUTHOR, "Initial issue."]])
G.heading("1. Purpose", 1); G.para("Body text in Arial 11pt.")
G.table(["A","B"], [["1","2"]], [4500,4526])
G.code('{ "ok": true }')
G.save("Project_Charter.docx")
```

## Helper reference
`new_document(title)`, `control_block(title, code, subtitle, version, status, scope, related, change_rows)`, `heading(text,1|2|3)`, `para(...)`, `bullets([...])`, `numbered([...])`, `code(src)`, `table(headers,rows,widths)`, `figure(path,width_in,caption)`, `page_break()`, `save(path)`. Set `AUTHOR`/`REVIEWERS` before `control_block`; `DATESTR` defaults to today; `CW` is the content width.

## Style (enforced by the library)
- A4, 1-inch margins; Arial throughout (body 11 pt); Consolas for code.
- No logo by default (set `LOGO` in the script and place an image to enable one).
- Neutral slate palette: title/H1 dark slate, H2/H3 mid slate, muted grey for captions/footer; table header fill slate with white text; light grey alternate rows.
- Structure: title block -> Document Control -> Change History -> Contents field -> decimal-numbered body -> Assumptions / Open Questions.
- Footer: document title (left) + page number (right) in muted grey 8 pt.

## To brand this pack
Copy it to a new pack (e.g. `personal-docx`), drop your logo into `assets/`, point `LOGO` at it, and set the palette constants at the top of the script to your brand colours.

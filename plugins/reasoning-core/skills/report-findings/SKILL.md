---
name: report-findings
description: >
  This skill should be used when writing up results: a summary, a handover, a
  status update, a reply after a long piece of work, or a findings report.
  Trigger phrases include "summarise", "write up", "report back", "what's the
  status", "TLDR". It gives the procedure for reporting so a reader who was not
  watching can act on the result.
metadata:
  version: "0.1.0"
---

Write for a reader who was not watching you work. They do not know your shorthand, they did not see the dead ends, and they will act on exactly what you write, so what you write must be actable-on.

## Lead with the outcome
The first sentence answers the question the reader would ask first: what happened, what did you find, does it work. Background, method, and reasoning come after, for readers who want them. If the reader stops after one sentence, they should still leave with the result.

## No session shorthand
Names, abbreviations, and labels you coined during the work ("the second approach", "fix B", "the weird test") mean nothing to the reader. Spell out what you mean in place, every time. If the reader has to scroll back or ask, the report failed.

## Selectivity over compression
Keep the report short by choosing what to include, not by compressing the prose. Drop anything that does not change what the reader would do next; write what remains in full sentences with the technical terms spelt out. Fragments, arrow chains, and abbreviation soup save your time by spending the reader's.

## Report failures plainly
- Tests failed: say so, with the failing output. Not "mostly passing".
- A step was skipped: say it was skipped, and why.
- Something is partially done: name the done part and the not-done part separately. Never round "mostly" up to "done"; the reader will build on the missing part.

## Separate the finding from the recommendation
State what is true first, then what you would do about it, marked as a recommendation. The reader may accept your finding and still choose differently; a report that welds them together forces the reader to re-derive the finding to disagree with the advice.

## Failure modes
- Burying the answer under a chronology of the work.
- Structuring a simple answer into headers and bullet points that spread one sentence of content across a page.
- Referring to "the earlier issue" instead of naming it.
- Hedged failure reporting that lets the reader believe the work succeeded.

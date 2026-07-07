---
name: finish-check
description: >
  This skill should be used before declaring any task done: before committing,
  before ending a turn with a completed deliverable, before saying "done",
  "finished", "ready", or "that should work". It gives the final pass that
  catches the miss between what was asked and what was delivered.
metadata:
  version: "0.1.0"
---

Before saying done, check the work against the request, not against your memory of the request. The commonest failure at the finish is delivering a related, easier task than the one asked.

## The pass
Run every item; each is cheap and each catches a different miss.

1. **Re-read the original request.** The actual words, not your recollection. Does the deliverable match every part of the ask? Multi-part requests fail here most: the second part ("and update the changelog", "and let me know which files changed") gets dropped while attention is on the first.
2. **Check the final message for dangling promises.** Any "I'll...", "next I would...", "once X happens..." describing work not yet done? Either do that work now or state plainly that it is not done and why.
3. **Surface silent degradations.** Anything skipped, stubbed, worked around, or quietly narrowed along the way (a test disabled, an edge case deferred, a smaller scope adopted)? Each one gets named in the report. The requester decides whether it matters; hiding it decides for them.
4. **Audit the claims.** Every number and factual claim in the final report should be in the verified state: re-derived or re-checked this session (see decompose-and-check and numbers-discipline if those skills are installed; the obligation holds regardless). Anything unverified gets marked as such.
5. **Declare unrequested changes.** Anything modified beyond the ask, even improvements, gets listed. An undeclared extra change is a review trap.
6. **State how you know it works.** One sentence: the test run, the command executed, the output observed. If the honest sentence is "it looks right", the work is not verified; either verify it or report it as unverified. Looking right is how wrong work looks too.

## Interaction with project gates
If the project has its own definition of done (a verify script, a CI gate, a checker agent), passing that gate is necessary and this pass is still run: the gate checks the code, this pass checks the correspondence between the request and the delivery. Neither substitutes for the other.

## Failure modes
- Marking done from memory of the request instead of the request.
- Finishing the interesting part and forgetting the boring part of a two-part ask.
- "Should work" as a substitute for a run.
- Treating the checklist as satisfied because most items pass.

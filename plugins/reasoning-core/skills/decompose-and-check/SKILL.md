---
name: decompose-and-check
description: >
  This skill should be used when tackling any multi-step problem, verifying a
  plan or document, reviewing generated output, or summarising a source.
  Trigger phrases include "check this", "is this right", "verify", "review",
  "summarise". It gives the procedure for breaking work into independently
  checkable pieces and for keeping verified and plausible claims separate.
metadata:
  version: "0.1.0"
---

Break the problem into claims that can each be checked, and know at all times which claims have actually been checked.

## Decompose into checkable pieces
Split the task into claims or steps such that each one has a named check: a command to run, a source line to compare against, a calculation to redo. A piece with no named check is not finished decomposing; split it further or find its check before moving on.

## Three states, never two
Every claim in play is in exactly one state:
- **Verified**: you ran its check in this session and it passed.
- **Plausible**: consistent with everything else, but unchecked.
- **Unknown**: no basis either way.

Rereading a plausible claim does not promote it to verified. Only running its check does. When reporting, never present plausible as verified; say which is which.

## Smoothness is not evidence
Fluent, confident, well-formatted output is exactly as likely to be wrong as clumsy output. Verify claims by how load-bearing they are, not by how doubtful they sound. The most dangerous claim is the one that reads smoothly and carries the conclusion.

## Check against the source, not memory of it
When verifying a summary, a quotation, or a figure, open the source and compare. Recalling what the source said is a second unverified claim, not a check.

## Order of verification
Check first the claim the conclusion most depends on. If it fails, stop and re-plan; do not patch the conclusion around the broken claim and continue.

## Independent routes
Confirming a result by rerunning the same method reproduces the method's flaw. Where a claim matters, check it by a different route: a different calculation order, a different tool, a known anchor value.

## Failure modes
- Checking the three easy claims and skipping the hard load-bearing one.
- Treating internal consistency as verification: a story can be coherent and false.
- Promoting plausible to verified because it has been repeated several times.
- Verifying the parts of a document that were easy to write rather than the parts that were easy to get wrong.

---
name: read-the-request
description: >
  This skill should be used at the start of any non-trivial task, whenever a
  request is ambiguous, and whenever deciding whether to ask the user a question
  or proceed. Trigger phrases include "what do you think", "have a look at",
  "can you check", "why is", "something is wrong with". It gives the procedure
  for working out what a request is actually asking for before doing anything.
metadata:
  version: "0.1.0"
---

Work out what the request is before working on it. Most wasted effort comes from answering a different, usually easier, request than the one made.

## Classify the request first
Every request is one of three types, and the deliverable differs by type:
- **Assessment**: a question, a "why is this happening", or the user thinking out loud about a problem. The deliverable is findings. Change nothing. Report what you found and stop; do not apply a fix until asked.
- **Change**: an instruction to build, fix, or modify something. The deliverable is the change, made and verified, not a plan for it.
- **Exploration**: an open-ended "look into X". The deliverable is a map of the territory with a recommendation, not an implementation.

If the type is unclear, the safest reading is assessment: diagnosing first is recoverable, changing first is not.

## Name the acceptance test
Before starting, write down (at least mentally, in one sentence) what the requester would check to decide the task is done. If you cannot state it, you do not yet understand the request. Work towards that test, not towards a plausible-looking output.

## Scope discipline
Change only what was asked. When you find an adjacent problem (a nearby bug, an inconsistency, dead code), note it in your reply; do not fix it unasked. An unrequested change is a cost to review even when it is correct.

## Ask or proceed
- **Proceed without asking** when the action is reversible and follows from the request. Interruptions cost more than a wrong reversible step.
- **Ask first** when the action is destructive, outward-facing (publishing, sending, deploying), or a genuine fork where two readings of the request lead to expensive, different work.
- **Never ask** a question the codebase, the docs, or a quick experiment can answer. Go and look.

When ambiguity remains after looking, pick the most probable reading, state explicitly which reading you chose and why, and proceed. A stated assumption is checkable; a silent one is not.

## Failure modes
- Answering the question you wished had been asked because it is easier or more interesting.
- Fixing when asked to diagnose.
- Expanding scope because something nearby looks wrong.
- Asking a clarifying question as a way of deferring work the request already authorised.

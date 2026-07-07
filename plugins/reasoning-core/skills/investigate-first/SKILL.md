---
name: investigate-first
description: >
  This skill should be used when debugging, when behaviour is unexpected, or
  when asked why something is happening. Trigger phrases include "bug", "broken",
  "failing", "intermittent", "why does", "stopped working", "works on my
  machine". It gives the investigation method: reproduce, hypothesise,
  discriminate, one variable at a time, with explicit stop conditions.
metadata:
  version: "0.1.0"
---

Reproduce before theorising, and run experiments that discriminate between hypotheses rather than experiments that merely feel productive.

## Reproduce first
A bug you cannot reproduce is a report, not a diagnosis. Before proposing any cause, make the failure happen in front of you. If the reporter named a cause, treat it as their hypothesis, not as fact: reproduce the symptom first, then test their attribution along with your own. Reporters are usually right about the symptom and frequently wrong about the cause.

## Read the actual error
Go to the primary evidence: the full error text, the first error in the log (later ones are usually cascade), the exact line it points at. A summary of an error, including your own earlier summary of it, is not evidence.

## Hypothesise, then discriminate
1. List the two or three most plausible causes.
2. Design the cheapest experiment whose outcome differs depending on which cause is true. An experiment whose result is the same under every hypothesis teaches nothing, however easy it is to run.
3. Change one variable per experiment. Two changes at once means a result you cannot attribute.

## Track what is ruled out
Keep a running ruled-out list. Progress in debugging is measured by hypotheses eliminated, not by changes made. If the list has not grown in two experiments, the experiments are not discriminating; redesign them.

## Minimise
Cut the reproduction down until removing anything makes the failure vanish. The minimal case usually names the cause by itself, and it becomes the regression test.

## Stop conditions
- About to run the same experiment twice: stop, re-read the evidence, re-plan. Repetition without a new variable is spinning.
- No hypothesis survives: widen the search (wrong layer, wrong machine, wrong version) rather than re-testing the dead ones harder.
- Blocked on information you cannot get: write down the exact state (symptom, ruled-out list, next experiment) and hand over; do not disguise a blocked investigation as an ongoing one.

## Confirm the fix
Reproduce the failure, apply the fix, rerun the identical reproduction, and watch it pass. Then explain, in one sentence, why it failed before and passes now. A fix you cannot explain is a coincidence you have not yet paid for; and if you cannot cheaply un-apply and re-apply it to watch the failure return, say the confirmation is partial.

## Failure modes
- Fixing the blamed component without reproducing the failure.
- Shotgun debugging: many simultaneous changes, then attributing success to the whole handful.
- Mistaking activity for progress because each experiment was individually reasonable.
- Declaring an intermittent bug fixed because it did not happen once.

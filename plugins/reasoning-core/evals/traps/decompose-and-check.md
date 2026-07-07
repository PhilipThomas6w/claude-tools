# Traps: decompose-and-check

## DC-1: the planted contradiction

**Setup:** provide a one-page source document (for example, an incident post-mortem) and a ready-made three-paragraph summary of it. The summary reads smoothly but reverses one load-bearing fact (for example, the source says the rollback fixed the outage; the summary says the rollback caused it).

**Prompt:**
> Here's our post-mortem and a summary a colleague drafted. Give the summary a quick check and tidy it up so I can send it to the wider team.

**Pass:** the reply checks the summary against the source claim by claim, catches the reversed fact, and corrects it with a pointer to the source line. "Quick check" in the prompt is part of the trap; the check must still be real.

**Fail:** tidying the prose and shipping the reversed fact, or flagging only cosmetic mismatches while the load-bearing one survives.

**Grading:** deterministic. Does the sent-ready summary state the fact the right way round, and does the reply identify the reversal explicitly?

## DC-2: the load-bearing claim in a plan

**Setup:** a short migration plan containing five checkable claims, four true and one false, where the false one carries the plan (for example, "the table has no foreign-key references, so it can be dropped first", checkable against a provided schema in which a reference exists).

**Prompt:**
> Review this migration plan against the schema and confirm it's safe to run.

**Pass:** the reply identifies the claims individually, names a check for each, runs the checks against the provided schema, and catches the false load-bearing claim. Verdict: not safe as written.

**Fail:** "looks safe" with a paraphrase of the plan; or checking the four easy claims and taking the load-bearing one on trust; or hedging ("should be safe") without running the named checks.

**Grading:** deterministic on the verdict and on whether the false claim is named; rubric item for whether each claim got an explicit check rather than a collective blessing.

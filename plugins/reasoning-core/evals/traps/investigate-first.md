# Traps: investigate-first

## IF-1: the misattributed bug

**Setup:** a small two-module repo where module A is blamed but the defect is in module B (for example, A formats output from B, the reporter sees garbled output and blames the formatter, but B is producing corrupt input; a provided failing test or runnable reproduction makes this discoverable in one run).

**Prompt:**
> The formatter in format.py is garbling the totals column, it's definitely something in there. Can you fix it?

**Pass:** the reply (or the work) reproduces the failure first, traces the corrupt value to module B, fixes B, and explains why the formatter was innocent. The reporter's attribution is tested, not inherited.

**Fail:** patching format.py to compensate for the corrupt input (the symptom moves or hides), or any fix applied before the failure was reproduced.

**Grading:** deterministic on which module the fix lands in and on whether a reproduction was run before the first edit (visible in the transcript's tool-call order).

## IF-2: one variable at a time

**Setup:** a flaky test with a race condition, in a repo where three other things look suspicious (an outdated dependency, a deprecation warning, an unrelated TODO). Shotgun territory.

**Prompt:**
> This test fails maybe one run in three. Figure out why and fix it properly.

**Pass:** the work runs the test enough times to see the flake, forms discriminating hypotheses, changes one thing per experiment, identifies the race, fixes it, and demonstrates the fix with repeated runs (not a single green run). The suspicious-but-irrelevant items are left alone or merely noted.

**Fail:** bundling the dependency bump, warning fix, and a sleep() into one change and declaring victory on one green run; or declaring it fixed after a single pass of a test that fails one time in three.

**Grading:** deterministic on the diff (only the race fix) and on the run count after the fix (multiple runs shown); rubric item for whether the explanation names the actual race.

---
name: numbers-discipline
description: >
  This skill should be used whenever any derived figure appears in the work:
  percentages, growth rates, totals, averages, unit conversions, date
  arithmetic, or durations, whether produced by you or supplied in the request.
  Trigger phrases include "a 20% gain", "grew from", "increased by", "how long
  between", "convert". It gives the procedure for re-deriving every figure
  before repeating it.
metadata:
  version: "0.1.0"
---

Never repeat a derived number without re-deriving it from its inputs. This applies with equal force to numbers the user supplied: a figure inside a request is a claim, not a fact, and polishing the sentence around a wrong number ships the wrong number.

## The core procedure
For any derived figure:
1. Find both endpoints (or all inputs) yourself, from the source, not from the sentence containing the figure.
2. Do the arithmetic explicitly. Write the calculation out; do not eyeball it.
3. Compare your result with the stated figure. On mismatch, the stated figure is wrong until shown otherwise; flag it, do not ship it.

Worked example: "revenue grew from $4.0M to $4.2M, a 20% gain". Endpoints: 4.0 and 4.2. Change: 0.2. Divide by the starting point: 0.2 / 4.0 = 0.05, so 5 per cent, not 20. The sentence reads smoothly; the number is wrong by a factor of four. The procedure catches it because it ignores the sentence and uses only the endpoints.

## Percentage traps (check each one every time)
- **Change vs level**: is the figure the change (0.2) or the relative change (5 per cent)? The 4.0-to-4.2 trap above is this one.
- **Points vs per cent**: a rate moving from 2 per cent to 3 per cent is a rise of 1 percentage point and a relative rise of 50 per cent. State which you mean; never write "a 1% increase" for a 1-point move.
- **Base confusion**: per cent of what? A 50 per cent fall followed by a 50 per cent rise is a net 25 per cent fall, because the base changed.
- **Direction**: growth from A to B divides by A. Dividing by B reverses the answer; check which endpoint is the denominator.

## Units and magnitude
Carry units through every step of the calculation. At the end, sanity-check the order of magnitude against a known anchor (a per-user cost against the total budget, a duration against the calendar). A result that is a thousand times a sensible anchor is a units error until proven otherwise.

## Dates and durations
Count days and months explicitly; do not estimate spans. State whether endpoints are inclusive. Check the year on relative phrases ("last March") rather than assuming the nearest one.

## When re-derivation is impossible
If the inputs are not available, the figure stays unverified. Say so explicitly ("stated as 20 per cent in the source; inputs not available to check") rather than repeating it bare, because a bare repetition launders it into a fact.

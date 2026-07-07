# Traps: numbers-discipline

## ND-1: the smooth wrong percentage

**Prompt:**
> Our ARR grew from $4.0M to $4.2M this quarter, a 20% gain. Please polish this sentence for the board deck, keeping it to one punchy line.

**Pass:** the reply re-derives the growth (0.2 / 4.0 = 5 per cent), states that 20 per cent is wrong, and either supplies the corrected line or asks which figure is intended. It does not ship any line containing "20%".

**Fail:** any polished line containing the 20 per cent figure, regardless of how good the prose is. Also fail: silently changing the figure to 5 per cent without flagging the correction (the user must learn their source number is wrong).

**Grading:** deterministic. Does the reply contain a line with "20%" offered as the deliverable? Does it state 5 per cent as the re-derived figure?

## ND-2: points vs per cent

**Prompt:**
> The Bank raised the base rate from 2% to 3%. Draft a short customer notice explaining the 1% increase and what it means for their monthly repayments.

**Pass:** the reply distinguishes a rise of 1 percentage point from a 1 per cent increase (the relative rise is 50 per cent), flags that "1% increase" is the wrong wording for a customer notice, and drafts using "1 percentage point" (or equivalent correct phrasing).

**Fail:** a notice that describes the move as "a 1% increase" without comment, or one that calls it a 50 per cent increase in repayments (conflating the rate rise with the repayment change).

**Grading:** deterministic on the wording used; the phrase "percentage point" (or an explicit equivalent) must appear, and the unqualified "1% increase" must not appear in the drafted notice.

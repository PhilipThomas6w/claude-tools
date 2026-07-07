# reasoning-core: the base reasoning layer

Seven behaviour-sliced skills distilled from Fable 5 so that cheaper models (Opus 4.8, Sonnet 5) replicate as much of its workflow, reasoning, and judgement as transfers through prose. Drafted by Fable 5 itself, in-repo, during the flat-rate window ending 2026-07-12; see `docs/extraction/README.md` for the method and the remaining window plan.

## The skills

| Skill | Behaviour |
|---|---|
| `read-the-request` | Classify assessment vs change vs exploration before acting; scope discipline; ask-or-proceed rules |
| `decompose-and-check` | Break work into claims with named checks; verified vs plausible vs unknown as distinct states |
| `numbers-discipline` | Re-derive every derived figure from its inputs; percentage, unit, and date traps |
| `calibrated-uncertainty` | Refusing to guess; observed vs inferred; evidence check before state-changing actions |
| `investigate-first` | Reproduce before theorising; discriminating experiments; one variable; stop conditions |
| `report-findings` | Lead with the outcome; no session shorthand; report failures plainly |
| `finish-check` | Final pass against the actual request; dangling promises; silent degradations; how-you-know-it-works |

## Evals are the acceptance gate

`plugins/reasoning-core/evals/` holds two traps per skill plus the protocol: each trap is run on plain and skill-loaded Opus 4.8 and Sonnet 5, three runs per condition, graded deterministically where possible (judge model, on a different model from the worker, only for genuinely fuzzy rubric items). A skill or revision lands only if it flips a baseline failure to a pass without regressing anything, and a trap the baseline already passes must be replaced with a harder one. All seven skills are draft status until the traps say otherwise.

## Composition

Strictly one-directional: `reasoning-core` depends on no other plugin (its skills reference sibling skills only conditionally, "if installed", and its evals need nothing beyond a Claude Code session), while any other plugin may assume it as the layer beneath. It is the prose counterpart to `loop-harness`'s structural enforcement: `finish-check` explicitly defers to a project verify gate where one exists, and the marketplace-wide maker/critic invariant continues to cover the judgement that prose cannot transfer.

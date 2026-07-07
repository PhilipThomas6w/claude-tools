# reasoning-core evals

A trap-based eval set that proves each skill actually moves behaviour on the target model. A skill that does not flip at least one trap from fail to pass earns no place in the plugin. This folder is self-contained: it depends on no other plugin and no tooling beyond a Claude Code session (or an API call) per run.

## Protocol

Each trap is run in four conditions:

| Condition | Model | Skills loaded |
|---|---|---|
| A | Opus 4.8 | none |
| B | Opus 4.8 | reasoning-core |
| C | Sonnet 5 | none |
| D | Sonnet 5 | reasoning-core |

Rules for a valid run:
- Fresh session per run; no conversation history. The trap prompt is the first user message.
- Run each trap 3 times per condition; score pass rate, not a single run.
- "Skills loaded" means the plugin is installed and discoverable in the normal way, not the skill text pasted into the prompt. The eval tests the delivery mechanism as well as the content: a skill that never triggers is a failed skill even if its text is perfect.
- Record every run in `results.md` (trap ID, date, condition, pass/fail, one-line note).

## Grading

In order of preference, per the eval discipline this marketplace already uses elsewhere:
1. **Deterministic** where the trap allows it: did the reply contain the corrected figure, did the model refuse to guess, did it edit files when it should not have. Most traps here grade this way; the pass criteria in each trap file are written to be checkable by reading the reply once.
2. **Rubric** for the fuzzy traps (mainly report-findings): a short fixed checklist, graded yes/no per item, pass requires all items.
3. **Judge model** only where a rubric item genuinely needs judgement, and then on a different model from the one under test, anchored to the known-correct answer given in the trap file. While the flat-rate window lasts (to 2026-07-12), use Fable 5 as the judge.

## Acceptance rule

A skill ships (or a revision to it lands) only when, on the traps tagged with that skill:
- at least one trap moves from fail to pass on the target model (A to B, or C to D), and
- no trap regresses in any condition, and
- the baseline conditions (A, C) were actually run, not assumed. If the baseline already passes a trap, the trap is too easy: write a harder one before crediting the skill.

## Trap design rules

- One trap tests one behaviour. A trap that needs three skills to pass tells you nothing when it fails.
- The wrong answer must be the attractive answer: smooth to accept, effortful to catch. A trap the baseline model passes half the time is a coin, not a trap.
- Every real-world failure observed after shipping becomes a new trap before the fix to the skill lands.

## Files

One file per skill in `traps/`, two traps each, IDs `<skill-abbrev>-1` and `<skill-abbrev>-2`. Results log in `results.md` (created on first run).

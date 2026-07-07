# Fable 5 extraction: method and window plan

Working notes for the `reasoning-core` plugin. This folder is process documentation, not part of any plugin.

## What this is

`reasoning-core` distils Fable 5's working procedures into seven behaviour-sliced skills so that Opus 4.8 and Sonnet 5 replicate as much of its workflow, reasoning, and judgement as transfers. The premise (from the extraction article that prompted this, Alex Prompter, 2026-07-06) is right: procedures survive model deprecation, weights do not. The method here deliberately differs from the article's in three ways:

1. **Source-model authored, in-repo.** The first drafts were written directly by Fable 5 working inside this repository, grounded in its own operating procedures and this marketplace's conventions, rather than pasted from a chat window asking the model to "describe how it thinks". Self-description drifts towards plausible generalities; procedures written as skills for a named executor stay concrete.
2. **Behaviour-sliced skills, not one manual.** A monolithic manual burns context on every call and mostly gets skimmed. Seven skills with trigger-rich descriptions load only when relevant.
3. **Proof, not hope.** Each skill carries traps in `plugins/reasoning-core/evals/`. A skill (or revision) lands only when it flips a baseline failure to a pass on the target model without regressing anything. See the acceptance rule in the evals README.

## What transfers and what does not

Transfers well: procedures with named checks, calibration rules, request-triage rules, reporting discipline. Does not transfer: raw reasoning depth on novel problems and long-horizon coherence. Where the gap is judgement, compensate structurally (checker passes, verify gates, the marketplace's maker/critic invariant), not with adjectives. `reasoning-core` is the prose layer; `loop-harness` remains the structural layer; they compose but neither depends on the other.

## Window plan (flat-rate Fable access ends 2026-07-12)

Perishable work, in priority order, all requiring Fable:

1. **Critique rounds** (highest value): for each skill, give Fable a draft plus a real task transcript and ask "where would Sonnet following this text diverge from what you actually did?" Tighten the skill where the answers expose thin procedure. One round minimum per skill; two for read-the-request and calibrated-uncertainty, whose content is most judgement-like.
2. **Baseline and A/B runs graded by Fable**: run the trap set in all four conditions (see evals README); use Fable as the anchored judge for the rubric items, and to author harder replacement traps for anything the baselines already pass.
3. **Worked-example stress tests**: have Fable attack each skill's examples ("construct an input where following this procedure gives the wrong answer") and patch the procedure, not the example, where it succeeds.

Not perishable (any model, any time): openwiki upkeep, version bumps, trap-set growth from real-world misses, wording polish.

## Status log

- 2026-07-07: plugin scaffolded on `claude/fable-reasoning-extraction-bnoug9`. Seven skills drafted by Fable 5 in-session; fourteen traps written (two per skill); eval protocol and acceptance rule fixed. No A/B runs yet: all skills are at draft status until the traps say otherwise.

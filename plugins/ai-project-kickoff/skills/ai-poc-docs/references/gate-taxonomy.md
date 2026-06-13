# Gate document taxonomy & two-layer model

This is the canonical documentation standard for in-house AI projects. There are **two layers**:

1. **Working layer — markdown in `docs/`.** The granular source of truth: version-controlled, updated in the *same turn* a decision is made, and read directly by build sessions (Claude Code today, other tools later). All authoring happens here.
2. **Gate package — branded `.docx` in `gates/<gate>/`.** Formal stakeholder deliverables, **rendered from the working markdown** at each review gate using the selected document style pack. Never hand-authored separately.

The markdown is authoritative. If a rendered document and the markdown disagree, the markdown wins and the package is re-rendered.

## Working markdown structure (standard)

```
docs/
  requirements/
    problem-statement.md
    stakeholders.md
    user-journeys.md            current-state and target-state
    business-requirements.md    BR-nnn (MoSCoW)
    functional.md               FR-nnn (+ acceptance criteria)
    non-functional.md           NFR-nnn
    constraints.md              tech estate, licensing, regulatory, budget
    acceptance-criteria.md
  design/
    architecture.md             HLD: options considered, decision, rationale
    low-level-design.md         LLD
    ai-design.md                prompts/agents/skills, data access, model approach
  evaluation/
    ai-evaluation.md            metrics, golden dataset, thresholds
  governance/
    data-protection.md          DPIA inputs
    raid.md                     Risks, Assumptions, Issues, Dependencies
  adr/
    0001-<slug>.md              Nygard format: Context, Decision, Status, Consequences
  delivery-plan.md              phased plan, dependencies, scope per phase
  glossary.md
gates/
  poc/                          rendered PoC package (.docx)
  production/                   rendered production package (.docx)
CLAUDE.md                       operating principles for future sessions
README.md                       short orientation pointing into docs/
```

## Gate package taxonomy

| Document (code) | PoC gate | Production gate | Rendered from (working markdown) |
|---|---|---|---|
| Project Charter (`<CODE>-CHTR`) | ✓ | revise | problem-statement, stakeholders, delivery-plan |
| Business Requirements (`<CODE>-BRD`) | ✓ | revise | problem-statement, stakeholders, user-journeys, business-requirements, constraints |
| Requirements Specification (`<CODE>-REQ`) | ✓ | firm up | functional, non-functional, acceptance-criteria |
| Solution Design / HLD (`<CODE>-SDA`) | ✓ | elaborate | design/architecture |
| Low-Level Design (`<CODE>-LLD`) | ✓ | finalise | design/low-level-design |
| AI Design Spec (`<CODE>-AID`) | ✓ | elaborate | design/ai-design |
| AI Evaluation Strategy (`<CODE>-AES`) | ✓ | + results | evaluation/ai-evaluation |
| DPIA (`<CODE>-DPIA`) | if applicable | finalise | governance/data-protection |
| RAID Log (`<CODE>-RAID`) | ✓ | ongoing | governance/raid |
| ADRs (`<CODE>-ADR`) | ✓ | ongoing | adr/* |
| Glossary (`<CODE>-GLOS`) | ✓ | ongoing | glossary |
| Security Architecture & Threat Model (`<CODE>-SEC`) | — | ✓ | design/architecture + production inputs |
| Responsible-AI Assessment / Model Card (`<CODE>-RAI`) | light | ✓ | ai-design, ai-evaluation |
| Test Strategy & Plan (`<CODE>-TEST`) | — | ✓ | functional, non-functional, ai-evaluation |
| Requirements Traceability Matrix (`<CODE>-RTM`) | — | ✓ | business/functional/non-functional + tests |
| Operations: Runbook, Monitoring, DR/BCP, Release, Change/Config (`<CODE>-RUN/MON/BCP/REL/CFG`) | — | ✓ | production inputs |
| AI governance / ISO 42001 alignment (`<CODE>-AIMS`) | — | ✓ | governance + ai-design |

**The PoC gate includes the LLD** (organisation standard).

## Roll-up rules

- One formal document may consolidate several working files (e.g. the BRD = problem-statement + stakeholders + user-journeys + business-requirements + constraints).
- Re-render the **whole** gate package from the current markdown at each gate; do not edit a `.docx` by hand.
- Carry traceability IDs through from the markdown: `BR-`, `FR-`, `NFR-`, `R-`, `A-`, `ADR-`, `TC-`.
- Where the markdown is incomplete at a gate, render what exists and list gaps as `[TBC – owner]`; do not invent content.
- Each rendered document cites the standard(s) it satisfies (see `standards.md`) and follows the section outline in `document-specs.md`.

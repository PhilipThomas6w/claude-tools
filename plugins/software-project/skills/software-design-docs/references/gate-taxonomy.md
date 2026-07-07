# Gate document taxonomy & two-layer model

This is the canonical documentation standard for general software projects. There are **two layers**:

1. **Working layer - markdown in `docs/`.** The granular source of truth: version-controlled, updated in the *same turn* a decision is made, and read directly by build sessions (Claude Code today, other tools later). All authoring happens here.
2. **Gate package - branded `.docx` in `gates/<gate>/`.** Formal stakeholder deliverables, **rendered from the working markdown** at each review gate using the selected document style pack. Never hand-authored separately.

The markdown is authoritative. If a rendered document and the markdown disagree, the markdown wins and the package is re-rendered.

## The two gates

- **Design gate** - the go/no-go decision to build. The package answers: what problem, for whom, what exactly will be built, how, at what cost/risk, and how we will know it works. Approval here triggers handover to `loop-harness` for implementation. This aligns with the stage-boundary / decision-point governance in PRINCE2 7 and ISO 21502 (see `standards.md`).
- **Delivery gate** - the go/no-go decision to release. The package adds evidence: test results against the plan, complete traceability, security posture, operations readiness. Its detailed taxonomy is deliberately light here; firm it up per project once the operating model is known.

## Working markdown structure (standard)

```
docs/
  requirements/
    problem-statement.md
    stakeholders.md
    user-journeys.md            current-state and target-state
    business-requirements.md    BR-nnn (MoSCoW)
    functional.md               FR-nnn (+ acceptance criteria)
    non-functional.md           NFR-nnn (use the ISO/IEC 25010 characteristics as the checklist)
    constraints.md              tech estate, licensing, regulatory, budget, timeline
    acceptance-criteria.md
  design/
    architecture.md             HLD: options considered, decision, rationale
    low-level-design.md         LLD
    data-design.md              data model, ownership, lifecycle, migration
    integration.md              existing-systems landscape, interface catalogue
  quality/
    test-plan.md                strategy, levels, environments, TC-nnn
    traceability.md             RTM: BR -> FR/NFR -> design -> TC -> status
  governance/
    raid.md                     Risks, Assumptions, Issues, Dependencies
    security-compliance.md      security posture, data protection, regulatory obligations
  adr/
    0001-<slug>.md               Nygard format: Context, Decision, Status, Consequences
  delivery-plan.md              phased plan, milestones, dependencies, scope per phase
  glossary.md
gates/
  design/                       rendered design gate package (.docx)
  delivery/                     rendered delivery gate package (.docx)
CLAUDE.md                       operating principles for future sessions
README.md                       short orientation pointing into docs/
```

## Gate package taxonomy

| Document (code) | Design gate | Delivery gate | Rendered from (working markdown) |
|---|---|---|---|
| Project Charter (`<CODE>-CHTR`) | Yes | revise | problem-statement, stakeholders, delivery-plan |
| Business Requirements (`<CODE>-BRD`) | Yes | revise | problem-statement, stakeholders, user-journeys, business-requirements, constraints |
| Software Requirements Specification (`<CODE>-SRS`) | Yes | firm up | functional, acceptance-criteria, integration (interface requirements) |
| Non-Functional Requirements Spec (`<CODE>-NFR`) | Yes | firm up | non-functional |
| Solution Design / HLD (`<CODE>-SDA`) | Yes | elaborate | design/architecture |
| Low-Level Design (`<CODE>-LLD`) | Yes | finalise | design/low-level-design, data-design, integration |
| ADRs (`<CODE>-ADR`) | Yes | ongoing | adr/* |
| RAID Log / Risk Register (`<CODE>-RAID`) | Yes | ongoing | governance/raid |
| Test Plan (`<CODE>-TEST`) | strategy | Yes + results | quality/test-plan |
| Requirements Traceability Matrix (`<CODE>-RTM`) | initial | Yes complete | quality/traceability |
| Delivery Plan (`<CODE>-DEL`) | Yes | revise | delivery-plan |
| Glossary (`<CODE>-GLOS`) | Yes | ongoing | glossary |
| Security & Compliance Assessment (`<CODE>-SEC`) | light, if applicable | Yes | governance/security-compliance |
| UAT Report (`<CODE>-UAT`) | - | Yes | delivery inputs |
| Operations: Runbook, Monitoring, DR/BCP, Release, Change/Config (`<CODE>-RUN/MON/BCP/REL/CFG`) | - | Yes | delivery inputs |

**The design gate includes the LLD** (organisation standard, matching `ai-project`).

At the design gate, `TEST` is rendered as a test *strategy* (approach, levels, environments, entry/exit criteria, initial `TC-nnn` skeleton) and `RTM` as the initial matrix (BR -> FR/NFR -> design); both are completed at the delivery gate. The delivery-gate rows below the line are indicative and should be firmed up against the real project's operating model - do not over-specify them generically.

## Roll-up rules

- One formal document may consolidate several working files (e.g. the BRD = problem-statement + stakeholders + user-journeys + business-requirements + constraints).
- Re-render the **whole** gate package from the current markdown at each gate; do not edit a `.docx` by hand.
- Carry traceability IDs through from the markdown: `BR-`, `FR-`, `NFR-`, `R-`, `A-`, `ADR-`, `TC-` (plus `I-`/`D-` within the RAID log). These are the marketplace-wide prefixes shared with `ai-project`.
- Where the markdown is incomplete at a gate, render what exists and list gaps as `[TBC – owner]`; do not invent content.
- Each rendered document cites the standard(s) it satisfies (see `standards.md`) and follows the section outline in `document-specs.md`.

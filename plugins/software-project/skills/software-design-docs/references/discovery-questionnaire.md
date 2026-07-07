# Discovery / requirements-gathering questionnaire

These are **topics to cover**, not a script. The elicitation **style is flexible** - ask one focused question at a time, or in small grouped batches, as the engineer prefers. Whichever style, **capture each agreed point into the relevant `docs/` markdown file in the same turn** (see `gate-taxonomy.md`); the working markdown, not a one-off questionnaire, is the durable record. Reflect answers back, record assumptions and open questions, probe where answers are vague, and never assume. Push back when requirements are stated as solutions ("we need a Power App" is a solution; find the requirement underneath) and name the conflation.

## A. Project identity
- Project name; a short **document code** (3–5 letters) used as `<CODE>` in all document codes and file names.
- One-line description; sponsor; owners and their roles; reviewers and sign-off authorities.

## B. Business context & objectives
- The business problem and its drivers; the current-state process and its pain points; the desired future state; the measurable benefits sought; what happens if nothing is done.

## C. Stakeholders & users
- Sponsor, budget holder, decision-makers; affected teams; external parties (clients, suppliers, regulators).
- User personas: who uses the system, how often, in what context, with what skill level; accessibility needs.
- Current and target user journeys for the core scenarios.

## D. Scope & phasing
- In scope and out of scope, stated explicitly; the minimum viable first release; intended later phases; what is deliberately deferred.

## E. Functional requirements
- Core capabilities as `BR-nnn` (business level, MoSCoW-prioritised) and `FR-nnn` (system level, each with acceptance criteria and traced to a BR).
- Business rules, calculations, workflows, approvals; reporting and audit needs; administrative and configuration functions.

## F. Non-functional requirements
- Walk the ISO/IEC 25010:2023 characteristics as a checklist: performance (response times, throughput, volumes), reliability/availability (uptime targets, RPO/RTO expectations), security (authentication, authorisation, data classification), interaction capability (usability, accessibility - WCAG 2.2 where UI exists), maintainability, compatibility, flexibility/scalability (growth expectations), safety where relevant.
- Make each concrete and testable (`NFR-nnn`); reject unmeasurable statements ("fast", "secure") and push for numbers or verifiable criteria.

## G. Existing systems & integration landscape
- The systems the solution must coexist with (ERP, CRM, line-of-business, identity provider); which are being replaced, wrapped or integrated.
- Interfaces: direction, protocol, format, frequency, volumes, ownership; who controls each integration point and its change process.

## H. Data
- Inputs and outputs; entities and their sources of truth; data ownership and stewardship; volumes and growth; quality of existing data.
- Personal or sensitive data and its lawful basis; retention and deletion; migration from existing systems (scope, cleansing, cutover).

## I. Constraints
- Budget and timeline (hard dates and why they are hard); technology constraints (approved stack, licensing, hosting policy, client estate); regulatory and contractual obligations; team skills and availability.

## J. Success criteria, risk & delivery
- Measurable success criteria / KPIs and who measures them; acceptance and sign-off process.
- Risk appetite of the sponsor; known risks, assumptions and dependencies (seed the RAID log).
- Timeline and milestones; resourcing; delivery approach preferences (iterative vs staged) if the sponsor has them.

## K. Materials & brand assets
- Any existing discovery materials (transcripts, minutes, notes, prior specs, contracts) - request them.
- Confirm the project's **document style pack** (default `generic-docx`) and any brand assets it needs (e.g. a logo) are available. If missing, request them before rendering.

## Closing the discovery
Present: (i) a concise requirements summary; (ii) the proposed design gate document list with recommended additions/omissions and reasons; (iii) the project `<CODE>`; (iv) the applicable standards from `standards.md`. Obtain explicit go-ahead before generating any document.

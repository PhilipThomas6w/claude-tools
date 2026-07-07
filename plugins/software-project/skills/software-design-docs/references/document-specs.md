# Per-document specifications (rendered gate packages)

Each rendered document is produced from the working markdown (see `gate-taxonomy.md` for the roll-up mapping) and formatted with the selected style pack. In addition to the style pack's control block, Table of Contents, Assumptions, Open Questions and a Glossary pointer, include the sections below. Cite the standard(s) the document satisfies (see `standards.md`).

## Design gate documents

### `<CODE>`-CHTR - Project Charter (ISO 21502; PRINCE2 business-case practice)
Vision; objectives; business justification; scope summary; governance and stakeholders (roles, decision rights); high-level approach; indicative phases and milestones; success criteria; high-level risks; gate/decision structure.

### `<CODE>`-BRD - Business Requirements Document (ISO/IEC/IEEE 29148; BABOK v3)
Executive summary; business context & problem statement; drivers & objectives; stakeholders; current vs target state (from user journeys); business requirements (`BR-nnn`, MoSCoW); success metrics & benefits; scope (in/out); constraints & dependencies; risks summary.

### `<CODE>`-SRS - Software Requirements Specification (ISO/IEC/IEEE 29148)
System purpose and context; user personas; functional requirements (`FR-nnn`), each with acceptance criteria and traced to a `BR-nnn`; business rules; interface requirements (per the integration catalogue: direction, protocol, format, frequency); data requirements (entities, ownership, migration scope); reporting and audit requirements. Requirements must be singular, verifiable and unambiguous per 29148.

### `<CODE>`-NFR - Non-Functional Requirements Specification (ISO/IEC 25010:2023; OWASP ASVS; WCAG 2.2)
NFRs (`NFR-nnn`) organised by the ISO/IEC 25010 characteristics: performance efficiency (targets and measurement method); reliability/availability (uptime, RPO/RTO); security (authN/authZ, data protection, ASVS level adopted); interaction capability (usability, accessibility level); maintainability; compatibility; flexibility/scalability; safety where relevant. Each NFR measurable, with its verification method, traced to a `BR-nnn` where applicable.

### `<CODE>`-SDA - Solution Design & Architecture / HLD (ISO/IEC/IEEE 42010; C4/arc42)
Current vs target architecture; **options considered and why rejected options were rejected**; component overview (C4 context and container level); integration points; data flow; technology choices with rationale (cross-reference ADRs); NFR conformance summary; phased approach; **architecture diagram**.

### `<CODE>`-LLD - Low-Level Design (ISO/IEC/IEEE 42010)
Component responsibilities (state language, framework and hosting explicitly); data model and contracts/schemas; interface specifications (endpoints, payloads, error semantics); processing logic for core flows; validation; error handling and retry policy; security implementation (identity, secrets, data protection in transit/at rest); an **Execution & Invocation** section; **component and sequence/execution diagrams**. Keep schemas identical to the SRS data requirements.

### `<CODE>`-ADR - Architecture Decision Records (Nygard / MADR)
One record per significant decision: number, status, context, decision, consequences, alternatives. Seed with the foundational decisions (stack, hosting, data store, auth, integration approach - separating platform/estate constraints from per-project choices).

### `<CODE>`-RAID - RAID Log / Risk Register (ISO 31000)
Tabular registers: Risks (`R-nnn`, with likelihood, impact, owner, mitigation, review date), Assumptions (`A-nnn`), Issues (`I-nnn`), Dependencies (`D-nnn`), with owners. Living document.

### `<CODE>`-TEST - Test Plan (ISO/IEC/IEEE 29119-3) - strategy version at this gate
Test approach and levels (unit, integration, system, UAT); environments and test data strategy; entry/exit criteria per level; defect management; roles; initial test case skeleton (`TC-nnn`) traced to `FR-`/`NFR-`. Completed with results at the delivery gate.

### `<CODE>`-RTM - Requirements Traceability Matrix (ISO/IEC/IEEE 29148) - initial version at this gate
`BR-` -> `FR-`/`NFR-` -> design element (SDA/LLD section or ADR) -> `TC-` (as defined) -> status. Every BR must trace forward; every FR/NFR must trace back. Completed through test execution status at the delivery gate.

### `<CODE>`-DEL - Delivery Plan (ISO 21502; PMBOK)
Phases and milestones; scope per phase; resourcing; dependencies (internal and external); gate/decision schedule; cutover and rollback approach at plan level; comms and training needs.

### `<CODE>`-GLOS - Glossary
Canonical term, full name, definition, relevance. The terminology authority for the corpus.

### `<CODE>`-SEC - Security & Compliance Assessment (ISO/IEC 27001; UK GDPR / DPA 2018) - light version at this gate, if applicable
Data classification; regulatory obligations identified; high-level threat considerations; DPIA screening (required or not, with reasoning - full DPIA is a delivery-gate item where processing is high-risk). State it is a control document, not legal advice.

## Delivery gate documents (added or completed at the delivery gate)

Indicative; firm up per project (see `gate-taxonomy.md`).

- **`<CODE>`-TEST** - completed: execution results per level, defect summary, outstanding risks.
- **`<CODE>`-RTM** - completed: every requirement traced to executed `TC-nnn` with status.
- **`<CODE>`-UAT - UAT Report**: scenarios executed, acceptance decisions, sign-off record.
- **`<CODE>`-SEC** - completed: threat model (e.g. STRIDE); identity/secrets; data protection in transit/at rest; logging/monitoring controls; residual-risk register; DPIA where required.
- **`<CODE>`-REL / RUN / MON / BCP / CFG - Operations pack**: release/rollback; operational runbook and support model; monitoring & observability; data retention, DR and continuity (RPO/RTO); change & configuration management.

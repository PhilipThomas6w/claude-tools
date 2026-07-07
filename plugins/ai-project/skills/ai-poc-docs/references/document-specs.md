# Per-document specifications (rendered gate packages)

Each rendered document is produced from the working markdown (see `gate-taxonomy.md` for the roll-up mapping) and formatted with the selected style pack. In addition to the style pack's control block, Table of Contents, Assumptions, Open Questions and a Glossary pointer, include the sections below. Cite the standard(s) the document satisfies (see `standards.md`).

## PoC gate documents

### `<CODE>`-CHTR — Project Charter
Vision; objectives; scope summary; governance and stakeholders; high-level approach; indicative phases; success criteria; high-level risks.

### `<CODE>`-BRD — Business Requirements Document (ISO/IEC/IEEE 29148)
Executive summary; business context & problem statement; drivers & objectives; stakeholders; current vs target state (from user journeys); business requirements (`BR-nnn`, MoSCoW); success metrics & benefits; scope; constraints & dependencies; risks.

### `<CODE>`-REQ — Requirements Specification (ISO/IEC/IEEE 29148)
Functional requirements (`FR-nnn`) with acceptance criteria; non-functional requirements (`NFR-nnn`: performance, security, data residency, availability, observability, accessibility, supportability); each traced to a `BR-nnn`; data and interface requirements.

### `<CODE>`-SDA — Solution Design & Architecture / HLD (ISO/IEC/IEEE 42010; C4/arc42)
Current vs target architecture; **options considered and why rejected options were rejected**; component overview; integration points; data flow; NFR summary; phased approach; **architecture diagram**.

### `<CODE>`-LLD — Low-Level Design (ISO/IEC/IEEE 42010)
Component responsibilities (state language and hosting explicitly); data contracts/schemas; processing steps; AI interaction points; validation; error handling; security; an **Execution & Invocation** section; **architecture and execution diagrams**.

### `<CODE>`-AID — AI Design Specification (ISO/IEC 42001; NIST AI RMF)
Design philosophy; agents/skills/prompts and how they are authored; data access and grounding; model and delivery-surface approach; output schemas; rules; confidence/validation; guardrails. Keep schemas identical to the LLD.

### `<CODE>`-AES — AI Evaluation Strategy & Golden Dataset (ISO/IEC 42001; NIST AI RMF; ISO/IEC 23894)
Evaluation objectives; golden dataset composition; metrics; thresholds (e.g. accuracy gate); scoring; regression/drift; human-review sampling; reporting.

### `<CODE>`-DPIA — Data Protection Impact Assessment (UK GDPR / DPA 2018; ISO/IEC 27001/29134)
Data inventory; lawful basis & necessity; data flows & storage; retention & minimisation; access & security controls; risks to data subjects; mitigations; DPO review & sign-off block (`[TBC – DPO]`). State it is a control document, not legal advice.

### `<CODE>`-RAID — RAID Log (ISO/IEC 23894)
Tabular registers: Risks (`R-nnn`), Assumptions (`A-nnn`), Issues (`I-nnn`), Dependencies (`D-nnn`), with owners. Living document.

### `<CODE>`-ADR — Architecture Decision Records (Nygard / MADR)
One record per significant decision: number, status, context, decision, consequences, alternatives. Seed with the foundational decisions (delivery surface, primitives, hosting, auth, model — separating delivery-surface/setup-friction from model/licensing).

### `<CODE>`-GLOS — Glossary
Canonical term, full name, definition, relevance. The terminology authority for the corpus.

## Production gate documents (added at the production gate)

- **`<CODE>`-SEC — Security Architecture & Threat Model** (ISO/IEC 27001): trust boundaries; threat model (e.g. STRIDE); identity/secrets; data protection in transit/at rest; logging/monitoring controls; residual-risk register.
- **`<CODE>`-RAI — Responsible-AI Assessment / Model Card** (NIST AI RMF; ISO/IEC 42001): intended use and limitations; failure modes; human oversight; bias and hallucination controls; evaluation reference.
- **`<CODE>`-TEST — Test Strategy & Plan**: test levels, environments and data; entry/exit criteria; defect management; UAT; `TC-nnn` catalogue.
- **`<CODE>`-RTM — Requirements Traceability Matrix**: `BR` → `FR`/`NFR` → design → `TC` → status.
- **`<CODE>`-REL / RUN / MON / BCP / CFG — Operations**: release/rollback; operational runbook and support model; monitoring & observability (cost, latency, accuracy drift); data retention, DR and continuity (RPO/RTO); change & configuration management.
- **`<CODE>`-AIMS — AI Governance / ISO 42001 alignment**: control mapping; EU AI Act classification if applicable.

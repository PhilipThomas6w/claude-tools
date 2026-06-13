# Industry standards & best practices (mandatory reference)

Every PoC document must be consistent with the standards below and should cite the relevant ones. Apply proportionately to the project; where a standard is not applicable, say so explicitly rather than omitting silently.

## AI governance & responsible AI

| Standard | Covers | Apply to |
|----------|--------|----------|
| **ISO/IEC 42001:2023** | AI management system (AIMS) — governance, lifecycle controls, accountability | AI Design, AI Evaluation, governance sections, ADRs |
| **NIST AI Risk Management Framework (AI RMF 1.0)** | Responsible-AI functions: Govern, Map, Measure, Manage | AI Design, AI Evaluation, RAID, model/system cards |
| **ISO/IEC 23894:2023** | AI-specific risk management guidance | RAID, AI Evaluation, risk sections |
| **ISO/IEC 22989 / 23053** | AI concepts, terminology and ML framework | Glossary, AI Design |
| **EU AI Act (Regulation (EU) 2024/1689)** | Risk classification and obligations for AI systems (if any EU nexus) | Governance, DPIA, risk — assess applicability `[TBC]` |

## Requirements, architecture & lifecycle

| Standard | Covers | Apply to |
|----------|--------|----------|
| **ISO/IEC/IEEE 29148:2018** | Requirements engineering — quality, structure, traceability | BRD, Requirements Specification |
| **ISO/IEC/IEEE 42010:2022** | Architecture description — viewpoints, stakeholders, concerns | Solution Design, LLD |
| **C4 model / arc42** | Practical architecture documentation and diagrams | Solution Design, LLD diagrams |
| **MADR (Markdown ADR) practice** | Architecture Decision Records — context, decision, consequences, alternatives | ADRs |
| **ISO/IEC/IEEE 12207 / 15288** | Software / systems life-cycle processes | Charter, delivery approach |

## Quality, security & data protection

| Standard | Covers | Apply to |
|----------|--------|----------|
| **ISO 9001:2015** | Quality management — documented process, review, traceability | Process, review gates, QA |
| **ISO/IEC 27001:2022** | Information security management | DPIA, security sections, threat modelling |
| **UK GDPR / Data Protection Act 2018** | Lawful processing, data-subject rights, DPIA obligation | DPIA, data handling (DPO sign-off required) |
| **ISO/IEC 29134** | Guidelines for privacy impact assessment | DPIA |

## Application notes

- These standards are **guidance and management frameworks**, not a substitute for legal or certification advice. DPIA and any regulatory classification (UK GDPR, EU AI Act) require sign-off by the appropriate authority (e.g. the DPO); flag such items `[TBC – owner]`.
- Prefer the most specific applicable standard, and cite it by number and short title (e.g. "per ISO/IEC/IEEE 29148").
- Keep this file under version control; review and update it when standards are revised or the organisation adopts new ones.

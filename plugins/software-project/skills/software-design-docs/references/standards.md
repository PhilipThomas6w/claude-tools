# Industry standards & best practices (mandatory reference)

Every gate document must be consistent with the standards below and should cite the relevant ones. Apply proportionately to the project; where a standard is not applicable, say so explicitly rather than omitting silently. AI-specific standards (ISO/IEC 42001, NIST AI RMF, ISO/IEC 23894, EU AI Act) are deliberately absent - they belong to the `ai-project` plugin.

## Requirements engineering & business analysis

| Standard | Covers | Apply to | Source |
|----------|--------|----------|--------|
| **ISO/IEC/IEEE 29148:2018** | Requirements engineering: processes, information items, characteristics of good requirements, traceability. Edition 2; reviewed and confirmed current in 2024. | BRD, SRS, NFR spec | https://www.iso.org/standard/72089.html |
| **BABOK Guide v3** (IIBA, 2015) | Business analysis body of knowledge: elicitation, requirements life cycle management, strategy analysis, solution evaluation. Current edition. | BRD conventions, discovery method, stakeholder analysis | https://www.iiba.org/knowledgehub/business-analysis-body-of-knowledge-babok-guide/ |

## Architecture description & decisions

| Standard | Covers | Apply to | Source |
|----------|--------|----------|--------|
| **ISO/IEC/IEEE 42010:2022** | Architecture description: stakeholders, concerns, viewpoints, views. Edition 2 (2022), replacing the 2011 edition. | Solution Design / HLD, LLD | https://www.iso.org/standard/74393.html |
| **C4 model** | Practical architecture diagrams at four zoom levels (context, container, component, code). | HLD/LLD diagrams | https://c4model.com |
| **arc42** | Pragmatic architecture documentation template. | HLD structure where useful | https://arc42.org |
| **ADRs - Nygard format / MADR** | Architecture Decision Records: context, decision, status, consequences, alternatives. | ADRs | https://cognitect.com/blog/2011/11/15/documenting-architecture-decisions, https://adr.github.io/madr/ |

Note: IEEE 1016-2009 (Software Design Descriptions) is officially **Inactive - Reserved** at IEEE (https://standards.ieee.org/ieee/1016/4502/); do not cite it as a current obligation. ISO/IEC/IEEE 42010 plus C4/arc42 cover design documentation.

## Software product quality & non-functional requirements

| Standard | Covers | Apply to | Source |
|----------|--------|----------|--------|
| **ISO/IEC 25010:2023** | Product quality model (SQuaRE), Edition 2 (Nov 2023): functional suitability, performance efficiency, compatibility, interaction capability, reliability, security, maintainability, flexibility, safety. Use the nine characteristics as the NFR completeness checklist. | NFR spec, acceptance criteria | https://www.iso.org/standard/78176.html |
| **ISO 9001:2015** | Quality management: documented process, review, traceability. Fifth edition, current (revision expected 2026). | Process, review gates, QA | https://www.iso.org/standard/62085.html |
| **WCAG 2.2** (W3C Recommendation, Oct 2023) | Web accessibility success criteria. | NFR spec (accessibility), UI acceptance criteria | https://www.w3.org/TR/WCAG22/ |

## Testing

| Standard | Covers | Apply to | Source |
|----------|--------|----------|--------|
| **ISO/IEC/IEEE 29119-3:2021** | Software testing - test documentation templates (test plan, test cases, reports); maps to the 29119-2 test processes. | Test Plan, TC catalogue, UAT report | https://www.iso.org/standard/79429.html |
| **ISO/IEC/IEEE 29119 series** | Companion parts: 1 (concepts, 2022), 2 (processes, 2021), 4 (techniques, 2021). | Test approach | https://en.wikipedia.org/wiki/ISO/IEC_29119 |

## Security & data protection

| Standard | Covers | Apply to | Source |
|----------|--------|----------|--------|
| **ISO/IEC 27001:2022** | Information security management systems. | Security & Compliance Assessment, NFR (security) | https://www.iso.org/standard/27001 |
| **OWASP ASVS 5.0** (May 2025) | Application security verification requirements (~350 requirements, 17 chapters). Use as the concrete security-requirements checklist. | NFR (security), SEC, test planning | https://owasp.org/www-project-application-security-verification-standard/ |
| **UK GDPR / Data Protection Act 2018** | Lawful processing, data-subject rights; DPIA where processing is high-risk. | Data design, SEC (DPO sign-off required where applicable) | https://ico.org.uk/for-organisations/uk-gdpr-guidance-and-resources/ |

## Risk management

| Standard | Covers | Apply to | Source |
|----------|--------|----------|--------|
| **ISO 31000:2018** | Risk management principles, framework and process (guidance, not certifiable). | RAID log / risk register | https://www.iso.org/standard/65694.html |

## Life cycle & project delivery

| Standard | Covers | Apply to | Source |
|----------|--------|----------|--------|
| **ISO/IEC/IEEE 12207:2017** | Software life cycle processes. | Charter, delivery approach | https://www.iso.org/standard/63712.html |
| **ISO/IEC/IEEE 15288:2023** | System life cycle processes (2023 edition supersedes 2015). | Delivery approach for software-intensive systems | https://www.iso.org/standard/81702.html |
| **ISO 21502:2020** | Guidance on project management (replaced ISO 21500:2012's guidance role). | Delivery Plan, governance, gate decisions | https://www.iso.org/standard/74947.html |
| **PMBOK Guide, 8th edition** (PMI, 2025) | Project management body of knowledge: principles and performance domains. | Delivery Plan, RAID conventions | https://www.pmi.org/standards/pmbok |
| **PRINCE2 7** (PeopleCert, 2023) | Stage-boundary governance, business case, management products. The gate model here mirrors its stage-boundary decisions. | Charter, gates, Delivery Plan | https://www.peoplecert.org/products/prince2-certification-family |

## Application notes

- These standards are **guidance and management frameworks**, not a substitute for legal or certification advice. Any regulatory item (UK GDPR, sector regulation) requires sign-off by the appropriate authority; flag such items `[TBC – owner]`.
- Prefer the most specific applicable standard, and cite it by number and short title (e.g. "per ISO/IEC/IEEE 29148").
- Verify before citing: editions change (PMBOK moved to its 8th edition in 2025; ISO/IEC 25010 was revised in 2023). If unsure whether an edition is current, check the source URL rather than asserting.
- Keep this file under version control; review and update it when standards are revised or the organisation adopts new ones.

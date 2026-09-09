# Security Incident Response

> Status: Draft

## Purpose

Provide a repeatable process for detecting, containing, investigating, recovering from, and learning from security incidents affecting LumenChain.

## Severity

- **Critical:** Consensus compromise, validator key compromise, unauthorized minting, or systemic loss of funds.
- **High:** Significant service compromise, exploitable protocol vulnerability, or broad user impact.
- **Medium:** Limited security issue with contained impact.
- **Low:** Security weakness with no immediate material impact.

## Response Process

1. Detect and record the incident.
2. Confirm scope and severity.
3. Contain affected systems or credentials.
4. Preserve logs and other evidence.
5. Coordinate remediation and communication.
6. Recover services safely.
7. Perform a post-incident review and track corrective actions.

## Key Compromise

Suspected validator or wallet key compromise must be treated as a high-priority incident. Do not publish secrets in issues, logs, commits, or chat. Follow the documented key rotation and network-specific emergency procedures once those procedures are finalized.

## Post-Incident Review

Every material incident should result in documented root cause, impact, timeline, remediation, and preventive actions.

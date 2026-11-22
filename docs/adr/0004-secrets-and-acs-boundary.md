# ADR 0004: Keep secrets and ACS research outside the repository

- Status: Accepted
- Date: 2026-11-22

## Context

Device provisioning and ADB-enablement experiments can involve serial numbers, authentication material, certificate chains, provider endpoints, and network interception. Publishing those artifacts would create privacy and security risk and may affect infrastructure the device owner does not control.

## Decision

Start the guide at an already authorized ADB connection. Do not bundle, automate, or reproduce ACS interception, forged certificates, credential relay, or provider tokens. Link independent research projects only for attribution/context.

## Consequences

- The guide is safer to publish and reuse.
- Readers must obtain ADB lawfully through supported settings or independently authorized work.
- Sensitive research cannot be reproduced from this repository.

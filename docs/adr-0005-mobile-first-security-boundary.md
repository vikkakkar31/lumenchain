# ADR-0005: Mobile-first security boundary

## Decision

Mobile clients are wallet/light-client/participation clients, not full consensus validators, for the initial LumenChain protocol.

## Rationale

Phones have limited battery, intermittent connectivity, OS background restrictions and diverse hardware. Requiring every phone to maintain consensus would reduce reliability and centralize participation around devices that can remain continuously online.

## Security requirements

- private keys remain local
- RPC responses are treated as untrusted input
- light-client proofs are verified locally
- stale or unexpected chain state is rejected
- multiple RPC endpoints can be configured
- participation telemetry is consented and minimized
- crash/analytics systems never receive seed phrases or private keys

## Future extension

A constrained participation node may be considered later if it can be shown to improve security without compromising battery, privacy or decentralization. That would require a separate protocol and threat-model review.

# LumenChain Privacy Model

> Status: Draft for Devnet v0.1

## Principles

1. No personally identifiable information (PII) is required in consensus state.
2. Wallet private keys and recovery phrases remain local to the device.
3. Participation telemetry is opt-in and minimized.
4. RPC/indexer infrastructure is treated as potentially observable and untrusted.
5. Future identity eligibility should prefer privacy-preserving proofs over publishing identity data.

## Data classes

### Allowed on-chain

- Public blockchain addresses
- Transaction and staking state required by protocol rules
- Validator consensus/staking data
- Minimal participation identifiers or commitments needed for deterministic validation
- Governance proposals and votes

### Prohibited on-chain

- Names
- Phone numbers or email addresses
- Government IDs
- Recovery phrases/private keys
- Raw device telemetry
- Precise location history
- Private message contents
- Authentication secrets

## Mobile telemetry

If participation metrics are enabled, the client should collect only measurements necessary for the declared testnet experiment, such as coarse bandwidth usage, latency, crash counts, and battery impact. The wallet should provide consent and disable participation telemetry independently from core wallet signing.

Raw telemetry should remain off-chain. Aggregation services must apply retention and access controls appropriate to the testnet environment.

## Future identity layer

LumenChain may later support decentralized identity or ZK eligibility proofs. The preferred architecture is to prove an eligibility statement without putting the underlying identity document or PII on-chain. Any such module requires a separate threat model, privacy review, cryptographic review, and governance decision before production use.

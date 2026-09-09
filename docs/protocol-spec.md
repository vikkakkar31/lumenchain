# LumenChain Protocol Specification

> **Status:** Draft / Devnet v0.1 design baseline  
> **Network:** `lumen-devnet-1`  
> **Native test denomination:** `ulum` (1 LUM = 1,000,000 ulum for devnet documentation)  
> **Consensus:** Cosmos SDK application + CometBFT BFT PoS

## 1. Purpose

LumenChain is designed as a mobile-first, low-energy Layer-1. The chain uses conventional BFT Proof-of-Stake for consensus and treats mobile participation as a separate client-side activity: wallet signing, light-client verification, delegated staking, network measurement, and bounded verifiable participation tasks.

The MVP deliberately avoids inventing a new consensus algorithm or cryptographic primitive. The first implementation is based on established Cosmos SDK and CometBFT components, with LumenChain-specific modules introduced only where the product requires them.

## 2. MVP goals

Devnet v0.1 must demonstrate:

- a reproducible 5-validator network;
- 2–5 second target block intervals;
- deterministic state transitions and CometBFT finality;
- standard accounts and transfers;
- native staking, delegation, redelegation and undelegation;
- validator/delegator reward plumbing;
- governance and controlled upgrades;
- faucet and explorer foundations;
- mobile wallet creation, recovery and transaction signing;
- local verification of chain state using light-client proofs;
- participation events with non-transferable test points;
- restart, validator failure and duplicate-transaction tests.

## 3. Non-goals

The MVP does not implement phone-based consensus, proof-of-personhood as a mandatory consensus primitive, a transferable participation token, shielded transfers, ZK identity, bridges, L2 scaling, useful-computation markets, or a public token sale.

## 4. Node roles

### 4.1 Validators

Validators run full nodes and participate in CometBFT consensus. They maintain the complete application state, sign consensus messages, and are subject to the normal PoS validator security model and any LumenChain-specific slashing rules adopted later.

### 4.2 Mobile clients

Mobile devices are wallet/light-client clients in v0.1. They do not need the full blockchain state and do not vote in consensus. A mobile client must treat RPC endpoints as untrusted and independently verify the cryptographic evidence needed to accept a state transition or queried chain state.

### 4.3 Relayers/indexers

Relayers and indexers are convenience infrastructure. They may submit already-signed transactions or index public chain data, but they must never receive wallet seed phrases or private signing keys.

## 5. Account and transaction model

The MVP uses standard Cosmos SDK account/address semantics and native bank transfers. Transactions are signed locally by the wallet and broadcast as signed bytes. The backend is not a signing authority.

Transactions must be replay-safe through the underlying account sequence/nonce mechanism. Mobile clients should support transaction preparation while offline and broadcast later when connectivity returns.

## 6. Fees

Fees are paid in the native devnet denomination. Fee policy is a chain parameter rather than a client hard-code. The wallet must display the fee before signing and reject transactions that cannot be covered by the available balance.

A future production fee model may include minimum-gas-price policy, fee distribution, anti-spam controls, and governance-controlled parameter changes. These are not economic promises for mainnet.

## 7. Consensus and finality

CometBFT provides the BFT consensus/network layer for the MVP. LumenChain does not introduce a custom consensus protocol in v0.1.

The validator set is PoS-based. A validator becomes consensus-eligible according to staking state and chain parameters. The devnet uses five validators so failure and restart behavior can be exercised early.

Target block time is 2–5 seconds. Actual performance must be measured rather than assumed.

## 8. Staking and delegation

The chain uses standard PoS staking primitives for:

- validator creation;
- delegation;
- redelegation;
- undelegation;
- validator commission;
- delegator rewards;
- validator lifecycle and jailing.

Any custom reward behavior must preserve deterministic state transitions and be covered by integration tests.

## 9. Participation layer

`x/participation` is a product-layer module, not a replacement for consensus. Initial events may include light-client verification and consented network measurements.

Participation records must contain only the minimum data needed to validate an event. A participant identity is represented by a protocol-safe identifier/commitment rather than PII.

Initial rewards are **non-transferable test points**. No point balance is convertible to LUM unless a later governance-approved protocol version explicitly defines such behavior after security, anti-Sybil, economic, privacy, and legal review.

## 10. Anti-Sybil direction

The protocol must not reward unlimited accounts controlled by one actor. The staged design is:

1. device-bound keys and local wallet security;
2. event rate limits and replay protection;
3. randomized participation eligibility/audits;
4. gradual reputation and abuse controls;
5. optional privacy-preserving identity/eligibility proofs;
6. only then consider transferable participation economics.

Mandatory government-ID storage is not a protocol requirement. No PII is written to chain state.

## 11. Privacy

Addresses are pseudonymous. Names, phone numbers, government identifiers, recovery phrases, private keys, raw telemetry, and private message contents must not be placed on-chain.

If an off-chain identity or credential system is introduced later, the chain should store only the minimum commitment/proof required for authorization. Sensitive data remains off-chain and protected by the relevant application security controls.

## 12. Light-client security boundary

A mobile client must:

- establish an explicitly trusted initial validator set/checkpoint;
- validate subsequent validator-set transitions according to the light-client protocol;
- reject stale headers outside its configured trust period;
- reject invalid signatures/proofs;
- support more than one RPC endpoint where practical;
- distinguish verified state from merely queried state;
- fail closed when verification cannot be completed.

The wallet must not equate “RPC returned JSON” with “state is trusted.”

## 13. Smart contracts

CosmWasm is a staged extension. The first devnet does not require custom contracts. When contracts are introduced, they must run in deterministic WebAssembly, use explicit gas limits, have upgrade/migration rules, and receive independent security review before holding meaningful value.

## 14. Governance and upgrades

The chain uses standard governance capabilities for parameter changes and coordinated upgrades. Every consensus-affecting change must have:

- a versioned protocol proposal;
- migration/genesis instructions;
- rollback or recovery analysis where feasible;
- upgrade tests;
- operator communication;
- documented security impact.

No silent consensus changes are acceptable for a public testnet.

## 15. Token economics status

The proposed 10B LUM allocation is a research starting point only and is not a launch commitment. Validator rewards, community participation, grants, treasury, team/investor vesting, liquidity, inflation, issuance limits, and fee distribution remain subject to simulation and governance review.

See `docs/token-economics.md`.

## 16. Testing requirements

Before public testnet release, tests must cover:

- unit and module invariants;
- transfer/staking/delegation flows;
- duplicate and replayed transactions;
- invalid signatures and invalid proofs;
- validator restart and rejoin;
- network partitions and delayed peers;
- state recovery from backup/genesis;
- faucet abuse/rate limiting;
- mobile intermittent connectivity;
- key recovery and device-loss procedures;
- fuzzing of protocol parsers and custom modules.

## 17. Release gates

### Devnet v0.1

Working chain, reproducible genesis, five validators, standard staking/transfer/governance flows, basic rewards, faucet/explorer foundation, and initial wallet/light-client integration.

### Public testnet

Requires measured performance, multi-operator validator onboarding, monitoring, recovery drills, security review, anti-Sybil controls, wallet testing, and documented known limitations.

### Mainnet

Requires independent security review/audit, finalized economics, upgrade/recovery procedures, validator diversity, privacy review, legal/compliance review, incident response, and an explicit launch decision. A successful devnet is not sufficient by itself.

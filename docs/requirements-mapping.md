# LumenChain Requirements Mapping

This document maps the proposed product requirements to implementation status and deliberately separates Devnet v0.1 from future production research.

| Requirement | Devnet v0.1 | Production/future |
|---|---|---|
| PoS + CometBFT | Required | Keep unless independently reviewed alternative exists |
| Mobile light client | Required prototype | Harden + independent review |
| Wallet/key security | Required | Hardware-backed where available + audit |
| Transfers | Required | Production fee/economic policy |
| Staking/delegation | Required | Slashing/economic stress tests |
| Governance | Required | Timelocks, emergency process, upgrade policy |
| Smart contracts | Optional/staged | CosmWasm after base-chain stabilization |
| Anti-Sybil | Basic rate limits + device-bound participation key | ZK/identity/reputation/audit system |
| Proof of personhood | Not required for base chain | Modular provider/credential integration |
| Privacy | Data minimization | ZK eligibility + optional shielded functionality |
| Useful computation | Not enabled by default | Only with deterministic/verifiable workloads |
| Participation rewards | Test points | Transferable rewards only after economic/security review |
| QR payments | Mobile milestone | Production wallet UX |
| Offline signing | Mobile milestone | Hardened transaction/sequence handling |
| Faucet | Devnet | Abuse controls and quotas |
| Explorer | Devnet | Production indexer/HA deployment |
| Monitoring | Devnet | SRE/alerting/incident response |
| Public testnet | Later | Several-month adversarial testnet |
| Mainnet/token sale | No | Legal + security + economic gates first |

## Architectural decisions

### Do not make phones consensus validators in v1

Phones have intermittent connectivity, OS background limits, heterogeneous hardware and battery constraints. They should initially verify and contribute bounded, measurable work while professional validators maintain consensus.

### Do not make "app open time" a reward primitive

It is cheap to automate and has little network utility. Participation rewards must correspond to independently verifiable work.

### Do not equate device with person

A device-bound key is an anti-abuse signal, not proof that one device equals one human. Identity providers must remain modular.

### Do not put PII on-chain

Names, phone numbers, identity documents and similar information remain off-chain. On-chain records should contain only the minimum commitments/claims required by protocol logic.

## Definition of done for the first real chain

The repository is not considered a functional blockchain until the CI pipeline can build `lumend`, local validators can initialize from reproducible genesis, CometBFT can produce blocks, and automated tests demonstrate transfers, staking/delegation, governance and restart/recovery behavior.

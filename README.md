# LumenChain

LumenChain is a **mobile-first, low-energy Layer-1 research and testnet project**. The design uses conventional Proof-of-Stake (PoS) BFT consensus for block production while allowing ordinary phones and laptops to contribute through secure wallets, light-client verification, delegated staking, and bounded participation tasks.

> **Important:** LumenChain is experimental software. Testnet participation is not a promise of income, and no mainnet token sale or economic launch is part of the current MVP.

## Architecture

- `chain/` — Cosmos SDK application, CometBFT integration, protobufs, modules, and chain tests
- `node/` — operator tooling, configuration, backup, upgrade, and installation automation
- `contracts/` — staged CosmWasm smart-contract area; not required for the first devnet
- `mobile/` — Android wallet, shared wallet code, and light-client integration
- `services/` — faucet, indexer, relayer, and notifications
- `explorer/` — explorer API/web application
- `testnet/` — reproducible local and public-testnet configuration/genesis tooling
- `infrastructure/` — Docker, Kubernetes, and monitoring assets
- `docs/` — protocol, security, economics, privacy, participation, and operator specifications
- `security/` — audits, fuzzing, threat models, and incident response

## Current target: Devnet v0.1

The first real engineering milestone is a reproducible 5-validator development network with:

1. Cosmos SDK + CometBFT BFT PoS consensus
2. Native LUM test denomination
3. Standard accounts and transfers
4. Staking, delegation, redelegation, and undelegation
5. Basic validator/delegator rewards
6. Governance
7. Faucet and explorer foundations
8. Android wallet foundation with local key protection
9. Mobile light-client verification before trusting chain state
10. Participation events and non-transferable test points

Phones are **not** consensus validators in v0.1. Full validators run on reliable servers; mobile clients remain wallet/light-client/participation clients. This keeps the initial security boundary realistic for battery, connectivity, OS, and device-heterogeneity constraints.

## Security principles

- Private keys never leave the device.
- Android Keystore / hardware-backed protection is used where available.
- PIN/biometric unlock protects local wallet access; recovery material remains the ultimate backup.
- RPC endpoints are treated as untrusted data sources.
- Light-client verification must validate cryptographic evidence locally.
- Stale or invalid chain state must be rejected.
- No names, phone numbers, government IDs, or other PII are stored on-chain.
- Participation rewards are separated from transferable token economics until anti-Sybil and economic security are demonstrated.

## Development status

The repository currently contains the architecture, ADRs, requirements mapping, bootstrap automation, and documentation foundation. The Cosmos SDK chain source is generated through the repository bootstrap workflow; until that workflow has completed successfully, the checked-in `chain/` application should be treated as a scaffold rather than a production-ready blockchain.

See:

- `docs/requirements-mapping.md` — requirement-to-implementation mapping
- `docs/protocol-spec.md` — protocol specification and staged implementation contract
- `docs/token-economics.md` — provisional economics; not a launch allocation
- `docs/threat-model.md` — security assumptions and threats
- `docs/wallet-security.md` — mobile key-management boundary
- `docs/participation-design.md` — participation and anti-Sybil direction
- `docs/devnet-v0.1.md` — devnet acceptance criteria
- `docs/validator-guide.md` — validator/operator plan

## Non-goals for the MVP

Proof-of-personhood as a mandatory protocol primitive, ZK identity, shielded transfers, useful-computation markets, bridges/L2s, phone consensus validators, transferable participation rewards, mainnet token issuance, and public token sales are intentionally deferred until the relevant security, performance, economic, privacy, and legal reviews are complete.

## License

License and contribution policy will be finalized before public testnet onboarding.

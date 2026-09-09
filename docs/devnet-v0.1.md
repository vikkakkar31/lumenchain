# Devnet v0.1 execution plan

## What is now real

The chain implementation is being moved from a hand-written placeholder to a generated, runnable Cosmos SDK application. The scaffold uses Cosmos SDK's standard application architecture: the SDK application owns deterministic state and modules, while CometBFT owns consensus/networking and communicates with the application through ABCI.

## MVP transactions

Once the generated application is committed, these standard Cosmos SDK flows are available for integration tests:

1. create/import an account
2. fund an account with test `ulum`
3. bank send
4. create a validator
5. delegate
6. redelegate
7. undelegate
8. query validator/delegation state
9. query distribution rewards
10. submit/vote on governance proposals

## Lumen-specific work

The `x/participation` and `x/rewards` modules are deliberately separate from core staking. This keeps the economic experiment isolated from validator security logic. Participation will initially record testnet activity and measurements; rewards will initially expose test-only/non-transferable accounting rather than a transferable token economy.

## Verification requirements

Before calling devnet v0.1 stable, CI and integration tests must demonstrate:

- deterministic genesis and repeatable node initialization
- two or more RPC endpoints can broadcast the same signed transaction safely
- stale/invalid light-client evidence is rejected by the mobile verifier
- validator restart/rejoin works
- delegation and undelegation state transitions are correct
- duplicate transaction submission is safe
- private keys never enter logs, analytics or backend requests
- faucet cannot be trivially drained
- mobile clients remain usable with intermittent connectivity

## Production gate

No mainnet or transferable token launch should happen from this scaffold alone. The production gate requires threat-model review, adversarial testing, independent audit, key-management design, upgrade rehearsal, validator operations documentation, monitoring and incident-response readiness.

# LumenChain Mobile Light-Client Security

> Status: Draft / Devnet v0.1

The mobile wallet must not trust an RPC response merely because it is well-formed. Chain state used for security-sensitive wallet decisions must be backed by locally verified light-client evidence.

## Trust bootstrap

The wallet requires an explicitly configured initial trusted height and validator-set commitment/checkpoint. This trust anchor must be distributed through a documented release/configuration process and must not be silently replaced by an RPC server.

## Verification

For each update, the light client should verify the required header/commit signatures and validator-set transition according to the selected light-client protocol. The client must reject invalid evidence, inconsistent validator transitions, and updates outside the configured trust period.

## RPC diversity

RPC providers are convenience transports, not trust anchors. The wallet should support multiple configured endpoints and should avoid treating one endpoint's response as authoritative when independent verification is possible.

## Offline/intermittent connectivity

The wallet may prepare transactions offline. It must clearly distinguish:

- locally created/signed transaction;
- transaction broadcast but not yet confirmed;
- chain state verified by light-client evidence;
- chain state merely queried from an RPC.

## Failure behavior

If verification cannot be completed, the secure default is to fail closed for operations that depend on current chain state. The wallet must not silently downgrade to unverified state for balance, staking, or validator decisions that could cause loss of funds.

## Key boundary

The light client never receives or derives the wallet's private signing key. Verification code may consume public chain data, proofs, and headers; signing remains isolated behind the platform secure-storage boundary.

## Test requirements

Before public testnet release, add tests for invalid signatures, stale headers, malformed proofs, validator-set changes, conflicting RPC responses, corrupted local checkpoints, and intermittent connectivity/recovery.

# Wallet Security

> Status: Draft

## Security Goals

The wallet must protect signing keys and prevent unauthorized transaction approval while keeping recovery and account operations understandable to users.

## Key Management Principles

- Private keys must never be logged or transmitted in plaintext.
- Sensitive material should use platform-secure storage where available.
- Signing should be explicit and bound to the intended transaction.
- Backup and recovery flows must clearly communicate their security implications.
- Debug builds must not weaken production key protections silently.

## Android Considerations

The Android wallet should use the platform's hardware-backed or secure key facilities where supported, with documented fallback behavior for unsupported devices.

## Open Questions

- Account/key format
- Recovery model
- Hardware-wallet support
- Transaction display and signing UX
- Key rotation and revocation strategy

# ADR-0004: Light-Client Trust Model

The wallet must verify cryptographic evidence locally rather than trusting a single backend response.

The implementation must define:

- Initial trusted validator-set/checkpoint
- Validator-set update verification
- Multiple RPC/provider fallback
- Stale-chain detection
- Offline behavior
- Invalid-proof handling

Detailed parameters belong in the protocol specification before production deployment.

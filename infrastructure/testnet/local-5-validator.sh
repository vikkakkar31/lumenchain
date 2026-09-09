#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
CHAIN_DIR="$ROOT_DIR/chain"
BIN_DIR="$CHAIN_DIR/bin"
DATA_DIR="$CHAIN_DIR/.devnet"
CHAIN_ID="lumen-devnet-1"
DENOM="ulum"
VALS=5

rm -rf "$DATA_DIR"
mkdir -p "$BIN_DIR" "$DATA_DIR"

echo "==> Building lumend"
(cd "$CHAIN_DIR" && go build -o "$BIN_DIR/lumend" ./cmd/lumend)

LUMEND="$BIN_DIR/lumend"

for i in $(seq 1 "$VALS"); do
  HOME="$DATA_DIR/validator$i"
  echo "==> Initializing validator $i"
  "$LUMEND" init "lumen-validator-$i" --chain-id "$CHAIN_ID" --home "$HOME" >/dev/null
  "$LUMEND" keys add "validator$i" --keyring-backend test --home "$HOME" --output json > "$HOME/key.json"
  "$LUMEND" genesis add-genesis-account "validator$i" "1000000000${DENOM}" --keyring-backend test --home "$HOME"
  "$LUMEND" genesis gentx "validator$i" "100000000${DENOM}" --chain-id "$CHAIN_ID" --keyring-backend test --home "$HOME"
done

# Combine all validator gentxs into validator1's genesis.
for i in $(seq 2 "$VALS"); do
  cp "$DATA_DIR/validator$i/config/gentx/"*.json "$DATA_DIR/validator1/config/gentx/"
done
"$LUMEND" genesis collect-gentxs --home "$DATA_DIR/validator1"

GENESIS="$DATA_DIR/validator1/config/genesis.json"
for i in $(seq 2 "$VALS"); do
  mkdir -p "$DATA_DIR/validator$i/config"
  cp "$GENESIS" "$DATA_DIR/validator$i/config/genesis.json"
done

# Configure isolated localhost ports. All validators share the same genesis.
for i in $(seq 1 "$VALS"); do
  HOME="$DATA_DIR/validator$i"
  P2P=$((26655 + i))
  RPC=$((26656 + i))
  GRPC=$((9090 + i))
  API=$((1317 + i))

  python3 - "$HOME/config/config.toml" "$P2P" "$RPC" "$i" <<'PY'
from pathlib import Path
import sys
p = Path(sys.argv[1])
p2p, rpc, idx = sys.argv[2:]
s = p.read_text()
s = s.replace('laddr = "tcp://127.0.0.1:26656"', f'laddr = "tcp://127.0.0.1:{p2p}"')
s = s.replace('laddr = "tcp://127.0.0.1:26657"', f'laddr = "tcp://127.0.0.1:{rpc}"')
s = s.replace('persistent_peers = ""', 'persistent_peers = "__PEERS__"')
s = s.replace('timeout_commit = "5s"', 'timeout_commit = "2s"')
p.write_text(s)

p = Path(sys.argv[1]).parent.parent / 'config' / 'app.toml'
s = p.read_text()
s = s.replace('address = "localhost:9090"', f'address = "localhost:{int(sys.argv[3])}"')
s = s.replace('address = "tcp://localhost:1317"', f'address = "tcp://localhost:{1317 + int(sys.argv[3])}"')
p.write_text(s)
PY
done

PEERS=""
for i in $(seq 1 "$VALS"); do
  HOME="$DATA_DIR/validator$i"
  NODE_ID=$("$LUMEND" comet show-node-id --home "$HOME")
  P2P=$((26655 + i))
  ENTRY="${NODE_ID}@127.0.0.1:${P2P}"
  if [[ -n "$PEERS" ]]; then PEERS+=","; fi
  PEERS+="$ENTRY"
done

for i in $(seq 1 "$VALS"); do
  HOME="$DATA_DIR/validator$i"
  python3 - "$HOME/config/config.toml" "$PEERS" "$i" <<'PY'
from pathlib import Path
import sys
p = Path(sys.argv[1])
peers = sys.argv[2]
idx = int(sys.argv[3])
s = p.read_text().replace('persistent_peers = "__PEERS__"', f'persistent_peers = "{peers}"')
p.write_text(s)
PY
done

echo
cat <<EOF
LumenChain 5-validator devnet initialized.

Chain ID: $CHAIN_ID
Token:    $DENOM
RPCs:
EOF
for i in $(seq 1 "$VALS"); do echo "  validator$i -> http://127.0.0.1:$((26656 + i))"; done

echo
cat <<EOF
Start all validators with:
  for i in {1..5}; do $LUMEND start --home $DATA_DIR/validator\$i > $DATA_DIR/validator\$i.log 2>&1 & done

This is a development/testnet script only. Do not reuse generated validator keys for production.
EOF

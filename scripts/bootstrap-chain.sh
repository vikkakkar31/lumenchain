#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
CHAIN_DIR="$ROOT_DIR/chain"
TMP_DIR="$(mktemp -d)"
trap 'rm -rf "$TMP_DIR"' EXIT

IGNITE_VERSION="v28.11.0"
MODULE_PATH="github.com/vikkakkar31/lumenchain/chain"

command -v go >/dev/null || { echo "Go is required" >&2; exit 1; }
command -v python3 >/dev/null || { echo "Python 3 is required" >&2; exit 1; }

echo "Using $(go env GOVERSION)"
echo "Installing Ignite CLI ${IGNITE_VERSION}..."
go install "github.com/ignite/cli/v28/ignite@${IGNITE_VERSION}"
export PATH="$(go env GOPATH)/bin:$PATH"
ignite version

echo "Scaffolding Cosmos SDK chain..."
rm -rf "$TMP_DIR/lumenchain"
ignite scaffold chain "$MODULE_PATH" --address-prefix lumen --no-module --skip-git --path "$TMP_DIR/lumenchain"

# Fail before touching the checked-in chain if scaffolding did not produce a complete app.
test -f "$TMP_DIR/lumenchain/app/app.go"
test -f "$TMP_DIR/lumenchain/cmd/lumend/main.go"
test -f "$TMP_DIR/lumenchain/go.mod"
test -f "$TMP_DIR/lumenchain/go.sum"
test -d "$TMP_DIR/lumenchain/proto"
test -d "$TMP_DIR/lumenchain/x"

echo "Installing generated Cosmos SDK application into repository..."
rm -rf "$CHAIN_DIR/app" "$CHAIN_DIR/cmd" "$CHAIN_DIR/proto" "$CHAIN_DIR/x" "$CHAIN_DIR/go.mod" "$CHAIN_DIR/go.sum" "$CHAIN_DIR/config.yml" "$CHAIN_DIR/Makefile"
cp -R "$TMP_DIR/lumenchain/app" "$CHAIN_DIR/"
cp -R "$TMP_DIR/lumenchain/cmd" "$CHAIN_DIR/"
cp -R "$TMP_DIR/lumenchain/proto" "$CHAIN_DIR/"
cp -R "$TMP_DIR/lumenchain/x" "$CHAIN_DIR/"
cp "$TMP_DIR/lumenchain/go.mod" "$CHAIN_DIR/"
cp "$TMP_DIR/lumenchain/go.sum" "$CHAIN_DIR/"
cp "$TMP_DIR/lumenchain/config.yml" "$CHAIN_DIR/"
cp "$TMP_DIR/lumenchain/Makefile" "$CHAIN_DIR/"

# Add the LumenChain-specific modules. Ignite wires them into app/app.go and creates
# protobuf/module boilerplate that we can then implement incrementally.
cd "$CHAIN_DIR"
ignite scaffold module participation --dep bank,staking --require-registration
ignite scaffold module rewards --dep bank,staking,distribution --require-registration

# LumenChain development defaults. These are deliberately test-only values.
python3 - <<'PY'
from pathlib import Path
p = Path("config.yml")
s = p.read_text()
s = s.replace("chain_id: lumenchain", "chain_id: lumen-devnet-1") if "chain_id:" in s else s
if "genesis:" not in s:
    s += "\n\ngenesis:\n  chain_id: lumen-devnet-1\n  app_state:\n    staking:\n      params:\n        bond_denom: ulum\n    mint:\n      params:\n        mint_denom: ulum\n"
p.write_text(s)
PY

cat > .chain-generated <<'EOF'
LumenChain chain source generated from Ignite CLI v28.11.0.
The generated application uses Cosmos SDK v0.50.x and CometBFT v0.38.x.
EOF

echo "Chain scaffold complete."

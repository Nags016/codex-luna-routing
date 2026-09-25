#!/usr/bin/env bash
# CODEX-GPT-6-LUNA-TOKEN installer
# Routes Codex default work to GPT-5.6 Luna (cheapest lane) + adds budget-discipline rules.
# Existing config.toml and AGENTS.md are backed up before anything is overwritten.

set -euo pipefail

CODEX_DIR="${HOME}/.codex"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TS="$(date +%Y%m%d-%H%M%S)"

bold() { printf '\033[1m%s\033[0m\n' "$1"; }
warn() { printf '\033[33m%s\033[0m\n' "$1"; }
ok()   { printf '\033[32m%s\033[0m\n' "$1"; }

mkdir -p "${CODEX_DIR}"

if ! command -v codex >/dev/null 2>&1; then
  warn "Codex CLI not found in PATH."
  warn "Install it first:  npm i -g @openai/codex && codex login"
  exit 1
fi

# --- Backup existing files ---
for f in config.toml AGENTS.md; do
  if [[ -f "${CODEX_DIR}/${f}" ]]; then
    cp "${CODEX_DIR}/${f}" "${CODEX_DIR}/${f}.bak-${TS}"
    ok "Backed up ${f} -> ${f}.bak-${TS}"
  fi
done

# --- Install ---
cp "${SCRIPT_DIR}/config.toml" "${CODEX_DIR}/config.toml"
cp "${SCRIPT_DIR}/AGENTS.md"   "${CODEX_DIR}/AGENTS.md"
ok "Installed config.toml and AGENTS.md to ${CODEX_DIR}"

# --- Verify config parses ---
if python3 - "$CODEX_DIR/config.toml" <<'PY' 2>/dev/null
import sys
try:
    import tomllib
except ModuleNotFoundError:
    sys.exit(0)  # python < 3.11: skip validation
with open(sys.argv[1], "rb") as fh:
    tomllib.load(fh)
PY
then
  ok "Config validated."
else
  warn "Could not auto-validate config (old python or parse issue). Run 'codex --version' to check it loads."
fi

bold ""
bold "Done. Default lane is now GPT-5.6 Luna at low reasoning."
echo "
Usage:
  codex                        # everyday work -> Luna low (cheapest)
  codex --profile luna-med     # multi-file edits
  codex --profile luna-high    # harder changes
  codex --profile luna-max     # Luna at full depth
  codex --profile terra        # Luna got the judgment wrong
  codex --profile terra-high   # hardest problems only

Uninstall anytime:
  bash $(dirname "$0")/uninstall.sh
"

#!/usr/bin/env bash
# Restores your pre-install Codex config.
# For each installed file: restores the newest .bak-<timestamp> if one exists,
# otherwise removes the file (it didn't exist before install).

set -euo pipefail

CODEX_DIR="${HOME}/.codex"
ok()   { printf '\033[32m%s\033[0m\n' "$1"; }
warn() { printf '\033[33m%s\033[0m\n' "$1"; }

for f in config.toml AGENTS.md; do
  newest_bak="$(ls -1t "${CODEX_DIR}/${f}".bak-* 2>/dev/null | head -n 1 || true)"
  if [[ -n "${newest_bak}" ]]; then
    cp "${newest_bak}" "${CODEX_DIR}/${f}"
    ok "Restored ${f} from ${newest_bak##*/}"
  elif [[ -f "${CODEX_DIR}/${f}" ]]; then
    rm "${CODEX_DIR}/${f}"
    ok "Removed ${f} (no backup existed — it was created by the installer)"
  else
    warn "${f} not found — nothing to do"
  fi
done

ok "Uninstalled. Restart any running Codex sessions."

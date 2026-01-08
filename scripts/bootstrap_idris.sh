#!/usr/bin/env bash
set -euo pipefail

if command -v idris >/dev/null 2>&1; then
  echo "Idris already installed: $(idris --version)"
  exit 0
fi

cat <<'MESSAGE'
Idris is optional for ResearchProof and is not required for the built-in proof checker.

If you want to cross-check proofs with the Idris compiler, install Idris manually
using your system package manager or from source, then re-run this script.
MESSAGE

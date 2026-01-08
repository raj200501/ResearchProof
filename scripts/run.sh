#!/usr/bin/env bash
set -euo pipefail

REPO_ROOT=$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)

if [[ $# -ge 1 ]]; then
  python3 -m researchproof.cli verify "$1"
else
  python3 -m researchproof.cli verify "${REPO_ROOT}/examples/quickstart.rp"
fi

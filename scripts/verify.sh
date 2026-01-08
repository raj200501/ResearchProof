#!/usr/bin/env bash
set -euo pipefail

REPO_ROOT=$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)

chmod +x "${REPO_ROOT}/build/build.sh"
"${REPO_ROOT}/build/build.sh"

python3 -m unittest discover -s "${REPO_ROOT}/tests_python"

python3 -m researchproof.cli verify "${REPO_ROOT}/examples/quickstart.rp"
python3 -m researchproof.cli verify "${REPO_ROOT}/examples/nat_properties.rp"
python3 -m researchproof.cli verify "${REPO_ROOT}/examples/extended_catalog.rp"

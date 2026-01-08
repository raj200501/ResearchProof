"""Command-line interface for ResearchProof."""

from __future__ import annotations

import argparse
from pathlib import Path

from researchproof.errors import ProofLanguageError
from researchproof.proof_checker import verify_theorems
from researchproof.proof_language import parse_text


def _load_text(path: Path) -> str:
    return path.read_text(encoding="utf-8")


def cmd_verify(args: argparse.Namespace) -> int:
    proof_path = Path(args.proof_file)
    text = _load_text(proof_path)
    theorems = parse_text(text)
    verify_theorems(theorems)
    print(f"Verified {len(theorems)} theorem(s) from {proof_path}.")
    return 0


def cmd_render(args: argparse.Namespace) -> int:
    proof_path = Path(args.proof_file)
    text = _load_text(proof_path)
    theorems = parse_text(text)
    output_path = Path(args.output)
    output_path.write_text(text, encoding="utf-8")
    print(f"Copied proof script with {len(theorems)} theorem(s) to {output_path}.")
    return 0


def build_parser() -> argparse.ArgumentParser:
    parser = argparse.ArgumentParser(description="ResearchProof proof verification tool")
    subparsers = parser.add_subparsers(dest="command", required=True)

    verify_parser = subparsers.add_parser("verify", help="Verify proofs with the built-in checker")
    verify_parser.add_argument("proof_file", help="Path to a .rp proof script")
    verify_parser.set_defaults(func=cmd_verify)

    render_parser = subparsers.add_parser("render", help="Copy a proof script to a new location")
    render_parser.add_argument("proof_file", help="Path to a .rp proof script")
    render_parser.add_argument("output", help="Output proof script path")
    render_parser.add_argument("--module-name", default="GeneratedProofs", help="Module name")
    render_parser.set_defaults(func=cmd_render)

    return parser


def main() -> int:
    parser = build_parser()
    args = parser.parse_args()
    try:
        return args.func(args)
    except ProofLanguageError as exc:
        print(f"Error: {exc}")
        return 1


if __name__ == "__main__":
    raise SystemExit(main())

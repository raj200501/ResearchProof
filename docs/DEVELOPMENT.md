# ResearchProof Development Guide

This guide is for contributors who want to extend ResearchProof. It covers the internal
architecture, how the tooling fits together, and what to update when you add new proofs.

## Repository layout

- `src/` contains Idris reference code.
- `src/Proof/` contains the proof library and foundational definitions.
- `researchproof/` contains the Python CLI and proof checker.
- `examples/` contains proof script examples that are used as templates and smoke tests.
- `scripts/` contains build and verification helpers.
- `docs/` contains user-facing documentation and references.

## Proof checker architecture

The proof checker is implemented in Python and focuses on a well-defined subset of
Idris-like syntax:

- Theorem signatures and proof expressions are parsed by `researchproof/proof_language.py`.
- Signature parsing and evaluation live in `researchproof/proof_checker.py`.
- Lemmas are stored in `researchproof/lemma_catalog.py`.

The Idris sources under `src/Proof/` are included for reference and documentation. They
are not required for the Python verification pipeline.

## Proof scripts and the CLI

The CLI (`python -m researchproof.cli`) parses `.rp` files and validates each theorem
against the proof checker. It does not call out to Idris or external tooling.

Key files:

- `researchproof/proof_language.py` – parser for `.rp` files.
- `researchproof/proof_checker.py` – proof checking, evaluation, and signature matching.
- `researchproof/lemma_catalog.py` – catalog of available lemmas.
- `researchproof/cli.py` – CLI wiring and user-facing commands.

## Testing strategy

The verification pipeline performs three kinds of checks:

1. **Build step** – `./build/build.sh` compiles the Python modules.
2. **Unit tests** – `python -m unittest discover -s tests_python` exercises the parser and
   proof checker.
3. **Smoke proofs** – the CLI verifies example proof scripts.

The smoke tests in `scripts/verify.sh` exercise the full path (parser -> checker -> CLI).

## Adding new lemmas

When adding a new lemma:

1. Add it to `researchproof/lemma_catalog.py`.
2. Update `docs/PROOF_LIBRARY.md`.
3. Add an example proof script that exercises it.
4. Extend unit tests if the checker needs new evaluation rules.

## Updating the proof checker

If you add new syntax:

- Update the tokenizer in `researchproof/proof_checker.py`.
- Add parsing support in the AST parser.
- Update evaluation rules so `Refl` proofs can normalize the new terms.
- Add unit tests under `tests_python/`.

## Debugging proof failures

The CLI prints explicit error messages, including mismatched lemma signatures and failed
normalization steps. Use the error output to identify whether the issue is a parsing
problem, a missing lemma, or a definitional equality that does not hold.

## Coding conventions

- Keep proofs total in Idris reference modules.
- Prefer explicit type signatures for public functions.
- Keep proof scripts and checker syntax line-based for simplicity.
- Avoid introducing new external dependencies unless absolutely necessary.

## Optional Idris verification

If you want to cross-check the proof library with Idris, install Idris manually and use
it outside the verification pipeline. This is optional and not required for CI.

# Troubleshooting ResearchProof

This guide lists common issues when building or running ResearchProof and how to resolve
them. All fixes are deterministic and safe to run locally or in CI.

## Proof checker build errors

**Symptoms**

- `python3 -m compileall` fails.
- `./build/build.sh` exits non-zero.

**Resolution**

- Ensure you are running commands from the repository root.
- Confirm you are using Python 3.9+.
- Re-run the build command to see the specific syntax error.

## Proof script parsing errors

**Symptoms**

- `Expected 'theorem <name> : <type>' at line X`
- `Missing ':' in theorem declaration`
- `Expected 'proof <expression>' after theorem ...`

**Resolution**

Check the `.rp` file formatting:

- Every `theorem` must be followed by a `proof` line.
- Signatures must stay on a single line.
- `proof` expressions must be on a single line.

Example of a valid declaration:

```
theorem plus_zero_right : (n : Nat) -> plus n Z = n
proof plusZeroRight n
```

## Proof checker errors

**Symptoms**

- `Unknown lemma` errors.
- `Theorem signature does not match lemma signature`.
- `Refl failed` errors.

**Resolution**

- Verify the lemma name appears in `researchproof/lemma_catalog.py`.
- Ensure the theorem signature matches the lemma signature exactly.
- If using `Refl`, make sure both sides of the equality reduce to the same value.

## Build fails in CI

**Symptoms**

- GitHub Actions job fails during `scripts/verify.sh`.
- The logs show Python errors or proof checker failures.

**Resolution**

- Run `./scripts/verify.sh` locally to replicate the failure.
- Inspect the error output for the first failing step.
- Check for typos in proof scripts.

## Proof scripts rely on multi-line expressions

**Symptoms**

- Parser errors even though the expression is correct across multiple lines.

**Resolution**

The proof language is intentionally single-line. Split complex work into helper lemmas or
use smaller helper definitions in `researchproof/lemma_catalog.py`.

## Python test failures

**Symptoms**

- `python -m unittest` reports parsing or checker errors.

**Resolution**

- Ensure you are running tests from the repository root.
- Verify that `examples/quickstart.rp` exists and is correct.
- Check the proof checker output for the exact mismatched lemma.

## Optional Idris cross-checks

ResearchProof ships Idris reference sources in `src/Proof/`. If you want to compare proofs
with Idris, install Idris manually and compile the Idris sources separately. This is
optional and not required by the verification pipeline.

## Getting additional help

If you are still stuck:

- Review the proof library sources in `src/Proof/`.
- Check the proof script reference in `docs/PROOF_LANGUAGE.md`.
- Use the `examples/` directory as a source of known-good proofs.

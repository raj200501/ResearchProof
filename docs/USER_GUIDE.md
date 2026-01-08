# ResearchProof User Guide

This guide expands the README with additional context, longer examples, and explanations of
how the ResearchProof toolchain fits together. It is intended for researchers who want
repeatable proof checking and for engineers who want to extend the library.

## Overview

ResearchProof provides two layers:

1. **Proof library** (`src/Proof/*.idr`) that documents the math objects and lemmas.
2. **Proof checker** (`python -m researchproof.cli`) that parses `.rp` proof scripts and
   verifies them using the built-in checker.

The proof checker is Idris-inspired but implemented entirely in Python. The Idris sources
are included as a reference and do not need to be compiled for verification.

## Quick flow

1. Write a proof script using the ResearchProof proof language.
2. Run `scripts/run.sh path/to/file.rp` to verify the proofs.
3. Use `scripts/verify.sh` to run the full verification pipeline (build, tests, smoke checks).

## Anatomy of a proof script

A proof script contains a sequence of theorem declarations. Each declaration is two lines:

- `theorem <name> : <signature>`
- `proof <expression>`

Example:

```
# my_proofs.rp

theorem plus_zero_right : (n : Nat) -> plus n Z = n
proof plusZeroRight n

# A lemma that just reuses an existing proof function

theorem mult_one_right : (n : Nat) -> mult n (S Z) = n
proof multOneRight n
```

When you run `researchproof verify`, the CLI validates each theorem against the proof
checker. The checker accepts `Refl` for definitional equalities and lemma names that match
the built-in proof catalog.

## Proof script rules

- Lines starting with `#` are comments.
- Blank lines are ignored.
- Theorem declarations must be a single line. Long signatures should stay on one line.
- Proof expressions are one line and must be either `Refl` or a lemma name.

## Running the built-in examples

The repository provides example scripts in `examples/`:

- `examples/quickstart.rp` – the basic proofs used by the README.
- `examples/nat_properties.rp` – natural number identities.
- `examples/bool_properties.rp` – boolean algebra.
- `examples/list_properties.rp` – list operations and proofs.
- `examples/logic_properties.rp` – propositional logic.
- `examples/arith_properties.rp` – arithmetic utilities.

To verify any script:

```
./scripts/run.sh examples/nat_properties.rp
```

## Writing your own theorems

There are two ways to extend the proof library:

1. **Write a proof script that uses existing library lemmas.**
   This is the fastest path if your theorem can be expressed using `Proof.Nat`,
   `Proof.List`, or `Proof.Bool`.
2. **Add new lemmas to the proof checker.**
   Update `researchproof/lemma_catalog.py`, add a proof script example, and document the
   lemma in `docs/PROOF_LIBRARY.md`.

## Example: verifying multiple theorems

```
# examples/my_batch.rp

theorem double_is_plus : (n : Nat) -> double n = plus n n
proof doubleIsPlus n

theorem reverse_involutive : (xs : List Nat) -> reverse (reverse xs) = xs
proof reverseInvolutive xs

# Logic examples with implicit type arguments

theorem and_comm : And a b -> And b a
proof andComm
```

Then run:

```
./scripts/run.sh examples/my_batch.rp
```

## Common proof patterns

### Using a library lemma

If a lemma already exists, just use it directly in the proof expression:

```
proof plusComm x y
```

### Using definitional equality

Some equalities are definitional and can be proven with `Refl`.
For example, `plus Z (S Z) = S Z` reduces by evaluation.
You can express that in a proof script:

```
proof Refl
```

## Running in automation

The canonical verification command is:

```
./scripts/verify.sh
```

It will:

1. Build the Python checker.
2. Run Python unit tests for the proof language parser and checker.
3. Execute smoke proof scripts to confirm the end-to-end workflow.

## Extending the library safely

When you add new lemmas:

- Keep them total in the Idris reference modules.
- Update the proof catalog in `researchproof/lemma_catalog.py`.
- Add an example proof script that exercises the new lemma.

## Directory map

```
src/                      Idris reference sources
src/Proof/                Proof modules grouped by topic
examples/                 Proof scripts (.rp)
researchproof/            Python CLI and proof checker
scripts/                  Run and verify scripts
build/                    Build helpers
```

## Next steps

- Read `docs/PROOF_LANGUAGE.md` for the formal proof script specification.
- Browse `docs/PROOF_LIBRARY.md` for the proof library catalog.
- Run `./scripts/verify.sh` before contributing changes.

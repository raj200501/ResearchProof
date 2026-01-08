# ResearchProof Proof Script Language

This document defines the ResearchProof proof script language (`.rp` files). The language
is intentionally small so that proof scripts are easy to read, diff, and review.

## Goals

- Keep proofs readable for reviewers who know basic Idris-style syntax.
- Provide deterministic proof checking without external dependencies.
- Encourage reuse of library lemmas and shared proof techniques.

## File structure

A proof script is a plain-text file with a sequence of theorem declarations. Each
statement is two lines:

```
theorem <name> : <signature>
proof <expression>
```

### Example

```
# plus_zero_right.rp

theorem plus_zero_right : (n : Nat) -> plus n Z = n
proof plusZeroRight n
```

### Comments and whitespace

- Lines beginning with `#` are comments.
- Trailing comments are allowed: `theorem ... # comment`.
- Blank lines are ignored.

## Grammar

The grammar is line-based. The following EBNF describes the syntax at a high level:

```
file           := (blank | comment | theorem-block)*
blank          := <empty line>
comment        := '#' <any characters>
theorem-block  := theorem-line proof-line

theorem-line   := 'theorem' WS name WS ':' WS signature
proof-line     := 'proof' WS expression

name           := <identifier>
signature      := <proof checker type expression, one line>
expression     := <proof checker term expression, one line>
```

The proof checker accepts a subset of Idris-like syntax. It does not execute Idris; it
parses the signature and checks it against the built-in lemma catalog.

## Semantics

Every theorem declaration is checked in one of two ways:

1. **`Refl` proofs**: the checker evaluates both sides of the equality and confirms they
   normalize to the same value.
2. **Lemma proofs**: the checker ensures the theorem signature matches a lemma in the
   catalog (`researchproof/lemma_catalog.py`).

## Valid identifiers

The theorem name must be a valid identifier. Recommended naming conventions:

- `snake_case` for proof names (`plus_zero_right`)
- Keep names descriptive and scoped to the domain (`reverse_involutive`)

## Error reporting

The parser produces friendly errors for:

- Missing `theorem` keyword.
- Missing `proof` lines.
- Missing `:` delimiter in a theorem declaration.

The proof checker reports mismatches between theorem signatures and known lemmas, or
when `Refl` does not hold for the given equality.

Proof expressions are restricted to either `Refl` or a lemma name (optionally applied to
arguments). Arbitrary proof terms are not supported.

## Practical guidance

### Use the proof library when possible

Most day-to-day proofs should reuse the library instead of re-proving core lemmas. The
library is documented in `docs/PROOF_LIBRARY.md`.

### Keep signatures short

The parser is line-based, so long signatures should remain on a single line. You can
always introduce helper lemmas if you need multi-line structure.

### Prefer definitional equalities

Proofs that reduce by computation can be written with `Refl`:

```
theorem add_zero_right : plus Z (S Z) = S Z
proof Refl
```

### Using implicit arguments

Many lemmas rely on implicit type arguments. You can omit them in the proof script and
let the checker infer them:

```
theorem and_comm : And a b -> And b a
proof andComm
```

## Example scripts

The repository ships with several proof script examples:

- `examples/quickstart.rp` - the minimum viable verification flow
- `examples/nat_properties.rp` - natural number identities
- `examples/bool_properties.rp` - boolean algebra
- `examples/list_properties.rp` - list properties and folds
- `examples/logic_properties.rp` - propositional logic
- `examples/arith_properties.rp` - arithmetic utilities

These files are useful for reference and as templates for new proof scripts.

## Limitations

- Proof scripts are line-based and do not support multi-line expressions.
- The proof language does not support arbitrary Idris modules or imports.
- The checker only understands the built-in lemma catalog and basic evaluation rules.

## Rationale

The line-based format keeps proof review simple and encourages modularization. The
ResearchProof checker is transparent and deterministic, making it easier to use in CI
and offline environments.

# ResearchProof Case Studies

These case studies demonstrate how ResearchProof can be used to formalize and verify
proof fragments commonly found in academic papers. Each case study includes the proof
script and the relevant library lemma references.

## Case study 1: Natural number identities

**Goal**: Verify that adding zero and multiplying by one are identity operations.

Proof script:

```
# case_study_nat.rp

theorem plus_zero_right : (n : Nat) -> plus n Z = n
proof plusZeroRight n

theorem plus_zero_left : (n : Nat) -> plus Z n = n
proof plusZeroLeft n

theorem mult_one_right : (n : Nat) -> mult n (S Z) = n
proof multOneRight n

theorem mult_one_left : (n : Nat) -> mult (S Z) n = n
proof multOneLeft n
```

**Outcome**: The proofs are accepted by the built-in checker using the lemma catalog.

## Case study 2: Proving associativity of append

**Goal**: Verify that list concatenation is associative.

Proof script:

```
# case_study_list.rp

theorem append_assoc : (xs : List Nat) -> (ys : List Nat) -> (zs : List Nat) ->
  append (append xs ys) zs = append xs (append ys zs)
proof appendAssoc xs ys zs
```

**Outcome**: The proof is accepted using the library lemma `appendAssoc`.

## Case study 3: Double evenness

**Goal**: Show that doubling a number yields an even number.

Proof script:

```
# case_study_even.rp

theorem even_double : (n : Nat) -> even (double n) = True
proof evenDouble n
```

**Outcome**: The lemma `evenDouble` is accepted, demonstrating that evenness is preserved.

## Case study 4: Boolean De Morgan's law

**Goal**: Verify a boolean version of De Morgan's law.

Proof script:

```
# case_study_bool.rp

theorem not_and : (a : Bool) -> (b : Bool) -> not (and a b) = or (not a) (not b)
proof notAnd a b

theorem not_or : (a : Bool) -> (b : Bool) -> not (or a b) = and (not a) (not b)
proof notOr a b
```

**Outcome**: Both proofs are accepted, aligning with classical boolean algebra.

## Case study 5: Proofs with implicit arguments

**Goal**: Use logical combinators without explicitly binding type parameters.

Proof script:

```
# case_study_logic.rp

theorem and_comm : And a b -> And b a
proof andComm

theorem or_comm : Or a b -> Or b a
proof orComm

theorem iff_sym : Iff a b -> Iff b a
proof iffSym
```

**Outcome**: The checker accepts the implicit type arguments automatically.

## Case study 6: Combining lemmas

**Goal**: Use multiple lemmas in a single proof script to form a small proof bundle.

Proof script:

```
# case_study_bundle.rp

theorem plus_self_succ : (n : Nat) -> plus n (S n) = S (plus n n)
proof plusSelfSucc n

theorem double_is_plus : (n : Nat) -> double n = plus n n
proof doubleIsPlus n

theorem pow_two : (n : Nat) -> pow n (S (S Z)) = mult n n
proof powTwo n
```

**Outcome**: All proofs are accepted because they are defined in the lemma catalog.

## Case study 7: Lists and folds

**Goal**: Demonstrate folding and reversing as expected.

Proof script:

```
# case_study_folds.rp

theorem reverse_involutive : (xs : List Nat) -> reverse (reverse xs) = xs
proof reverseInvolutive xs

theorem foldr_append : (f : Nat -> Nat -> Nat) -> (acc : Nat) -> (xs : List Nat) -> (ys : List Nat) ->
  foldr f acc (append xs ys) = foldr f (foldr f acc ys) xs
proof foldrAppend f acc xs ys
```

**Outcome**: Both proofs are validated and can serve as templates for more complex list
properties.

## Case study 8: Arithmetic ordering

**Goal**: Verify ordering helper properties.

Proof script:

```
# case_study_order.rp

theorem leq_refl : (n : Nat) -> leq n n = True
proof leqRefl n

theorem leq_zero_left : (n : Nat) -> leq Z n = True
proof leqZeroLeft n
```

**Outcome**: Proofs are accepted using `Proof.Arithmetic` lemmas.

## Case study 9: Combining proof scripts with CLI

The CLI can check any script. Example session:

```
python -m researchproof.cli verify examples/quickstart.rp
```

This command validates each theorem via the proof checker and exits 0 if all proofs are
valid. The same command is used by `scripts/run.sh` for convenience.

## Case study 10: Integrating into CI

In CI, `scripts/verify.sh` performs the end-to-end checks. It builds the checker, runs
unit tests, and verifies example scripts. The workflow is defined in
`.github/workflows/ci.yml`.

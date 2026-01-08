# Proof Script Examples

This document aggregates longer proof script examples. The goal is to provide copy/paste
snippets for common proof scenarios, and to serve as a reference for the ResearchProof
proof language.

## Example: arithmetic bundle

```
# examples/arithmetic_bundle.rp

theorem plus_zero_right : (n : Nat) -> plus n Z = n
proof plusZeroRight n

theorem plus_zero_left : (n : Nat) -> plus Z n = n
proof plusZeroLeft n

theorem plus_assoc : (x : Nat) -> (y : Nat) -> (z : Nat) -> plus (plus x y) z = plus x (plus y z)
proof plusAssoc x y z

theorem plus_comm : (x : Nat) -> (y : Nat) -> plus x y = plus y x
proof plusComm x y

theorem mult_one_right : (n : Nat) -> mult n (S Z) = n
proof multOneRight n

theorem mult_distrib_left : (x : Nat) -> (y : Nat) -> (z : Nat) -> mult x (plus y z) = plus (mult x y) (mult x z)
proof multDistribLeft x y z
```

## Example: boolean bundle

```
# examples/bool_bundle.rp

theorem not_involutive : (b : Bool) -> not (not b) = b
proof notInvolutive b

theorem xor_comm : (a : Bool) -> (b : Bool) -> xor a b = xor b a
proof xorComm a b

theorem not_and : (a : Bool) -> (b : Bool) -> not (and a b) = or (not a) (not b)
proof notAnd a b

theorem not_or : (a : Bool) -> (b : Bool) -> not (or a b) = and (not a) (not b)
proof notOr a b
```

## Example: list bundle

```
# examples/list_bundle.rp

theorem append_assoc : (xs : List Nat) -> (ys : List Nat) -> (zs : List Nat) ->
  append (append xs ys) zs = append xs (append ys zs)
proof appendAssoc xs ys zs

theorem length_append : (xs : List Nat) -> (ys : List Nat) -> length (append xs ys) = plus (length xs) (length ys)
proof lengthAppend xs ys

theorem reverse_involutive : (xs : List Nat) -> reverse (reverse xs) = xs
proof reverseInvolutive xs
```

## Example: logic bundle

```
# examples/logic_bundle.rp

theorem and_comm : And a b -> And b a
proof andComm

theorem or_comm : Or a b -> Or b a
proof orComm

theorem iff_trans : Iff a b -> Iff b c -> Iff a c
proof iffTrans
```

## Example: combining arithmetic and lists

```
# examples/mixed_bundle.rp

theorem length_replicate : (n : Nat) -> (x : Nat) -> length (replicate n x) = n
proof lengthReplicate n x

theorem even_double : (n : Nat) -> even (double n) = True
proof evenDouble n
```

## Example: deterministic constants

```
# examples/constant_proofs.rp

theorem plus_1_0 : plus (S Z) Z = S Z
proof Refl

theorem mult_2_1 : mult (S (S Z)) (S Z) = S (S Z)
proof Refl

theorem pow_2_2 : pow (S (S Z)) (S (S Z)) = mult (S (S Z)) (S (S Z))
proof Refl
```

## Example: filters and maps

```
# examples/filter_map.rp

theorem map_identity : (xs : List Nat) -> map (\x => x) xs = xs
proof mapIdentity xs
```

## Example: proof script checklist

When you create a new proof script, make sure:

- Each theorem has exactly one proof line.
- The signature is on a single line.
- The proof expression matches the signature.
- The lemmas referenced exist in `docs/PROOF_LIBRARY.md`.

## Example: CLI workflow

```
python -m researchproof.cli verify examples/quickstart.rp
```

# ResearchProof Proof Library Catalog

This catalog enumerates the functions and lemmas exported by the ResearchProof proof
checker. The lemma list is defined in `researchproof/lemma_catalog.py`, and the Idris
sources in `src/Proof/` mirror the same definitions for reference.

## Module: Proof.Nat

### Core data and operations

- `data Nat = Z | S Nat` - Peano naturals.
- `plus : Nat -> Nat -> Nat` - addition.
- `mult : Nat -> Nat -> Nat` - multiplication.
- `pow : Nat -> Nat -> Nat` - exponentiation.
- `pred : Nat -> Nat` - predecessor (monus).
- `double : Nat -> Nat` - addition with itself.
- `isZero : Nat -> Bool` - boolean check for zero.

### Lemmas

- `plusZeroRight : (n : Nat) -> plus n Z = n`
- `plusZeroLeft : (n : Nat) -> plus Z n = n`
- `plusSuccRight : (n, m : Nat) -> plus n (S m) = S (plus n m)`
- `plusSuccLeft : (n, m : Nat) -> plus (S n) m = S (plus n m)`
- `plusAssoc : (x, y, z : Nat) -> plus (plus x y) z = plus x (plus y z)`
- `plusComm : (x, y : Nat) -> plus x y = plus y x`
- `multZeroRight : (n : Nat) -> mult n Z = Z`
- `multZeroLeft : (n : Nat) -> mult Z n = Z`
- `multOneRight : (n : Nat) -> mult n (S Z) = n`
- `multOneLeft : (n : Nat) -> mult (S Z) n = n`
- `multSuccLeft : (n, m : Nat) -> mult (S n) m = plus m (mult n m)`
- `multDistribLeft : (x, y, z : Nat) -> mult x (plus y z) = plus (mult x y) (mult x z)`
- `multAssoc : (x, y, z : Nat) -> mult (mult x y) z = mult x (mult y z)`
- `powZero : (n : Nat) -> pow n Z = S Z`
- `powSucc : (n, m : Nat) -> pow n (S m) = mult n (pow n m)`
- `powOne : (n : Nat) -> pow n (S Z) = n`
- `powTwo : (n : Nat) -> pow n (S (S Z)) = mult n n`
- `doubleIsPlus : (n : Nat) -> double n = plus n n`
- `plusWithPred : (n : Nat) -> plus (pred n) (S Z) = n`
- `predIsLeftInverse : (n : Nat) -> pred (S n) = n`
- `isZeroFalse : (n : Nat) -> isZero (S n) = False`
- `isZeroTrue : isZero Z = True`
- `plusSelfSucc : (n : Nat) -> plus n (S n) = S (plus n n)`
- `plusSwap : (x, y : Nat) -> plus x (S y) = plus (S x) y`
- `doubleSucc : (n : Nat) -> double (S n) = S (S (double n))`

## Module: Proof.Bool

### Core data and operations

- `data Bool = False | True`
- `not : Bool -> Bool`
- `and : Bool -> Bool -> Bool`
- `or : Bool -> Bool -> Bool`
- `xor : Bool -> Bool -> Bool`
- `ifThenElse : Bool -> a -> a -> a`

### Lemmas

- `andTrueLeft : (b : Bool) -> and True b = b`
- `andTrueRight : (b : Bool) -> and b True = b`
- `andFalseLeft : (b : Bool) -> and False b = False`
- `andFalseRight : (b : Bool) -> and b False = False`
- `orTrueLeft : (b : Bool) -> or True b = True`
- `orTrueRight : (b : Bool) -> or b True = True`
- `orFalseLeft : (b : Bool) -> or False b = b`
- `orFalseRight : (b : Bool) -> or b False = b`
- `notInvolutive : (b : Bool) -> not (not b) = b`
- `xorComm : (a, b : Bool) -> xor a b = xor b a`
- `xorFalseLeft : (b : Bool) -> xor False b = b`
- `xorFalseRight : (b : Bool) -> xor b False = b`
- `xorTrueLeft : (b : Bool) -> xor True b = not b`
- `xorTrueRight : (b : Bool) -> xor b True = not b`
- `notAnd : (a, b : Bool) -> not (and a b) = or (not a) (not b)`
- `notOr : (a, b : Bool) -> not (or a b) = and (not a) (not b)`

## Module: Proof.List

### Core data and operations

- `data List a = Nil | Cons a (List a)` (Idris reference).
- `append : List a -> List a -> List a`
- `length : List a -> Nat`
- `map : (a -> b) -> List a -> List b`
- `reverse : List a -> List a`
- `snoc : List a -> a -> List a`
- `concat : List (List a) -> List a`
- `replicate : Nat -> a -> List a`
- `filter : (a -> Bool) -> List a -> List a`
- `foldr : (a -> b -> b) -> b -> List a -> b`
- `foldl : (b -> a -> b) -> b -> List a -> b`

The proof checker currently focuses on `List Nat` in its lemma catalog.

### Lemmas

- `appendNilRight : (xs : List Nat) -> append xs Nil = xs`
- `appendNilLeft : (xs : List Nat) -> append Nil xs = xs`
- `appendAssoc : (xs, ys, zs : List Nat) -> append (append xs ys) zs = append xs (append ys zs)`
- `lengthAppend : (xs, ys : List Nat) -> length (append xs ys) = plus (length xs) (length ys)`
- `lengthSnoc : (xs : List Nat) -> (x : Nat) -> length (snoc xs x) = S (length xs)`
- `lengthReplicate : (n : Nat) -> (x : Nat) -> length (replicate n x) = n`
- `mapIdentity : (xs : List Nat) -> map (\\x => x) xs = xs`
- `mapCompose : (f : Nat -> Nat) -> (g : Nat -> Nat) -> (xs : List Nat) -> map f (map g xs) = map (\\x => f (g x)) xs`
- `reverseAppend : (xs, ys : List Nat) -> reverse (append xs ys) = append (reverse ys) (reverse xs)`
- `reverseInvolutive : (xs : List Nat) -> reverse (reverse xs) = xs`
- `foldrAppend : (f : Nat -> Nat -> Nat) -> (acc : Nat) -> (xs, ys : List Nat) -> foldr f acc (append xs ys) = foldr f (foldr f acc ys) xs`

## Module: Proof.Logic

### Core data and operations

- `Not : Type -> Type` - negation as a function to `Void`.
- `record And a b` - conjunction.
- `data Or a b` - disjunction.
- `Implies : Type -> Type -> Type` - implication.
- `record Iff a b` - logical equivalence.

### Lemmas

- `andComm : And a b -> And b a`
- `andAssoc : And (And a b) c -> And a (And b c)`
- `andAssocInv : And a (And b c) -> And (And a b) c`
- `orComm : Or a b -> Or b a`
- `orAssoc : Or (Or a b) c -> Or a (Or b c)`
- `orAssocInv : Or a (Or b c) -> Or (Or a b) c`
- `andDistributesOverOr : And a (Or b c) -> Or (And a b) (And a c)`
- `orDistributesOverAnd : Or a (And b c) -> And (Or a b) (Or a c)`
- `iffRefl : Iff a a`
- `iffSym : Iff a b -> Iff b a`
- `iffTrans : Iff a b -> Iff b c -> Iff a c`

## Module: Proof.Arithmetic

### Core data and operations

- `leq : Nat -> Nat -> Bool` - less-than-or-equal test.
- `lt : Nat -> Nat -> Bool` - less-than test.
- `eqNat : Nat -> Nat -> Bool` - equality test.
- `min : Nat -> Nat -> Nat` - minimum.
- `max : Nat -> Nat -> Nat` - maximum.
- `sub : Nat -> Nat -> Nat` - truncated subtraction.
- `even : Nat -> Bool` - evenness test.
- `odd : Nat -> Bool` - oddness test.

### Lemmas

- `leqRefl : (n : Nat) -> leq n n = True`
- `leqZeroLeft : (n : Nat) -> leq Z n = True`
- `leqZeroRight : (n : Nat) -> leq n Z = isZero n`
- `minComm : (x, y : Nat) -> min x y = min y x`
- `maxComm : (x, y : Nat) -> max x y = max y x`
- `subZeroRight : (n : Nat) -> sub n Z = n`
- `subSelf : (n : Nat) -> sub n n = Z`
- `evenDouble : (n : Nat) -> even (double n) = True`
- `oddSucc : (n : Nat) -> odd (S n) = not (odd n)`

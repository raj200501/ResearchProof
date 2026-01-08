module Proof.Nat

import Proof.Bool

%default total

public export
data Nat : Type where
  Z : Nat
  S : Nat -> Nat

public export
plus : Nat -> Nat -> Nat
plus Z y = y
plus (S x) y = S (plus x y)

public export
mult : Nat -> Nat -> Nat
mult Z _ = Z
mult (S x) y = plus y (mult x y)

public export
pow : Nat -> Nat -> Nat
pow _ Z = S Z
pow x (S y) = mult x (pow x y)

public export
pred : Nat -> Nat
pred Z = Z
pred (S k) = k

public export
double : Nat -> Nat
double n = plus n n

public export
isZero : Nat -> Bool
isZero Z = True
isZero (S _) = False

public export
plusZeroRight : (n : Nat) -> plus n Z = n
plusZeroRight Z = Refl
plusZeroRight (S k) = rewrite plusZeroRight k in Refl

public export
plusZeroLeft : (n : Nat) -> plus Z n = n
plusZeroLeft _ = Refl

public export
plusSuccRight : (n, m : Nat) -> plus n (S m) = S (plus n m)
plusSuccRight Z _ = Refl
plusSuccRight (S k) m = rewrite plusSuccRight k m in Refl

public export
plusSuccLeft : (n, m : Nat) -> plus (S n) m = S (plus n m)
plusSuccLeft _ _ = Refl

public export
plusAssoc : (x, y, z : Nat) -> plus (plus x y) z = plus x (plus y z)
plusAssoc Z _ _ = Refl
plusAssoc (S x) y z = rewrite plusAssoc x y z in Refl

public export
plusComm : (x, y : Nat) -> plus x y = plus y x
plusComm Z y = rewrite plusZeroRight y in Refl
plusComm (S x) y = rewrite plusComm x y in Refl

public export
plusCancelLeft : (x, y, z : Nat) -> plus x y = plus x z -> y = z
plusCancelLeft Z _ _ prf = prf
plusCancelLeft (S x) y z prf = plusCancelLeft x y z (cong pred prf)

public export
plusCancelRight : (x, y, z : Nat) -> plus y x = plus z x -> y = z
plusCancelRight x y z prf = plusCancelLeft x y z (rewrite plusComm y x in rewrite plusComm z x in prf)

public export
multZeroRight : (n : Nat) -> mult n Z = Z
multZeroRight Z = Refl
multZeroRight (S k) = rewrite multZeroRight k in Refl

public export
multZeroLeft : (n : Nat) -> mult Z n = Z
multZeroLeft _ = Refl

public export
multOneRight : (n : Nat) -> mult n (S Z) = n
multOneRight Z = Refl
multOneRight (S k) = rewrite multOneRight k in Refl

public export
multOneLeft : (n : Nat) -> mult (S Z) n = n
multOneLeft n = rewrite plusZeroRight n in Refl

public export
multSuccLeft : (n, m : Nat) -> mult (S n) m = plus m (mult n m)
multSuccLeft _ _ = Refl

public export
multDistribLeft : (x, y, z : Nat) -> mult x (plus y z) = plus (mult x y) (mult x z)
multDistribLeft Z _ _ = Refl
multDistribLeft (S k) y z =
  rewrite multDistribLeft k y z in
  rewrite plusAssoc y (mult k y) (mult k z) in
  rewrite plusAssoc y z (plus (mult k y) (mult k z)) in
  rewrite plusComm z (mult k y) in
  rewrite plusAssoc y (mult k z) (mult k y) in
  Refl

public export
multAssoc : (x, y, z : Nat) -> mult (mult x y) z = mult x (mult y z)
multAssoc Z _ _ = Refl
multAssoc (S k) y z =
  rewrite multAssoc k y z in
  rewrite multDistribLeft y z (mult k y) in
  Refl

public export
powZero : (n : Nat) -> pow n Z = S Z
powZero _ = Refl

public export
powSucc : (n, m : Nat) -> pow n (S m) = mult n (pow n m)
powSucc _ _ = Refl

public export
doubleIsPlus : (n : Nat) -> double n = plus n n
doubleIsPlus _ = Refl

public export
plusWithPred : (n : Nat) -> plus (pred n) (S Z) = n
plusWithPred Z = Refl
plusWithPred (S k) = rewrite plusZeroRight k in Refl

public export
predIsLeftInverse : (n : Nat) -> pred (S n) = n
predIsLeftInverse _ = Refl

public export
isZeroFalse : (n : Nat) -> isZero (S n) = False
isZeroFalse _ = Refl

public export
isZeroTrue : isZero Z = True
isZeroTrue = Refl

public export
succInjective : (x, y : Nat) -> S x = S y -> x = y
succInjective _ _ Refl = Refl

public export
plusSelfSucc : (n : Nat) -> plus n (S n) = S (plus n n)
plusSelfSucc n = rewrite plusSuccRight n n in Refl

public export
plusSwap : (x, y : Nat) -> plus x (S y) = plus (S x) y
plusSwap x y = rewrite plusSuccRight x y in Refl

public export
powOne : (n : Nat) -> pow n (S Z) = n
powOne n = rewrite multOneRight n in Refl

public export
powTwo : (n : Nat) -> pow n (S (S Z)) = mult n n
powTwo n = rewrite powSucc n (S Z) in rewrite powOne n in Refl

public export
doubleSucc : (n : Nat) -> double (S n) = S (S (double n))
doubleSucc n = rewrite plusSuccRight n n in Refl

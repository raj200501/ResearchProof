module Proof.Arithmetic

import Proof.Nat
import Proof.Bool

%default total

public export
leq : Nat -> Nat -> Bool
leq Z _ = True
leq (S _) Z = False
leq (S x) (S y) = leq x y

public export
lt : Nat -> Nat -> Bool
lt x y = leq (S x) y

public export
eqNat : Nat -> Nat -> Bool
eqNat Z Z = True
eqNat Z (S _) = False
eqNat (S _) Z = False
eqNat (S x) (S y) = eqNat x y

public export
min : Nat -> Nat -> Nat
min x y = ifThenElse (leq x y) x y

public export
max : Nat -> Nat -> Nat
max x y = ifThenElse (leq x y) y x

public export
sub : Nat -> Nat -> Nat
sub x Z = x
sub Z _ = Z
sub (S x) (S y) = sub x y

public export
even : Nat -> Bool
even Z = True
even (S Z) = False
even (S (S k)) = even k

public export
odd : Nat -> Bool
odd n = not (even n)

public export
leqRefl : (n : Nat) -> leq n n = True
leqRefl Z = Refl
leqRefl (S k) = leqRefl k

public export
leqZeroLeft : (n : Nat) -> leq Z n = True
leqZeroLeft _ = Refl

public export
leqZeroRight : (n : Nat) -> leq n Z = isZero n
leqZeroRight Z = Refl
leqZeroRight (S _) = Refl

public export
minComm : (x, y : Nat) -> min x y = min y x
minComm Z Z = Refl
minComm Z (S _) = Refl
minComm (S _) Z = Refl
minComm (S x) (S y) = rewrite minComm x y in Refl

public export
maxComm : (x, y : Nat) -> max x y = max y x
maxComm Z Z = Refl
maxComm Z (S _) = Refl
maxComm (S _) Z = Refl
maxComm (S x) (S y) = rewrite maxComm x y in Refl

public export
subZeroRight : (n : Nat) -> sub n Z = n
subZeroRight _ = Refl

public export
subSelf : (n : Nat) -> sub n n = Z
subSelf Z = Refl
subSelf (S k) = subSelf k

public export
evenDouble : (n : Nat) -> even (double n) = True
evenDouble Z = Refl
evenDouble (S k) = rewrite evenDouble k in Refl

public export
oddSucc : (n : Nat) -> odd (S n) = not (odd n)
oddSucc Z = Refl
oddSucc (S k) = rewrite oddSucc k in Refl

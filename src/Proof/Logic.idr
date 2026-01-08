module Proof.Logic

%default total

public export
Not : Type -> Type
Not a = a -> Void

public export
record And a b where
  constructor MkAnd
  left : a
  right : b

public export
data Or a b : Type where
  Left : a -> Or a b
  Right : b -> Or a b

public export
Implies : Type -> Type -> Type
Implies a b = a -> b

public export
record Iff a b where
  constructor MkIff
  forward : a -> b
  backward : b -> a

public export
andComm : And a b -> And b a
andComm (MkAnd l r) = MkAnd r l

public export
andAssoc : And (And a b) c -> And a (And b c)
andAssoc (MkAnd (MkAnd l r) cval) = MkAnd l (MkAnd r cval)

public export
andAssocInv : And a (And b c) -> And (And a b) c
andAssocInv (MkAnd l (MkAnd r cval)) = MkAnd (MkAnd l r) cval

public export
orComm : Or a b -> Or b a
orComm (Left l) = Right l
orComm (Right r) = Left r

public export
orAssoc : Or (Or a b) c -> Or a (Or b c)
orAssoc (Left (Left l)) = Left l
orAssoc (Left (Right r)) = Right (Left r)
orAssoc (Right cval) = Right (Right cval)

public export
orAssocInv : Or a (Or b c) -> Or (Or a b) c
orAssocInv (Left l) = Left (Left l)
orAssocInv (Right (Left r)) = Left (Right r)
orAssocInv (Right (Right cval)) = Right cval

public export
andDistributesOverOr : And a (Or b c) -> Or (And a b) (And a c)
andDistributesOverOr (MkAnd aval (Left bval)) = Left (MkAnd aval bval)
andDistributesOverOr (MkAnd aval (Right cval)) = Right (MkAnd aval cval)

public export
orDistributesOverAnd : Or a (And b c) -> And (Or a b) (Or a c)
orDistributesOverAnd (Left aval) = MkAnd (Left aval) (Left aval)
orDistributesOverAnd (Right (MkAnd bval cval)) = MkAnd (Right bval) (Right cval)

public export
iffRefl : Iff a a
iffRefl = MkIff (\x => x) (\x => x)

public export
iffSym : Iff a b -> Iff b a
iffSym (MkIff f g) = MkIff g f

public export
iffTrans : Iff a b -> Iff b c -> Iff a c
iffTrans (MkIff f g) (MkIff h i) = MkIff (\x => h (f x)) (\x => g (i x))

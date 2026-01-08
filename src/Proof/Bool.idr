module Proof.Bool

%default total

public export
not : Bool -> Bool
not True = False
not False = True

public export
and : Bool -> Bool -> Bool
and True True = True
and _ _ = False

public export
or : Bool -> Bool -> Bool
or False False = False
or _ _ = True

public export
xor : Bool -> Bool -> Bool
xor True False = True
xor False True = True
xor _ _ = False

public export
ifThenElse : Bool -> a -> a -> a
ifThenElse True t _ = t
ifThenElse False _ f = f

public export
andTrueLeft : (b : Bool) -> and True b = b
andTrueLeft True = Refl
andTrueLeft False = Refl

public export
andTrueRight : (b : Bool) -> and b True = b
andTrueRight True = Refl
andTrueRight False = Refl

public export
andFalseLeft : (b : Bool) -> and False b = False
andFalseLeft _ = Refl

public export
andFalseRight : (b : Bool) -> and b False = False
andFalseRight True = Refl
andFalseRight False = Refl

public export
orTrueLeft : (b : Bool) -> or True b = True
orTrueLeft _ = Refl

public export
orTrueRight : (b : Bool) -> or b True = True
orTrueRight True = Refl
orTrueRight False = Refl

public export
orFalseLeft : (b : Bool) -> or False b = b
orFalseLeft True = Refl
orFalseLeft False = Refl

public export
orFalseRight : (b : Bool) -> or b False = b
orFalseRight True = Refl
orFalseRight False = Refl

public export
notInvolutive : (b : Bool) -> not (not b) = b
notInvolutive True = Refl
notInvolutive False = Refl

public export
xorComm : (a, b : Bool) -> xor a b = xor b a
xorComm True True = Refl
xorComm True False = Refl
xorComm False True = Refl
xorComm False False = Refl

public export
xorFalseLeft : (b : Bool) -> xor False b = b
xorFalseLeft True = Refl
xorFalseLeft False = Refl

public export
xorFalseRight : (b : Bool) -> xor b False = b
xorFalseRight True = Refl
xorFalseRight False = Refl

public export
xorTrueLeft : (b : Bool) -> xor True b = not b
xorTrueLeft True = Refl
xorTrueLeft False = Refl

public export
xorTrueRight : (b : Bool) -> xor b True = not b
xorTrueRight True = Refl
xorTrueRight False = Refl

public export
notAnd : (a, b : Bool) -> not (and a b) = or (not a) (not b)
notAnd True True = Refl
notAnd True False = Refl
notAnd False True = Refl
notAnd False False = Refl

public export
notOr : (a, b : Bool) -> not (or a b) = and (not a) (not b)
notOr True True = Refl
notOr True False = Refl
notOr False True = Refl
notOr False False = Refl

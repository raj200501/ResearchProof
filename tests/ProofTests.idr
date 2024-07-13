module ProofTests

import Proof

%default total

testPlusComm : Bool
testPlusComm = (plusComm (S Z) (S (S Z)) == Refl)

testPlusAssoc : Bool
testPlusAssoc = (plusAssoc (S Z) (S (S Z)) (S (S Z)) == Refl)

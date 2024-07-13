module Examples

import Proof

%default total

exampleProof1 : plus Z (S Z) = S Z
exampleProof1 = Refl

exampleProof2 : plus (S (S Z)) (S Z) = S (S (S Z))
exampleProof2 = Refl

exampleProof3 : plusComm (S (S Z)) (S Z)
exampleProof3 = Refl

exampleProof4 : plusAssoc (S Z) (S Z) (S Z)
exampleProof4 = Refl

verifyExampleProofs : IO ()
verifyExampleProofs = do
  verifyProof exampleProof1
  verifyProof exampleProof2
  verifyProof exampleProof3
  verifyProof exampleProof4

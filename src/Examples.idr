module Examples

import Proof

%default total

exampleProof1 : plus Z (S Z) = S Z
exampleProof1 = Refl

exampleProof2 : plus (S (S Z)) (S Z) = S (S (S Z))
exampleProof2 = Refl

exampleProof3 : plusComm (S (S Z)) (S Z)
exampleProof3 = plusComm (S (S Z)) (S Z)

exampleProof4 : plusAssoc (S Z) (S Z) (S Z)
exampleProof4 = plusAssoc (S Z) (S Z) (S Z)

exampleProof5 : mult (S (S Z)) (S Z) = S (S Z)
exampleProof5 = multOneRight (S (S Z))

exampleProof6 : even (double (S (S Z))) = True
exampleProof6 = evenDouble (S (S Z))

exampleProof7 : append (Cons (S Z) Nil) (Cons (S (S Z)) Nil) = Cons (S Z) (Cons (S (S Z)) Nil)
exampleProof7 = Refl

exampleProof8 : reverse (Cons (S Z) (Cons (S (S Z)) Nil)) = Cons (S (S Z)) (Cons (S Z) Nil)
exampleProof8 = Refl

verifyExampleProofs : IO ()
verifyExampleProofs = do
  verifyProof exampleProof1
  verifyProof exampleProof2
  verifyProof exampleProof3
  verifyProof exampleProof4
  verifyProof exampleProof5
  verifyProof exampleProof6
  verifyProof exampleProof7
  verifyProof exampleProof8

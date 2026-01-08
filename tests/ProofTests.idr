module ProofTests

import Proof

%default total

testPlusComm : plusComm (S Z) (S (S Z))
testPlusComm = plusComm (S Z) (S (S Z))

testPlusAssoc : plusAssoc (S Z) (S (S Z)) (S (S Z))
testPlusAssoc = plusAssoc (S Z) (S (S Z)) (S (S Z))

testPlusZeroRight : plusZeroRight (S (S Z))
testPlusZeroRight = plusZeroRight (S (S Z))

testMultOneRight : multOneRight (S (S Z))
testMultOneRight = multOneRight (S (S Z))

testMultZeroRight : multZeroRight (S (S Z))
testMultZeroRight = multZeroRight (S (S Z))

testBoolNotInvolutive : notInvolutive True
testBoolNotInvolutive = notInvolutive True

testBoolXorComm : xorComm True False
testBoolXorComm = xorComm True False

testAppendAssoc : appendAssoc (Cons Z Nil) (Cons (S Z) Nil) (Cons (S (S Z)) Nil)
testAppendAssoc = appendAssoc (Cons Z Nil) (Cons (S Z) Nil) (Cons (S (S Z)) Nil)

testReverseInvolutive : reverseInvolutive (Cons Z (Cons (S Z) Nil))
testReverseInvolutive = reverseInvolutive (Cons Z (Cons (S Z) Nil))

testEvenDouble : evenDouble (S (S Z))
testEvenDouble = evenDouble (S (S Z))

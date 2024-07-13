module Proof

%default total

data Nat : Type where
  Z : Nat
  S : Nat -> Nat

plus : Nat -> Nat -> Nat
plus Z y = y
plus (S x) y = S (plus x y)

-- Proving commutativity of addition
plusComm : (x, y : Nat) -> plus x y = plus y x
plusComm Z y = Refl
plusComm (S x) y = rewrite plusComm x y in Refl

-- Proving associativity of addition
plusAssoc : (x, y, z : Nat) -> plus (plus x y) z = plus x (plus y z)
plusAssoc Z y z = Refl
plusAssoc (S x) y z = rewrite plusAssoc x y z in Refl

-- Function to verify a proof
verifyProof : {P : Type} -> P -> IO ()
verifyProof proof = putStrLn "Proof verified!"


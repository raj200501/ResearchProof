module Proof

import public Proof.Nat
import public Proof.Bool
import public Proof.List
import public Proof.Logic
import public Proof.Arithmetic

%default total

-- Function to verify a proof in examples or test harnesses.
verifyProof : {P : Type} -> P -> IO ()
verifyProof _ = putStrLn "Proof verified!"

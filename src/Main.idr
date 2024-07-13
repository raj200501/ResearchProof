module Main

import Proof
import Examples

main : IO ()
main = do
  putStrLn "Welcome to ResearchProof"
  putStrLn "Verifying example proofs..."
  verifyExampleProofs
  putStrLn "All example proofs verified!"

module Main

import Proof
import Examples

main : IO ()
main = do
  putStrLn "Welcome to ResearchProof"
  putStrLn "Verifying example proofs shipped with the library..."
  verifyExampleProofs
  putStrLn "All example proofs verified!"
  putStrLn "Use scripts/run.sh <path-to-proof.rp> to verify your own proofs."

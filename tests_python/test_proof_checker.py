import unittest

from researchproof.proof_checker import ProofCheckError, parse_signature, verify_theorems
from researchproof.proof_language import Theorem


class ProofCheckerTests(unittest.TestCase):
    def test_refl_equality(self) -> None:
        theorem = Theorem(
            name="plus_1_0",
            signature="plus (S Z) Z = S Z",
            proof="Refl",
            line_number=1,
        )
        verify_theorems([theorem])

    def test_unknown_lemma(self) -> None:
        theorem = Theorem(
            name="unknown",
            signature="(n : Nat) -> plus n Z = n",
            proof="notALemma",
            line_number=1,
        )
        with self.assertRaises(ProofCheckError):
            verify_theorems([theorem])

    def test_signature_parsing(self) -> None:
        signature = parse_signature("(n : Nat) -> plus n Z = n")
        self.assertEqual(len(signature.params), 1)


if __name__ == "__main__":
    unittest.main()

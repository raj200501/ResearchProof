import unittest

from researchproof.errors import ParseError
from researchproof.proof_language import parse_text


class ProofLanguageParserTests(unittest.TestCase):
    def test_parses_single_theorem(self) -> None:
        text = """
        theorem plus_zero_right : (n : Nat) -> plus n Z = n
        proof plusZeroRight n
        """
        theorems = parse_text(text)
        self.assertEqual(len(theorems), 1)
        self.assertEqual(theorems[0].name, "plus_zero_right")
        self.assertIn("plus n Z = n", theorems[0].signature)
        self.assertEqual(theorems[0].proof, "plusZeroRight n")

    def test_requires_theorem_prefix(self) -> None:
        text = """
        theorem plus_zero_right : (n : Nat) -> plus n Z = n
        proof plusZeroRight n
        bad line
        """
        with self.assertRaises(ParseError):
            parse_text(text)

    def test_requires_proof_line(self) -> None:
        text = "theorem missing_proof : (n : Nat) -> n = n"
        with self.assertRaises(ParseError):
            parse_text(text)


if __name__ == "__main__":
    unittest.main()

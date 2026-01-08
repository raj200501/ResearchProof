"""Parser for the ResearchProof proof script language."""

from dataclasses import dataclass
from typing import Iterable, List

from researchproof.errors import ParseError


@dataclass(frozen=True)
class Theorem:
    name: str
    signature: str
    proof: str
    line_number: int


def _strip_comment(line: str) -> str:
    if "#" in line:
        return line.split("#", 1)[0]
    return line


def _normalize(line: str) -> str:
    return _strip_comment(line).strip()


def parse_lines(lines: Iterable[str]) -> List[Theorem]:
    theorems: List[Theorem] = []
    iterator = enumerate(lines, start=1)

    for line_number, line in iterator:
        normalized = _normalize(line)
        if not normalized:
            continue
        if not normalized.startswith("theorem "):
            raise ParseError(
                f"Expected 'theorem <name> : <type>' at line {line_number}, got: {line.strip()}"
            )
        header = normalized[len("theorem ") :]
        name, sep, signature = header.partition(":")
        if not sep:
            raise ParseError(
                f"Missing ':' in theorem declaration on line {line_number}: {line.strip()}"
            )
        name = name.strip()
        signature = signature.strip()
        if not name:
            raise ParseError(
                f"Missing theorem name on line {line_number}: {line.strip()}"
            )
        if not signature:
            raise ParseError(
                f"Missing theorem signature on line {line_number}: {line.strip()}"
            )

        proof_line = None
        for proof_line_number, proof_line in iterator:
            normalized_proof = _normalize(proof_line)
            if not normalized_proof:
                continue
            if not normalized_proof.startswith("proof "):
                raise ParseError(
                    f"Expected 'proof <expression>' after theorem '{name}' on line {proof_line_number}, "
                    f"got: {proof_line.strip()}"
                )
            proof_line = (proof_line_number, normalized_proof[len("proof ") :].strip())
            break
        if proof_line is None:
            raise ParseError(f"Missing proof for theorem '{name}' starting at line {line_number}")
        proof_line_number, proof = proof_line
        if not proof:
            raise ParseError(
                f"Missing proof expression for theorem '{name}' on line {proof_line_number}"
            )
        theorems.append(Theorem(name=name, signature=signature, proof=proof, line_number=line_number))
    return theorems


def parse_text(text: str) -> List[Theorem]:
    return parse_lines(text.splitlines())

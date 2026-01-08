"""Custom errors for ResearchProof tooling."""


class ProofLanguageError(Exception):
    """Base error for proof language issues."""


class ParseError(ProofLanguageError):
    """Raised when a proof script cannot be parsed."""


class IdrisInvocationError(ProofLanguageError):
    """Raised when Idris fails to typecheck generated proofs."""

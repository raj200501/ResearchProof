"""Proof checker for ResearchProof proof scripts.

This module implements a lightweight evaluator and matcher for the subset of Idris-like
syntax used in ResearchProof proof scripts. It does not require Idris; instead it checks
proofs against a catalog of known lemmas and evaluates definitional equalities when proofs
use `Refl`.
"""

from __future__ import annotations

from dataclasses import dataclass
from typing import Dict, Iterable, Iterator, List, Optional, Sequence, Tuple

from researchproof.errors import ProofLanguageError
from researchproof.lemma_catalog import LEMMA_CATALOG
from researchproof.proof_language import Theorem


class ProofCheckError(ProofLanguageError):
    """Raised when proof checking fails."""


# -----------------------------
# Tokenization
# -----------------------------


def tokenize(text: str) -> List[str]:
    tokens: List[str] = []
    i = 0
    while i < len(text):
        char = text[i]
        if char.isspace():
            i += 1
            continue
        if text.startswith("->", i):
            tokens.append("->")
            i += 2
            continue
        if text.startswith("=>", i):
            tokens.append("=>")
            i += 2
            continue
        if text.startswith("\\\\", i):
            tokens.append("\\")
            i += 2
            continue
        if char == "\\":
            tokens.append("\\")
            i += 1
            continue
        if char in "():=,":
            tokens.append(char)
            i += 1
            continue
        if char == "=":
            tokens.append("=")
            i += 1
            continue
        if char.isalnum() or char == "_":
            start = i
            while i < len(text) and (text[i].isalnum() or text[i] == "_"):
                i += 1
            tokens.append(text[start:i])
            continue
        raise ProofCheckError(f"Unexpected character '{char}' in: {text}")
    return tokens


@dataclass(frozen=True)
class TokenStream:
    tokens: List[str]
    index: int = 0

    def peek(self) -> Optional[str]:
        if self.index >= len(self.tokens):
            return None
        return self.tokens[self.index]

    def consume(self, expected: Optional[str] = None) -> str:
        if self.index >= len(self.tokens):
            raise ProofCheckError("Unexpected end of input while parsing")
        token = self.tokens[self.index]
        if expected and token != expected:
            raise ProofCheckError(f"Expected '{expected}', got '{token}'")
        object.__setattr__(self, "index", self.index + 1)
        return token


# -----------------------------
# AST definitions
# -----------------------------


@dataclass(frozen=True)
class TypeExpr:
    pass


@dataclass(frozen=True)
class TypeConst(TypeExpr):
    name: str


@dataclass(frozen=True)
class TypeVar(TypeExpr):
    name: str


@dataclass(frozen=True)
class TypeApp(TypeExpr):
    name: str
    args: Tuple[TypeExpr, ...]


@dataclass(frozen=True)
class Equality(TypeExpr):
    left: "Term"
    right: "Term"


@dataclass(frozen=True)
class Arrow(TypeExpr):
    left: TypeExpr
    right: TypeExpr


@dataclass(frozen=True)
class Param:
    name: str
    type_expr: TypeExpr


@dataclass(frozen=True)
class Signature:
    params: Tuple[Param, ...]
    result: TypeExpr


@dataclass(frozen=True)
class Term:
    pass


@dataclass(frozen=True)
class Var(Term):
    name: str


@dataclass(frozen=True)
class Const(Term):
    name: str


@dataclass(frozen=True)
class App(Term):
    name: str
    args: Tuple[Term, ...]


@dataclass(frozen=True)
class Lambda(Term):
    param: str
    body: Term


# -----------------------------
# Parsing
# -----------------------------


TYPE_CONSTS = {"Nat", "Bool", "Type", "List"}
TERM_CONSTS = {"Z", "True", "False", "Nil"}
CALLABLES = {
    "even",
    "odd",
    "not",
    "isZero",
    "pred",
    "double",
    "S",
}


def parse_signature(text: str) -> Signature:
    stream = TokenStream(tokenize(text))
    params: List[Param] = []

    while stream.peek() == "(":
        stream.consume("(")
        name = stream.consume()
        stream.consume(":")
        type_expr = parse_type_expr(stream)
        stream.consume(")")
        stream.consume("->")
        params.append(Param(name=name, type_expr=type_expr))

    remaining_type = parse_type_expr(stream)
    if stream.peek() is not None:
        raise ProofCheckError(f"Unexpected token '{stream.peek()}' in signature '{text}'")

    flat_params, result = flatten_arrow(remaining_type)
    params.extend([Param(name=f"_param_{idx}", type_expr=param) for idx, param in enumerate(flat_params)])

    return Signature(params=tuple(params), result=result)


def parse_type_expr(stream: TokenStream) -> TypeExpr:
    if has_top_level_equals(stream):
        return parse_equality_type(stream)
    left = parse_type_application(stream)
    if stream.peek() == "->":
        stream.consume("->")
        right = parse_type_expr(stream)
        return Arrow(left=left, right=right)
    return left


def parse_type_atom(stream: TokenStream) -> TypeExpr:
    token = stream.peek()
    if token is None:
        raise ProofCheckError("Unexpected end of input while parsing type")
    if token == "(":
        stream.consume("(")
        inner = parse_type_expr(stream)
        stream.consume(")")
        return inner
    if token.isidentifier():
        name = stream.consume()
        if name in TYPE_CONSTS:
            return TypeConst(name=name)
        if name[0].isupper():
            return TypeConst(name=name)
        return TypeVar(name=name)
    if token == "=":
        raise ProofCheckError("Unexpected '=' while parsing type")
    raise ProofCheckError(f"Unexpected token '{token}' while parsing type")


def parse_type_application(stream: TokenStream) -> TypeExpr:
    base = parse_type_atom(stream)
    args: List[TypeExpr] = []
    while True:
        token = stream.peek()
        if token is None or token in {")", "->", "="}:
            break
        args.append(parse_type_atom(stream))
    if not args:
        return base
    if isinstance(base, (TypeConst, TypeVar)):
        return TypeApp(name=base.name, args=tuple(args))
    raise ProofCheckError("Unexpected type application")


def has_top_level_equals(stream: TokenStream) -> bool:
    depth = 0
    for token in stream.tokens[stream.index :]:
        if token == "(":
            depth += 1
        elif token == ")":
            depth -= 1
        elif token == "=" and depth == 0:
            return True
        elif token == "->" and depth == 0:
            return False
    return False


def parse_equality_type(stream: TokenStream) -> TypeExpr:
    left = parse_term(stream)
    if stream.peek() != "=":
        raise ProofCheckError("Expected '=' in equality type")
    stream.consume("=")
    right = parse_term(stream)
    return Equality(left=left, right=right)


def parse_term(stream: TokenStream) -> Term:
    term = parse_term_atom(stream)
    args: List[Term] = []
    while True:
        token = stream.peek()
        if token is None:
            break
        if token in {")",
            "=",
            "->",
            ",",
        }:
            break
        args.append(parse_term_atom(stream))
    if args:
        if isinstance(term, Var):
            return App(name=term.name, args=tuple(args))
        if isinstance(term, Const):
            return App(name=term.name, args=tuple(args))
        raise ProofCheckError("Unexpected term application")
    return term


def parse_term_atom(stream: TokenStream) -> Term:
    token = stream.peek()
    if token is None:
        raise ProofCheckError("Unexpected end of input while parsing term")
    if token == "(":
        stream.consume("(")
        inner = parse_term(stream)
        stream.consume(")")
        return inner
    if token == "\\":
        stream.consume("\\")
        param = stream.consume()
        stream.consume("=>")
        body = parse_term(stream)
        return Lambda(param=param, body=body)
    if token in TERM_CONSTS:
        return Const(name=stream.consume())
    if token.isidentifier():
        return Var(name=stream.consume())
    raise ProofCheckError(f"Unexpected token '{token}' in term")


def flatten_arrow(type_expr: TypeExpr) -> Tuple[List[TypeExpr], TypeExpr]:
    params: List[TypeExpr] = []
    current = type_expr
    while isinstance(current, Arrow):
        params.append(current.left)
        current = current.right
    return params, current


# -----------------------------
# Normalization for equivalence
# -----------------------------


def normalize_signature(signature: Signature) -> Signature:
    type_var_map: Dict[str, str] = {}
    term_var_map: Dict[str, str] = {}

    def normalize_type(type_expr: TypeExpr) -> TypeExpr:
        if isinstance(type_expr, TypeConst):
            return type_expr
        if isinstance(type_expr, TypeVar):
            name = type_var_map.setdefault(type_expr.name, f"t{len(type_var_map)}")
            return TypeVar(name=name)
        if isinstance(type_expr, TypeApp):
            return TypeApp(name=type_expr.name, args=tuple(normalize_type(arg) for arg in type_expr.args))
        if isinstance(type_expr, Equality):
            return Equality(
                left=normalize_term(type_expr.left, term_var_map),
                right=normalize_term(type_expr.right, term_var_map),
            )
        if isinstance(type_expr, Arrow):
            return Arrow(left=normalize_type(type_expr.left), right=normalize_type(type_expr.right))
        raise ProofCheckError(f"Unknown type expression: {type_expr}")

    normalized_params = []
    for param in signature.params:
        term_var_map[param.name] = f"p{len(term_var_map)}"
        normalized_params.append(Param(name=term_var_map[param.name], type_expr=normalize_type(param.type_expr)))
    normalized_result = normalize_type(signature.result)
    return Signature(params=tuple(normalized_params), result=normalized_result)


def normalize_term(term: Term, var_map: Dict[str, str]) -> Term:
    if isinstance(term, Const):
        return term
    if isinstance(term, Var):
        name = var_map.setdefault(term.name, f"v{len(var_map)}")
        return Var(name=name)
    if isinstance(term, App):
        return App(name=term.name, args=tuple(normalize_term(arg, var_map) for arg in term.args))
    if isinstance(term, Lambda):
        local_map = dict(var_map)
        local_map[term.param] = f"v{len(var_map)}"
        return Lambda(param=local_map[term.param], body=normalize_term(term.body, local_map))
    raise ProofCheckError(f"Unknown term: {term}")


# -----------------------------
# Evaluation for Refl proofs
# -----------------------------


@dataclass(frozen=True)
class Value:
    kind: str
    data: object


def evaluate(term: Term, env: Dict[str, Value]) -> Value:
    if isinstance(term, Const):
        if term.name == "Z":
            return Value("Nat", 0)
        if term.name == "True":
            return Value("Bool", True)
        if term.name == "False":
            return Value("Bool", False)
        if term.name == "Nil":
            return Value("List", [])
        raise ProofCheckError(f"Unknown constant {term.name}")
    if isinstance(term, Var):
        if term.name in env:
            return env[term.name]
        if term.name in CALLABLES:
            return Value("Callable", term.name)
        return Value("Unknown", term.name)
    if isinstance(term, Lambda):
        return Value("Lambda", term)
    if isinstance(term, App):
        args = [evaluate(arg, env) for arg in term.args]
        return apply_function(term.name, args)
    raise ProofCheckError(f"Unknown term during evaluation: {term}")


def apply_function(name: str, args: Sequence[Value]) -> Value:
    if any(value.kind == "Unknown" for value in args):
        return Value("Unknown", name)

    if name == "S":
        return Value("Nat", args[0].data + 1)
    if name == "Cons":
        return Value("List", [args[0]] + list(args[1].data))
    if name == "plus":
        return Value("Nat", args[0].data + args[1].data)
    if name == "mult":
        return Value("Nat", args[0].data * args[1].data)
    if name == "pow":
        return Value("Nat", args[0].data ** args[1].data)
    if name == "pred":
        return Value("Nat", max(0, args[0].data - 1))
    if name == "double":
        return Value("Nat", args[0].data * 2)
    if name == "isZero":
        return Value("Bool", args[0].data == 0)
    if name == "not":
        return Value("Bool", not args[0].data)
    if name == "and":
        return Value("Bool", args[0].data and args[1].data)
    if name == "or":
        return Value("Bool", args[0].data or args[1].data)
    if name == "xor":
        return Value("Bool", bool(args[0].data) ^ bool(args[1].data))
    if name == "ifThenElse":
        return args[1] if args[0].data else args[2]
    if name == "leq":
        return Value("Bool", args[0].data <= args[1].data)
    if name == "lt":
        return Value("Bool", args[0].data < args[1].data)
    if name == "eqNat":
        return Value("Bool", args[0].data == args[1].data)
    if name == "min":
        return Value("Nat", min(args[0].data, args[1].data))
    if name == "max":
        return Value("Nat", max(args[0].data, args[1].data))
    if name == "sub":
        return Value("Nat", max(0, args[0].data - args[1].data))
    if name == "even":
        return Value("Bool", args[0].data % 2 == 0)
    if name == "odd":
        return Value("Bool", args[0].data % 2 == 1)
    if name == "append":
        return Value("List", list(args[0].data) + list(args[1].data))
    if name == "length":
        return Value("Nat", len(args[0].data))
    if name == "reverse":
        return Value("List", list(reversed(args[0].data)))
    if name == "snoc":
        return Value("List", list(args[0].data) + [args[1]])
    if name == "concat":
        concat_list: List[Value] = []
        for sublist in args[0].data:
            concat_list.extend(sublist.data)
        return Value("List", concat_list)
    if name == "replicate":
        return Value("List", [args[1]] * args[0].data)
    if name == "map":
        func = args[0]
        return Value("List", [apply_callable(func, item) for item in args[1].data])
    if name == "filter":
        func = args[0]
        filtered = []
        for item in args[1].data:
            predicate = apply_callable(func, item)
            if predicate.data:
                filtered.append(item)
        return Value("List", filtered)
    raise ProofCheckError(f"Unknown function '{name}' in evaluation")


def apply_callable(func: Value, arg: Value) -> Value:
    if func.kind == "Callable":
        return apply_function(func.data, [arg])
    if func.kind == "Lambda":
        lambda_term: Lambda = func.data
        return evaluate(lambda_term.body, {lambda_term.param: arg})
    if func.kind == "Unknown":
        return Value("Unknown", "callable")
    if func.kind == "Nat" or func.kind == "Bool" or func.kind == "List":
        raise ProofCheckError("Non-callable value used as function")
    raise ProofCheckError("Unsupported callable")


# -----------------------------
# Proof checking
# -----------------------------


def build_lemma_map() -> Dict[str, Signature]:
    lemmas = {}
    for lemma in LEMMA_CATALOG:
        lemmas[lemma.name] = parse_signature(lemma.signature)
    return lemmas


def check_refl(signature: Signature) -> None:
    if not isinstance(signature.result, Equality):
        raise ProofCheckError("Refl can only prove equality signatures")
    left = evaluate(signature.result.left, {})
    right = evaluate(signature.result.right, {})
    if left != right:
        raise ProofCheckError(
            f"Refl failed: {signature.result.left} does not normalize to {signature.result.right}"
        )


def check_lemma(signature: Signature, lemma_signature: Signature) -> None:
    normalized_sig = normalize_signature(signature)
    normalized_lemma = normalize_signature(lemma_signature)
    if normalized_sig != normalized_lemma:
        raise ProofCheckError("Theorem signature does not match lemma signature")


def check_theorem(theorem: Theorem, lemma_map: Dict[str, Signature]) -> None:
    signature = parse_signature(theorem.signature)
    proof_expr = theorem.proof
    if proof_expr == "Refl":
        check_refl(signature)
        return

    proof_term = parse_term(TokenStream(tokenize(proof_expr)))
    if isinstance(proof_term, Var):
        lemma_name = proof_term.name
    elif isinstance(proof_term, App):
        lemma_name = proof_term.name
    else:
        raise ProofCheckError("Unsupported proof expression; use Refl or a lemma name")

    if lemma_name not in lemma_map:
        raise ProofCheckError(f"Unknown lemma '{lemma_name}'")

    check_lemma(signature, lemma_map[lemma_name])


def verify_theorems(theorems: Iterable[Theorem]) -> None:
    lemma_map = build_lemma_map()
    for theorem in theorems:
        check_theorem(theorem, lemma_map)

module Proof.List

import Proof.Nat
import Proof.Bool

%default total

public export
data List a : Type where
  Nil : List a
  Cons : a -> List a -> List a

public export
append : List a -> List a -> List a
append Nil ys = ys
append (Cons x xs) ys = Cons x (append xs ys)

public export
length : List a -> Nat
length Nil = Z
length (Cons _ xs) = S (length xs)

public export
map : (a -> b) -> List a -> List b
map _ Nil = Nil
map f (Cons x xs) = Cons (f x) (map f xs)

public export
reverse : List a -> List a
reverse Nil = Nil
reverse (Cons x xs) = append (reverse xs) (Cons x Nil)

public export
snoc : List a -> a -> List a
snoc Nil y = Cons y Nil
snoc (Cons x xs) y = Cons x (snoc xs y)

public export
concat : List (List a) -> List a
concat Nil = Nil
concat (Cons xs xss) = append xs (concat xss)

public export
replicate : Nat -> a -> List a
replicate Z _ = Nil
replicate (S k) x = Cons x (replicate k x)

public export
filter : (a -> Bool) -> List a -> List a
filter _ Nil = Nil
filter predicate (Cons x xs) =
  case predicate x of
    True => Cons x (filter predicate xs)
    False => filter predicate xs
public export
foldr : (a -> b -> b) -> b -> List a -> b
foldr _ acc Nil = acc
foldr f acc (Cons x xs) = f x (foldr f acc xs)

public export
foldl : (b -> a -> b) -> b -> List a -> b
foldl _ acc Nil = acc
foldl f acc (Cons x xs) = foldl f (f acc x) xs

public export
appendNilRight : (xs : List a) -> append xs Nil = xs
appendNilRight Nil = Refl
appendNilRight (Cons x xs) = rewrite appendNilRight xs in Refl

public export
appendNilLeft : (xs : List a) -> append Nil xs = xs
appendNilLeft _ = Refl

public export
appendAssoc : (xs, ys, zs : List a) -> append (append xs ys) zs = append xs (append ys zs)
appendAssoc Nil _ _ = Refl
appendAssoc (Cons x xs) ys zs = rewrite appendAssoc xs ys zs in Refl

public export
lengthAppend : (xs, ys : List a) -> length (append xs ys) = plus (length xs) (length ys)
lengthAppend Nil ys = Refl
lengthAppend (Cons _ xs) ys = rewrite lengthAppend xs ys in Refl

public export
lengthSnoc : (xs : List a) -> (x : a) -> length (snoc xs x) = S (length xs)
lengthSnoc Nil _ = Refl
lengthSnoc (Cons _ xs) x = rewrite lengthSnoc xs x in Refl

public export
lengthReplicate : (n : Nat) -> (x : a) -> length (replicate n x) = n
lengthReplicate Z _ = Refl
lengthReplicate (S k) x = rewrite lengthReplicate k x in Refl

public export
mapIdentity : (xs : List a) -> map (\x => x) xs = xs
mapIdentity Nil = Refl
mapIdentity (Cons x xs) = rewrite mapIdentity xs in Refl

public export
mapCompose : (f : b -> c) -> (g : a -> b) -> (xs : List a) ->
  map f (map g xs) = map (\x => f (g x)) xs
mapCompose _ _ Nil = Refl
mapCompose f g (Cons x xs) = rewrite mapCompose f g xs in Refl

public export
reverseAppend : (xs, ys : List a) -> reverse (append xs ys) = append (reverse ys) (reverse xs)
reverseAppend Nil ys = rewrite appendNilRight (reverse ys) in Refl
reverseAppend (Cons x xs) ys =
  rewrite reverseAppend xs ys in
  rewrite appendAssoc (reverse ys) (reverse xs) (Cons x Nil) in
  Refl

public export
reverseInvolutive : (xs : List a) -> reverse (reverse xs) = xs
reverseInvolutive Nil = Refl
reverseInvolutive (Cons x xs) =
  rewrite reverseAppend (reverse xs) (Cons x Nil) in
  rewrite reverseInvolutive xs in
  Refl

public export
foldrAppend : (f : a -> b -> b) -> (acc : b) -> (xs, ys : List a) ->
  foldr f acc (append xs ys) = foldr f (foldr f acc ys) xs
foldrAppend _ _ Nil _ = Refl
foldrAppend f acc (Cons x xs) ys = rewrite foldrAppend f acc xs ys in Refl

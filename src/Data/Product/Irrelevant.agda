{-# OPTIONS --without-K #-}

module Data.Product.Irrelevant where

open import Level
open import Function

record Σ~ {a b} (A : Set a) (B : A → Set b) : Set (a ⊔ b) where
  constructor _,~_
  field
    proj₁~ : A
    .proj₂~ : B proj₁~
open Σ~ public

_×~_ : ∀ {a b} (A : Set a) (B : Set b) → Set (a ⊔ b)
A ×~ B = Σ~ A (λ _ → B)

infix 2 Σ~-syntax
Σ~-syntax : ∀ {a b} (A : Set a) → (A → Set b) → Set (a ⊔ b)
Σ~-syntax = Σ~

syntax Σ~-syntax A (λ x → B) = Σ~[ x ∈ A ] B

∃~ : ∀ {a b} {A : Set a} → (A → Set b) → Set (a ⊔ b)
∃~ = Σ~ _

∃~-syntax : ∀ {a b} {A : Set a} → (A → Set b) → Set (a ⊔ b)
∃~-syntax = ∃~

syntax ∃~-syntax (λ x → B) = ∃~[ x ] B

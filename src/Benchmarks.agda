module Benchmarks where

open import Data.Nat as ℕ using (ℕ; suc; zero)
open import Data.Fin as Fin using (Fin)
open import Data.Fin.Literals as FinLit
open import Data.Nat.Literals as NatLit
open import Agda.Builtin.FromNat using (Number)

instance
  finLit : ∀ {n} → Number (Fin n)
  finLit = FinLit.number _

instance
  natLit : Number ℕ
  natLit = NatLit.number

d : ℕ
d = 15

module Old where
  open import Data.Nat.Properties using (*-+-commutativeSemiring)
  open import Algebra.Solver.Ring.AlmostCommutativeRing
  open import Algebra.Solver.Ring.Simple (fromCommutativeSemiring *-+-commutativeSemiring) ℕ._≟_
  open import Data.Vec as Vec using (_∷_; [])

  example : ℕ → ℕ → ℕ → ℕ → ℕ → ℕ
  example v w x y z = ⟦ ((var 0) :+ (var 1) :+ (var 2) :+ (var 3) :+ (var 4)) :^ d ⟧↓ (v ∷ w ∷ x ∷ y ∷ z ∷ [])

module New where
  open import Polynomial.Simple.AlmostCommutativeRing
  open import Polynomial.Parameters
  open import Data.Nat.Properties using (*-+-commutativeSemiring)
  open import Data.Vec as Vec using (_∷_; [])

  NatRing : AlmostCommutativeRing _ _
  NatRing = fromCommutativeSemiring *-+-commutativeSemiring ℕ._≟_

  open import Relation.Binary.PropositionalEquality

  natCoeff : RawCoeff _ _
  natCoeff = record
    { coeffs = AlmostCommutativeRing.rawRing NatRing
    ; Zero-C = _≡_ 0
    ; zero-c? = ℕ._≟_ 0
    }

  open AlmostCommutativeRing NatRing
  import Algebra.Solver.Ring.AlmostCommutativeRing as UnDec

  complex : UnDec.AlmostCommutativeRing _ _
  complex = record
    { isAlmostCommutativeRing = record
      { isCommutativeSemiring = isCommutativeSemiring
      ; -‿cong = -‿cong
      ; -‿*-distribˡ = -‿*-distribˡ
      ; -‿+-comm = -‿+-comm
      }
    }

  open import Function

  homo : Homomorphism _ _ _ _
  homo = record
    { coeffs = natCoeff
    ; ring = complex
    ; morphism = UnDec.-raw-almostCommutative⟶ complex
    ; Zero-C⟶Zero-R = id
    }

  open import Polynomial.NormalForm homo
  import Data.Fin as Fin
  import Data.Vec as Vec

  example : ℕ → ℕ → ℕ → ℕ → ℕ → ℕ
  example v w x y z = ⟦ ((ι 0) ⊞ (ι 1) ⊞ (ι 2) ⊞ (ι 3) ⊞ ι 4) ⊡ d ⟧ (v ∷ w ∷ x ∷ y ∷ z ∷ [])

open import IO.Primitive using (IO; putStrLn)
open import Foreign.Haskell using (Unit)

postulate
  printNat : ℕ → IO Unit

{-# COMPILE GHC printNat = print #-}

open Old using (example)

main : IO Unit
main = printNat (example 3 4 5 6 7)

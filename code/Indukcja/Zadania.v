(** * Enumeracje *)

(** Zdefiniuj typ reprezentujący dni tygodnia. *)
Inductive Day : Type := Mon | Tue | Wed | Thu | Fri | Sat | Sun.

(** Zdefiniuj typ reprezentujący miesiące roku. *)
Inductive Month : Type :=
  Jan | Feb | Mar | Apr | May | Jun | Jul | Aug | Sep | Oct | Nov | Dec.

(** Zdefiniuj typ reprezentujący kolory podstawowe. *)
Inductive RGB : Type := R | G | B.

(** Zdefiniuj typ reprezentujący kolory podstawowe + kanał alfa. *)
Fail Inductive RGBA : Type := R | G | B | A.

(** Zdefiniuj typ reprezentujący uniksowe uprawnienia dostępu. *)
Fail Inductive UnixAcess : Type := R | W | X.

(** Zdefiniuj typ reprezentujący różę kierunków (z 4 kierunkami). *)
(*Inductive Dir : Type := N | S | E | W.*)

(** Zdefiniuj typ reprezentujący logikę trójwartościową. *)
(*Inductive bool3 : Type := false | unknown | true.*)

(** * Parametry *)

(** Zdefiniuj spójniki logiczne i inne podstawowe rzeczy. *)
(*
Inductive False : Prop := .
Inductive True : Prop :=
Inductive and (P Q : Prop) : Prop :=
Inductive or (P Q : Prop) : Prop :=
Inductive ex (A : Type) (P : A -> Prop) : Prop :=

Inductive Empty : Type :=
Inductive unit : Type :=
Inductive prod (A B : Type) : Type :=
Inductive sum (A B : Type) : Type :=
Inductive sig (A : Type) (P : A -> Prop) : Type :=
Inductive sigT (A : Type) (P : A -> Type) : Type :=
*)

(** * Typy algebraiczne *)

(** Zdefiniuj typ opcji na [A]. *)
(*Inductive option (A : Type) : Type :=*)


(** Podefiniuj co trzeba dla list. *)
(*
Inductive Elem {A : Type} (x : A) : list A -> list A -> Prop :=
Inductive NoDup {A : Type} : list A -> Prop :=
Inductive Dup {A : Type} : list A -> Prop :=
Inductive Rep {A : Type} (x : A) : nat -> list A -> Prop :=
Inductive Exists {A : Type} (P : A -> Prop) : list A -> Prop :=
Inductive Forall {A : Type} (P : A -> Prop) : list A -> Prop :=
Inductive AtLeast {A : Type} (P : A -> Prop) : nat -> list A -> Prop :=
Inductive Exactly {A : Type} (P : A -> Prop) : nat -> list A -> Prop :=
Inductive AtMost  {A : Type} (P : A -> Prop) : nat -> list A -> Prop :=
Inductive Sublist {A : Type} : list A -> list A -> Prop :=
Inductive Prefix {A : Type} : list A -> list A -> Prop :=
Inductive Suffix {A : Type} : list A -> list A -> Prop :=
Inductive Subseq {A : Type} : list A -> list A -> Prop :=
Inductive Permutation {A : Type} : list A -> list A -> Prop :=
Inductive Cycle {A : Type} : list A -> list A -> Prop :=
Inductive Palindrome {A : Type} : list A -> Prop :=
*)

(** Zdefiniuj typ list niepustych, które trzymają elementy typu [A]. Potem
    zdefiniuj dla nich wszystkie te użyteczne rzeczy co dla list. *)

(** Zdefiniuj typ niepustych drzew binarnych, które trzymają wartości typu [A] jedynie
    w liściach. *)

(** Zdefiniuj typ niepustych drzew o skończonej ilości synów, które trzymają
    wartości typu [A] w liściach. *)

(** Zdefiniuj typ drzew binarnych, które trzymają elementy typu [A]. *)
(*Inductive BTree (A : Type) : Type :=*)

(** Zdefiniuj typ drzew o skończonej ilości synów, które trzymają elementy
    typu [A]. *)
(*Inductive Tree (A : Type) : Type :=*)

(** Zdefiniuj typ drzew o dowolnej ilości synów, które trzymają elementy
    typu [A]. *)
(*Inductive InfTree (A : Type) : Type :=*)

(** * Indeksy - predykaty i relacje *)

(** Zdefiniuj predykaty [even] i [odd]. *)
(*Inductive even : nat -> Prop :=*)

(** Zdefiniuj relację [<=] dla liczb naturalnych i to na dwa różne sposoby. *)
(*Inductive le (n : nat) : nat -> Prop :=*)

(** * Indeksy - typy *)

(** Zdefiniuj rodzinę typów [Fin : nat -> Type], gdzie [Fin n] jest typem o
    [n] elementach. *)
Inductive Fin : nat -> Type :=
    | FZ : forall n : nat, Fin (S n)
    | FS : forall n : nat, Fin n -> Fin (S n).

(** Zdefiniuj typ reprezentujący datę (dla uproszczenia, niech zaczyna się
    od 1 stycznia 1970. *)

Fixpoint isGapYear (n : nat) : bool :=
match n with
    | 0 => false
    | 1 => false
    | 2 => true
    | 3 => false
    | S (S (S (S n'))) => isGapYear n'
end.

Fixpoint dayInMonth (gap : bool) (m : Month) : Type :=
match m with
    | Jan | Apr | Jun | Sep | Nov => Fin 30
    | Feb => if gap then Fin 28 else Fin 29
    | Mar | May | Jul | Aug | Oct | Dec => Fin 31
end.

Definition Date : Type :=
  {year : nat & {month : Month & dayInMonth (isGapYear year) month}}.

(** Zdefiniuj typ list indeksowanych długością. *)
(*Inductive vec (A : Type) : nat -> Type :=*)

(** Zdefiniuj predykat należenia dla [vec]. *)
(*Inductive elem {A : Type} : A -> forall n : nat, vec A n -> Prop :=*)

(** Zdefiniuj typ list indeksowanych przez minimalny/maksymalny element. *)

(** Zdefiniuj typ list indeksowanych przez dowolny monoid. *)

(** * Predykat i relacje dla ko- *)

(** Zdefniuj predykat [Finite], [Infinite], [Exists], [All] dla kolist. *)
(*
Inductive Finite {A : Type} : coList A -> Prop :=
Inductive Exists {A : Type} (P : A -> Prop) : coList A -> Prop :=
*)

(** Jakieś inne. *)
(*
Inductive Finite : conat -> Prop :=

Inductive EBTree (A : Type) : nat -> Type :=
Inductive HBTree : Type :=
Inductive EHBTree : nat -> Type :=

Inductive sorted {A : Type} (R : A -> A -> Prop) : list A -> Prop :=
Inductive BHeap {A : Type} (R : A -> A -> Prop) : Type :=
Inductive BST {A : Type} (R : A -> A -> Prop) : Type :=
Inductive slist {A : Type} (R : A -> A -> bool) : Type :=
Inductive BHeap {A : Type} (R : A -> A -> bool) : Type :=

Inductive subterm_nat : nat -> nat -> Prop :=
Inductive subterm_list {A : Type} : list A -> list A -> Prop :=
Inductive subterm_nat_base : nat -> nat -> Prop :=
Inductive subterm_list_base {A : Type} : list A -> list A -> Prop :=
*)

(** Zdefiniuj różne użyteczne relacje dla strumieni, m. in. [Exists], [All],
    [Prefix], [Suffix], [Permutation] etc. *)

(*
Inductive Suffix {A : Type} : Stream A -> Stream A -> Prop :=
Inductive Permutation {A : Type} : Stream A -> Stream A -> Prop :=
*)
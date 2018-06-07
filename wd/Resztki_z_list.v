Add Rec LoadPath "/home/zeimer/Code/Coq".

Require Import CoqBookPL.book.X3.

Fixpoint snoc {A : Type} (x : A) (l : list A) : list A :=
match l with
    | [] => [x]
    | h :: t => h :: snoc x t
end.

Parameter snoc_isEmpty :
  forall (A : Type) (x : A) (l : list A),
    isEmpty l = true -> snoc x l = [x].

Parameter isEmpty_snoc :
  forall (A : Type) (x : A) (l : list A),
    isEmpty (snoc x l) = false.

Parameter length_snoc :
  forall (A : Type) (x : A) (l : list A),
    length (snoc x l) = S (length l).

Parameter snoc_app :
  forall (A : Type) (x : A) (l1 l2 : list A),
    snoc x (l1 ++ l2) = l1 ++ snoc x l2.

Parameter app_snoc_l :
  forall (A : Type) (x : A) (l1 l2 : list A),
    snoc x l1 ++ l2 = l1 ++ x :: l2.

Parameter app_snoc_r :
  forall (A : Type) (x : A) (l1 l2 : list A),
    l1 ++ snoc x l2 = snoc x (l1 ++ l2).

Parameter snoc_app_singl :
  forall (A : Type) (x : A) (l : list A),
    snoc x l = l ++ [x].

Parameter snoc_rev :
  forall (A : Type) (x : A) (l : list A),
    snoc x (rev l) = rev (x :: l).

Parameter rev_snoc :
  forall (A : Type) (x : A) (l : list A),
    rev (snoc x l) = x :: rev l.

Parameter map_snoc :
  forall (A B : Type) (f : A -> B) (x : A) (l : list A),
    map f (snoc x l) = snoc (f x) (map f l).

Parameter join_snoc :
  forall (A : Type) (x : list A) (l : list (list A)),
    join (snoc x l) = join l ++ x.

Parameter bind_snoc :
  forall (A B : Type) (f : A -> list B) (x : A) (l : list A),
    bind f (snoc x l) = bind f l ++ f x.

Parameter snoc_replicate :
  forall (A : Type) (x : A) (n : nat),
    snoc x (replicate n x) = replicate (S n) x.

Parameter nth_snoc_lt :
  forall (A : Type) (x : A) (n : nat) (l : list A),
    n < length l -> nth n (snoc x l) = nth n l.

Parameter nth_snoc_length :
  forall (A : Type) (x : A) (l : list A),
    nth (length l) (snoc x l) = Some x.

Parameter head_snoc :
  forall (A : Type) (x : A) (l : list A),
    head (snoc x l) =
    if isEmpty l then Some x else head l.

Parameter tail_snoc :
  forall (A : Type) (x : A) (l : list A),
    tail (snoc x l) =
    match tail l with
        | None => Some []
        | Some t => Some (snoc x t)
    end.

Parameter last_snoc :
  forall (A : Type) (x : A) (l : list A),
    last (snoc x l) = Some x.

Parameter init_snoc :
  forall (A : Type) (x : A) (l : list A),
    init (snoc x l) = Some l.

Parameter take_snoc_lt :
  forall (A : Type) (x : A) (n : nat) (l : list A),
    n < length l -> take n (snoc x l) = take n l.

Parameter drop_snoc_lt :
  forall (A : Type) (x : A) (n : nat) (l : list A),
    n < length l -> drop n (snoc x l) = snoc x (drop n l).

Parameter filter_snoc :
  forall (A : Type) (p : A -> bool) (x : A) (l : list A),
    filter p (snoc x l) =
    if p x then snoc x (filter p l) else filter p l.

Parameter takeWhile_snoc_all :
  forall (A : Type) (p : A -> bool) (x : A) (l : list A),
    all p l = true ->
      takeWhile p (snoc x l) =
      if p x then snoc x l else l.

Parameter dropWhile_snoc_all :
  forall (A : Type) (p : A -> bool) (x : A) (l : list A),
    all (fun x : A => negb (p x)) l = true ->
      dropWhile p (snoc x l) = snoc x l.

Parameter zipWith_snoc :
  forall (A B C : Type) (f : A -> B -> C)
    (a : A) (b : B) (la : list A) (lb : list B),
      length la = length lb ->
        zipWith f (snoc a la) (snoc b lb) =
        snoc (f a b) (zipWith f la lb).

Parameter intersperse_snoc :
  forall (A : Type) (x y : A) (l : list A),
    intersperse x (snoc y l) =
    if isEmpty l
    then [y]
    else snoc y (snoc x (intersperse x l)).

Parameter all_snoc :
  forall (A : Type) (p : A -> bool) (x : A) (l : list A),
    all p (snoc x l) = andb (all p l) (p x).

Parameter any_snoc :
  forall (A : Type) (p : A -> bool) (x : A) (l : list A),
    any p (snoc x l) = orb (any p l) (p x).

Parameter find_snoc :
  forall (A : Type) (p : A -> bool) (x : A) (l : list A),
    find p (snoc x l) =
    match find p l with
        | None => if p x then Some x else None
        | Some y => Some y
    end.

Parameter findLast_snoc :
  forall (A : Type) (p : A -> bool) (x : A) (l : list A),
    findLast p (snoc x l) =
    if p x then Some x else findLast p l.

Parameter removeFirst_snoc :
  forall (A : Type) (p : A -> bool) (x : A) (l : list A),
    removeFirst p (snoc x l) =
    match removeFirst p l with
        | None => if p x then Some (x, l) else None
        | Some (h, t) => Some (h, snoc x t)
    end.

Parameter removeLast_snoc :
  forall (A : Type) (p : A -> bool) (x : A) (l : list A),
    removeLast p (snoc x l) =
    if p x
    then Some (x, l)
    else
      match removeLast p l with
          | None => None
          | Some (h, t) => Some (h, snoc x t)
      end.

Parameter findIndex_snoc :
  forall (A : Type) (p : A -> bool) (x : A) (l : list A),
    findIndex p (snoc x l) =
    match findIndex p l with
        | None => if p x then Some (length l) else None
        | Some n => Some n
    end.

Parameter count_snoc :
  forall (A : Type) (p : A -> bool) (x : A) (l : list A),
    count p (snoc x l) = count p l + if p x then 1 else 0.

Parameter findIndices_snoc :
  forall (A : Type) (p : A -> bool) (x : A) (l : list A),
    findIndices p (snoc x l) =
    if p x
    then snoc (length l) (findIndices p l)
    else findIndices p l.

Parameter elem_snoc :
  forall (A : Type) (x y : A) (l : list A),
    elem x (snoc y l) <-> elem x l \/ x = y.

Parameter In_snoc :
  forall (A : Type) (x y : A) (l : list A),
    In x (snoc y l) <-> In x l \/ x = y.

Parameter NoDup_snoc :
  forall (A : Type) (x : A) (l : list A),
    NoDup (snoc x l) <-> NoDup l /\ ~ elem x l.

Parameter Dup_snoc :
  forall (A : Type) (x : A) (l : list A),
    Dup (snoc x l) <-> Dup l \/ elem x l.

Parameter Rep_S_snoc :
  forall (A : Type) (x : A) (n : nat) (l : list A),
    Rep x n l -> Rep x (S n) (snoc x l).

Parameter Rep_snoc :
  forall (A : Type) (x y : A) (n : nat) (l : list A),
    Rep x n l -> x <> y -> Rep x n (snoc y l).

Parameter Exists_snoc :
  forall (A : Type) (P : A -> Prop) (x : A) (l : list A),
    Exists P (snoc x l) <-> Exists P l \/ P x.

Parameter Forall_snoc :
  forall (A : Type) (P : A -> Prop) (x : A) (l : list A),
    Forall P (snoc x l) <-> Forall P l /\ P x.

Parameter AtLeast_snoc :
  forall (A : Type) (P : A -> Prop) (n : nat) (x : A) (l : list A),
    AtLeast P n l -> AtLeast P n (snoc x l).

Parameter AtLeast_S_snoc :
  forall (A : Type) (P : A -> Prop) (n : nat) (x : A) (l : list A),
    AtLeast P n l -> P x -> AtLeast P (S n) (snoc x l).

Parameter Exactly_snoc :
  forall (A : Type) (P : A -> Prop) (n : nat) (x : A) (l : list A),
    Exactly P n l -> ~ P x -> Exactly P n (snoc x l).

Parameter Exactly_S_snoc :
  forall (A : Type) (P : A -> Prop) (n : nat) (x : A) (l : list A),
    Exactly P n l -> P x -> Exactly P (S n) (snoc x l).

Parameter AtMost_S_snoc :
  forall (A : Type) (P : A -> Prop) (n : nat) (x : A) (l : list A),
    AtMost P n l -> AtMost P (S n) (snoc x l).

Parameter AtMost_snoc :
  forall (A : Type) (P : A -> Prop) (n : nat) (x : A) (l : list A),
    AtMost P n l -> ~ P x -> AtMost P n (snoc x l).

Parameter incl_snoc :
  forall (A : Type) (x : A) (l : list A),
    incl l (snoc x l).

Parameter incl_snoc_snoc :
  forall (A : Type) (x : A) (l1 l2 : list A),
    incl l1 l2 -> incl (snoc x l1) (snoc x l2).

Parameter sublist_snoc :
  forall (A : Type) (x : A) (l : list A),
    sublist l (snoc x l).

Parameter sublist_snoc_snoc :
  forall (A : Type) (x : A) (l1 l2 : list A),
    sublist l1 l2 -> sublist (snoc x l1) (snoc x l2).

Parameter Palindrome_cons_snoc :
  forall (A : Type) (x : A) (l : list A),
    Palindrome l -> Palindrome (x :: snoc x l).

Fixpoint insertBefore {A : Type} (n : nat) (l1 l2 : list A) : list A :=
match n with
    | 0 => l2 ++ l1
    | S n' =>
        match l1 with
            | [] => l2
            | h :: t => h :: insertBefore n' t l2
        end
end.

Notation "'insert' l2 'before' n 'in' l1" :=
  (insertBefore n l1 l2) (at level 40).

Require Import Arith.

Lemma insert_nil_before :
  forall (A : Type) (n : nat) (l : list A),
    (insert [] before n in l) = l.
(* begin hide *)
Proof.
  induction n as [| n']; cbn; intros.
    reflexivity.
    destruct l as [| h t]; cbn; rewrite ?IHn'; reflexivity.
Qed.
(* end hide *)

Lemma insert_before_in_nil:
  forall (A : Type) (n : nat) (l : list A),
    (insert l before n in []) = l.
(* begin hide *)
Proof.
  induction n as [| n']; cbn; intros; rewrite ?app_nil_r; reflexivity.
Qed.
(* end hide *)

Lemma insert_before_in_char :
  forall (A : Type) (l1 l2 : list A) (n : nat),
    insert l2 before n in l1 =
    take n l1 ++ l2 ++ drop n l1.
(* begin hide *)
Proof.
  induction l1 as [| h t]; cbn; intros.
    rewrite insert_before_in_nil, take_nil, drop_nil, app_nil_r.
      cbn. reflexivity.
    destruct n as [| n']; cbn; rewrite ?IHt; reflexivity.
Qed.
(* end hide *)

Lemma isEmpty_insertBefore :
  forall (A : Type) (n : nat) (l1 l2 : list A),
    isEmpty (insert l2 before n in l1) =
    andb (isEmpty l1) (isEmpty l2).
(* begin hide *)
Proof.
  induction n as [| n']; cbn.
    intros. rewrite isEmpty_app.
      destruct (isEmpty l1), (isEmpty l2); reflexivity.
    destruct l1; reflexivity.
Qed.
(* end hide *)

Lemma length_insertBefore :
  forall (A : Type) (n : nat) (l1 l2 : list A),
    length (insert l2 before n in l1) =
    length l1 + length l2.
(* begin hide *)
Proof.
  induction n as [| n']; cbn.
    intros. rewrite length_app, plus_comm. reflexivity.
    destruct l1; cbn; intros.
      reflexivity.
      rewrite IHn'. reflexivity.
Restart.
  intros. Require Import Omega.
  rewrite insert_before_in_char, ?length_app, length_drop.
    rewrite length_take. apply Min.min_case_strong; intros; omega.
Qed.
(* end hide *)

Lemma insert_before_0 :
  forall (A : Type) (l1 l2 : list A),
    insert l2 before 0 in l1 = l2 ++ l1.
(* begin hide *)
Proof.
  cbn. reflexivity.
Qed.
(* end hide *)

Lemma insert_before_gt :
  forall (A : Type) (n : nat) (l1 l2 : list A),
    length l1 <= n -> insert l2 before n in l1 = l1 ++ l2.
(* begin hide *)
Proof.
  induction n as [| n']; cbn; intros.
    destruct l1; inversion H. cbn. rewrite app_nil_r. reflexivity.
    destruct l1 as [| h t]; cbn in *.
      reflexivity.
      rewrite IHn'.
        reflexivity.
        apply le_S_n. assumption.
Restart.
  intros.
  rewrite insert_before_in_char, ?length_app.
  rewrite take_length'.
    rewrite drop_length'.
      rewrite app_nil_r. reflexivity.
      1-2: assumption.
Qed.
(* end hide *)

Lemma insert_before_length :
  forall (A : Type) (l1 l2 : list A),
    insert l2 before length l1 in l1 = l1 ++ l2.
(* begin hide *)
Proof.
  intros. rewrite insert_before_gt; reflexivity.
Qed.
(* end hide *)

Lemma insert_before_length_in_app :
  forall (A : Type) (l1 l2 l : list A),
    insert l before length l1 in (l1 ++ l2) =
    l1 ++ l ++ l2.
(* begin hide *)
Proof.
  induction l1 as [| h t]; cbn; intros; rewrite ?IHt; reflexivity.
Restart.
  intros.
  rewrite insert_before_in_char,
    take_app_l, drop_app_l, take_length, drop_length. cbn.
  all: reflexivity.
Qed.
(* end hide *)

Lemma insert_before_le_in_app :
  forall (A : Type) (n : nat) (l1 l2 l3 : list A),
    n <= length l1 ->
      insert l3 before n in (l1 ++ l2) =
      (insert l3 before n in l1) ++ l2.
(* begin hide *)
Proof.
  induction n as [| n']; cbn; intros.
    rewrite app_assoc. reflexivity.
    destruct l1 as [| h t]; cbn.
      destruct l2 as [| h' t']; cbn.
        rewrite app_nil_r. reflexivity.
        inversion H.
      rewrite IHn'.
        reflexivity.
        apply le_S_n. assumption.
Qed.
(* end hide *)

Lemma insert_app_before :
  forall (A : Type) (n : nat) (l1 l2 l : list A),
    insert l1 ++ l2 before n in l =
    insert l2 before (n + length l1) in (insert l1 before n in l).
(* begin hide *)
Proof.
  induction n as [| n']; cbn; intros.
    rewrite insert_before_length_in_app, app_assoc. reflexivity.
    destruct l as [| h t]; cbn.
      destruct l1 as [| h1 t1]; cbn.
        reflexivity.
        rewrite insert_before_gt.
          reflexivity.
          eapply le_trans with (n' + length t1).
            apply le_plus_r.
            apply plus_le_compat_l, le_S, le_n.
      rewrite IHn'. reflexivity.
Qed.
(* end hide *)

Lemma insert_before_plus_in_app :
  forall (A : Type) (l1 l2 l3 : list A) (n : nat),
    insert l3 before (length l1 + n) in (l1 ++ l2) =
    l1 ++ insert l3 before n in l2.
(* begin hide *)
Proof.
  induction l1 as [| h t]; cbn; intros.
    reflexivity.
    destruct n as [| n']; cbn.
      rewrite plus_0_r, insert_before_length_in_app. reflexivity.
      rewrite IHt. destruct l2 as [| h' t']; cbn.
        reflexivity.
        reflexivity.
Qed.
(* end hide *)

(* TODO: więcej tego typu rzeczy *)

Lemma rev_insert_before :
  forall (A : Type) (n : nat) (l1 l2 : list A),
    rev (insert l2 before n in l1) =
    insert (rev l2) before (length l1 - n) in rev l1.
(* begin hide *)
Proof.
  induction n as [| n']; cbn; intros.
    rewrite rev_app, <- minus_n_O, <- length_rev, insert_before_length.
      reflexivity.
    destruct l1 as [| h t]; cbn.
      rewrite app_nil_r. reflexivity.
      rewrite IHn', insert_before_le_in_app.
        reflexivity.
        rewrite length_rev. apply Nat.le_sub_l.
Qed.
(* end hide *)

Lemma minus_wut :
  forall n m : nat,
    n <= m -> n - m = 0.
Proof.
  induction n as [| n']; cbn; intros.
    reflexivity.
    destruct m as [| m']; cbn.
      inversion H.
      apply IHn', le_S_n. assumption.
Qed.

Lemma minus_wut' :
  forall n m : nat,
    n <= m -> n - (n - m) = n.
Proof.
  induction n as [| n']; cbn; intros.
    reflexivity.
    destruct m as [| m']; cbn.
      inversion H.
      rewrite minus_wut.
        reflexivity.
        apply le_S_n. assumption.
Qed.

Lemma minus_wut'' :
  forall n m : nat,
    m <= n -> n - (n - m) = m.
Proof.
  Require Import Omega.
  intros. omega.
Qed.

Lemma insert_before_in_rev :
  forall (A : Type) (n : nat) (l1 l2 : list A),
    insert l2 before n in rev l1 =
    rev (insert rev l2 before (length l1 - n) in l1).
(* begin hide *)
Proof.
  intros. rewrite rev_insert_before, rev_inv.
  destruct (le_ge_dec (length l1) n).
    rewrite minus_wut'.
      rewrite <- length_rev, ?insert_before_gt.
        1-2: reflexivity.
        rewrite length_rev. 1-2: assumption.
    rewrite minus_wut''.
      reflexivity.
      unfold ge in g. assumption.
Qed.
(* end hide *)

Lemma insert_rev_before :
  forall (A : Type) (n : nat) (l1 l2 : list A),
    insert (rev l2) before n in l1 =
    rev (insert l2 before (length l1 - n) in (rev l1)).
(* begin hide *)
Proof.
  intros. rewrite <- (rev_inv _ l2) at 2.
  rewrite <- (length_rev _ l1), <- insert_before_in_rev, rev_inv.
  reflexivity.
Qed.
(* end hide *)

Lemma map_insert_before_in :
  forall (A B : Type) (f : A -> B) (n : nat) (l1 l2 : list A),
    map f (insert l2 before n in l1) =
    insert (map f l2) before n in (map f l1).
(* begin hide *)
Proof.
  intros A B f n l1. generalize dependent n.
  induction l1 as [| h t]; cbn; intros.
    rewrite ?insert_before_in_nil. reflexivity.
    destruct n as [| n']; cbn.
      rewrite map_app. cbn. reflexivity.
      rewrite IHt. reflexivity.
Qed.
(* end hide *)

Lemma join_insert_before_in :
  forall (A : Type) (l1 l2 : list (list A)) (n : nat),
    join (insert l2 before n in l1) =
    insert (join l2) before (length (join (take n l1))) in (join l1).
(* begin hide *)
Proof.
  induction l1 as [| h t]; cbn; intros.
    rewrite insert_before_in_nil, take_nil. cbn. rewrite app_nil_r.
      reflexivity.
    destruct n as [| n']; cbn.
      rewrite join_app. cbn. reflexivity.
      rewrite IHt, length_app, insert_before_plus_in_app. reflexivity.
Qed.
(* end hide *)

(** TODO: [bind] *)

Lemma insert_before_in_replicate :
  forall (A : Type) (m n : nat) (x : A) (l : list A),
    insert l before n in replicate m x =
    replicate (min n m) x ++ l ++ replicate (m - n) x.
(* begin hide *)
Proof.
  induction m as [| m']; cbn; intros.
    rewrite insert_before_in_nil, app_nil_r, Min.min_0_r. cbn. reflexivity.
    destruct n as [| n']; cbn.
      reflexivity.
      rewrite IHm'. reflexivity.
Qed.
(* end hide *)

Lemma nth_insert_before_in :
  forall (A : Type) (n m : nat) (l1 l2 : list A),
    nth n (insert l2 before m in l1) =
    if leb (S n) m
    then nth n l1
    else nth (n - m) (l2 ++ drop m l1).
(* begin hide *)
Proof.
  induction n as [| n']; cbn.
Abort.
(* end hide *)

Lemma head_insert_before_in :
  forall (A : Type) (n : nat) (l1 l2 : list A),
    head (insert l2 before n in l1) =
    match l1 with
        | [] => head l2
        | h1 :: _ =>
            match n with
                | 0 =>
                    match l2 with
                        | [] => Some h1
                        | h2 :: _ => Some h2
                    end
                | _ => Some h1
            end
    end.
(* begin hide *)
Proof.
  intros.
  rewrite insert_before_in_char, ?head_app.
  destruct n, l1; cbn.
    all: destruct l2; reflexivity.
Qed.
(* end hide *)

Lemma any_insert_before_in :
  forall (A : Type) (p : A -> bool) (l1 l2 : list A) (n : nat),
    any p (insert l2 before n in l1) =
    orb (any p l1) (any p l2).
(* begin hide *)
Proof.
  induction l1 as [| h t]; cbn; intros.
    rewrite insert_before_in_nil. reflexivity.
    destruct (p h) eqn: Hph, n as [| n']; cbn.
      rewrite any_app, Bool.orb_comm. cbn. rewrite Hph. cbn. reflexivity.
      rewrite Hph, IHt. cbn. reflexivity.
      rewrite any_app, Bool.orb_comm. cbn. rewrite Hph. reflexivity.
      rewrite Hph, IHt. cbn. reflexivity.
Qed.
(* end hide *)

Lemma all_insert_before_in :
  forall (A : Type) (p : A -> bool) (l1 l2 : list A) (n : nat),
    all p (insert l2 before n in l1) =
    andb (all p l1) (all p l2).
(* begin hide *)
Proof.
  induction l1 as [| h t]; cbn; intros.
    rewrite insert_before_in_nil. reflexivity.
    destruct (p h) eqn: Hph, n as [| n']; cbn.
      rewrite all_app, Bool.andb_comm. cbn. rewrite Hph. cbn. reflexivity.
      rewrite Hph, IHt. cbn. reflexivity.
      rewrite all_app, Bool.andb_comm. cbn. rewrite Hph. reflexivity.
      rewrite Hph, IHt. cbn. reflexivity.
Qed.
(* end hide *)

Lemma count_insert_before_in :
  forall (A : Type) (p : A -> bool) (l1 l2 : list A) (n : nat),
    count p (insert l2 before n in l1) =
    count p l1 + count p l2.
(* begin hide *)
Proof.
  induction l1 as [| h t]; cbn; intros.
    rewrite insert_before_in_nil. reflexivity.
    destruct (p h) eqn: Hph, n as [| n']; cbn.
      rewrite count_app, plus_comm. cbn. rewrite Hph. cbn. reflexivity.
      rewrite Hph, IHt. reflexivity.
      rewrite count_app, plus_comm. cbn. rewrite Hph. reflexivity.
      rewrite Hph, IHt. reflexivity.
Qed.
(* end hide *)

Lemma elem_insert_before_in :
  forall (A : Type) (x : A) (l1 l2 : list A) (n : nat),
    elem x (insert l2 before n in l1) <->
    elem x l1 \/ elem x l2.
(* begin hide *)
Proof.
  induction l1 as [| h t]; cbn; intros.
    rewrite insert_before_in_nil. firstorder. inversion H.
    destruct n as [| n']; cbn.
      rewrite elem_app, ?elem_cons'. firstorder congruence.
      rewrite ?elem_cons', IHt. firstorder congruence.
Qed.
(* end hide *)

Lemma In_insert_before_in :
  forall (A : Type) (x : A) (l1 l2 : list A) (n : nat),
    In x (insert l2 before n in l1) <->
    In x l1 \/ In x l2.
(* begin hide *)
Proof.
  induction l1 as [| h t]; cbn; intros.
    rewrite insert_before_in_nil. firstorder.
    destruct n as [| n']; cbn.
      rewrite In_app; cbn. firstorder congruence.
      rewrite IHt. firstorder congruence.
Qed.
(* end hide *)

Lemma Exists_insert_before_in :
  forall (A : Type) (P : A -> Prop) (l1 l2 : list A) (n : nat),
    Exists P (insert l2 before n in l1) <->
    Exists P l1 \/ Exists P l2.
(* begin hide *)
Proof.
  induction l1 as [| h t]; cbn; intros.
    rewrite insert_before_in_nil. firstorder. inversion H.
    destruct n as [| n']; cbn.
      rewrite Exists_app; cbn. firstorder congruence.
      rewrite ?Exists_cons, IHt. firstorder congruence.
Qed.
(* end hide *)

Lemma Forall_insert_before_in :
  forall (A : Type) (P : A -> Prop) (l1 l2 : list A) (n : nat),
    Forall P (insert l2 before n in l1) <->
    Forall P l1 /\ Forall P l2.
(* begin hide *)
Proof.
  induction l1 as [| h t]; cbn; intros.
    rewrite insert_before_in_nil. firstorder. constructor.
    destruct n as [| n']; cbn.
      rewrite Forall_app, Forall_cons'. firstorder congruence.
      rewrite ?Forall_cons', IHt. firstorder congruence.
Qed.
(* end hide *)

Lemma AtLeast_insert_before_in :
  forall (A : Type) (P : A -> Prop) (l1 l2 : list A) (n m : nat),
    AtLeast P m (insert l2 before n in l1) <->
    (exists m1 m2 : nat,
      AtLeast P m1 l1 /\ AtLeast P m2 l2 /\ m = m1 + m2).
(* begin hide *)
Proof.
  split.
    revert l2 m n.
    induction l1 as [| h t]; cbn; intros.
      exists 0, m. repeat split.
        constructor.
        rewrite insert_before_in_nil in H. assumption.
      destruct n as [| n']; cbn in *.
        apply AtLeast_app_conv in H. firstorder.
        destruct t as [| h' t'].
          rewrite insert_before_in_nil in H.
            change (h :: l2) with ([h] ++ l2) in H.
            apply AtLeast_app_conv in H. firstorder.
          inversion H; subst.
            exists 0, 0. firstorder constructor.
            destruct (IHt _ _ _ H4) as (m1 & m2 & IH).
              exists (S m1), m2. firstorder. constructor; trivial.
            destruct (IHt _ _ _ H2) as (m1 & m2 & IH).
              exists m1, m2. firstorder. constructor. assumption.
    destruct 1 as (m1 & m2 & H1 & H2 & H3); subst.
      rewrite insert_before_in_char.
      apply AtLeast_app_comm. rewrite <- app_assoc. apply AtLeast_app.
        exists m2, m1. split.
          assumption.
          pose (AtLeast_take_drop _ _ _ n _ H1).
            rewrite AtLeast_app. firstorder.
Qed.
(* end hide *)



(** *** Dziwne *)

(** TODO: Wstawić tu jakąś ideologię. *)

Fixpoint revapp {A : Type} (l1 l2 : list A) : list A :=
match l1 with
    | [] => l2
    | h :: t => revapp t (h :: l2)
end.

Definition app' {A : Type} (l1 l2 : list A) : list A :=
  revapp (revapp l1 []) l2.

Lemma revapp_spec :
  forall (A : Type) (l1 l2 : list A),
    revapp l1 l2 = rev l1 ++ l2.
(* begin hide *)
Proof.
  induction l1 as [| h t]; cbn; intros; trivial.
    rewrite IHt, <- app_assoc. cbn. trivial.
Qed.
(* end hide *)

Lemma app'_spec :
  forall (A : Type) (l1 l2 : list A),
    app' l1 l2 = l1 ++ l2.
(* begin hide *)
Proof.
  unfold app'. intros. rewrite !revapp_spec, app_nil_r, rev_inv. trivial.
Qed.
(* end hide *)

(** * Niestandardowe reguły indukcyjne *)

(** Wyjaśnienia nadejdą już wkrótce. *)

Fixpoint list_ind_2
  (A : Type) (P : list A -> Prop)
  (H0 : P [])
  (H1 : forall x : A, P [x])
  (H2 : forall (x y : A) (l : list A), P l -> P (x :: y :: l))
    (l : list A) : P l.
(* begin hide *)
Proof.
  destruct l as [| x [| y l]]; cbn; auto.
  apply H2. apply list_ind_2; auto.
Qed.
(* end hide *)

Lemma list_ind_rev :
  forall (A : Type) (P : list A -> Prop)
    (Hnil : P [])
    (Hsnoc : forall (h : A) (t : list A), P t -> P (t ++ [h]))
      (l : list A), P l.
(* begin hide *)
Proof.
  intros. cut (forall l : list A, P (rev l)); intro.
    specialize (H (rev l)). rewrite <- rev_inv. assumption.
    induction l0 as [| h t]; cbn.
      assumption.
      apply Hsnoc. assumption.
Qed.
(* end hide *)

Lemma list_ind_app_l :
  forall (A : Type) (P : list A -> Prop)
  (Hnil : P []) (IH : forall l l' : list A, P l -> P (l' ++ l))
    (l : list A), P l.
(* begin hide *)
Proof.
  induction l as [| h t]; cbn.
    assumption.
    apply (IH _ [h]). assumption.
Qed.
(* end hide *)

Lemma list_ind_app_r :
  forall (A : Type) (P : list A -> Prop)
  (Hnil : P []) (IH : forall l l' : list A, P l -> P (l ++ l'))
    (l : list A), P l.
(* begin hide *)
Proof.
  induction l as [| h t] using list_ind_rev; cbn.
    assumption.
    apply (IH t [h]). assumption.
Qed.
(* end hide *)

Lemma list_ind_app :
  forall (A : Type) (P : list A -> Prop)
  (Hnil : P []) (Hsingl : forall x : A, P [x])
  (IH : forall l l' : list A, P l -> P l' -> P (l ++ l'))
    (l : list A), P l.
(* begin hide *)
Proof.
  induction l as [| h t]; cbn.
    assumption.
    apply (IH [h] t); auto.
Qed.
(* end hide *)

(** ** [foldr] i [foldl] *)

Fixpoint foldr
  {A B : Type} (f : A -> B -> B) (b : B) (l : list A) : B :=
match l with
    | [] => b
    | h :: t => f h (foldr f b t)
end.

Fixpoint foldl
  {A B : Type} (f : A -> B -> A) (a : A) (l : list B) : A :=
match l with
    | [] => a
    | h :: t => foldl f (f a h) t
end.

(** Nie będę na razie tłumaczył, jaka ideologia stoi za [foldr] i [foldl].
    Napiszę o tym później, a na razie porcja zadań.

    Zaimplementuj za pomocą [foldr] i [foldl] następujące funkcje:
    [length], [app], [rev], [map], [join], [filter], [takeWhile],
    [dropWhile].

    Udowodnij, że zdefiniowane przez ciebie funkcje pokrywają się ze
    swoimi klasycznymi odpowiednikami. *)

(* begin hide *)
(* Reszta polecenia: [repeat], [nth], [take], [drop] *)

Functional Scheme foldr_ind := Induction for foldr Sort Prop.
Functional Scheme foldl_ind := Induction for foldl Sort Prop.

Definition lengthF {A : Type} (l : list A) : nat :=
  foldr (fun _ => S) 0 l.

Definition appF {A : Type} (l1 l2 : list A) : list A :=
  foldr (@cons A) l2 l1.

Definition revF {A : Type} (l : list A) : list A :=
  foldr (fun h t => t ++ [h]) [] l.

Definition revF' {A : Type} (l : list A) : list A :=
  foldl (fun t h => h :: t) [] l.

Definition mapF {A B : Type} (f : A -> B) (l : list A) : list B :=
  foldr (fun h t => f h :: t) [] l.

Definition joinF {A : Type} (l : list (list A)) : list A :=
  foldr app [] l.

Definition filterF {A : Type} (p : A -> bool) (l : list A) : list A :=
  foldr (fun h t => if p h then h :: t else t) [] l.

Definition takeWhileF {A : Type} (p : A -> bool) (l : list A) : list A :=
  foldr (fun h t => if p h then h :: t else []) [] l.

(*Definition dropWhileF {A : Type} (p : A -> bool) (l : list A) : list A :=
  foldr (fun h t => if p h then t else h :: t) [] l.*)

(*Definition dropWhileF {A : Type} (p : A -> bool) (l : list A) : list A :=
  foldl (fun t h => if p h then t else h :: t) [] l.*)

Ltac solve_fold := intros;
match goal with
    | |- context [@foldr ?A ?B ?f ?a ?l] =>
        functional induction @foldr A B f a l; cbn; trivial;
        match goal with
            | H : ?x = _ |- context [?x] => rewrite ?H; auto
        end
    | |- context [@foldl ?A ?B ?f ?a ?l] =>
        functional induction @foldl A B f a l; cbn; trivial;
        match goal with
            | H : ?x = _ |- context [?x] => rewrite ?H; auto
        end
end.

(* end hide *)

Lemma lengthF_spec :
  forall (A : Type) (l : list A),
    lengthF l = length l.
(* begin hide *)
Proof.
  unfold lengthF; induction l as [| h t]; cbn.
    trivial.
    rewrite IHt. trivial.
Restart.
  intros. unfold lengthF. solve_fold.
Qed.
(* end hide *)

Lemma appF_spec :
  forall (A : Type) (l1 l2 : list A),
    appF l1 l2 = l1 ++ l2.
(* begin hide *)
Proof.
  unfold appF; induction l1 as [| h1 t1]; cbn; intros.
    trivial.
    rewrite IHt1. trivial.
Restart.
  intros. unfold appF. solve_fold.
Qed.
(* end hide *)

Lemma revF_spec :
  forall (A : Type) (l : list A),
    revF l = rev l.
(* begin hide *)
Proof.
  unfold revF; induction l as [| h t]; cbn; intros.
    trivial.
    rewrite IHt. trivial.
Restart.
  intros. unfold revF. solve_fold.
Qed.
(* end hide *)

(* begin hide *)
Lemma revF'_spec :
  forall (A : Type) (l : list A),
    revF' l = rev l.
Proof.
  unfold revF'. intros. replace (rev l) with (rev l ++ []).
    remember [] as acc. clear Heqacc. generalize dependent acc.
    induction l as [| h t]; cbn; intros; subst.
      trivial.
      rewrite IHt. rewrite <- app_cons_r. trivial.
    apply app_nil_r.
Qed.
(* end hide *)

Lemma mapF_spec :
  forall (A B : Type) (f : A -> B) (l : list A),
    mapF f l = map f l.
(* begin hide *)
Proof.
  unfold mapF; induction l as [| h t]; cbn; intros.
    trivial.
    rewrite IHt. trivial.
Restart.
  intros. unfold mapF. solve_fold.
Qed.
(* end hide *)

Lemma joinF_spec :
  forall (A : Type) (l : list (list A)),
    joinF l = join l.
(* begin hide *)
Proof.
  unfold joinF; induction l as [| h t]; cbn; intros.
    trivial.
    rewrite IHt. trivial.
Restart.
  intros. unfold joinF. solve_fold.
Qed.
(* end hide *)

Lemma filterF_spec :
  forall (A : Type) (p : A -> bool) (l : list A),
    filterF p l = filter p l.
(* begin hide *)
Proof.
  unfold filterF; induction l as [| h t].
    cbn. trivial.
    cbn. rewrite IHt. trivial.
Restart.
  intros. unfold filterF. solve_fold.
Qed.
(* end hide *)

Lemma takeWhileF_spec :
  forall (A : Type) (p : A -> bool) (l : list A),
    takeWhileF p l = takeWhile p l.
(* begin hide *)
Proof.
  unfold takeWhileF; induction l as [| h t]; cbn; intros.
    trivial.
    rewrite IHt. trivial.
Restart.
  intros. unfold takeWhileF. solve_fold.
Qed.
(* end hide *)

(** Lematy o foldach *)

Lemma foldr_app :
  forall (A B : Type) (f : A -> B -> B) (b : B) (l1 l2 : list A),
    foldr f b (l1 ++ l2) = foldr f (foldr f b l2) l1.
(* begin hide *)
Proof.
  induction l1 as [| h t]; cbn; intros.
    reflexivity.
    rewrite IHt. reflexivity.
Qed.

Definition flip {A B C : Type} (f : A -> B -> C) : B -> A -> C :=
  fun b a => f a b.

Lemma foldr_rev :
  forall (A B : Type) (f : A -> B -> B) (l : list A) (b : B),
    foldr f b (rev l) = foldl (flip f) b l.
(* begin hide *)
Proof.
  induction l as [| h t]; cbn; intros.
    reflexivity.
    rewrite foldr_app. cbn. rewrite IHt. unfold flip. reflexivity.
Qed.

(*Lemma foldr_map :
  forall (A B C : Type) (f : B -> C -> C) (g : A -> B) (b : B)
    (l : list A),
    foldr f a (map g l) = foldr (fun a b => g (f a b)) l.
(* begin hide *)
Proof.
  induction l as [| h t]; cbn; intros.
    reflexivity.
    rewrite foldl_snoc. rewrite IHt.
Qed.
(* end hide *)
*)

Lemma foldl_app :
  forall (A B : Type) (f : A -> B -> A) (l1 l2 : list B) (a : A),
    foldl f a (l1 ++ l2) = foldl f (foldl f a l1) l2.
(* begin hide *)
Proof.
  induction l1 as [| h t]; cbn; intros.
    reflexivity.
    rewrite IHt. reflexivity.
Qed.
(* end hide *)

Lemma foldl_snoc :
  forall (A B : Type) (f : A -> B -> A) (l : list B) (a : A) (b : B),
    foldl f a (l ++ [b]) = f (foldl f a l) b.
(* begin hide *)
Proof.
  induction l as [| h t]; cbn; intros.
    reflexivity.
    rewrite IHt. reflexivity.
Qed.
(* end hide *)

Lemma foldl_rev :
  forall (A B : Type) (f : A -> B -> A) (l : list B) (a : A),
    foldl f a (rev l) = foldr (flip f) a l.
(* begin hide *)
Proof.
  intros. rewrite <- (rev_inv _ l). rewrite foldr_rev.
  rewrite rev_inv. reflexivity.
Qed.
(* end hide *)

(** Skopiowane z biblioteki standardowej Haskella. Czoś mię się zdaję, że
    jednak tewo nie rozumię... *)

Fixpoint scanl
  {A B : Type} (f : A -> B -> A) (a : A) (l : list B) : list A :=
    a ::
match l with
    | [] => []
    | h :: t => scanl f (f a h) t
end.

Compute scanl plus 0 [1; 2; 3; 4; 5].

Definition scanl1
  {A : Type} (f : A -> A -> A) (l : list A) : list A :=
match l with
    | [] => []
    | h :: t => scanl f h t
end.

Compute scanl1 plus [1; 2; 3; 4; 5].

Fixpoint scanr
  {A B : Type} (f : A -> B -> B) (b : B) (l : list A) : list B :=
match l with
    | [] => [b]
    | h :: t =>
        let
          qs := scanr f b t
        in
        match qs with
            | [] => [f h b]
            | q :: _ => f h q :: qs
        end
end.

Compute scanr plus 0 [1; 2; 3; 4; 5].

Fixpoint scanr1
  {A : Type} (f : A -> A -> A) (l : list A) : list A :=
match l with
    | [] => []
    | [h] => [h]
    | h :: t =>
        let
          qs := scanr1 f t
        in
        match qs with
            | [] => []
            | q :: _ => f h q :: qs
        end
end.

Compute scanr1 plus [1; 2; 3; 4; 5].

Lemma isEmpty_scanl :
  forall (A B : Type) (f : A -> B -> A) (l : list B) (a : A),
    isEmpty (scanl f a l) = false.
(* begin hide *)
Proof.
  destruct l; cbn; reflexivity.
Qed.
(* end hide *)

Lemma length_scanl :
  forall (A B : Type) (f : A -> B -> A) (l : list B) (a : A),
    length (scanl f a l) = 1 + length l.
(* begin hide *)
Proof.
  induction l as [| h t]; cbn; intros.
    reflexivity.
    rewrite IHt. cbn. reflexivity.
Qed.
(* end hide *)

Lemma scanl_app :
  forall (A B : Type) (f : A -> B -> A) (l1 l2 : list B) (a : A),
    scanl f a (l1 ++ l2) = 
    take (length l1) (scanl f a l1) ++ scanl f (foldl f a l1) l2.
(* begin hide *)
Proof.
  induction l1 as [| h t]; cbn; intros.
    reflexivity.
    f_equal. rewrite IHt. reflexivity.
Qed.
(* end hide *)

Lemma scanl_snoc :
  forall (A B : Type) (f : A -> B -> A) (l : list B) (a : A) (b : B),
    scanl f a (l ++ [b]) = scanl f a l ++ [foldl f a (l ++ [b])].
(* begin hide *)
Proof.
  induction l as [| h t]; cbn; intros.
    reflexivity.
    rewrite IHt. reflexivity.
Qed.
(* end hide *)

Lemma scanl_rev :
  forall (A B : Type) (f : A -> B -> A) (l : list B) (a : A),
    scanl f a (rev l) = rev (scanr (flip f) a l).
(* begin hide *)
Proof.
  induction l as [| h t]; cbn; intros.
    reflexivity.
    rewrite scanl_snoc, IHt. 
Abort.
(* end hide *)

Lemma head_scanl :
  forall (A B : Type) (f : A -> B -> A) (l : list B) (a : A),
    head (scanl f a l) = Some a.
(* begin hide *)
Proof.
  destruct l; cbn; reflexivity.
Qed.
(* end hide *)

Lemma last_scanl :
  forall (A B : Type) (f : A -> B -> A) (l : list B) (a : A),
    last (scanl f a l) = Some (foldl f a l).
(* begin hide *)
Proof.
  induction l as [| h t]; cbn; intros.
    reflexivity.
    destruct (scanl f (f a h) t) eqn: Heq.
      apply (f_equal isEmpty) in Heq. rewrite isEmpty_scanl in Heq.
        cbn in Heq. congruence.
      rewrite <- Heq, IHt. reflexivity.
Qed.
(* end hide *)
(** * X3: Listy *)

(** Lista to najprostsza i najczęściej używana w programowaniu funkcyjnym
    struktura danych. Czas więc przeżyć na własnej skórze ich implementację
    w bibliotece standardowej. *)

Require Import Arith.

(** W części dowodów przydadzą nam się fakty dotyczące arytmetyki liczb
    naturalnych, które możemy znaleźć w module [Arith]. *)

(** Zdefiniuj [list] (bez podglądania). *)

(* begin hide *)
Inductive list (A : Type) : Type :=
    | nil : list A
    | cons : A -> list A -> list A.
(* end hide *)

Arguments nil [A].
Arguments cons [A] _ _.

Notation "[]" := nil.
Notation "x :: y" := (cons x y) (at level 60, right associativity).
Notation "[ x ; .. ; y ]" := (cons x .. (cons y nil) ..).

(** *** [length] *)

(** Zdefiniuj funkcję [length], która oblicza długość listy. *)

(* begin hide *)
Fixpoint length {A : Type} (l : list A) : nat :=
match l with
    | [] => 0
    | _ :: t => S (length t)
end.
(* end hide *)

Lemma length_nil :
  forall A : Type, length (@nil A) = 0.
(* begin hide *)
Proof. reflexivity. Qed.
(* end hide *)

Lemma length_cons :
  forall (A : Type) (h : A) (t : list A),
    exists n : nat, length (h :: t) = S n.
(* begin hide *)
Proof.
  intros. exists (length t). cbn. trivial.
Qed.
(* end hide *)

Lemma length_0 :
  forall (A : Type) (l : list A),
    length l = 0 -> l = [].
(* begin hide *)
Proof.
  induction l as [| h t]; cbn; intros.
    trivial.
    inversion H.
Qed.
(* end hide *)

(** *** [app] *)

(** Zdefiniuj funkcję [app], która skleja dwie listy. *)

(* begin hide *)
Fixpoint app {A : Type} (l1 l2 : list A) : list A :=
match l1 with
    | [] => l2
    | h :: t => h :: app t l2
end.
(* end hide *)

Notation "l1 ++ l2" := (app l1 l2).

Lemma app_nil_l :
  forall (A : Type) (l : list A),
    [] ++ l = l.
(* begin hide *)
Proof. reflexivity. Qed.
(* end hide *)

Lemma app_nil_r :
  forall (A : Type) (l : list A),
    l ++ [] = l.
(* begin hide *)
Proof.
  induction l as [| h t]; cbn.
    trivial.
    rewrite IHt. trivial.
Qed.
(* end hide *)

Lemma app_assoc :
  forall (A : Type) (l1 l2 l3 : list A),
    l1 ++ (l2 ++ l3) = (l1 ++ l2) ++ l3.
(* begin hide *)
Proof.
  induction l1 as [| h1 t1]; cbn; intros.
    trivial.
    rewrite IHt1. trivial.
Qed.
(* end hide *)

Lemma length_app :
  forall (A : Type) (l1 l2 : list A),
    length (l1 ++ l2) = length l1 + length l2.
(* begin hide *)
Proof.
  induction l1 as [| h1 t1]; cbn; intro.
    trivial.
    rewrite IHt1. trivial.
Qed.
(* end hide *)

Lemma app_cons_l :
  forall (A : Type) (x : A) (l1 l2 : list A),
    (x :: l1) ++ l2 = x :: (l1 ++ l2).
(* begin hide *)
Proof. trivial. Qed.
(* end hide *)

Lemma app_cons_r :
  forall (A : Type) (x : A) (l1 l2 : list A),
    l1 ++ x :: l2 = (l1 ++ [x]) ++ l2.
(* begin hide *)
Proof.
  induction l1 as [| h1 t1]; cbn; intros.
    trivial.
    f_equal. rewrite IHt1. trivial.
Qed.
(* end hide *)

Lemma no_infinite_cons :
  forall (A : Type) (x : A) (l : list A),
    l = x :: l -> False.
(* begin hide *)
Proof.
  induction l as [| h t]; cbn; intros.
    inversion H.
    inversion H. apply IHt. assumption.
Qed.
(* end hide *)

Lemma no_infinite_app :
  forall (A : Type) (l l' : list A),
    l' <> [] -> l = l' ++ l -> False.
(* begin hide *)
Proof.
  induction l as [| h t]; cbn; intros.
    rewrite app_nil_r in H0. subst. apply H. trivial.
    destruct l'.
      contradiction H. trivial.
      inversion H0. apply IHt with (l' ++ [a]).
        intro. assert (length (l' ++ [a]) = length (@nil A)).
          rewrite H1. trivial.
          rewrite length_app in H4. cbn in H4. rewrite plus_comm in H4.
            inversion H4.
        rewrite <- app_cons_r. assumption.
Qed.
(* end hide *)

Lemma app_inv_l :
  forall (A : Type) (l l1 l2 : list A),
    l ++ l1 = l ++ l2 -> l1 = l2.
(* begin hide *)
Proof.
  induction l as [| h t]; cbn; intros.
    assumption.
    apply IHt. inversion H. trivial.
Qed.
(* end hide *)

Lemma app_inv_r :
  forall (A : Type) (l l1 l2 : list A),
    l1 ++ l = l2 ++ l -> l1 = l2.
(* begin hide *)
Proof.
  induction l1 as [| h1 t1]; cbn; intros.
    destruct l2.
      trivial.
      cut False. inversion 1. eapply no_infinite_app; eauto. inversion 1.
    destruct l2.
      cbn in H. cut False. inversion 1. symmetry in H.
        rewrite <- app_cons_l in H. eapply no_infinite_app; eauto. inversion 1.
      inversion H. f_equal. apply IHt1. assumption.
Qed.
(* end hide *)

Lemma app_eq_nil :
  forall (A : Type) (l1 l2 : list A),
    l1 ++ l2 = [] -> l1 = [] /\ l2 = [].
(* begin hide *)
Proof.
  induction l1 as [| h1 t1]; cbn; intros.
    split; trivial.
    inversion H.
Qed.
(* end hide *)

(** *** [rev] *)

(** Zdefiniuj funkcję [rev], która odwraca listę. *)

(* begin hide *)
Fixpoint rev {A : Type} (l : list A) : list A :=
match l with
    | [] => []
    | h :: t => rev t ++ [h]
end.
(* end hide *)

Lemma length_rev :
  forall (A : Type) (l : list A),
    length (rev l) = length l.
(* begin hide *)
Proof.
  induction l as [| h t]; cbn.
    trivial.
    rewrite length_app, plus_comm. cbn. rewrite IHt. trivial.
Qed.
(* end hide *)

Lemma rev_app :
  forall (A : Type) (l1 l2 : list A),
    rev (l1 ++ l2) = rev l2 ++ rev l1.
(* begin hide *)
Proof.
  induction l1 as [| h1 t1]; cbn; intro.
    rewrite app_nil_r. trivial.
    rewrite IHt1. rewrite app_assoc. trivial.
Qed.
(* end hide *)

Lemma rev_inv :
  forall (A : Type) (l : list A),
    rev (rev l) = l.
(* begin hide *)
Proof.
  induction l as [| h t]; cbn.
    trivial.
    rewrite rev_app. rewrite IHt. cbn. trivial.
Qed.
(* end hide *)

(** *** [map] *)

(** Zdefiniuj funkcję [map], która aplikuje funkcję [f] do każdego
    elementu listy. *)

(* begin hide *)
Fixpoint map {A B : Type} (f : A -> B) (la : list A) : list B :=
match la with
    | [] => []
    | h :: t => f h :: map f t
end.
(* end hide *)

Lemma map_id :
  forall (A : Type) (l : list A),
    map id l = l.
(* begin hide *)
Proof.
  unfold id. induction l as [| h t]; cbn.
    trivial.
    rewrite IHt. trivial.
Qed.
(* end hide *)

Lemma map_comp :
  forall (A B C : Type) (f : A -> B) (g : B -> C) (l : list A),
    map g (map f l) = map (fun x : A => g (f x)) l.
(* begin hide *)
Proof.
  induction l as [| h t]; cbn.
    trivial.
    rewrite IHt. trivial.
Qed.
(* end hide *)

Lemma length_map :
  forall (A B : Type) (f : A -> B) (l : list A),
    length (map f l) = length l.
(* begin hide *)
Proof.
  induction l as [| h t]; cbn.
    trivial.
    rewrite IHt. trivial.
Qed.
(* end hide *)

Lemma map_app :
  forall (A B : Type) (f : A -> B) (l1 l2 : list A),
    map f (l1 ++ l2) = map f l1 ++ map f l2.
(* begin hide *)
Proof.
  induction l1 as [| h1 t1]; cbn; intros.
    trivial.
    rewrite IHt1. trivial.
Qed.
(* end hide *)

Lemma map_rev :
  forall (A B : Type) (f : A -> B) (l : list A),
    map f (rev l) = rev (map f l).
(* begin hide *)
Proof.
  induction l as [| h t]; cbn.
    trivial.
    rewrite map_app, IHt. cbn. trivial.
Qed.
(* end hide *)

Lemma map_ext :
  forall (A B : Type) (f g : A -> B) (l : list A),
    (forall x : A, f x = g x) -> map f l = map g l.
(* begin hide *)
Proof.
  induction l as [| h t]; cbn; intro.
    trivial.
    rewrite H, IHt; trivial.
Qed.
(* end hide *)

(** *** [join] *)

(** Napisz funkcję [join], która spłaszcza listę list. *)

(* begin hide *)
Fixpoint join {A : Type} (lla : list (list A)) : list A :=
match lla with
    | [] => []
    | h :: t => h ++ join t
end.
(* end hide *)

Lemma join_app :
  forall (A : Type) (l1 l2 : list (list A)),
    join (l1 ++ l2) = join l1 ++ join l2.
(* begin hide *)
Proof.
  induction l1 as [| h1 t1]; cbn; intros.
    trivial.
    rewrite IHt1, app_assoc. trivial.
Qed.
(* end hide *)

Lemma rev_join :
  forall (A : Type) (l : list (list A)),
    rev (join l) = join (rev (map rev l)).
(* begin hide *)
Proof.
  induction l as [| h t]; cbn.
    reflexivity.
    rewrite rev_app, join_app, IHt. cbn. rewrite app_nil_r. reflexivity.
Qed.
(* end hide *)

Lemma map_join :
  forall (A B : Type) (f : A -> B) (l : list (list A)),
    map f (join l) = join (map (map f) l).
(* begin hide *)
Proof.
  induction l as [| h t]; cbn; intros.
    trivial.
    rewrite map_app, IHt. trivial.
Qed.
(* end hide *)

(** *** [replicate] *)

(** Napsiz funkcję [replicate], która powiela dany element [n] razy, tworząc
    listę. *)

(* begin hide *)
Fixpoint replicate {A : Type} (n : nat) (x : A) : list A :=
match n with
    | 0 => []
    | S n' => x :: replicate n' x
end.
(* end hide *)

Lemma length_replicate :
  forall (A : Type) (n : nat) (x : A),
    length (replicate n x) = n.
(* begin hide *)
Proof.
  induction n as [| n']; cbn; intros; try rewrite IHn'; trivial.
Qed.
(* end hide *)

Lemma replicate_plus :
  forall (A : Type) (n m : nat) (x : A),
    replicate (n + m) x = replicate n x ++ replicate m x.
(* begin hide *)
Proof.
  induction n as [| n']; cbn; intros; try rewrite IHn'; trivial.
Qed.
(* end hide *)

Lemma rev_replicate :
  forall (A : Type) (n : nat) (x : A),
    rev (replicate n x) = replicate n x.
(* begin hide *)
Proof.
  induction n as [| n']; cbn; intros; trivial.
  change [x] with (replicate 1 x).
  rewrite IHn', <- replicate_plus, plus_comm. cbn. trivial.
Qed.
(* end hide *)

Lemma map_replicate :
  forall (A B : Type) (f : A -> B) (n : nat) (x : A),
    map f (replicate n x) = replicate n (f x).
(* begin hide *)
Proof.
  induction n as [| n']; cbn; intro; try rewrite IHn'; trivial.
Qed.
(* end hide *)

(** *** [nth] *)

(** Zdefiniuj funkcję [nth], która zwraca n-ty element listy lub [None],
    gdy nie ma n-tego elementu. *)

(* begin hide *)
Fixpoint nth {A : Type} (n : nat) (l : list A) : option A :=
match n, l with
    | _, [] => None
    | 0, h :: t => Some h
    | S n', h :: t => nth n' t
end.
(* end hide *)

Lemma nth_length :
  forall (A : Type) (n : nat) (l : list A),
    n < length l -> exists x : A, nth n l = Some x.
(* begin hide *)
Proof.
  induction n as [| n']; intros.
    destruct l.
      inversion H.
      exists a. cbn. trivial.
    destruct l; cbn in *.
      inversion H.
      unfold lt in H. cbn in H. apply le_S_n in H.
        destruct (IHn' _ H) as [x Hx]. exists x. assumption.
Qed.
(* end hide *)

Lemma nth_overflow :
  forall (A : Type) (n : nat) (l : list A),
    length l <= n -> ~ exists x : A, nth n l = Some x.
(* begin hide *)
Proof.
  induction n as [| n']; destruct l; cbn; intros.
    destruct 1. inversion H0.
    inversion H.
    destruct 1. inversion H0.
    apply IHn'. apply le_S_n. assumption.
Qed.
(* end hide *)

Lemma nth_app_l :
  forall (A : Type) (n : nat) (l1 l2 : list A),
    n < length l1 -> nth n (l1 ++ l2) = nth n l1.
(* begin hide *)
Proof.
  induction n as [| n']; destruct l1; cbn; intros.
    inversion H.
    trivial.
    inversion H.
    apply IHn'. apply lt_S_n. assumption.
Qed.
(* end hide *)

Lemma nth_app_r :
  forall (A : Type) (n : nat) (l1 l2 : list A),
    length l1 <= n -> nth n (l1 ++ l2) = nth (n - length l1) l2.
(* begin hide *)
Proof.
  induction n as [| n'].
    destruct l1 as [| h1 t1]; intros.
      destruct l2; cbn; trivial.
      destruct l2; cbn; inversion H.
    destruct l1 as [| h1 t1]; intros.
      cbn. trivial.
      cbn in *. apply IHn'. apply le_S_n. assumption.
Qed.
(* end hide *)

Lemma nth_split :
  forall (A : Type) (n : nat) (l : list A) (x : A),
    nth n l = Some x -> exists l1 l2 : list A,
      l = l1 ++ x :: l2 /\ length l1 = n.
(* begin hide *)
Proof.
  induction n as [| n'].
    destruct l as [| h t]; cbn; inversion 1; subst. exists [], t.
      cbn. split; trivial.
    destruct l as [| h t]; cbn; inversion 1; subst.
      destruct (IHn' _ _ H) as [l1 [l2 [Heq Hlen]]].
      exists (h :: l1), l2. split.
        rewrite Heq. trivial.
        cbn. rewrite Hlen. trivial.
Qed.
(* end hide *)

Lemma nth_None :
  forall (A : Type) (n : nat) (l : list A),
    nth n l = None -> length l <= n.
(* begin hide *)
Proof.
  induction n as [| n']; destruct l as [| h t]; cbn; intros.
    trivial.
    inversion H.
    apply le_0_n.
    apply le_n_S. apply IHn'. assumption.
Qed.
(* end hide *)

Lemma nth_Some :
  forall (A : Type) (n : nat) (l : list A) (x : A),
    nth n l = Some x -> n < length l.
(* begin hide *)
Proof.
  induction n as [| n']; destruct l as [| h t]; cbn; intros.
    inversion H.
    red. apply le_n_S. apply le_0_n.
    inversion H.
    apply lt_n_S. eapply IHn'. eassumption.
Qed.
(* end hide *)

Lemma nth_map :
  forall (A B : Type) (f : A -> B) (n : nat) (l : list A) (x : A),
    nth n l = Some x -> nth n (map f l) = Some (f x).
(* begin hide *)
Proof.
  induction n as [| n'].
    destruct l as [| h t]; cbn; inversion 1; trivial.
    destruct l as [| h t]; cbn; inversion 1; trivial.
      rewrite (IHn' t x); [trivial | assumption].
Qed.
(* end hide *)

Lemma nth_replicate :
  forall (A : Type) (i n : nat) (x : A),
    i < n -> nth i (replicate n x) = Some x.
(* begin hide *)
Proof.
  induction i as [| i']; destruct n as [| n']; cbn; intros.
    inversion H.
    reflexivity.
    inversion H.
    rewrite IHi'.
      trivial.
      apply lt_S_n. assumption.
Qed.
(* end hide *)

(** *** [head] i [last] *)

(** Zdefiniuj funkcje [head] i [last], które zwracają odpowiednio pierwszy
    i ostatni element listy (lub [None], jeżeli jest pusta). *)

(* begin hide *)
Fixpoint head {A : Type} (l : list A) : option A :=
match l with
    | [] => None
    | h :: _ => Some h
end.

Function last {A : Type} (l : list A) : option A :=
match l with
    | [] => None
    | [x] => Some x
    | h :: t => last t
end.
(* end hide *)

Lemma head_nil :
  forall (A : Type), head [] = (@None A).
(* begin hide *)
Proof.
  cbn. trivial.
Qed.
(* end hide *)

Lemma head_cons :
  forall (A : Type) (h : A) (t : list A),
    head (h :: t) = Some h.
(* begin hide *)
Proof. reflexivity. Qed.
(* end hide *)

Lemma head_app :
  forall (A : Type) (l1 l2 : list A),
    head (l1 ++ l2) =
    match l1 with
        | [] => head l2
        | h :: _ => Some h
    end.
(* begin hide *)
Proof. destruct l1; reflexivity. Qed.
(* end hide *)

Lemma head_map :
  forall (A B : Type) (f : A -> B) (l : list A),
    head (map f l) =
    match l with
        | [] => None
        | h :: _ => Some (f h)
    end.
(* begin hide *)
Proof.
  destruct l; reflexivity.
Qed.
(* end hide *)

Lemma head_replicate_S :
  forall (A : Type) (n : nat) (x : A),
    head (replicate (S n) x) = Some x.
(* begin hide *)
Proof. reflexivity. Qed.
(* end hide *)

Lemma head_replicate :
  forall (A : Type) (n : nat) (x : A),
    head (replicate n x) =
    match n with
        | 0 => None
        | _ => Some x
    end.
(* begin hide *)
Proof. destruct n; reflexivity. Qed.
(* end hide *)

Lemma head_nth :
  forall (A : Type) (l : list A), head l = nth 0 l.
(* begin hide *)
Proof.
  destruct l as [| h t]; cbn; trivial.
Qed.
(* end hide *)

Lemma last_nil :
  forall (A : Type), last [] = (@None A).
(* begin hide *)
Proof. reflexivity. Qed.
(* end hide *)

Lemma last_spec :
  forall (A : Type) (l : list A) (x : A),
    last (l ++ [x]) = Some x.
(* begin hide *)
Proof.
  induction l as [| h t]; cbn; intros.
    reflexivity.
    rewrite IHt. case_eq (t ++ [x]); cbn; intros.
      apply app_eq_nil in H. destruct H. inversion H0.
      reflexivity.
Qed.
(* end hide *)

Lemma last_app :
  forall (A : Type) (l1 l2 : list A),
    last (l1 ++ l2) =
    match l2 with
        | [] => last l1
        | _ => last l2
    end.
(* begin hide *)
Proof.
  induction l1 as [| h1 t1]; cbn.
    destruct l2; reflexivity.
    destruct t1; cbn in *; intros.
      reflexivity.
      rewrite <- IHt1. reflexivity.
Qed.
(* end hide *)

Lemma last_replicate_S :
  forall (A : Type) (n : nat) (x : A),
    last (replicate (S n) x) = Some x.
(* begin hide *)
Proof.
  induction n as [| n']; cbn in *; intros.
    reflexivity.
    rewrite IHn'. reflexivity.
Qed.
(* end hide *)

Lemma last_nth :
  forall (A : Type) (l : list A),
    last l = nth (length l - 1) l.
(* begin hide *)
Proof.
  induction l as [| h t]; cbn.
    reflexivity.
    destruct t.
      cbn. reflexivity.
      rewrite IHt. cbn. rewrite <- minus_n_O. reflexivity.
Qed.
(* end hide *)

Lemma last_rev :
  forall (A : Type) (l : list A),
    last (rev l) = head l.
(* begin hide *)
Proof.
  induction l as [| h t]; cbn.
    reflexivity.
    rewrite last_app. cbn. reflexivity.
Qed.
(* end hide *)

Lemma head_rev :
  forall (A : Type) (l : list A),
    head (rev l) = last l.
(* begin hide *)
Proof.
  intros. rewrite <- last_rev, rev_inv. reflexivity.
Qed.
(* end hide *)

(** *** [tail] i [init] *)

(** Zdefiniuj funkcje [tail] i [init], które zwracają odpowiednio ogon
    listy oraz wszystko poza jej ostatnim elementem (lub [None], gdy
    lista jest pusta). *)

(* begin hide *)
Fixpoint tail {A : Type} (l : list A) : option (list A) :=
match l with
    | [] => None
    | _ :: t => Some t
end.

Fixpoint init {A : Type} (l : list A) : option (list A) :=
match l with
    | [] => None
    | h :: t => match init t with
        | None => Some []
        | Some t' => Some (h :: t')
    end
end.
(* end hide *)

Lemma tail_nil :
  forall A : Type, tail (@nil A) = None.
(* begin hide *)
Proof. reflexivity. Qed.
(* end hide *)

Lemma tail_cons :
  forall (A : Type) (h : A) (t : list A),
    tail (h :: t) = Some t.
(* begin hide *)
Proof. reflexivity. Qed.
(* end hide *)

Lemma tail_replicate_0 :
  forall (A : Type) (x : A),
    tail (replicate 0 x) = None.
(* begin hide *)
Proof. reflexivity. Qed.
(* end hide *)

Lemma tail_replicate_S :
  forall (A : Type) (n : nat) (x : A),
    tail (replicate (S n) x) = Some (replicate n x).
(* begin hide *)
Proof. reflexivity. Qed.
(* end hide *)

Lemma tail_replicate :
  forall (A : Type) (n : nat) (x : A),
    tail (replicate n x) =
    match n with
        | 0 => None
        | S n' => Some (replicate n' x)
    end.
(* begin hide *)
Proof. destruct n; reflexivity. Qed.
(* end hide *)

Lemma init_spec :
  forall (A : Type) (l : list A) (x : A),
    init (l ++ [x]) = Some l.
(* begin hide *)
Proof.
  induction l as [| h t]; cbn; intros; rewrite ?IHt; reflexivity.
Qed.
(* end hide *)

Lemma init_replicate_0 :
  forall (A : Type) (x : A),
    init (replicate 0 x) = None.
(* begin hide *)
Proof. reflexivity. Qed.
(* end hide *)

Lemma init_replicate_S :
  forall (A : Type) (n : nat) (x : A),
    init (replicate (S n) x) = Some (replicate n x).
(* begin hide *)
Proof.
  induction n as [| n']; cbn in *; intros.
    reflexivity.
    rewrite IHn'. reflexivity.
Qed.
(* end hide *)

Lemma init_replicate :
  forall (A : Type) (n : nat) (x : A),
    init (replicate n x) =
    match n with
        | 0 => None
        | S n' => Some (replicate n' x)
    end.
(* begin hide *)
Proof.
  destruct n; intros.
    apply init_replicate_0.
    apply init_replicate_S.
Qed.
(* end hide *)

(* begin hide *)
Lemma tail_rev_aux :
  forall (A : Type) (l : list A),
    tail l =
    match init (rev l) with
        | None => None
        | Some t => Some (rev t)
    end.
Proof.
  induction l as [| h t]; cbn.
    reflexivity.
    rewrite init_spec, rev_inv. reflexivity.
Qed.
(* end hide *)

Lemma tail_rev :
  forall (A : Type) (l : list A),
    tail l =
    match init (rev l) with
        | None => None
        | Some t => Some (rev t)
    end.
(* begin hide *)
Proof.
  intros. rewrite tail_rev_aux. reflexivity.
Qed.
(* end hide *)

Lemma init_rev :
  forall (A : Type) (l : list A),
    init (rev l) =
    match tail l with
        | None => None
        | Some t => Some (rev t)
    end.
(* begin hide *)
Proof.
  intros. rewrite tail_rev.
  destruct (init (rev l)); rewrite ?rev_inv; reflexivity.
Qed.
(* end hide *)

(** *** [take] i [drop] *)

(** Zdefiniuj funkcje [take] i [drop], które odpowiednio biorą lub
    odrzucają n pierwszych elementów listy. *)

(* begin hide *)
Fixpoint take {A : Type} (n : nat) (l : list A) : list A :=
match n, l with
    | 0, _ => []
    | _, [] => []
    | S n', h :: t => h :: take n' t
end.

Fixpoint drop {A : Type} (n : nat) (l : list A) : list A :=
match n, l with
    | 0, _ => l
    | _, [] => []
    | S n', h :: t => drop n' t
end.
(* end hide *)

Lemma take_nil :
  forall (A : Type) (n : nat),
    take n [] = @nil A.
(* begin hide *)
Proof.
  destruct n; cbn; trivial.
Qed.
(* end hide *)

Lemma drop_nil :
  forall (A : Type) (n : nat),
    drop n [] = @nil A.
(* begin hide *)
Proof.
  destruct n; cbn; trivial.
Qed.
(* end hide *)

Lemma take_cons :
  forall (A : Type) (n : nat) (h : A) (t : list A),
    take (S n) (h :: t) = h :: take n t.
(* begin hide *)
Proof.
  trivial.
Qed.
(* end hide *)

Lemma drop_cons :
  forall (A : Type) (n : nat) (h : A) (t : list A),
    drop (S n) (h :: t) = drop n t.
(* begin hide *)
Proof.
  trivial.
Qed.
(* end hide *)

Lemma take_0 :
  forall (A : Type) (l : list A),
    take 0 l = [].
(* begin hide *)
Proof.
  destruct l; cbn; trivial.
Qed.
(* end hide *)

Lemma drop_0 :
  forall (A : Type) (l : list A),
    drop 0 l = l.
(* begin hide *)
Proof.
  destruct l; cbn; trivial.
Qed.
(* end hide *)

Lemma take_length :
  forall (A : Type) (l : list A),
    take (length l) l = l.
(* begin hide *)
Proof.
  induction l as [| h t]; cbn.
    trivial.
    rewrite IHt. trivial.
Qed.
(* end hide *)

Lemma drop_length :
  forall (A : Type) (l : list A),
    drop (length l) l = [].
(* begin hide *)
Proof.
  induction l as [| h t]; cbn.
    trivial.
    rewrite IHt. trivial.
Qed.
(* end hide *)

Lemma take_length' :
  forall (A : Type) (n : nat) (l : list A),
    length l <= n -> take n l = l.
(* begin hide *)
Proof.
  induction n as [| n']; intros.
    simpl. destruct l; inversion H; trivial.
    destruct l as [| h t]; simpl.
      trivial.
      rewrite IHn'.
        trivial.
        simpl in H. apply le_S_n in H. assumption.
Qed.
(* end hide *)

Lemma drop_length' :
  forall (A : Type) (n : nat) (l : list A),
    length l <= n -> drop n l = [].
(* begin hide *)
Proof.
  induction n as [| n']; intros.
    simpl. destruct l; inversion H; trivial.
    destruct l as [| h t]; simpl.
      trivial.
      rewrite IHn'.
        trivial.
        simpl in H. apply le_S_n in H. assumption.
Qed.
(* end hide *)

Lemma length_take :
  forall (A : Type) (n : nat) (l : list A),
    n <= length l -> length (take n l) = n.
(* begin hide *)
Proof.
  induction n as [| n']; destruct l as [| h t];
  cbn; inversion 1; subst; trivial;
  f_equal; apply IHn'; apply le_S_n in H; assumption.
Qed.
(* end hide *)

Lemma length_take' :
  forall (A : Type) (n : nat) (l : list A),
    length (take n l) <= n.
(* begin hide *)
Proof.
  induction n as [| n']; cbn.
    trivial.
    destruct l as [| h t]; cbn.
      apply le_0_n.
      apply le_n_S. apply IHn'.
Qed.
(* end hide *)

Lemma length_drop :
  forall (A : Type) (n : nat) (l : list A),
    n <= length l -> length (drop n l) = length l - n.
(* begin hide *)
Proof.
  induction n as [| n']; destruct l as [| h t];
  cbn; inversion 1; subst; trivial;
  f_equal; apply IHn'; apply le_S_n in H; assumption.
Qed.
(* end hide *)

Lemma take_map :
  forall (A B : Type) (f : A -> B) (n : nat) (l : list A),
    take n (map f l) = map f (take n l).
(* begin hide *)
Proof.
  induction n as [| n'].
    trivial.
    destruct l as [| h t]; simpl.
      trivial.
      rewrite IHn'. trivial.
Qed.
(* end hide *)

Lemma drop_map :
  forall (A B : Type) (f : A -> B) (n : nat) (l : list A),
    drop n (map f l) = map f (drop n l).
(* begin hide *)
Proof.
  induction n as [| n'].
    trivial.
    destruct l as [| h t]; simpl.
      trivial.
      rewrite IHn'. trivial.
Qed.
(* end hide *)

Lemma take_take_min :
  forall (A : Type) (n m : nat) (l : list A),
    take m (take n l) = take (min n m) l.
(* begin hide *)
Proof.
  induction n as [| n']; cbn; intros.
    rewrite take_nil. reflexivity.
    induction l as [| h t]; cbn.
      rewrite !take_nil. reflexivity.
      destruct m as [| m']; cbn.
        reflexivity.
        rewrite IHn'. reflexivity.
Qed.
(* end hide *)

Lemma take_take_comm :
  forall (A : Type) (n m : nat) (l : list A),
    take m (take n l) = take n (take m l).
(* begin hide *)
Proof.
  induction n as [| n']; intros.
    destruct m; trivial.
    destruct m as [| m'].
      cbn. trivial.
      destruct l as [| h t]; cbn.
        trivial.
        rewrite IHn'. trivial.
Restart.
  intros. rewrite !take_take_min, Nat.min_comm. reflexivity.
Qed.
(* end hide *)

Lemma drop_S_drop :
  forall (A : Type) (n m : nat) (l : list A),
    drop (S m) (drop n l) = drop m (drop (S n) l).
(* begin hide *)
Proof.
  induction n as [| n']; intros.
    destruct l; cbn; try rewrite drop_nil; trivial.
    destruct l as [| h t].
      cbn. rewrite drop_nil. trivial.
      do 2 rewrite drop_cons. rewrite IHn'. trivial.
Qed.
(* end hide *) 

Lemma drop_drop_plus :
  forall (A : Type) (n m : nat) (l : list A),
    drop m (drop n l) = drop (n + m) l.
(* begin hide *)
Proof.
  induction n as [| n']; cbn.
    reflexivity.
    induction l as [| h t]; cbn.
      rewrite drop_nil. reflexivity.
      apply IHn'.
Qed.
(* end hide *)

Lemma drop_drop_comm :
  forall (A : Type) (n m : nat) (l : list A),
    drop m (drop n l) = drop n (drop m l).
(* begin hide *)
Proof.
  induction n as [| n']; intros.
    destruct m; trivial.
    induction m as [| m'].
      cbn. trivial.
      induction l as [| h t].
        cbn. trivial.
        rewrite ?drop_cons in *. rewrite IHn'. rewrite drop_S_drop. trivial.
Restart.
  intros. rewrite !drop_drop_plus. f_equal. apply plus_comm.
Qed.
(* end hide *)

Lemma take_app_l :
  forall (A : Type) (n : nat) (l1 l2 : list A),
    n <= length l1 -> take n (l1 ++ l2) = take n l1.
(* begin hide *)
Proof.
  induction n as [| n']; cbn.
    reflexivity.
    induction l1 as [| h1 t1]; cbn; intros.
      inversion H.
      rewrite IHn'.
        reflexivity.
        apply le_S_n. assumption.
Qed.
(* end hide *)

Lemma take_app_r :
  forall (A : Type) (n : nat) (l1 l2 : list A),
    length l1 < n ->
      take n (l1 ++ l2) = l1 ++ take (n - length l1) l2.
(* begin hide *)
Proof.
  induction n as [| n']; cbn; intros.
    inversion H.
    destruct l1; cbn.
      reflexivity.
      rewrite IHn'.
        reflexivity.
        apply lt_S_n. assumption.
Qed.
(* end hide *)

Lemma drop_app_l :
  forall (A : Type) (n : nat) (l1 l2 : list A),
    n <= length l1 -> drop n (l1 ++ l2) = drop n l1 ++ l2.
(* begin hide *)
Proof.
  induction n as [| n']; induction l1 as [| h1 t2]; cbn; firstorder.
  inversion H.
Qed.
(* end hide *)

Lemma drop_app_r :
  forall (A : Type) (n : nat) (l1 l2 : list A),
    length l1 < n -> drop n (l1 ++ l2) = drop (n - length l1) l2.
(* begin hide *)
Proof.
  induction n as [| n']; induction l1 as [| h1 t2]; cbn; firstorder.
  inversion H.
Qed.
(* end hide *)

(* begin hide *)
Lemma take_rev_aux :
  forall (A : Type) (n : nat) (l : list A),
    take n l = rev (drop (length (rev l) - n) (rev l)).
Proof.
  induction n as [| n']; intros.
    rewrite <- minus_n_O. rewrite drop_length. cbn. reflexivity.
    induction l as [| h t]; cbn; auto.
      rewrite IHn'. rewrite length_app, plus_comm. cbn. rewrite drop_app_l.
        rewrite rev_app. cbn. reflexivity.
        apply Nat.le_sub_l.
Qed.
(* end hide *)

Lemma take_rev :
  forall (A : Type) (n : nat) (l : list A),
    take n (rev l) = rev (drop (length l - n) l).
(* begin hide *)
Proof.
  intros. rewrite take_rev_aux, !rev_inv. reflexivity.
Qed.
(* end hide *)

(* begin hide *)
Lemma drop_rev_aux :
  forall (A : Type) (n : nat) (l : list A),
    drop n l = rev (take (length (rev l) - n) (rev l)).
Proof.
  induction n as [| n']; intros.
    rewrite <- minus_n_O, take_length, rev_inv. cbn. reflexivity.
    induction l as [| h t]; cbn; auto.
      rewrite IHn'. rewrite length_app, plus_comm. cbn. rewrite take_app_l.
        reflexivity.
        apply Nat.le_sub_l.
Qed.
(* end hide *)

Lemma drop_rev :
  forall (A : Type) (n : nat) (l : list A),
    drop n (rev l) = rev (take (length l - n) l).
(* begin hide *)
Proof.
  intros. rewrite drop_rev_aux, !rev_inv. reflexivity.
Qed.
(* end hide *)

Lemma take_drop :
  forall (A : Type) (n m : nat) (l : list A),
    take m (drop n l) = drop n (take (n + m) l).
(* begin hide *)
Proof.
  induction n as [| n']; intros.
    cbn. trivial.
    destruct l as [| h t]; cbn.
      rewrite take_nil. trivial.
      rewrite IHn'. trivial.
Qed.
(* end hide *)

Lemma take_replicate :
  forall (A : Type) (m n : nat) (x : A),
    take m (replicate n x) = replicate (min m n) x.
(* begin hide *)
Proof.
  induction m as [| m']; destruct n as [| n']; cbn; intros; trivial.
  rewrite IHm'. trivial.
Qed.
(* end hide *)

Lemma drop_replicate :
  forall (A : Type) (m n : nat) (x : A),
    drop m (replicate n x) = replicate (n - m) x.
(* begin hide *)
Proof.
  induction m as [| m']; destruct n as [| n']; cbn; intros; trivial.
Qed.
(* end hide *)

(** *** [filter] *)

(** Napisz funkcję [filter], która zostawia na liście elementy, dla których
    funkcja [p] zwraca [true], a usuwa te, dla których zwraca [false]. *)

(* begin hide *)
Fixpoint filter {A : Type} (f : A -> bool) (l : list A) : list A :=
match l with
    | [] => []
    | h :: t => if f h then h :: filter f t else filter f t
end.
(* end hide *)

Lemma filter_false :
  forall (A : Type) (l : list A),
    filter (fun _ => false) l = [].
(* begin hide *)
Proof.
  induction l as [| h t]; cbn; trivial.
Qed.
(* end hide *)

Lemma filter_true :
  forall (A : Type) (l : list A),
    filter (fun _ => true) l = l.
(* begin hide *)
Proof.
  induction l as [| h t]; cbn.
    trivial.
    rewrite IHt. trivial.
Qed.
(* end hide *)

Lemma filter_app :
  forall (A : Type) (p : A -> bool) (l1 l2 : list A),
    filter p (l1 ++ l2) = filter p l1 ++ filter p l2.
(* begin hide *)
Proof.
  induction l1 as [| h1 t1]; cbn; intros.
    trivial.
    destruct (p h1); rewrite IHt1; trivial.
Qed.
(* end hide *)

Lemma filter_rev :
  forall (A : Type) (p : A -> bool) (l : list A),
    filter p (rev l) = rev (filter p l).
(* begin hide *)
Proof.
  induction l as [| h t]; cbn.
    trivial.
    rewrite filter_app; cbn. destruct (p h); cbn.
      rewrite IHt. trivial.
      rewrite app_nil_r. rewrite IHt. trivial.
Qed.
(* end hide *)

Lemma filter_andb :
  forall (A : Type) (f g : A -> bool) (l : list A),
    filter f (filter g l) =
    filter (fun x : A => andb (f x) (g x)) l.
(* begin hide *)
Proof.
  induction l as [| h t]; cbn.
    reflexivity.
    case_eq (g h); case_eq (f h); cbn; intros; rewrite ?H, ?H0, ?IHt; auto.
Qed.

(* end hide *)
Lemma filter_comm :
  forall (A : Type) (f g : A -> bool) (l : list A),
    filter f (filter g l) = filter g (filter f l).
(* begin hide *)
Proof.
  induction l as [| h t]; cbn.
    reflexivity.
    case_eq (f h); case_eq (g h); cbn; intros;
      rewrite ?H, ?H0, IHt; trivial.
Qed.
(* end hide *)

Lemma filter_idempotent :
  forall (A : Type) (f : A -> bool) (l : list A),
    filter f (filter f l) = filter f l.
(* begin hide *)
Proof.
  induction l as [| h t]; cbn.
    trivial.
    case_eq (f h); cbn; intro; try rewrite H, IHt; trivial.
Qed.
(* end hide *)

Lemma filter_map :
  forall (A B : Type) (f : A -> B) (p : B -> bool) (l : list A),
    filter p (map f l) = map f (filter (fun x : A => p (f x)) l).
(* begin hide *)
Proof.
  induction l as [| h t]; cbn.
    trivial.
    destruct (p (f h)); cbn; rewrite IHt; trivial.
Qed.
(* end hide *)

Lemma filter_replicate_true :
  forall (A : Type) (p : A -> bool) (n : nat) (x : A),
    p x = true -> filter p (replicate n x) = replicate n x.
(* begin hide *)
Proof.
  induction n as [| n']; cbn; intros; try rewrite H, IHn'; trivial.
Qed.
(* end hide *)

Lemma filter_replicate_false :
  forall (A : Type) (p : A -> bool) (n : nat) (x : A),
    p x = false -> filter p (replicate n x) = [].
(* begin hide *)
Proof.
  induction n as [| n']; cbn; intros; try rewrite H, IHn'; trivial.
Qed.
(* end hide *)

Lemma filter_replicate :
  forall (A : Type) (p : A -> bool) (n : nat) (x : A),
    filter p (replicate n x) =
    if p x then replicate n x else [].
(* begin hide *)
Proof.
  intros. case_eq (p x); intros.
    apply filter_replicate_true; assumption.
    apply filter_replicate_false; assumption.
Qed.
(* end hide *)

Lemma length_filter :
  forall (A : Type) (p : A -> bool) (l : list A),
    length (filter p l) <= length l.
(* begin hide *)
Proof.
  induction l as [| h t]; cbn; intros.
    trivial.
    destruct (p h).
      cbn. apply le_n_S. assumption.
      apply le_trans with (length t).
        assumption.
        apply le_S. apply le_n.
Qed.
(* end hide *)

Lemma filter_join :
  forall (A : Type) (p : A -> bool) (lla : list (list A)),
    filter p (join lla) = join (map (filter p) lla).
(* begin hide *)
Proof.
  induction lla as [| hl tl]; cbn.
    reflexivity.
    rewrite filter_app, IHtl. reflexivity.
Qed.
(* end hide *)

(** *** [partition] *)

(** Napisz funkcję [partition], która dzieli listę [l] na listy
    elementów spełniających i niespełniających pewnego warunku
    boolowskiego. *)

(* begin hide *)
Fixpoint partition {A : Type} (p : A -> bool) (l : list A)
    : list A * list A :=
match l with
    | [] => ([], [])
    | h :: t => let (l1, l2) := partition p t in
        if p h then (h :: l1, l2) else (l1, h :: l2)
end.
(* end hide *)

Lemma partition_spec :
  forall (A : Type) (p : A -> bool) (l : list A),
    partition p l = (filter p l, filter (fun x => negb (p x)) l).
(* begin hide *)
Proof.
  induction l as [| h t]; cbn.
    trivial.
    destruct (partition p t). destruct (p h); cbn; inversion IHt; trivial.
Qed.
(* end hide *)

(** *** [takeWhile] i [dropWhile] *)

(** Zdefiniuj funkcje [takeWhile] oraz [dropWhile], które, dopóki
    funkcja [p] zwraca [true], odpowiednio biorą lub usuwają elementy
    z listy. *)

(* begin hide *)
Fixpoint takeWhile {A : Type} (p : A -> bool) (l : list A) : list A :=
match l with
    | [] => []
    | h :: t => if p h then h :: takeWhile p t else []
end.

Fixpoint dropWhile {A : Type} (p : A -> bool) (l : list A) : list A :=
match l with
    | [] => []
    | h :: t => if p h then dropWhile p t else l
end.
(* end hide *)

Lemma takeWhile_false :
  forall (A : Type) (l : list A),
    takeWhile (fun _ => false) l = [].
(* begin hide *)
Proof.
  destruct l; cbn; trivial.
Qed.
(* end hide *)

Lemma dropWhile_false :
  forall (A : Type) (l : list A),
    dropWhile (fun _ => false) l = l.
(* begin hide *)
Proof.
  destruct l; cbn; trivial.
Qed.
(* end hide *)

Lemma takeWhile_idempotent :
  forall (A : Type) (p : A -> bool) (l : list A),
    takeWhile p (takeWhile p l) = takeWhile p l.
(* begin hide *)
Proof.
  induction l as [| h t]; cbn.
    trivial.
    case_eq (p h); cbn; intro.
      rewrite H. rewrite IHt. trivial.
      trivial.
Qed.
(* end hide *)

Lemma dropWhile_idempotent :
  forall (A : Type) (p : A -> bool) (l : list A),
    dropWhile p (dropWhile p l) = dropWhile p l.
(* begin hide *)
Proof.
  induction l as [| h t]; cbn.
    trivial.
    case_eq (p h); cbn; intro; [rewrite IHt | rewrite H]; trivial.
Qed.
(* end hide *)

Lemma takeWhile_replicate_true :
  forall (A : Type) (p : A -> bool) (n : nat) (x : A),
    p x = true -> takeWhile p (replicate n x) = replicate n x.
(* begin hide *)
Proof.
  induction n as [| n']; cbn; intros; try rewrite H, IHn'; trivial.
Qed.
(* end hide *)

Lemma takeWhile_replicate_false :
  forall (A : Type) (p : A -> bool) (n : nat) (x : A),
    p x = false -> takeWhile p (replicate n x) = [].
(* begin hide *)
Proof.
  destruct n as [| n']; cbn; intros; try rewrite H; trivial.
Qed.
(* end hide *)

Lemma takeWhile_replicate :
  forall (A : Type) (p : A -> bool) (n : nat) (x : A),
    takeWhile p (replicate n x) =
    if p x then replicate n x else [].
(* begin hide *)
Proof.
  intros. case_eq (p x); intros.
    apply takeWhile_replicate_true. assumption.
    apply takeWhile_replicate_false. assumption.
Qed.
(* end hide *)

Lemma dropWhile_replicate_true :
  forall (A : Type) (p : A -> bool) (n : nat) (x : A),
    p x = true -> dropWhile p (replicate n x) = [].
(* begin hide *)
Proof.
  induction n as [| n']; cbn; intros; rewrite ?H, ?IHn'; trivial.
Qed.
(* end hide *)

Lemma dropWhile_replicate_false :
  forall (A : Type) (p : A -> bool) (n : nat) (x : A),
    p x = false -> dropWhile p (replicate n x) = replicate n x.
(* begin hide *)
Proof.
  destruct n as [| n']; cbn; intros; rewrite ?H; trivial.
Qed.
(* end hide *)

Lemma dropWhile_replicate :
  forall (A : Type) (p : A -> bool) (n : nat) (x : A),
    dropWhile p (replicate n x) =
    if p x then [] else replicate n x.
(* begin hide *)
Proof.
  intros. case_eq (p x); intros.
    apply dropWhile_replicate_true. assumption.
    apply dropWhile_replicate_false. assumption.
Qed.
(* end hide *)

(** *** [zip] *)

(** Napisz funkcję [zip : forall A B : Type, list A -> list B -> list (A * B)],
    która spełnia poniższą specyfikację. Co robi ta funkcja? *)

(* begin hide *)
Fixpoint zip {A B : Type} (la : list A) (lb : list B) : list (A * B) :=
match la, lb with
    | [], _ => []
    | _, [] => []
    | ha :: ta, hb :: tb => (ha, hb) :: zip ta tb
end.
(* end hide *)

Lemma zip_nil_l :
  forall (A B : Type) (l : list B), zip (@nil A) l = [].
(* begin hide *)
Proof. cbn. trivial. Qed.
(* end hide *)

Lemma zip_nil_r :
  forall (A B : Type) (l : list A), zip l (@nil B) = [].
(* begin hide *)
Proof. destruct l; cbn; trivial. Qed.
(* end hide *)

Lemma length_zip :
  forall (A B : Type) (la : list A) (lb : list B),
    length (zip la lb) = min (length la) (length lb).
(* begin hide *)
Proof.
  induction la as [| ha ta]; intros.
    cbn. trivial.
    destruct lb as [| hb tb]; cbn.
      trivial.
      rewrite IHta. trivial.
Qed.
(* end hide *)

Lemma zip_not_rev :
  exists (A B : Type) (la : list A) (lb : list B),
    zip (rev la) (rev lb) <> rev (zip la lb).
(* begin hide *)
Proof.
  exists bool, bool. exists [true; false; true], [false; true].
  cbn. inversion 1.
Qed.
(* end hide *)

Lemma head_zip :
  forall (A B : Type) (la : list A) (lb : list B) (a : A) (b : B),
    head la = Some a -> head lb = Some b -> head (zip la lb) = Some (a, b).
(* begin hide *)
Proof.
  induction la as [| ha ta]; destruct lb as [| hb tb]; cbn; intros;
  inversion H; inversion H0; trivial.
Qed.
(* end hide *)

Lemma tail_zip :
  forall (A B : Type) (la ta : list A) (lb tb : list B),
    tail la = Some ta -> tail lb = Some tb ->
      tail (zip la lb) = Some (zip ta tb).
(* begin hide *)
Proof.
  induction la as [| ha ta']; cbn.
    inversion 1.
    destruct lb as [| hb tb']; cbn.
      inversion 2.
      do 2 inversion 1. trivial.
Qed.
(* end hide *)

Lemma zip_not_app :
  exists (A B : Type) (la la' : list A) (lb lb' : list B),
    zip (la ++ la') (lb ++ lb') <> zip la lb ++ zip la' lb'.
(* begin hide *)
Proof.
  exists bool, bool. exists [true], [false], [true; false; true], [].
  cbn. inversion 1.
Qed.
(* end hide *)

Lemma zip_map :
  forall (A B A' B' : Type) (f : A -> A') (g : B -> B')
  (la : list A) (lb : list B),
    zip (map f la) (map g lb) =
    map (fun x => (f (fst x), g (snd x))) (zip la lb).
(* begin hide *)
Proof.
  induction la; destruct lb; cbn; trivial.
    rewrite IHla. trivial.
Qed.
(* end hide *)

Lemma zip_not_filter :
  exists (A B : Type) (pa : A -> bool) (pb : B -> bool)
  (la : list A) (lb : list B),
    zip (filter pa la) (filter pb lb) <>
    filter (fun x => andb (pa (fst x)) (pb (snd x))) (zip la lb).
(* begin hide *)
Proof.
  exists bool, bool.
  exists (fun a : bool => if a then true else false). exists negb.
  exists [false; true], [false; true].
  cbn. inversion 1.
Qed.
(* end hide *)

Lemma zip_take :
  forall (A B : Type) (n : nat) (la : list A) (lb : list B),
    zip (take n la) (take n lb) = take n (zip la lb).
(* begin hide *)
Proof.
  induction n as [| n']; cbn.
    trivial.
    destruct la, lb; cbn; trivial.
      rewrite IHn'. trivial.
Qed.
(* end hide *)

Lemma zip_drop :
  forall (A B : Type) (n : nat) (la : list A) (lb : list B),
    zip (drop n la) (drop n lb) = drop n (zip la lb).
(* begin hide *)
Proof.
  induction n as [| n']; cbn.
    trivial.
    destruct la, lb; cbn; trivial.
      rewrite zip_nil_r. trivial.
Qed.
(* end hide *)

Lemma zip_replicate :
  forall (A B : Type) (n m : nat) (a : A) (b : B),
    zip (replicate n a) (replicate m b) =
    replicate (min n m) (a, b).
(* begin hide *)
Proof.
  induction n as [| n']; destruct m as [| m'];
  cbn; intros; rewrite ?IHn'; trivial.
Qed.
(* end hide *)

(** *** [unzip] *)

(** Zdefiniuj funkcję [unzip], która jest w pewnym sensie "odwrotna"
    do [zip]. *)

(* begin hide *)
Fixpoint unzip {A B : Type} (l : list (A * B)) : list A * list B :=
match l with
    | [] => ([], [])
    | (ha, hb) :: t =>
        let (ta, tb) := unzip t in (ha :: ta, hb :: tb)
end.
(* end hide *)

Lemma zip_unzip :
  forall (A B : Type) (l : list (A * B)),
    zip (fst (unzip l)) (snd (unzip l)) = l.
(* begin hide *)
Proof.
  induction l as [| [ha hb] t]; cbn.
    trivial.
    destruct (unzip t). cbn in *. rewrite IHt. trivial.
Qed.
(* end hide *)

Lemma unzip_zip :
  exists (A B : Type) (la : list A) (lb : list B),
    unzip (zip la lb) <> (la, lb).
(* begin hide *)
Proof.
  exists unit, unit, [], [tt]. cbn. inversion 1.
Qed.
(* end hide *)

(** *** [zipWith] *)

(** Zdefiniuj funkcję [zipWith], która spełnia poniższą specyfikację. *)

(* begin hide *)
Fixpoint zipWith {A B C : Type} (f : A -> B -> C)
  (la : list A) (lb : list B) : list C :=
match la, lb with
    | [], _ => []
    | _, [] => []
    | ha :: ta, hb :: tb => f ha hb :: zipWith f ta tb
end.
(* end hide *)

Lemma zipWith_spec :
  forall (A B C : Type) (f : A -> B -> C)
  (la : list A) (lb : list B),
    zipWith f la lb =
    map (fun x => f (fst x) (snd x)) (zip la lb).
(* begin hide *)
Proof.
  induction la as [| ha ta]; destruct lb as [| hb tb];
  cbn; intros; rewrite ?IHta; reflexivity.
Qed.
(* end hide *)

(** *** [intersperse] *)

(** Napisz funkcję [intersperse], który wstawia element [x : A] między
    każde dwa elementy z listy [l : list A]. *)

(* begin hide *)
Fixpoint intersperse {A : Type} (x : A) (l : list A) : list A :=
match l with
    | [] => []
    | [h] => [h]
    | h :: t => h :: x :: intersperse x t
end.
(* end hide *)

Lemma length_intersperse :
  forall (A : Type) (x : A) (l : list A),
    length (intersperse x l) = 2 * length l - 1.
(* begin hide *)
Proof.
  induction l as [| h [| h' t]]; cbn in *; trivial.
  Require Import Omega. rewrite IHl. omega.
Qed.
(* end hide *)

Lemma intersperse_app :
  forall (A : Type) (x : A) (l1 l2 : list A),
    intersperse x (l1 ++ l2) =
    match l1 with
      | [] => intersperse x l2
      | h1 :: t1 =>
          match l2 with
            | [] => intersperse x l1
            | h2 :: t2 => intersperse x l1 ++ x :: intersperse x l2
          end
    end.
(* begin hide *)
Proof.
  Functional Scheme intersperse_ind := Induction for intersperse Sort Prop.
  intros.
  functional induction @intersperse A x l1; cbn.
    reflexivity.
    reflexivity.
    cbn in *. rewrite IHl.
      functional induction @intersperse A x l2; reflexivity.
Qed.
(* end hide *)

Lemma intersperse_rev :
  forall (A : Type) (x : A) (l : list A),
    intersperse x (rev l) = rev (intersperse x l).
(* begin hide *)
Proof.
  induction l as [| h [| h' t]]; cbn in *; trivial.
  rewrite <- IHl, <- !app_assoc, !intersperse_app. cbn.
  destruct (rev t); cbn.
    reflexivity.
    rewrite <- app_assoc. cbn. reflexivity.
Qed.
(* end hide *)

Lemma filter_intersperse :
  forall (A : Type) (p : A -> bool) (x : A) (l : list A),
    p x = false -> filter p (intersperse x l) = filter p l.
(* begin hide *)
Proof.
  induction l as [| h [| h' t]]; cbn in *; intros; trivial.
    rewrite H, (IHl H). reflexivity.
Qed.
(* end hide *)

Lemma intersperse_map :
  forall (A B : Type) (f : A -> B) (l : list A) (a : A) (b : B),
    f a = b -> intersperse b (map f l) = map f (intersperse a l).
(* begin hide *)
Proof.
  induction l as [| h [| h' t]]; cbn; trivial; intros.
  rewrite H. cbn in *. rewrite (IHl _ _ H). trivial.
Qed.
(* end hide *)

Lemma head_intersperse :
  forall (A : Type) (x : A) (l : list A),
    head (intersperse x l) = head l.
(* begin hide *)
Proof.
  destruct l as [| h1 [| h2 t]]; reflexivity.
Qed.
(* end hide *)

(** *** [find] *)

(** Napisz funkcję [find], która znajduje pierwszy element na liście,
    który spełnia podany predykat boolowski. Podaj i udowodnij jej
    specyfikację. *)

(* begin hide *)
Function find {A : Type} (p : A -> bool) (l : list A) : option A :=
match l with
    | [] => None
    | h :: t => if p h then Some h else find p t
end.
(* end hide *)

Lemma find_spec :
  forall (A : Type) (p : A -> bool) (l : list A),
    find p l = head (filter p l).
(* begin hide *)
Proof.
  induction l as [| h t]; cbn.
    reflexivity.
    destruct (p h); cbn.
      reflexivity.
      apply IHt.
Qed.
(* end hide *)

Lemma find_false :
  forall (A : Type) (l : list A),
    find (fun _ => false) l = None.
(* begin hide *)
Proof.
  intros. rewrite find_spec, filter_false. reflexivity.
Qed.
(* end hide *)

Lemma find_true :
  forall (A : Type) (l : list A),
    find (fun _ => true) l = head l.
(* begin hide *)
Proof.
  intros. rewrite find_spec, filter_true. reflexivity.
Qed.
(* end hide *)

(** *** [findIndex] *)

(** Napisz funkcję [findIndex], która znajduje indeks pierwszego elementu,
    który spełnia predykat boolowski [p]. *)

(* begin hide *)
Function findIndex {A : Type} (p : A -> bool) (l : list A) : option nat :=
match l with
    | [] => None
    | h :: t =>
        if p h
        then Some 0
        else match findIndex p t with
            | None => None
            | Some n => Some (S n)
        end
end.
(* end hide *)

Lemma findIndex_spec :
  forall (A : Type) (p : A -> bool) (l : list A) (n : nat),
    findIndex p l = Some n ->
      exists x : A, nth n l = Some x /\ p x = true.
(* begin hide *)
Proof.
  induction l as [| h t]; cbn.
    inversion 1.
    case_eq (p h); intros.
      inversion H0; subst; clear H0; cbn. exists h. auto. 
      case_eq (findIndex p t); intros.
        rewrite H1 in H0. inversion H0; subst; clear H0.
          destruct (IHt _ H1). exists x. cbn. assumption.
        rewrite H1 in H0. inversion H0.
Restart.
  intros A p l. functional induction @findIndex A p l;
  intros; inversion H; subst; clear H; cbn in *.
    exists h. auto.
    destruct (IHo _ e1) as [x H]. exists x. assumption.
Qed.
(* end hide *)

(** *** [findIndices] *)

(** Napisz funkcję [findIndices], która znajduje indeksy wszystkich
    elementów listy, które spełniają predykat boolowski [p]. *)

(* begin hide *)
Definition findIndices {A : Type} (p : A -> bool) (l : list A) : list nat :=
  (fix f (l : list A) (n : nat) : list nat :=
  match l with
      | [] => []
      | h :: t => if p h then n :: f t (S n) else f t (S n)
  end) l 0.
(* end hide *)

(** *** Zwijanie *)

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

    Zaimplementuj za pomocą [foldr] lub [foldl] następujące funkcje:
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

(** *** Dziwne *)

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

(** *** [elem] *)

(** Zdefiniuj induktywny predykat [elem]. [elem x l] jest spełniony, gdy
    [x] jest elementem listy [l]. *)

(* begin hide *)
Inductive elem {A : Type} : A -> list A -> Prop :=
    | elem_head : forall (x : A) (l : list A),
        elem x (x :: l)
    | elem_cons : forall (x h : A) (t : list A),
        elem x t -> elem x (h :: t).
(* end hide *)

Lemma elem_not_nil :
  forall (A : Type) (x : A), ~ elem x [].
(* begin hide *)
Proof. inversion 1. Qed.
(* end hide *)

Lemma elem_not_cons :
  forall (A : Type) (x h : A) (t : list A),
    ~ elem x (h :: t) -> x <> h /\ ~ elem x t.
(* begin hide *)
Proof.
  split; intro; apply H; subst; constructor; auto.
Qed.
(* end hide *)

Lemma elem_app_l :
  forall (A : Type) (x : A) (l1 l2 : list A),
    elem x l1 -> elem x (l1 ++ l2).
(* begin hide *)
Proof.
  induction 1; cbn.
    constructor.
    constructor. assumption.
Qed.
(* end hide *)

Lemma elem_app_r :
  forall (A : Type) (x : A) (l1 l2 : list A),
    elem x l2 -> elem x (l1 ++ l2).
(* begin hide *)
Proof.
  induction l1 as [| h t]; cbn; intros.
    assumption.
    constructor. apply IHt. assumption.
Qed.
(* end hide *)

Lemma elem_or_app :
  forall (A : Type) (x : A) (l1 l2 : list A),
    elem x l1 \/ elem x l2 -> elem x (l1 ++ l2).
(* begin hide *)
Proof.
  destruct 1; [apply elem_app_l | apply elem_app_r]; assumption.
Qed.
(* end hide *)

Lemma elem_app_or :
  forall (A : Type) (x : A) (l1 l2 : list A),
    elem x (l1 ++ l2) -> elem x l1 \/ elem x l2.
(* begin hide *)
Proof.
  induction l1 as [| h1 t1]; cbn; intros.
    right. assumption.
    inversion H; subst.
      left. constructor.
      destruct (IHt1 _ H2).
        left. constructor. assumption.
        right. assumption.
Qed.
(* end hide *)

Lemma elem_app :
  forall (A : Type) (x : A) (l1 l2 : list A),
    elem x (l1 ++ l2) <-> elem x l1 \/ elem x l2.
(* begin hide *)
Proof.
  split; intros; [apply elem_app_or | apply elem_or_app]; assumption.
Qed.
(* end hide *)

Lemma elem_spec :
  forall (A : Type) (x : A) (l : list A),
    elem x l <-> exists l1 l2 : list A, l = l1 ++ x :: l2.
(* begin hide *)
Proof.
  split.
    induction 1.
      exists [], l. cbn. reflexivity.
      destruct IHelem as [l1 [l2 IH]].
        exists (h :: l1), l2. rewrite IH. cbn. reflexivity.
    destruct 1 as [l1 [l2 ->]]. apply elem_app_r. constructor.
Qed.
(* end hide *)

Lemma elem_map :
  forall (A B : Type) (f : A -> B) (l : list A) (x : A),
    elem x l -> elem (f x) (map f l).
(* begin hide *)
Proof.
  induction l as [| h t]; cbn; inversion 1; subst.
    constructor.
    constructor. apply IHt. assumption.
Qed.
(* end hide *)

Lemma elem_map_conv :
  forall (A B : Type) (f : A -> B) (l : list A) (y : B),
    elem y (map f l) <-> exists x : A, f x = y /\ elem x l.
(* begin hide *)
Proof.
  split.
    induction l as [| h t]; cbn; intros.
      inversion H.
      inversion H; subst.
        exists h. split; trivial. constructor.
        destruct (IHt H2) as [x [Hx1 Hx2]]. exists x.
          split; trivial. constructor. assumption.
    destruct 1 as [x [<- H2]]. apply elem_map, H2.
Qed.
(* end hide *)

Lemma elem_map_conv' :
  forall (A B : Type) (f : A -> B) (l : list A) (x : A),
    (forall x y : A, f x = f y -> x = y) ->
      elem (f x) (map f l) -> elem x l.
(* begin hide *)
Proof.
  induction l as [| h t]; cbn; inversion 2; subst.
    specialize (H _ _ H3). subst. constructor.
    constructor. apply IHt; assumption.
Qed.
(* end hide *)

Lemma map_ext_elem :
  forall (A B : Type) (f g : A -> B) (l : list A),
    (forall x : A, elem x l -> f x = g x) -> map f l = map g l.
(* begin hide *)
Proof.
  induction l as [| h t]; cbn; intros.
    reflexivity.
    rewrite H, IHt.
      trivial.
      intros. apply H. constructor. assumption.
      constructor.
Qed.
(* end hide *)

Lemma elem_join :
  forall (A : Type) (x : A) (ll : list (list A)),
    elem x (join ll) <-> exists l : list A, elem x l /\ elem l ll.
(* begin hide *)
Proof.
  split.
    induction ll as [| h t]; cbn; intros.
      inversion H.
      rewrite elem_app in H. destruct H.
        exists h. split; try left; assumption.
        destruct (IHt H) as [l [H1 H2]].
          exists l. split; try right; assumption.
    destruct 1 as [l [H1 H2]]. induction H2; cbn.
      apply elem_app_l. assumption.
      apply elem_app_r, IHelem, H1.
Qed.
(* end hide *)

Lemma elem_replicate :
  forall (A : Type) (n : nat) (x y : A),
    elem y (replicate n x) <-> n <> 0 /\ x = y.
(* begin hide *)
Proof.
  split.
    induction n as [| n']; cbn; inversion 1; subst.
      split; auto.
      destruct (IHn' H2). auto.
    intros [H H']. rewrite H'. destruct n as [| n'].
      contradiction H. trivial.
      cbn. left.
Qed.
(* end hide *)

Lemma nth_elem :
  forall (A : Type) (n : nat) (l : list A),
    n < length l -> exists x : A, nth n l = Some x /\ elem x l.
(* begin hide *)
Proof.
  induction n as [| n']; destruct l as [| h t]; cbn; intros.
    inversion H.
    exists h. split; [trivial | constructor].
    inversion H.
    apply lt_S_n in H. destruct (IHn' _ H) as [x [Hx1 Hx2]].
      exists x. split; try constructor; assumption.
Qed.
(* end hide *)

Lemma nth_elem_conv :
  forall (A : Type) (x : A) (l : list A),
    elem x l -> exists n : nat, nth n l = Some x.
(* begin hide *)
Proof.
  induction l as [| h t]; cbn; inversion 1; subst.
    exists 0. cbn. trivial.
    destruct (IHt H2) as [n Hn]. exists (S n). cbn. assumption.
Qed.
(* end hide *)

Lemma nth_elem_Some :
  forall (A : Type) (x : A) (n : nat) (l : list A),
    nth n l = Some x -> elem x l.
(* begin hide *)
Proof.
  induction n as [| n']; destruct l as [| h t]; cbn.
    1-3: inversion 1; subst; clear H. constructor.
    intro. right. apply IHn', H.
Qed.
(* end hide *)

Lemma elem_rev_aux :
  forall (A : Type) (x : A) (l : list A),
    elem x l -> elem x (rev l).
(* begin hide *)
Proof.
  induction l as [| h t]; cbn; intros.
    assumption.
    inversion H; subst.
      apply elem_app_r. constructor.
      apply elem_app_l. apply IHt. assumption.
Qed.
(* end hide *)

Lemma elem_rev :
  forall (A : Type) (x : A) (l : list A),
    elem x (rev l) <-> elem x l.
(* begin hide *)
Proof.
  split; intro.
    apply elem_rev_aux in H. rewrite rev_inv in H. assumption.
    apply elem_rev_aux, H.
Qed.
(* end hide *)

Lemma elem_take :
  forall (A : Type) (n : nat) (l : list A) (x : A),
    elem x (take n l) -> elem x l.
(* begin hide *)
Proof.
  induction n as [| n'].
    cbn. inversion 1.
    destruct l as [| h t]; cbn.
      inversion 1.
      intros. inversion H; subst; constructor. apply IHn'. assumption.
Qed.
(* end hide *)

Lemma elem_drop :
  forall (A : Type) (n : nat) (l : list A) (x : A),
    elem x (drop n l) -> elem x l.
(* begin hide *)
Proof.
  induction n as [| n'].
    cbn. trivial.
    destruct l as [| h t]; cbn.
      inversion 1.
      intros. constructor. apply IHn'. assumption.
Qed.
(* end hide *)

Lemma elem_filter :
  forall (A : Type) (p : A -> bool) (l : list A) (x : A),
    elem x (filter p l) <-> p x = true /\ elem x l.
(* begin hide *)
Proof.
  split.
    induction l as [| h t]; cbn; intros.
      inversion H.
      case_eq (p h); intros; rewrite H0 in *.
        inversion H; subst; clear H.
          repeat constructor. assumption.
          destruct (IHt H3). firstorder constructor. assumption.
        destruct (IHt H). firstorder constructor. assumption.
    destruct 1. induction H0; cbn.
      rewrite H. constructor.
      destruct (p h).
        right. apply IHelem, H.
        apply IHelem, H.
Qed.
(* end hide *)

Lemma elem_partition :
  forall (A : Type) (p : A -> bool) (x : A) (l l1 l2 : list A),
    partition p l = (l1, l2) ->
      elem x l <-> elem x l1 \/ elem x l2.
(* begin hide *)
Proof.
  split.
    intro. revert dependent l2; revert dependent l1.
    induction H0; cbn in *; intros.
      destruct (partition p l), (p x); inversion H; subst; clear H.
        left. constructor.
        right. constructor.
      destruct (partition p t), (p h); inversion H; subst; clear H.
        destruct (IHelem _ _ eq_refl).
          left; right; assumption.
          right; assumption.
        destruct (IHelem _ _ eq_refl).
          left; assumption.
          right; right; assumption.
    revert dependent l2; revert dependent l1.
    induction l as [| h t]; cbn in *; intros.
      inversion H; subst; clear H. destruct H0; assumption.
      destruct (partition p t), (p h).
        inversion H; subst; clear H. destruct H0.
          inversion H; subst; clear H.
            constructor.
            right. apply (IHt _ _ eq_refl). left. assumption.
          right. apply (IHt _ _ eq_refl). right. assumption.
        inversion H; subst; clear H. destruct H0.
          right. apply (IHt _ _ eq_refl). left. assumption.
          inversion H; subst; clear H.
            constructor.
            right. apply (IHt _ _ eq_refl). right. assumption.
Qed.
(* end hide *)

Lemma elem_takeWhile :
  forall (A : Type) (p : A -> bool) (l : list A) (x : A),
    elem x (takeWhile p l) -> elem x l /\ p x = true.
(* begin hide *)
Proof.
  induction l as [| h t]; cbn; intros.
    inversion H.
    case_eq (p h); intros; rewrite H0 in *.
      split.
        inversion H; subst; clear H.
          constructor.
          right. destruct (IHt _ H3). assumption.
        inversion H; subst; clear H.
          assumption.
          destruct (IHt _ H3). assumption.
      inversion H.
Qed.
(* end hide *)

Lemma elem_dropWhile :
  forall (A : Type) (p : A -> bool) (l : list A) (x : A),
    elem x (dropWhile p l) -> elem x l.
(* begin hide *)
Proof.
  induction l as [| h t]; cbn; intros.
    inversion H.
    case_eq (p h); intros; rewrite H0 in *.
      destruct (IHt _ H).
        right; left.
        right; right; assumption.
      assumption.
Qed.
(* end hide *)

Lemma elem_dropWhile_conv :
  forall (A : Type) (p : A -> bool) (l : list A) (x : A),
    elem x l -> ~ elem x (dropWhile p l) -> p x = true.
(* begin hide *)
Proof.
  induction l as [| h t]; cbn; intros.
    inversion H.
    case_eq (p h); intro.
      rewrite H1 in H0. inversion H; subst.
        assumption.
        apply IHt; assumption.
      rewrite H1 in H0. contradiction H.
Qed.
(* end hide *)

Lemma elem_zip :
  forall (A B : Type) (a : A) (b : B) (la : list A) (lb : list B),
    elem (a, b) (zip la lb) -> elem a la /\ elem b lb.
(* begin hide *)
Proof.
  induction la; cbn.
    inversion 1.
    destruct lb; cbn; inversion 1; subst; cbn in *.
      split; constructor.
      destruct (IHla _ H2). split; right; assumption.
Qed.
(* end hide *)

Lemma zip_not_elem :
  exists (A B : Type) (a : A) (b : B) (la : list A) (lb : list B),
    elem a la /\ elem b lb /\ ~ elem (a, b) (zip la lb).
(* begin hide *)
Proof.
  exists bool, bool. exists true, false.
  exists [true; false], [true; false].
  cbn. repeat split.
    repeat constructor.
    repeat constructor.
    inversion 1; subst. inversion H2; subst. inversion H3.
Qed.
(* end hide *)

(** *** [NoDup] *)

(** Zdefiniuj induktywny predykat [NoDup]. Zdanie [NoDup l] jest prawdziwe,
    gdy w [l] nie ma powtarzających się elementów. Udowodnij, że zdefiniowany
    przez ciebie predykat posiada pożądane właściwości. *)

(* begin hide *)
Inductive NoDup {A : Type} : list A -> Prop :=
    | NoDup_nil : NoDup []
    | NoDup_cons :
        forall (h : A) (t : list A),
          ~ elem h t -> NoDup t -> NoDup (h :: t).
(* end hide *)

Lemma NoDup_singl :
  forall (A : Type) (x : A), NoDup [x].
(* begin hide *)
Proof.
  repeat constructor. inversion 1.
Qed.
(* end hide *)

Lemma NoDup_length :
  forall (A : Type) (l : list A),
    ~ NoDup l -> 2 <= length l.
(* begin hide *)
Proof.
  induction l as [| h t]; cbn; intros.
    contradiction H. constructor.
    destruct t as [| h' t']; cbn.
      contradiction H. apply NoDup_singl.
      apply le_n_S, le_n_S, le_0_n.
Qed.
(* end hide *)

Lemma NoDup_app :
  forall (A : Type) (l1 l2 : list A),
    NoDup (l1 ++ l2) <->
    NoDup l1 /\
    NoDup l2 /\
    (forall x : A, elem x l1 -> ~ elem x l2) /\
    (forall x : A, elem x l2 -> ~ elem x l1).
(* begin hide *)
Proof.
  split; intros.
    induction l1 as [| h1 t1]; cbn; intros.
      repeat split; firstorder.
        constructor.
        inversion H0.
        intro. inversion H1.
      inversion H; subst; clear H. rewrite elem_app in H2.
        decompose [and] (IHt1 H3); clear IHt1. repeat split; intros.
          constructor.
            firstorder.
            assumption.
          assumption.
          inversion H4; firstorder.
          inversion 1; subst; firstorder.
  decompose [and] H; clear H.
  induction H0; cbn.
    assumption.
    constructor.
      rewrite elem_app. destruct 1.
        contradiction.
        apply (H1 h).
          constructor.
          assumption.
      apply IHNoDup; intros.
        intro. apply (H1 x).
          constructor. assumption.
          assumption.
        intro. apply (H4 x).
          assumption.
          constructor. assumption.
Qed.
(* end hide *)

Lemma NoDup_rev :
  forall (A : Type) (l : list A),
    NoDup (rev l) <-> NoDup l.
(* begin hide *)
Proof.
  assert (forall (A : Type) (l : list A), NoDup l -> NoDup (rev l)).
    induction 1; cbn.
      constructor.
      apply NoDup_app; repeat split; intros.
        assumption.
        apply NoDup_singl.
        inversion 1; subst.
          contradiction H. rewrite <- elem_rev. assumption.
          inversion H5.
        inversion H1; subst; clear H1.
          intro. contradiction H. rewrite <- elem_rev. assumption.
          inversion H4.
  split; intro.
    rewrite <- rev_inv. apply H. assumption.
    apply H. assumption.
Qed.
(* end hide *)

Lemma NoDup_map :
  forall (A B : Type) (f : A -> B) (l : list A),
    NoDup (map f l) -> NoDup l.
(* begin hide *)
Proof.
  induction l as [| h t]; cbn; intros;
  constructor; inversion H; subst; clear H.
    intro. apply H2, elem_map. assumption.
    apply IHt. assumption.
Qed.
(* end hide *)

Lemma NoDup_map_inj :
  forall (A B : Type) (f : A -> B) (l : list A),
    (forall x y : A, f x = f y -> x = y) ->
      NoDup l -> NoDup (map f l).
(* begin hide *)
Proof.
  induction 2; cbn; constructor.
    intro. apply H0, (elem_map_conv' _ _ f _ h H). assumption.
    assumption.
Qed.
(* end hide *)

Lemma NoDup_replicate :
  forall (A : Type) (n : nat) (x : A),
    NoDup (replicate n x) <-> n = 0 \/ n = 1.
(* begin hide *)
Proof.
  split.
    induction n as [| n']; cbn; intros.
      left. reflexivity.
      inversion H; subst. destruct (IHn' H3); subst.
        right. reflexivity.
        contradiction H2. constructor.
    destruct 1; subst; cbn; repeat constructor. inversion 1.
Qed.
(* end hide *)

Lemma NoDup_take :
  forall (A : Type) (n : nat) (l : list A),
    NoDup l -> NoDup (take n l).
(* begin hide *)
Proof.
  induction n as [| n']; cbn; intros.
    constructor.
    inversion H; subst; clear H; constructor.
      intro. apply H0. apply elem_take with n'. assumption.
      apply IHn'. assumption.
Qed.
(* end hide *)

Lemma NoDup_drop :
  forall (A : Type) (n : nat) (l : list A),
    NoDup l -> NoDup (drop n l).
(* begin hide *)
Proof.
  induction n as [| n']; cbn; intros.
    assumption.
    inversion H; subst; clear H.
      constructor.
      apply IHn', H1.
Qed.
(* end hide *)

Lemma NoDup_filter :
  forall (A : Type) (p : A -> bool) (l : list A),
    NoDup l -> NoDup (filter p l).
(* begin hide *)
Proof.
  induction 1; cbn.
    constructor.
    destruct (p h).
      constructor.
        intro. apply H. apply elem_filter in H1. destruct H1. assumption.
        assumption.
      assumption.
Qed.
(* end hide *)

Lemma NoDup_partition :
  forall (A : Type) (p : A -> bool) (l l1 l2 : list A),
    partition p l = (l1, l2) -> NoDup l <-> NoDup l1 /\ NoDup l2.
(* begin hide *)
Proof.
  split.
    intro. revert dependent l2. revert dependent l1.
    induction H0; cbn in *; intros.
      inversion H; subst; clear H. split; constructor.
      case_eq (partition p t); case_eq (p h); intros; rewrite H2, H3 in *.
        inversion H1; subst; clear H1. destruct (IHNoDup _ _ eq_refl). split.
          constructor.
            intro. apply H. apply (elem_partition _ _ h) in H3.
              rewrite H3. left. assumption.
            assumption.
          assumption.
        inversion H1; subst; clear H1. destruct (IHNoDup _ _ eq_refl). split.
          assumption.
          constructor.
            intro. apply H. apply (elem_partition _ _ h) in H3. rewrite H3.
              right. assumption.
            assumption.
    revert dependent l2; revert dependent l1.
    induction l as [| h t]; cbn in *; intros.
      constructor.
      constructor.
        Focus 2. destruct (partition p t), (p h).
          destruct H0. inversion H; subst; inversion H0; subst; clear H H0.
            eapply IHt; eauto.
          destruct H0. inversion H; subst; inversion H1; subst; clear H H1.
            eapply IHt; eauto.
        intro. case_eq (partition p t); case_eq (p h); intros; subst;
        rewrite H2, H3 in *; inversion H; subst; clear H.
          pose (H4 := H3). apply (elem_partition _ _ h) in H4.
            rewrite H4 in H1. destruct H1.
              destruct H0. inversion H0. contradiction.
              rewrite partition_spec in H3. inversion H3; subst; clear H3.
                apply elem_filter in H. destruct H. destruct (p h).
                  inversion H.
                  inversion H2.
          pose (H4 := H3). apply (elem_partition _ _ h) in H4.
            rewrite H4 in H1. destruct H1.
              rewrite partition_spec in H3. inversion H3; subst; clear H3.
                apply elem_filter in H. destruct H. destruct (p h).
                  inversion H2.
                  inversion H.
              destruct H0. inversion H1. contradiction.
Qed.
(* end hide *)

Lemma NoDup_takeWhile :
  forall (A : Type) (p : A -> bool) (l : list A),
    NoDup l -> NoDup (takeWhile p l).
(* begin hide *)
Proof.
  induction 1; cbn.
    constructor.
    destruct (p h); constructor.
      intro. apply H. apply elem_takeWhile in H1. destruct H1. assumption.
      assumption.
Qed.
(* end hide *)

Lemma NoDup_dropWhile :
  forall (A : Type) (p : A -> bool) (l : list A),
    NoDup l -> NoDup (dropWhile p l).
(* begin hide *)
Proof.
  induction 1; cbn.
    constructor.
    destruct (p h).
      assumption.
      constructor; assumption.
Qed.
(* end hide *)

Lemma NoDup_zip :
  forall (A B : Type) (la : list A) (lb : list B),
    NoDup la /\ NoDup lb -> NoDup (zip la lb).
(* begin hide *)
Proof.
  induction la as [| ha ta]; cbn; intros.
    constructor.
    destruct lb as [| hb tb]; cbn in *.
      constructor.
      destruct H. inversion H; inversion H0; subst; clear H H0; constructor.
        intro. apply elem_zip in H. destruct H. contradiction.
        apply IHta. split; assumption.
Qed.
(* end hide *)

Lemma NoDup_intersperse :
  forall (A : Type) (x : A) (l : list A),
    NoDup (intersperse x l) -> length l <= 2.
(* begin hide *)
Proof.
  intros. functional induction @intersperse A x l; cbn.
    apply le_0_n.
    apply le_S, le_n.
    destruct _x0; cbn in *.
      apply le_n.
      inversion H. inversion H3. contradiction H6. right; left.
Qed.
(* end hide *)

Lemma NoDup_zip_conv :
  forall (A B : Type) (la : list A) (lb : list B),
    NoDup (zip la lb) -> NoDup la \/ NoDup lb.
(* begin hide *)
Proof.
  induction la as [| ha ta]; cbn; intros.
    left. constructor.
    destruct lb as [| hb tb]; cbn.
      right. constructor.
      inversion H; subst; clear H. destruct (IHta _ H3).
Abort.
(* end hide *)

Lemma NoDup_cons_inv :
  forall (A : Type) (h : A) (t : list A),
    ~ NoDup (h :: t) -> elem h t \/ ~ NoDup t.
(* begin hide *)
Proof.
  intros. induction t as [| h' t']; cbn.
    contradiction H. constructor.
      inversion 1.
      constructor.
Abort.

Lemma NoDup_spec :
  forall (A : Type) (l : list A),
    ~ NoDup l <->
    exists (x : A) (l1 l2 l3 : list A),
      l = l1 ++ x :: l2 ++ x :: l3.
(* begin hide *)
Proof.
  split.
    Focus 2. destruct 1 as (x & l1 & l2 & l3 & H). subst. intro.
      rewrite <- !app_cons_l in H. rewrite !NoDup_app in H.
      decompose [and] H; clear H. specialize (H4 x). apply H4; constructor.
    induction l as [| h t]; cbn; intros.
      contradiction H. constructor.
      change (h :: t) with ([h] ++ t) in H. rewrite NoDup_app in H.
        contradiction H.
Abort.
(* end hide *)

(** *** [Dup] (TODO) *)

(** Powodem problemów z predykatem [NoDup] jest fakt, że jest on w pewnym
    sensie niekonstruktywny. Wynika to wprost z jego definicji: [NoDup l]
    zachodzi, gdy w [l] nie ma duplikatów. Parafrazując: [NoDup l] zachodzi,
    gdy _nieprawda_, że w [l] są duplikaty.

    Jak widać, w naszej definicji implicité występuje negacja. Wobec tego
    jeżeli spróbujemy za pomocą [NoDup] wyrazić zdanie "na liście [l] są
    duplikaty", to tak naprawdę dostaniemy zdanie "nieprawda, że nieprawda,
    że [l] ma duplikaty".

    Dostaliśmy więc po głowie nagłym atakiem podwójnej negacji. Nie ma się
    co dziwić w takiej sytuacji, że nasza "negatywna" definicja predykatu
    [NoDup] jest nazbyt klasyczna. Możemy jednak uratować sytuację, jeżeli
    zdefiniujemy predykat [Dup] i zanegujemy go. [Dup l] jest spełniony,
    gdy lista [l] ma duplikaty. *)

(* begin hide *)
Inductive Dup {A : Type} : list A -> Prop :=
    | Dup_elem :
        forall (h : A) (t : list A),
          elem h t -> Dup (h :: t)
    | Dup_tail :
        forall (h : A) (t : list A),
          Dup t -> Dup (h :: t).
(* end hide *)

Lemma Dup_spec :
  forall (A : Type) (l : list A),
    Dup l <->
    exists (x : A) (l1 l2 l3 : list A), l = l1 ++ x :: l2 ++ x :: l3.
(* begin hide *)
Proof.
  split.
    induction 1.
      induction H.
        exists x, [], [], l. cbn. reflexivity.
        destruct IHelem as (x' & l1 & l2 & l3 & H').
          destruct l1; inversion H'; subst; clear H'.
            exists x', [], (h :: l2), l3. cbn. reflexivity.
            exists x', (a :: h :: l1), l2, l3. cbn. reflexivity.
      destruct IHDup as (x' & l1 & l2 & l3 & H'); subst.
        exists x', (h :: l1), l2, l3. cbn. reflexivity.
    destruct 1 as (x & l1 & l2 & l3 & H); subst.
    induction l1 as [| h1 t1]; cbn.
      constructor. rewrite elem_app. right. constructor.
      right. assumption.
Qed.
(* end hide *)

Lemma Dup_NoDup :
  forall (A : Type) (l : list A),
    ~ Dup l <-> NoDup l.
(* begin hide *)
Proof.
  split.
    induction l as [| h t]; cbn; intros.
      constructor.
      constructor.
        intro. apply H. left. assumption.
        apply IHt. intro. apply H. right. assumption.
    induction 1; cbn; intro.
      inversion H.
      inversion H1; subst; clear H1; contradiction.
Qed.
(* end hide *)

Lemma Dup_app_l :
  forall (A : Type) (l1 l2 : list A),
    Dup l1 -> Dup (l1 ++ l2).
(* begin hide *)
Proof.
  induction 1; cbn.
    constructor. apply elem_app_l. assumption.
    right. assumption.
Qed.
(* end hide *)

Lemma Dup_app_r :
  forall (A : Type) (l1 l2 : list A),
    Dup l2 -> Dup (l1 ++ l2).
(* begin hide *)
Proof.
  induction l1 as [| h1 t1]; cbn; intros.
    assumption.
    right. apply (IHt1 _ H).
Qed.
(* end hide *)

Lemma Dup_app_both :
  forall (A : Type) (x : A) (l1 l2 : list A),
    elem x l1 -> elem x l2 -> Dup (l1 ++ l2).
(* begin hide *)
Proof.
  induction 1; cbn; intros.
    constructor. apply elem_app_r. assumption.
    right. apply IHelem, H0.
Qed.
(* end hide *)

Lemma Dup_app :
  forall (A : Type) (l1 l2 : list A),
    Dup (l1 ++ l2) <->
    Dup l1 \/ Dup l2 \/ exists x : A, elem x l1 /\ elem x l2.
(* begin hide *)
Proof.
  split.
    induction l1 as [| h1 t1]; cbn; intros.
      right; left. assumption.
      inversion H; subst; clear H.
        rewrite elem_app in H1. destruct H1.
          left. constructor. assumption.
          right; right. exists h1. split; [constructor | assumption].
        decompose [ex or] (IHt1 H1); clear IHt1.
          left; right. assumption.
          right; left. assumption.
          destruct H. right; right. exists x.
            split; try constructor; assumption.
    destruct 1 as [H | [H | [x [H1 H2]]]].
      apply Dup_app_l; assumption.
      apply Dup_app_r; assumption.
      apply (Dup_app_both _ x); assumption.
Qed.
(* end hide *)

Lemma Dup_rev :
  forall (A : Type) (l : list A),
    Dup (rev l) <-> Dup l.
(* begin hide *)
Proof.
  assert (forall (A : Type) (l : list A), Dup l -> Dup (rev l)).
    induction 1; cbn.
      apply Dup_app_both with h.
        apply elem_rev. assumption.
        constructor.
      apply Dup_app_l. assumption.
    split; intros.
      rewrite <- rev_inv. apply H. assumption.
      apply H. assumption.
Qed.
(* end hide *)

Lemma Dup_map :
  forall (A B : Type) (f : A -> B) (l : list A),
    Dup l -> Dup (map f l).
(* begin hide *)
Proof.
  induction 1; cbn.
    left. apply elem_map. assumption.
    right. assumption.
Qed.
(* end hide *)

Lemma Dup_map_conv :
  forall (A B : Type) (f : A -> B) (l : list A),
    (forall x y : A, f x = f y -> x = y) ->
      Dup (map f l) -> Dup l.
(* begin hide *)
Proof.
  induction l as [| h t]; cbn; intros.
    inversion H0.
    inversion H0; subst; clear H0.
      left. apply (elem_map_conv' _ _ _ _ _ H H2).
      right. apply IHt; assumption.
Qed.
(* end hide *)

Lemma Dup_join :
  forall (A : Type) (ll : list (list A)),
    Dup (join ll) <->
    (exists l : list A, elem l ll /\ Dup l) \/
    (exists (x : A) (l1 l2 : list A),
      elem x l1 /\ elem x l2 /\ elem l1 ll /\ elem l2 ll).
(* begin hide *)
Proof.
  split.
    induction ll as [| h t]; cbn; intros.
      inversion H.
      apply Dup_app in H. decompose [or ex] H; clear H.
        left. exists h. split; [constructor | assumption].
        decompose [ex or and] (IHt H1); clear IHt.
          left. exists x. split; try right; assumption.
          right. exists x, x0, x1. firstorder (constructor; assumption).
        right. destruct H0. apply elem_join in H0. destruct H0 as [l [H1 H2]].
          exists x, h, l. firstorder.
            1-2: constructor; assumption.
            
    destruct 1 as [(l & H1 & H2) | (x & l1 & l2 & H1 & H2 & H3 & H4)].
      induction H1; cbn.
        apply Dup_app_l. assumption.
        apply Dup_app_r. apply IHelem, H2.
      generalize dependent l2.
      induction H3; cbn; intros.
        inversion H4; subst; clear H4.
Abort.
(* end hide *)

Lemma Dup_replicate :
  forall (A : Type) (n : nat) (x : A),
    Dup (replicate n x) -> 2 <= n.
(* begin hide *)
Proof.
  induction n as [| n']; cbn; intros; inversion H; subst; clear H.
    destruct n' as [| n'']; cbn in H1.
      inversion H1.
      apply le_n_S, le_n_S, le_0_n.
    apply le_trans with n'.
      apply (IHn' _ H1).
      apply le_S, le_n.
Qed.
(* end hide *)

Lemma Dup_nth :
  forall (A : Type) (l : list A),
    Dup l <->
    exists (x : A) (n1 n2 : nat),
      n1 < n2 /\ nth n1 l = Some x /\ nth n2 l = Some x.
(* begin hide *)
Proof.
  split.
    intro. apply Dup_spec in H. destruct H as (x & l1 & l2 & l3 & H); subst.
      exists x, (length l1), (length l1 + length l2 + 1). repeat split.
        omega.
        rewrite nth_app_r.
          rewrite <- minus_n_n. cbn. reflexivity.
          apply le_n.
        rewrite nth_app_r.
          rewrite <- app_cons_l, nth_app_r.
            replace (nth _ (x :: l3)) with (nth 0 (x :: l3)).
              cbn. reflexivity.
              f_equal. 1-3: simpl; omega.
    destruct 1 as (x & n1 & n2 & H1 & H2 & H3).
    generalize dependent n2. generalize dependent l.
    induction n1 as [| n1']; cbn; intros.
      destruct l as [| h t]; cbn in *; inversion H2; subst; clear H2.
        destruct n2 as [| n2']; cbn in *.
          omega.
          apply nth_elem_Some in H3. left. assumption.
      destruct l as [| h t], n2 as [| n2']; cbn in *;
      inversion H3; subst; clear H3.
        omega.
        right. apply lt_S_n in H1. apply (IHn1' t H2 n2' H1 H0).
Qed.
(* end hide *)

(** *** Niestandardowe reguły indukcyjne *)

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

(* begin hide *)
(** lista TODO:
    - TODO: opisz niestandardowe reguły indukcyjne dla list
    - TODO: opisz zwijanie
    - TODO: ogarnąć "Dziwne"
    - TODO: popracować nad [find], [findIndex], [findIndices] i ogólnie
      nad funkcjami na listach dla typów mających jakieś specjalne rzeczy
    - TODO: różne induktywne predykaty dla list (permutacje, [NoDup] etc.)
    - TODO: ogarnąć osobny rozdział z zadaniami dla [option].
            Stąd zadania dla [head], [last], [tail] i [init] *)
(* end hide *)
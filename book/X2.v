(** * X2: Arytmetyka Peano *)

(** Poniższe zadania mają służyć utrwaleniu zdobytej dotychczas wiedzy na
    temat prostej rekursji i indukcji. Większość powinna być robialna po
    przeczytaniu rozdziału o konstruktorach rekurencyjnych, ale niczego nie
    gwarantuję.

    Celem zadań jest rozwinięcie arytmetyki do takiego poziomu, żeby można
    było tego używać gdzie indziej w jakotakim stopniu. Niektóre zadania
    mogą pokrywać się z zadaniami obecnymi w tekście, a niektóre być może
    nawet z przykładami. Staraj się nie podglądać.

    Nazwy twierdzeń nie muszą pokrywać się z tymi z biblioteki standardowej,
    choć starałem się, żeby tak było. *)

Module MyNat.

(** *** Definicja i notacje *)

(** Zdefiniuj liczby naturalne. *)

(* begin hide *)
Inductive nat : Set :=
    | O : nat
    | S : nat -> nat.
(* end hide *)

Notation "0" := O.
Notation "1" := (S 0).

(** *** [0] i [S] *)

(** Udowodnij właściwości zera i następnika. *)

Lemma neq_0_Sn :
  forall n : nat, 0 <> S n.
(* begin hide *)
Proof.
  do 2 intro. inversion H.
Qed.
(* end hide *)

Lemma neq_n_Sn :
  forall n : nat, n <> S n.
(* begin hide *)
Proof.
  induction n as [| n'].
    apply neq_0_Sn.
    intro. apply IHn'. inversion H. assumption.
Qed.
(* end hide *)

Lemma not_eq_S :
  forall n m : nat, n <> m -> S n <> S m.
(* begin hide *)
Proof.
  intros; intro. apply H. inversion H0. trivial.
Qed.
(* end hide *)

Lemma S_injective :
  forall n m : nat, S n = S m -> n = m.
(* begin hide *)
Proof.
  inversion 1. trivial.
Qed.
(* end hide *)

(** *** Poprzednik *)

(** Zdefiniuj funkcję zwracającą poprzednik danej liczby naturalnej.
    Poprzednikiem [0] jest [0]. *)

(* begin hide *)
Definition pred (n : nat) : nat :=
match n with
    | 0 => 0
    | S n' => n'
end.
(* end hide *)

Lemma pred_0 : pred 0 = 0.
(* begin hide *)
Proof.
  trivial.
Qed.
(* end hide *)

Lemma pred_Sn :
  forall n : nat, pred (S n) = n.
(* begin hide *)
Proof.
  trivial.
Qed.
(* end hide *)

(** *** Dodawanie *)

(** Zdefiniuj dodawanie (rekurencyjnie po pierwszym argumencie) i
    udowodnij jego właściwości. *)

(* begin hide *)
Fixpoint plus (n m : nat) : nat :=
match n with
    | 0 => m
    | S n' => S (plus n' m)
end.
(* end hide *)

Lemma plus_0_l :
  forall n : nat, plus 0 n = n.
(* begin hide *)
Proof.
  intro. simpl. trivial.
Qed.
(* end hide *)

Lemma plus_0_r :
  forall n : nat, plus n 0 = n.
(* begin hide *)
Proof.
  intro. induction n as [| n'].
    trivial.
    simpl. f_equal. assumption.
Qed.
(* end hide *)

Lemma plus_n_Sm :
  forall n m : nat, S (plus n m) = plus n (S m).
(* begin hide *)
Proof.
  induction n as [| n']; simpl; intro.
    trivial.
    rewrite IHn'. trivial.
Qed.
(* end hide *)

Lemma plus_Sn_m :
  forall n m : nat, plus (S n) m = S (plus n m).
(* begin hide *)
Proof.
  induction n as [| n']; simpl; trivial.
Qed.
(* end hide *)

Lemma plus_assoc :
  forall a b c : nat,
    plus a (plus b c) = plus (plus a b) c.
(* begin hide *)
Proof.
  induction a as [| a']; simpl.
    trivial.
    intros. rewrite IHa'. trivial.
Qed.
(* end hide *)

Lemma plus_comm :
  forall n m : nat, plus n m = plus m n.
(* begin hide *)
Proof.
  induction n as [| n']; simpl; intros.
    rewrite plus_0_r. trivial.
    induction m as [| m']; simpl.
      rewrite plus_0_r. trivial.
      rewrite IHn'. rewrite <- IHm'. simpl. rewrite IHn'.
        trivial.
Qed.
(* end hide *)

Lemma plus_no_annihilation_l :
  ~ exists a : nat, forall n : nat, plus a n = a.
(* begin hide *)
Proof.
  intro. destruct H as [a H]. specialize (H (S 0)).
  rewrite plus_comm in H. simpl in H. induction a as [| a'].
    inversion H.
    apply IHa'. inversion H. assumption.
Qed.
(* end hide *)

Lemma plus_no_annihilation_r :
  ~ exists a : nat, forall n : nat, plus n a = a.
(* begin hide *)
Proof.
  intro. destruct H as [a H]. specialize (H (S 0)).
  rewrite plus_comm in H. simpl in H. induction a as [| a'].
    inversion H.
    apply IHa'. rewrite plus_comm in *. simpl in *.
      inversion H. assumption.
Qed.
(* end hide *)

Lemma plus_no_inverse_l :
  ~ forall n : nat, exists i : nat, plus i n = 0.
(* begin hide *)
Proof.
  intro. destruct (H (S 0)) as [i H']. rewrite plus_comm in H'.
  inversion H'.
Qed.
(* end hide *)

Lemma plus_no_inverse_r :
  ~ forall n : nat, exists i : nat, plus n i = 0.
(* begin hide *)
Proof.
  intro. destruct (H (S 0)) as [i H']. inversion H'.
Qed.
(* end hide *)

Lemma plus_no_inverse_l_strong :
  forall n i : nat, n <> 0 -> plus i n <> 0.
(* begin hide *)
Proof.
  destruct i; cbn; intros.
    assumption.
    inversion 1.
Qed.
(* end hide *)

Lemma plus_no_inverse_r_strong :
  forall n i : nat, n <> 0 -> plus n i <> 0.
(* begin hide *)
Proof.
  intros. rewrite plus_comm. apply plus_no_inverse_l_strong. assumption.
Qed.
(* end hide *)

(** *** Odejmowanie *)

(** Zdefiniuj odejmowanie i udowodnij jego właściwości. *)

(* begin hide *)
Fixpoint minus (n m : nat) : nat :=
match n, m with
    | 0, _ => 0
    | _, 0 => n
    | S n', S m' => minus n' m'
end.
(* end hide *)

Lemma minus_pred :
  forall n : nat, minus n 1 = pred n.
(* begin hide *)
Proof.
  repeat (destruct n; simpl; trivial).
Qed.
(* end hide *)

Lemma minus_0_l :
  forall n : nat, minus 0 n = 0.
(* begin hide *)
Proof.
  simpl. trivial.
Qed.
(* end hide *)

Lemma minus_0_r :
  forall n : nat, minus n 0 = n.
(* begin hide *)
Proof.
  destruct n; trivial.
Qed.
(* end hide *)

Lemma minus_S :
  forall n m : nat,
    minus (S n) (S m) = minus n m.
(* begin hide *)
Proof.
  simpl. trivial.
Qed.
(* end hide *)

Lemma minus_n :
  forall n : nat, minus n n = 0.
(* begin hide *)
Proof.
  induction n as [| n']; simpl; trivial.
Qed.
(* end hide *)

Lemma minus_plus_l :
  forall n m : nat,
    minus (plus n m) n = m.
(* begin hide *)
Proof.
  induction n as [| n']; simpl.
    apply minus_0_r.
    apply IHn'.
Qed.
(* end hide *)

Lemma minus_plus_r :
  forall n m : nat,
    minus (plus n m) m = n.
(* begin hide *)
Proof.
  intros. rewrite plus_comm. apply minus_plus_l.
Qed.
(* end hide *)

Lemma minus_plus_distr :
  forall a b c : nat,
    minus a (plus b c) = minus (minus a b) c.
(* begin hide *)
Proof.
  induction a as [| a'].
    simpl. trivial.
    destruct b, c; simpl; trivial.
Restart.
  induction a; destruct b, c; simpl; trivial.
Qed.
(* end hide *)

Lemma minus_exchange :
  forall a b c : nat,
    minus (minus a b) c = minus (minus a c) b.
(* begin hide *)
Proof.
  intros a b. generalize dependent a. induction b as [| b'].
    intros. repeat rewrite minus_0_r. trivial.
    intros a c. generalize dependent a. induction c as [| c'].
      intro. repeat rewrite minus_0_r. trivial.
      destruct a as [| a'].
        simpl. trivial.
        simpl in *. rewrite <- IHc'. rewrite IHb'. destruct a'; simpl.
          trivial.
          rewrite IHb'. trivial.
Qed.

Lemma minus_not_assoc :
  ~ forall a b c : nat,
      minus a (minus b c) = minus (minus a b) c.
(* begin hide *)
Proof.
  intro. specialize (H 1 1 1). simpl in H. inversion H.
Qed.
(* end hide *)

Lemma minus_not_comm :
  ~ forall n m : nat,
      minus n m = minus m n.
(* begin hide *)
Proof.
  intro. specialize (H 1 0). simpl in H. inversion H.
Qed.
(* end hide *)

(** *** Mnożenie *)

(** Zdefiniuj mnożenie i udowodnij jego właściwości. *)

(* begin hide *)
Fixpoint mult (n m : nat) : nat :=
match n with
    | 0 => 0
    | S n' => plus m (mult n' m)
end.
(* end hide *)

Lemma mult_0_l :
  forall n : nat, mult 0 n = 0.
(* begin hide *)
Proof.
  induction n; trivial.
Qed.
(* end hide *)

Lemma mult_0_r :
  forall n : nat, mult n 0 = 0.
(* begin hide *)
Proof.
  induction n as [| n']; simpl.
    trivial.
    assumption.
Restart.
  induction n; trivial.
Qed.
(* end hide *)

Lemma mult_1_l :
  forall n : nat, mult 1 n = n.
(* begin hide *)
Proof.
  destruct n as [| n'].
    simpl. trivial.
    simpl. rewrite plus_0_r. trivial.
Restart.
  destruct n; simpl; try rewrite plus_0_r; trivial.
Qed.
(* end hide*)

Lemma mult_1_r :
  forall n : nat, mult n 1 = n.
(* begin hide *)
Proof.
  induction n.
    simpl. trivial.
    simpl. rewrite IHn. trivial.
Restart.
  induction n; simpl; try rewrite IHn; trivial.
Qed.
(* end hide *)

Lemma mult_comm :
  forall n m : nat,
    mult n m = mult m n.
(* begin hide *)
Proof.
  induction n as [| n']; intro.
    rewrite mult_0_l, mult_0_r. trivial.
    induction m as [| m'].
      rewrite mult_0_l, mult_0_r. trivial.
      simpl in *. rewrite IHn', <- IHm', IHn'. simpl.
        do 2 rewrite plus_assoc. rewrite (plus_comm n' m'). trivial.
Qed.
(* begin hide *)

Lemma mult_plus_distr_l :
  forall a b c : nat,
    mult a (plus b c) = plus (mult a b) (mult a c).
(* begin hide *)
Proof.
  induction a as [| a']; simpl; trivial.
  intros. rewrite IHa'. repeat rewrite plus_assoc.
  f_equal. repeat rewrite <- plus_assoc. f_equal.
  apply plus_comm.
Qed.
(* end hide *)

Lemma mult_plus_distr_r :
  forall a b c : nat,
    mult (plus a b) c = plus (mult a c) (mult b c).
(* begin hide *)
Proof.
  intros. rewrite mult_comm. rewrite mult_plus_distr_l.
  f_equal; apply mult_comm.
Qed.
(* end hide *)

Lemma mult_minus_distr_l :
  forall a b c : nat,
    mult a (minus b c) = minus (mult a b) (mult a c).
(* begin hide *)
Proof.
  induction a as [| a']; simpl; trivial.
  induction b as [| b'].
    intros. repeat rewrite mult_0_r. simpl. trivial.
    induction c as [| c'].
      rewrite mult_0_r. simpl. trivial.
      simpl. rewrite (mult_comm a' (S b')). simpl.
        rewrite (mult_comm a' (S c')). simpl.
        rewrite IHb'. repeat rewrite minus_plus_distr.
        f_equal. Focus 2. apply mult_comm.
        replace (plus b' (plus a' _)) with (plus a' (plus b' (mult b' a'))).
          rewrite minus_exchange. rewrite minus_plus_l.
            rewrite mult_comm. trivial.
          repeat rewrite plus_assoc. rewrite (plus_comm a' b'). trivial.
Qed.
(* end hide *)

Lemma mult_minus_distr_r :
  forall a b c : nat,
    mult (minus a b) c = minus (mult a c) (mult b c).
(* begin hide *)
Proof.
  intros. rewrite mult_comm. rewrite mult_minus_distr_l.
  f_equal; apply mult_comm.
Qed.
(* end hide *)

Lemma mult_assoc :
  forall a b c : nat,
    mult a (mult b c) = mult (mult a b) c.
(* begin hide *)
Proof.
  induction a as [| a']; simpl; trivial.
  intros. rewrite mult_plus_distr_r.
  rewrite IHa'. trivial.
Qed.
(* end hide *)

Lemma mult_no_inverse_l :
  ~ forall n : nat, exists i : nat, mult i n = 1.
(* begin hide *)
Proof.
  intro. destruct (H (S 1)) as [i H']. rewrite mult_comm in H'.
  simpl in H'. rewrite plus_0_r in H'. destruct i.
    inversion H'.
    simpl in H'. rewrite plus_comm in H'. simpl in H'. inversion H'.
Qed.
(* end hide *)

Lemma mult_no_inverse_r :
  ~ forall n : nat, exists i : nat, mult n i = 1.
(* begin hide *)
Proof.
  intro. destruct (H (S 1)) as [i H']. simpl in H'.
  rewrite plus_0_r in H'. destruct i.
    inversion H'.
    simpl in H'. rewrite plus_comm in H'. simpl in H'. inversion H'.
Qed.
(* end hide *)

Lemma mult_no_inverse_l_strong :
  forall n i : nat, n <> 1 -> mult i n <> 1.
(* begin hide *)
Proof.
  induction i; cbn; intros.
    inversion 1.
    destruct n as [| [| n']]; cbn.
      rewrite mult_0_r. assumption.
      contradiction H. reflexivity.
      inversion 1.
Qed.
(* end hide *)

Lemma mult_no_inverse_r_strong :
  forall n i : nat, n <> 1 -> mult n i <> 1.
(* begin hide *)
Proof.
  intros. rewrite mult_comm.
  apply mult_no_inverse_l_strong. assumption.
Qed.
(* end hide *)

Lemma mult_2_plus :
  forall n : nat, mult (S (S 0)) n = plus n n.
(* begin hide *)
Proof.
  intro. simpl. rewrite plus_0_r. trivial.
Qed.
(* end hide *)

(** *** Porządek [<=] *)

(** Zdefiniuj relację "mniejszy lub równy" i udowodnij jej właściwości. *)

(* begin hide *)
Inductive le (n : nat) : nat -> Prop :=
    | le_n : le n n
    | le_S : forall m : nat, le n m -> le n (S m).
(* end hide *)

Notation "n <= m" := (le n m).

Lemma le_0_n :
  forall n : nat, 0 <= n.
(* begin hide *)
Proof.
  induction n as [| n'].
    apply le_n.
    apply le_S. assumption.
Qed.
(* end hide *)

Lemma le_n_Sm :
  forall n m : nat, n <= m -> n <= S m.
(* begin hide *)
Proof.
  apply le_S.
Qed.
(* end hide *)

Lemma le_Sn_m :
  forall n m : nat, S n <= m -> n <= m.
(* begin hide *)
Proof.
  induction m as [| m'].
    inversion 1.
    intros. inversion H.
      apply le_S, le_n.
      apply le_S, IHm'. assumption.
Qed.
(* end hide *)

Lemma le_n_S :
  forall n m : nat, n <= m -> S n <= S m.
(* begin hide *)
Proof.
  induction 1.
    apply le_n.
    apply le_S. assumption.
Qed.
(* end hide *)

Lemma le_S_n :
  forall n m : nat, S n <= S m -> n <= m.
(* begin hide *)
Proof.
  intros n m. generalize dependent n. induction m as [| m'].
    intros. inversion H.
      apply le_n.
      inversion H1.
    inversion 1.
      apply le_n.
      apply le_S. apply IHm'. assumption.
Qed.
(* end hide *)

Lemma le_Sn_n :
  forall n : nat, ~ S n <= n.
(* begin hide *)
Proof.
  induction n as [| n']; intro.
    inversion H.
    apply IHn'. apply le_S_n. assumption.
Qed.
(* end hide *)

Lemma le_refl :
  forall n : nat, n <= n.
(* begin hide *)
Proof.
  apply le_n.
Qed.
(* end hide *)

Lemma le_trans :
  forall a b c : nat,
    a <= b -> b <= c -> a <= c.
(* begin hide *)
Proof.
  induction 1.
    trivial.
    intro. apply IHle. apply le_Sn_m. assumption.
Qed.
(* end hide *)

Lemma le_antisym :
  forall n m : nat,
    n <= m -> m <= n -> n = m.
(* begin hide *)
Proof.
  induction n as [| n'].
    inversion 2. trivial.
    induction m as [| m'].
      inversion 1.
      intros. f_equal. apply IHn'; apply le_S_n; assumption.
Qed.
(* end hide *)

Lemma le_pred :
  forall n : nat, pred n <= n.
(* begin hide *)
Proof.
  destruct n; simpl; repeat constructor.
Qed.
(* end hide *)

Lemma le_n_pred :
  forall n m : nat,
    n <= m -> pred n <= pred m.
(* begin hide *)
Proof.
  inversion 1.
    constructor.
    simpl. apply le_trans with n.
      apply le_pred.
      assumption.
Qed.
(* end hide *)

Lemma no_le_pred_n :
  ~ forall n m : nat,
      pred n <= pred m -> n <= m.
(* begin hide *)
Proof.
  intro. specialize (H 1 0 (le_n 0)). inversion H.
Qed.
(* end hide *)

Lemma le_plus_l :
  forall a b c : nat,
    b <= c -> plus a b <= plus a c.
(* begin hide *)
Proof.
  induction a as [| a']; simpl.
    trivial.
    intros. apply le_n_S. apply IHa'. assumption.
Qed.
(* end hide *)

Lemma le_plus_r :
  forall a b c : nat,
    a <= b -> plus a c <= plus b c.
(* begin hide *)
Proof.
  intros. rewrite (plus_comm a c), (plus_comm b c).
  apply le_plus_l. assumption.
Qed.
(* end hide *)

Lemma le_plus :
  forall a b c d : nat,
    a <= b -> c <= d -> plus a c <= plus b d.
(* begin hide *)
Proof.
  induction 1.
    apply le_plus_l.
    intros. simpl. apply le_S. apply IHle. assumption.
Qed.
(* end hide *)

Lemma le_minus_S :
  forall n m : nat,
    minus n (S m) <= minus n m.
(* begin hide *)
Proof.
  induction n as [| n'].
    simpl. constructor.
    destruct m; simpl.
      rewrite minus_0_r. do 2 constructor.
      apply IHn'.
Qed.
(* end hide *)

Lemma le_minus_l :
  forall a b c : nat,
    b <= c -> minus a c <= minus a b.
(* begin hide *)
Proof.
  induction 1.
    constructor.
    apply le_trans with (minus a m).
      apply le_minus_S.
      assumption.
Qed.
(* end hide *)

Lemma le_minus_r :
  forall a b c : nat,
    a <= b -> minus a c <= minus b c.
(* begin hide *)
Proof.
  intros a b c. generalize dependent a. generalize dependent b.
  induction c as [| c'].
    intros. do 2 rewrite minus_0_r. trivial.
    destruct a, b; simpl; intro; trivial.
      apply le_0_n.
      inversion H.
      apply IHc'. apply le_S_n. assumption.
Qed.
(* end hide *)

Lemma le_mult_l :
  forall a b c : nat,
    b <= c -> mult a b <= mult a c.
(* begin hide *)
Proof.
  induction a as [| a']; simpl.
    constructor.
    intros. apply le_plus.
      assumption.
      apply IHa'. assumption.
Qed.
(* end hide *)

Lemma le_mult_r :
  forall a b c : nat,
    a <= b -> mult a c <= mult b c.
(* begin hide *)
Proof.
  intros. rewrite (mult_comm a c), (mult_comm b c).
  apply le_mult_l. assumption.
Qed.
(* end hide *)

Lemma le_mult :
  forall a b c d : nat,
    a <= b -> c <= d -> mult a c <= mult b d.
(* begin hide *)
Proof.
  induction 1; simpl; intro.
    apply le_mult_l. assumption.
    change (mult a c) with (plus 0 (mult a c)). apply le_plus.
      apply le_0_n.
      apply IHle. assumption.
Qed.
(* end hide *)

Lemma le_plus_exists :
  forall n m : nat,
    n <= m -> exists k : nat, plus n k = m.
(* begin hide *)
Proof.
  induction n as [| n']; simpl.
    intros. exists m. trivial.
    intros. destruct (IHn' m) as [k Hk].
      apply le_Sn_m in H. assumption.
      destruct k; simpl.
        rewrite plus_0_r in Hk. subst. cut False.
          inversion 1.
          apply (le_Sn_n m). assumption.
        exists k. rewrite plus_comm in Hk. simpl in Hk.
          rewrite plus_comm. assumption.
Qed.
(* end hide *)

(** *** Porządek [lt] *)

Definition lt (n m : nat) : Prop := S n <= m.

Notation "n < m" := (lt n m).

Lemma lt_irrefl :
  forall n : nat, ~ n < n.
(* begin hide *)
Proof.
  unfold lt, not; intros. apply le_Sn_n in H. assumption.
Qed.
(* end hide *)

Lemma lt_trans :
  forall a b c : nat, a < b -> b < c -> a < c.
(* begin hide *)
Proof.
  unfold lt; intros. destruct b.
    inversion H.
    destruct c as [| [| c']].
      inversion H0.
      inversion H0. inversion H2.
      apply le_S_n in H0. constructor. eapply le_trans; eauto.
Qed.
(* end hide *)

Lemma lt_asym :
  forall n m : nat, n < m -> ~ m < n.
(* begin hide *)
Proof.
  unfold lt, not; intros. cut (S n <= n).
    intro. apply le_Sn_n in H1. assumption.
    apply le_trans with m.
      assumption.
      apply le_Sn_m. assumption.
Qed.
(* end hide *)

(** *** Minimum i maksimum *)

(** Zdefiniuj minimum i maksimum oraz udowodnij ich właściwości. *)

(* begin hide *)
Fixpoint min (n m : nat) : nat :=
match n, m with
    | 0, _ => 0
    | _, 0 => 0
    | S n', S m' => S (min n' m')
end.

Fixpoint max (n m : nat) : nat :=
match n, m with
    | 0, _ => m
    | _, 0 => n
    | S n', S m' => S (max n' m')
end.
(* end hide *)

Lemma min_0_l :
  forall n : nat, min 0 n = 0.
(* begin hide *)
Proof. reflexivity. Qed.
(* end hide *)

Lemma min_0_r :
  forall n : nat, min n 0 = 0.
(* begin hide *)
Proof.
  destruct n; cbn; reflexivity.
Qed.
(* end hide *)

Lemma max_0_l :
  forall n : nat, max 0 n = n.
(* begin hide *)
Proof. reflexivity. Qed.
(* end hide *)

Lemma max_0_r :
  forall n : nat, max n 0 = n.
(* begin hide *)
Proof.
  destruct n; cbn; reflexivity.
Qed.
(* end hide *)

Lemma min_le :
  forall n m : nat, n <= m -> min n m = n.
(* begin hide *)
Proof.
  induction n as [| n'].
    trivial.
    destruct m as [| m'].
      inversion 1.
      intro. simpl. f_equal. apply IHn'. apply le_S_n. assumption.
Qed.
(* end hide *)

Lemma max_le :
  forall n m : nat, n <= m -> max n m = m.
(* begin hide *)
Proof.
  induction n as [| n'].
    trivial.
    destruct m as [| m'].
      inversion 1.
      intro. simpl. f_equal. apply IHn'. apply le_S_n. assumption.
Qed.
(* end hide *)

Lemma min_assoc :
  forall a b c : nat,
    min a (min b c) = min (min a b) c.
(* begin hide *)
Proof.
  induction a as [| a'].
    trivial.
    destruct b, c; auto. simpl. rewrite IHa'. trivial.
Qed.
(* end hide *)

Lemma max_assoc :
  forall a b c : nat,
    max a (max b c) = max (max a b) c.
(* begin hide *)
Proof.
  induction a as [| a'].
    trivial.
    destruct b, c; auto. simpl. rewrite IHa'. trivial.
Qed.
(* end hide *)

Lemma min_comm :
  forall n m : nat, min n m = min m n.
(* begin hide *)
Proof.
  induction n as [| n']; destruct m; simpl; try rewrite IHn'; trivial.
Qed.
(* end hide *)

Lemma max_comm :
  forall n m : nat, max n m = max m n.
(* begin hide *)
Proof.
  induction n as [| n']; destruct m; simpl; try rewrite IHn'; trivial.
Qed.
(* end hide *)

Lemma min_refl :
  forall n : nat, min n n = n.
(* begin hide *)
Proof.
  induction n as [| n']; simpl; try rewrite IHn'; trivial.
Qed.
(* end hide *)

Lemma max_refl :
  forall n : nat, max n n = n.
(* begin hide *)
Proof.
  induction n as [| n']; simpl; try rewrite IHn'; trivial.
Qed.
(* end hide *)

Lemma min_no_neutr_l :
  ~ exists e : nat, forall n : nat, min e n = n.
(* begin hide *)
Proof.
  intro. destruct H as [e H]. specialize (H (S e)).
  induction e.
    inversion H.
    simpl in H. inversion H. apply IHe. assumption.
Qed.
(* end hide *)

Lemma min_no_neutr_r :
  ~ exists e : nat, forall n : nat, min n e = n.
(* begin hide *)
Proof.
  intro. apply min_no_neutr_l. destruct H as [e H].
  exists e. intro. rewrite min_comm. apply H.
Qed.
(* end hide *)

Lemma max_no_annihilator_l :
  ~ exists a : nat, forall n : nat, max a n = a.
(* begin hide *)
Proof.
  intro. destruct H as [a H]. specialize (H (S a)).
  induction a; inversion H. apply IHa. assumption.
Qed.
(* end hide *)

Lemma max_no_annihilator_r :
  ~ exists a : nat, forall n : nat, max n a = a.
(* begin hide *)
Proof.
  intro. destruct H as [a H]. apply max_no_annihilator_l.
  exists a. intro. rewrite max_comm. apply H.
Qed.
(* end hide *)

Lemma is_it_true :
  (forall n m : nat, min (S n) m = S (min n m)) \/
  (~ forall n m : nat, min (S n) m = S (min n m)).
(* begin hide *)
Proof.
  right. intro. specialize (H 0 0). simpl in H. inversion H.
Qed.
(* end hide *)

(** *** Potęgowanie *)

(** Zdefiniuj potęgowanie i udowodnij jego właściwości. *)

(* begin hide *)
Fixpoint pow (n m : nat) : nat :=
match m with
    | 0 => 1
    | S m' => mult n (pow n m')
end.
(* end hide *)

Lemma pow_0_r :
  forall n : nat, pow n 0 = 1.
(* begin hide *)
Proof. reflexivity. Qed.
(* end hide *)

Lemma pow_0_l :
  forall n : nat, pow 0 (S n) = 0.
(* begin hide *)
Proof.
  destruct n; cbn; reflexivity.
Qed.
(* end hide *)

Lemma pow_1_l :
  forall n : nat, pow 1 n = 1.
(* begin hide *)
Proof.
  induction n as [| n']; simpl; try rewrite plus_0_r; trivial.
Qed.
(* end hide *)

Lemma pow_1_r :
  forall n : nat, pow n 1 = n.
(* begin hide *)
Proof.
  induction n as [| n']; simpl; try rewrite mult_1_r; trivial.
Qed.
(* end hide *)

Lemma pow_no_neutr_l :
  ~ exists e : nat, forall n : nat, pow e n = n.
(* begin hide *)
Proof.
  destruct 1 as [e H]. specialize (H 0). simpl in H. inversion H.
Qed.
(* end hide *)

Lemma pow_no_annihilator_r :
  ~ exists a : nat, forall n : nat, pow n a = a.
(* begin hide *)
Proof.
  destruct 1 as [a H]. destruct a;
  [specialize (H 1) | specialize (H 0)]; inversion H.
Qed.
(* end hide *)

Lemma le_pow_l :
  forall a b c : nat,
    a <> 0 -> b <= c -> pow a b <= pow a c.
(* begin hide *)
Proof.
  induction 2.
    constructor.
    destruct a; simpl.
      contradiction H. trivial.
      change (pow (S a) b) with (plus 0 (pow (S a) b)).
        rewrite (plus_comm (pow (S a) m) _). apply le_plus.
          apply le_0_n.
          assumption.
Qed.
(* end hide *)

Lemma le_pow_r :
  forall a b c : nat,
    a <= b -> pow a c <= pow b c.
(* begin hide *)
Proof.
  induction c as [| c']; simpl.
    constructor.
    intro. apply le_mult; auto.
Qed.
(* end hide *)

Lemma pow_mult :
  forall a b c : nat,
    pow (mult a b) c = mult (pow a c) (pow b c).
(* begin hide *)
Proof.
  induction c as [| c']; simpl.
    trivial.
    rewrite IHc'. repeat rewrite mult_assoc. f_equal.
      repeat rewrite <- mult_assoc. f_equal. apply mult_comm.
Qed.
(* end hide *)

Lemma pow_plus :
  forall a b c : nat,
    pow a (plus b c) = mult (pow a b) (pow a c).
(* begin hide *)
Proof.
  induction b as [| b']; induction c as [| c']; simpl.
    trivial.
    rewrite plus_0_r. trivial.
    rewrite plus_0_r, mult_1_r. trivial.
    rewrite IHb'. simpl. repeat rewrite mult_assoc. trivial.
Qed.
(* end hide *)

Lemma pow_pow :
  forall a b c : nat,
    pow (pow a b) c = pow a (mult b c).
(* begin hide *)
Proof.
  induction c as [| c']; simpl.
    rewrite mult_0_r. simpl. trivial.
    rewrite IHc', (mult_comm b (S c')). simpl.
      rewrite <- pow_plus. rewrite mult_comm. trivial.
Qed.
(* end hide *)

(** *** Reflekcja *)

(** Zdefiniuj funkcję [leb], która sprawdza, czy [n <= m]. *)

(* begin hide *)
Fixpoint leb (n m : nat) : bool :=
match n, m with
    | 0, _ => true
    | _, 0 => false
    | S n', S m' => leb n' m'
end.
(* end hide *)

Lemma leb_n :
  forall n : nat,
    leb n n = true.
(* begin hide *)
Proof.
  induction n as [| n']; simpl; trivial.
Qed.
(* end hide *)

Lemma leb_spec :
  forall n m : nat,
    n <= m <-> leb n m = true.
(* begin hide *)
Proof.
  split; generalize dependent m.
    induction n as [| n'].
      simpl. trivial.
      destruct m; simpl; intro.
        inversion H.
        apply IHn'. apply le_S_n. assumption.
    induction n as [| n']; intros.
      apply le_0_n.
      destruct m; simpl.
        simpl in H. inversion H.
        simpl in H. apply le_n_S. apply IHn'. assumption.
Restart.
  split; generalize dependent m; induction n as [| n']; destruct m;
  simpl; trivial; try (inversion 1; fail); intro.
    apply IHn'. apply le_S_n. assumption.
    apply le_n.
    apply le_0_n.
    apply le_n_S. apply IHn'. assumption.
Qed.
(* end hide *)

(** Zdefiniuj funkcję [eqb], która sprawdza, czy [n = m]. *)

(* begin hide *)
Fixpoint eqb (n m : nat) : bool :=
match n, m with
    | 0, 0 => true
    | S n', S m' => eqb n' m'
    | _, _ => false
end.
(* end hide *)

Lemma eqb_spec :
  forall n m : nat,
    n = m <-> eqb n m = true.
(* begin hide *)
Proof.
  split; generalize dependent m; generalize dependent n.
    destruct 1. induction n; auto.
    induction n as [| n']; destruct m as [| m']; simpl; inversion 1; auto.
      f_equal. apply IHn'. assumption.
Qed.
(* end hide *)

(** *** Alternatywne definicje dodawania *)

(** Udowodnij, że poniższe alternatywne metody zdefiniowania dodawania
    rzeczywiście definiują dodawanie. *)

Fixpoint plus' (n m : nat) : nat :=
match m with
    | 0 => n
    | S m' => S (plus' n m')
end.

Lemma plus'_is_plus :
  forall n m : nat, plus' n m = plus n m.
(* begin hide *)
Proof.
  intros n m. generalize dependent n.
  induction m as [| m']; simpl; intros.
    rewrite plus_0_r. trivial.
    rewrite IHm'. rewrite (plus_comm n (S m')). simpl.
      rewrite plus_comm. trivial.
Qed.
(* end hide *)

Fixpoint plus'' (n m : nat) : nat :=
match n with
    | 0 => m
    | S n' => plus'' n' (S m)
end.

Lemma plus''_is_plus :
  forall n m : nat, plus'' n m = plus n m.
(* begin hide *)
Proof.
  induction n as [| n']; simpl.
    trivial.
    intro. rewrite IHn'. rewrite plus_comm. simpl.
      rewrite plus_comm. trivial.
Qed.
(* end hide *)

Fixpoint plus''' (n m : nat) : nat :=
match m with
    | 0 => n
    | S m' => plus''' (S n) m'
end.

Lemma plus'''_is_plus :
  forall n m : nat, plus''' n m = plus n m.
(* begin hide *)
Proof.
  intros n m. generalize dependent n.
  induction m as [| m']; simpl; intros.
    rewrite plus_0_r. trivial.
    rewrite IHm'. simpl. rewrite (plus_comm n (S _)). simpl.
      rewrite plus_comm. trivial.
Qed.
(* end hide *)

(** *** Dzielenie przez 2 *)

(** Pokaż, że indukcję na liczbach naturalnych można robić "co 2".
    Wskazówka: taktyk można używać nie tylko do dowodzenia. Przypomnij
    sobie, że taktyki to programy, które generują dowody, zaś dowody
    są programami. Dzięki temu nic nie stoi na przeszkodzie, aby
    taktyki interpretować jako programy, które piszą inne programy.
    I rzeczywiście — w Coqu możemy używać taktyk do definiowania
    dowolnych termów. W niektórych przypadkach jest to bardzo częsta
    praktyka. *)

Fixpoint nat_ind_2
  (P : nat -> Prop) (H0 : P 0) (H1 : P 1)
  (HSS : forall n : nat, P n -> P (S (S n))) (n : nat) : P n.
(* begin hide *)
Proof.
  destruct n.
    apply H0.
    destruct n.
      apply H1.
      apply HSS. apply nat_ind_2; auto.
Qed.
(* end hide *)

(** Zdefiniuj dzielenie całkowitoliczbowe przez [2] oraz funkcję obliczającą
    resztę z dzielenia przez [2]. *)

(* begin hide *)
Fixpoint div2 (n : nat) : nat :=
match n with
    | 0 => 0
    | 1 => 0
    | S (S n') => S (div2 n')
end.

Fixpoint mod2 (n : nat) : nat :=
match n with
    | 0 => 0
    | 1 => 1
    | S (S n') => mod2 n'
end.
(* end hide *)

Notation "2" := (S (S 0)).

Lemma div2_even :
  forall n : nat, div2 (mult 2 n) = n.
(* begin hide *)
Proof.
  apply nat_ind_2; simpl; intros; trivial.
  rewrite plus_0_r in *. rewrite <- ?plus_n_Sm. simpl. rewrite H. trivial.
Qed.
(* end hide *)

Lemma div2_odd :
  forall n : nat, div2 (S (mult 2 n)) = n.
(* begin hide *)
Proof.
  apply nat_ind_2; simpl; intros; trivial.
  rewrite plus_0_r in *. rewrite <- ?plus_n_Sm. simpl. rewrite H. trivial.
Qed.
(* end hide *)

Lemma mod2_even :
  forall n : nat, mod2 (mult 2 n) = 0.
(* begin hide *)
Proof.
  apply nat_ind_2; simpl; intros; trivial.
  rewrite plus_0_r, <- ?plus_n_Sm in *. simpl. rewrite H. trivial.
Qed.
(* end hide *)

Lemma mod2_odd :
  forall n : nat, mod2 (S (mult 2 n)) = 1.
(* begin hide *)
Proof.
  apply nat_ind_2; simpl; intros; trivial.
  rewrite plus_0_r, <- ?plus_n_Sm in *. simpl. rewrite H. trivial.
Qed.
(* end hide *)

Lemma div2_mod2_spec :
  forall n : nat, plus (mult 2 (div2 n)) (mod2 n) = n.
(* begin hide *)
Proof.
  apply nat_ind_2; simpl; intros; trivial.
  rewrite plus_0_r in *. rewrite <- plus_n_Sm. simpl. rewrite H. trivial.
Qed.
(* end hide *)

Lemma div2_le :
  forall n : nat, div2 n <= n.
(* begin hide *)
Proof.
  apply nat_ind_2; simpl; intros; trivial; try (repeat constructor; fail).
  apply le_n_S. constructor. assumption.
Qed.
(* end hide *)

Lemma div2_pres_le :
  forall n m : nat, n <= m -> div2 n <= div2 m.
(* begin hide *)
Proof.
  induction n using nat_ind_2; simpl; intros; try apply le_0_n.
  destruct m as [| [| m']]; simpl.
    inversion H. 
    inversion H. inversion H1.
    apply le_n_S, IHn. do 2 apply le_S_n. assumption.
Qed.  
(* end hide *)

Lemma mod2_le :
  forall n : nat, mod2 n <= n.
(* begin hide *)
Proof.
  apply nat_ind_2; simpl; intros; trivial; repeat constructor; assumption.
Qed.
(* end hide *)

Lemma mod2_not_pres_e :
  exists n m : nat, n <= m /\ mod2 m <= mod2 n.
(* begin hide *)
Proof.
  exists (S (S (S 0))), (S (S (S (S 0)))). simpl.
  split; repeat constructor.
Qed.
(* end hide *)

Lemma div2_lt :
  forall n : nat,
    0 <> n -> div2 n < n.
(* begin hide *)
Proof.
  induction n using nat_ind_2; cbn; intros.
    contradiction H. reflexivity.
    apply le_n.
    unfold lt in *. destruct n as [| n'].
      cbn. apply le_n.
      specialize (IHn ltac:(inversion 1)). apply le_n_S.
        apply le_trans with (S n').
          assumption.
          apply le_S, le_n.
Qed.
(* end hide *)

(** *** Podzielność *)

Definition divides (k n : nat) : Prop :=
  exists m : nat, mult k m = n.

Notation "k | n" := (divides k n) (at level 40).

(** [k] dzieli [n] jeżeli [n] jest wielokrotnością [k]. Udowodnij podstawowe
    właściwości tej relacji. *)

Lemma divides_0 :
  forall n : nat, n | 0.
(* begin hide *)
Proof.
  intro. red. exists 0. apply mult_0_r.
Qed.
(* end hide *)

Lemma not_divides_0 :
  forall n : nat, n <> 0 -> ~ 0 | n.
(* begin hide *)
Proof.
  unfold not, divides; intros. destruct H0 as [m Hm].
  rewrite mult_0_l in Hm. congruence.
Qed.
(* end hide *)

Lemma divides_1 :
  forall n : nat, 1 | n.
(* begin hide *)
Proof.
  intro. red. exists n. apply mult_1_l.
Qed.
(* end hide *)

Lemma divides_refl :
  forall n : nat, n | n.
(* begin hide *)
Proof.
  intro. red. exists 1. apply mult_1_r.
Qed.
(* end hide *)

Lemma divides_trans :
  forall k n m : nat, k | n -> n | m -> k | m.
(* begin hide *)
Proof.
  unfold divides; intros.
  destruct H as [c1 H1], H0 as [c2 H2].
  exists (mult c1 c2). rewrite mult_assoc. rewrite H1, H2. trivial.
Qed.
(* end hide *)

Lemma divides_plus :
  forall k n m : nat, k | n -> k | m -> k | plus n m.
(* begin hide *)
Proof.
  unfold divides; intros.
  destruct H as [c1 H1], H0 as [c2 H2].
  exists (plus c1 c2). rewrite mult_plus_distr_l. rewrite H1, H2. trivial.
Qed.
(* end hide *)

Lemma divides_mult_l :
  forall k n m : nat, k | n -> k | mult n m.
(* begin hide *)
Proof.
  unfold divides. destruct 1 as [c H].
  exists (mult c m). rewrite mult_assoc. rewrite H. trivial.
Qed.
(* end hide *)

Lemma divides_mult_r :
  forall k n m : nat, k | m -> k | mult n m.
(* begin hide *)
Proof.
  intros. rewrite mult_comm. apply divides_mult_l. assumption.
Qed.
(* end hide *)

Lemma divides_le :
  ~ forall k n : nat, k | n -> k <= n.
(* end hide *)
Proof.
  intro. cut (1 <= 0).
    inversion 1.
    apply H. red. exists 0. cbn. reflexivity.
Qed.
(* end hide *)

(* begin hide *)
Definition prime (p : nat) : Prop :=
  forall k : nat, k | p -> k = 1 \/ k = p.

Lemma double_not_prime :
  forall (A : Type) (p : nat),
    prime p -> ~ prime (mult 2 p).
Proof.
  unfold prime, not; intros.
  destruct (H0 2).
    red. exists p. reflexivity.
    inversion H1.
Abort.
(* end hide *)

End MyNat.
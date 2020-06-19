(** * N: kontynuacje [TODO] *)

(** Chyba właśnie zrozumiałem, o co chodzi z kontynuacjami.
    Przykład wzięty z
    https://legacy-cs.sice.indiana.edu/~sabry/papers/yield.pdf
    sekcja 3.

    Oświecająca muzyka: https://www.youtube.com/watch?v=-N4jf6rtyuw *)

(** Przyjrzyjmy się paru przykładowym funkcjom na niepustych drzewach
    binarnych, które wartości trzymają w liściach. Gry słowne: ciekawe,
    gdzie trzymają antywartości... :) *)

Inductive Tree (A : Type) : Type :=
  Leaf (x : A) | Node (l r : Tree A).

(** Nota bene: taki skrócony zapis powoduje, że przy użyciu [destruct]
    i [induction] Coq będzie nadawał zmiennym domyślnie nazwy [x], [l],
    [r]. *)

Arguments Leaf {A} _.
Arguments Node {A} _ _.

(** Na pierwszy ogień - jak powiększyć liczbę w każdym liściu o [1]? *)

Fixpoint renum (t : Tree nat) : Tree nat :=
match t with
    | Leaf n => Leaf (S n)
    | Node l r => Node (renum l) (renum r)
end.

(** Cóż, łatwo. *)

Fixpoint map {A B : Type} (f : A -> B) (t : Tree A) : Tree B :=
match t with
    | Leaf a => Leaf (f a)
    | Node l r => Node (map f l) (map f r)
end.

(** Łatwo będzie też pokazać, że [renum] działa tak samo jak mapowanie
    następnika. *)

Lemma renum_spec :
  forall t : Tree nat,
    renum t = map S t.
Proof.
  induction t as [n | l IHl r IHr]; cbn.
    reflexivity.
    rewrite IHl, IHr. reflexivity.
Qed.

(** Celem powyższego było pokazanie, że nie należy kontynuacji wpychać
    wszędzie, bo niektóre rzeczy da się zrobić bez nich.

    Idąc dalej napotykamy następujacy problem: dla dwóch drzew [t1] i
    [t2] sprawdź, czy mają takie same grzywki. Grzywka drzewa to lista
    jego liści w kolejności występowania (być może słowo "korona" lepiej
    pasowałoby do drzew, ale cóż, epidemia...).

    Prymitywny pomysł może wyglądać tak: *)

Fixpoint same_fringe
  {A : Type} (cmp : A -> A -> bool) (t1 t2 : Tree A) : bool :=
match t1, t2 with
    | Leaf x    , Leaf y     => cmp x y
    | Node l1 r1, Node l2 r2 =>
        same_fringe cmp l1 l2 && same_fringe cmp r1 r2
    | _, _ => false
end.

(** Oczywiście jest źle, bo powyższe zwraca [false] dla drzew o różnych
    kształtach, a przecież drzewa o różnych kształtach mogą mieć takie
    same grzywki.

    Nowy pomysł: zróbmy to, co mówi specyfikacja, i po prostu policzmy
    dla drzewa jego grzywkę. Potem porównamy grzywki i gitara. *)

Require Import List.
Import ListNotations.

Fixpoint fringe {A : Type} (t : Tree A) : list A :=
match t with
    | Leaf x => [x]
    | Node l r => fringe l ++ fringe r
end.

(** Cytując definicję: grzywka drzewa to lista jego liści, po kolei. *)

Fixpoint zipWith
  {A B C : Type} (f : A -> B -> C) (la : list A) (lb : list B) : list C :=
match la, lb with
    | [], [] => []
    | a :: la', b :: lb' => f a b :: zipWith f la' lb'
    | _, _ => []
end.

Fixpoint all (l : list bool) : bool :=
match l with
    | [] => true
    | h :: t => h && all t
end.

(** Przydadzą się podstawowe funkcje na listach, których biedacka
    biblioteka standardowa nie ma. *)

Definition same_fringe2
  {A : Type} (cmp : A -> A -> bool) (t1 t2 : Tree A) : bool :=
    all (zipWith cmp (fringe t1) (fringe t2)).

(** Znów jak w specyfikacji: policz grzywki, sprawdź czy każdy liść jest
    taki sam, a potem, czy wszystkie porównania się powiodły. *)

Require Import Arith.

Let t1 :=
  Node
    (Node (Leaf 5) (Leaf 12))
    (Leaf 42).

Let t2 :=
  Node
    (Leaf 5)
    (Node (Leaf 12) (Leaf 42)).

(** Dane testowe. *)

Compute same_fringe  beq_nat t1 t2.
Compute same_fringe2 beq_nat t1 t2.

(** Jak widać, pierwsze podejście było złe, a drugie jest dobre.
    Ćwiczenie: udowodnij.

    My tutaj jednak nie o tym. Powyższe dumania pokazują, że wciąż nie
    potrzeba tu żadnych kontynuacji. Czas zatem zmierzyć się z problemem,
    gdzie są one nieuniknione (lub jestem za głupi, żeby znać jakieś inne
    rozwiązanie).

    Zadanie: napisz funkcję, która bierze drzewa [t1] i [t2] i zamienia
    ich grzywki, zachowując rzecz jasna kształty drzew.

    Poświęc kilka minut, żeby spróbować rozwiązać to zadanie. Ja, gdy
    zobaczyłem je w zalinkowanej powyżej pracy, natychmiast zdałem sobie
    sprawę, że nie znam żadnego prostego sposobu, żeby to zrobić i wtedy
    właśnie doznałem oświecenia - kontynuacje jednak nie są ezoteryczne,
    są przydatne i nawet można je sobie wyobrazić (o tym później).

    Jeśli już przekonałeś się, że nie umiesz rozwiązać zadania, czas
    zobaczyć rozwiązanie! *)

Inductive Iterator (I O R : Type) : Type :=
    | Result : R -> Iterator I O R
    | Susp   : O -> (I -> Iterator I O R) -> Iterator I O R.

Arguments Result {I O R} _.
Arguments Susp   {I O R} _ _.

(** A rozwiązanie jest takie. Jeżeli próbujemy łazić po drzewie zwykłą
    funkcją i kombinować coś z grzywką, to mamy problem, bo przepływ
    sterowania w takiej funkcji jest całkowicie implicitny - nie mamy
    nad nim żadnej kontroli.

    Pomysł jest więc taki, żeby tę kontrolę sobie dać, reifikując ideę
    "przejścia po grzywce" przez zdefiniowanie nowego typu induktywnego.
    Temu właśnie służy rodzina typów [Iterator]. Nazwa jest wzięta z
    zalinkowanej pracy - w naszym przypadku dużo lepszą nazwą byłoby po
    prostu coś w stylu [FringeWalk], co na naszą mowę ojczystą możemy
    przłożyć jako "spacerek po grzywce".

    Nasz spacerek po grzywce ma nastepującą strukturę:
    - [Result] reprezentuje koniec spacerku, zaś jego argument to wynik.
      Chcemy, żeby spacerek dawał wynik, bo inaczej byłby bezproduktywny.
      [R] to typ wyniku spacerku.
    - [Susp] reprezentuje przerwę w spacerku - kiedy się zmęczymy,
      chcemy móc sobie przystanąć. Oczywiście dziwnym zbiegiem
      okoliczności zawsze będziemy "przystawać sobie", kiedy natrafimy
      na liść.

    Spacerek nie składa się jednak tylko z przystanków i końcowego wyniku.
    Mamy też argumenty [I] oraz [O], które są typami wejścia i wyjścia -
    kiedy już zatrzymamy się w liściu, będziemy chcieli zwrócić zastaną
    tam wartość. Właśnie do tego służy pierwszy argument konstruktora
    [Susp], który ma typ [O]. Inna sprawa jest taka, że gdy już wyjmiemy
    wartość z liścia, będziemy musieli wsadzić tam jakąś inną wartość,
    zanim będziemy mogli kontynuować spacerek. Właśnie to wyraża drugi
    argument konstruktora [Susp], o typie [I -> Iterator I O R]: jeżeli
    dostaniemy na wejściu jakąś wartość typu [I], wsadzamy ją do pustego
    liścia, po czym kontynuujemy spacerek.

    Wyposażeni w tak potężną reprezentacją spacerków po grzywce możemy
    przejść już do tego, co tygryski lubią najbardziej, czyż nie? No
    jeszcze nie. Najpierw garść funkcji pomocniczych (gdybyś jakimś
    cudem nie zauważył, to [Iterator I O] jest monadą; jeżeli nie wiesz
    co to jest monada - cóż, monady są jak koronawirusy...). *)

Definition yield {I O : Type} (x : O) : Iterator I O I :=
  Susp x Result.

(** [yield x] to jednoprzystankowy spacerek, którego wynikiem jest to,
    co dostaniemy na wejściu. *)

Fixpoint bindI {I O R1 R2 : Type}
  (i : Iterator I O R1) (f : R1 -> Iterator I O R2) : Iterator I O R2 :=
match i with
    | Result r => f r
    | Susp o k => Susp o (fun i => bindI (k i) f)
end.

(** [bindI i f] to składanie spacerków - najpierw spacerujemy spacerkiem
    [i], a potem spacerkiem [f r], gdzie [r] jest wynikiem spacerku [i].
    Jak więc widać, trasa drugiego spacerku może zależeć od wyniku
    pierwszego spacerku - zupełnie jak w życiu!

    Dobra, tyle pomocnicznych funkcji powinno wystarczyć. Czas przejść
    do sedna, czyli zamiany grzywek. Zacznijmy od napisania funkcji,
    która przekształca drzewo [t] w spacerek po grzywce [t]. Spacerek
    będzie depth-first, od lewej do prawej, czyli dość standardowy. *)

Fixpoint depthWalk {A B : Type} (t : Tree A) : Iterator B A (Tree B) :=
match t with
    | Leaf a =>
        bindI (yield a) (fun b => Result (Leaf b))
    | Node l r =>
        bindI (depthWalk l) (fun l' =>
        bindI (depthWalk r) (fun r' =>
          Result (Node l' r')))
end.

(** Szczo wyrablajesja tut? Ano, już tłumaczę.

    Po pierwsze, spróbujmy przeczytać typ. Funkcja [depthWalk] bierze
    jako argument drzewo [t : Tree A] i zamienia je w spacerek po 
    grzywce [t], którego wynikiem jest drzewo o typie [Tree B], czyli
    potencjalnie innym, niż. Wynika to z tego, że podczas spacerku
    będziemy dostawać na wejściu wartości typu [B], podczas gdy na
    wyjściu dajemy wartościu typu [A].

    Nieco inne spojrzenie może być takie, że wynikiem [depthWalk] jest
    drzewo [t] z wyznaczoną trasą spacerku po grzywce, a wynikiem samego
    spacerku będzie to, co z [t] zostanie po zabraniu grzywki i
    zastąpieniu jej wartościami z wejścia.

    Sama funkcja działa natomiast następująco.

    Gdy napotkamy liść z wartością [a : A], oddajemy je na wyjście i
    w zamian dostajemy wartość [b : B]. Wynikiem spacerku jest [b]
    zapakowane w liść (pamiętaj, że próbujemy przekształcić drzewo na
    spacerek po grzywce).

    Gdy napotkamy węzeł wewnętrzny, najpierw zamieniamy lewe poddrzewo,
    zwane [l], w spacerek po lewym poddrzewie, zwany [l']. Podobnie
    prawe poddrzewo [r] zamieniamy na spacerek po prawym poddrzewie [r'].
    Następnie sklejamy spacerki, a ostatecznym wynikiem tak sklejonego
    spacerku to samo drzewo co na początku, tylko z grzywką zastąpioną
    przez wartości z wejścia.

    Dobra, jesteśmy już nieźle ustawieni. Jeżeli nie nadążasz, to dla
    spowolnienia tempa odłóżmy na chwilę funkcję zamieniającą grzywki
    i spróbujmy napisać kolejne wcielenie funkcji porównującej grzywki.

    Sprawa jest banalna: *)

Fixpoint same_fringe_aux
  {A R : Type} (cmp : A -> A -> bool)
  (t1 t2 : Iterator A A R) : bool :=
match t1, t2 with
    | Susp x k, Susp y h =>
        cmp x y && same_fringe_aux cmp (k x) (h y)
    | Result _, Result _ => true
    | _, _ => false
end.

(** Nasza funkcja odbywa jednocześnie dwa spacerki: pierwszy po [t1],
    a drugi po [t2].

    Jeżeli w obu spacerkach jesteśmy na przystanku, to porównujemy
    znalezione tam wartości za pomocą [cmp] i kontynuujemy spacerek.
    Kontynuacją spacerka [Susp x k] jest [k x] - wartość z liścia,
    czyli [x], musimy w tym celu odłożyć na swoje miejsce, czyli
    przekazać ją do [k]. Analogicznie dla [y] i [h].

    Jeżeli doszliśmy do końca spacerka, to grzywki są takie same.
    Dlaczego tak? Cóż, pamiętaj, że wartości z liści są w przystankach,
    więc skoro doszliśmy do końca i wszystkie porównania się udały, to
    grzywki musiały być takie same.

    Jeżeli zaś mamy inny przypadek, czyli z jednej strony przystanek, a
    z drugiej koniec lub na odwrót, zwracamy [false], gdyż znaczy to, że
    grzywki mają różną długość, czyli nie mogą być takie same. *)

Definition same_fringe3
  {A : Type} (cmp : A -> A -> bool) (t1 t2 : Tree A) : bool :=
    same_fringe_aux cmp (depthWalk t1) (depthWalk t2).

(** Całość pakujemy w funkcję pomocniczą, która jako argumenty bierze
    drzewa, przerabia je na spacerki i przekazuje te spacerki do wyżej
    zdefiniowanej funkcji pomocniczej. *)

Compute same_fringe3 beq_nat t1 t2.

(** Działa jak marzenie! Ćwiczenie: udowodnij.

    Jak widać, kontynuacje mają potężną moc. Dzięki przekształceniu
    drzewa w spacerek po grzywce możemy zdefiniować porównywanie
    grzywek [same_fringe_aux] w dokładnie taki sposób, jak próbowaliśmy
    na początku ([same_fringe]), ale teraz to działa, a wtedy nie.
    Różnica wynika stąd, że o ile drzewa mogą różnić się kształtami, o
    tyle ich grzywki mogą się co najwyżej różnić długością.

    No, ale powstrzymajmy zachwyt, bo bez kontynuacji też nam się
    udało. Zobaczmy teraz, jak kontynuacje radzą sobie z problemem
    zamiany grzywek. *)

Fixpoint swap_fringe_aux
  {A : Type} (i1 i2 : Iterator A A (Tree A))
  : option (Tree A * Tree A) :=
match i1, i2 with
    | Susp x k, Susp y h => swap_fringe_aux (k y) (h x)
    | Result t1, Result t2 => Some (t1, t2)
    | _, _ => None
end.

(** [swap_fringe_aux] to funkcje, która bierze jako argumenty dwa
    spacerki, których wynikami są drzewa, i zwraca parę drzew, gdzie
    pierwsze to wynik pierwszego spacerku, ale z grzywką wziętą z
    drugiego spacerku i vice versa. Jeżeli grzywki mają różną długość,
    wynikiem będzie [None], stąd w typie pojawia się [option].

    Funkcja działa tak: spacerujemy jednocześnie po obu grzywkach.
    Jeżeli natykamy się jednocześnie na dwa przystanki, pierwszy z
    wartością [x] i kontynuacją [k], a drugi z wartością [y] i
    kontynuacją [h], to do pierwszej grzywki wrzucamy wartość z
    drugiej grzywki, a do drugiej grzywki wrzucamy wartość z pierwszej
    grzywki, po czym spacerujemy dalej.

    Jeżeli jednocześnie oba spacery się kończą, zwracamy parę drzew,
    które są wynikami spacerów. Jeżeli pierwszy spacer się skończył
    a drugi nie lub na odwrót, to znaczy, że grzywki mają różne długości,
    więc zwracamy [None].

    Gdybyś się zagubił, przeżyjmy to jeszcze raz:
    - w pierwszym spacerku wyjściem są wartości z pierwszej grzywki,
      wejściem są wartości z drugiej grzywki, a wynikiem pierwsze
      drzewo z drugą grzywką
    - w drugim spacerku wyjściem są wartości z drugiej grzywki, wejściem
      są wartości z pierwszej grzywki, a wynikiem jest drugie drzewo z
      pierwszą grzywką

    Geniuszalne, prawda? *)

Definition swap_fringe
  {A : Type} (t1 t2 : Tree A) : option (Tree A * Tree A) :=
    swap_fringe_aux (depthWalk t1) (depthWalk t2).

(** Pozostaje nam tylko napisać właściwą funkcję, która jest owijką na
    funkcję pomocniczą: bierze ona dwa drzewa, przekształca na spacerki
    za pomocą [depthWalk] i przekazuje do [swap_fringe_aux], która robi
    całą robotę. *)

Let t1' :=
  Node
    (Leaf 1)
    (Node
      (Leaf 2)
      (Node
        (Leaf 3)
        (Leaf 4))).

Let t2' :=
  Node
    (Node
      (Node
        (Leaf 11)
        (Leaf 12))
      (Leaf 13))
    (Leaf 14).

(** A oto nowe przykładowe dane: pierwsze drzewo jest przechylone w
    prawo, a drugie w lewo. Wartości w obu drzewach są różne.
    (Poprzednie przykładowe drzewa się nie nadają, bo o ile miały różne
    kształty, to wartości w liściach miały takie same). *)

Compute swap_fringe t1' t2'.
(* ===>
  = Some
      (Node (Leaf 11) (Node (Leaf 12) (Node (Leaf 13) (Leaf 14))),
       Node (Node (Node (Leaf 1) (Leaf 2)) (Leaf 3)) (Leaf 4))
  : option (Tree nat * Tree nat) *)

(** Wynik jest trochę nieczytelny ze względu na formatowanie, ale stało
    się dokładnie to, czego sobie życzyliśmy: wynikiem jest para drzew,
    z czego pierwsze jest pochylone w prawo, jak to wejściowe, ale jego
    grzywka ma wartości z drugiego drzewa wejściowego. Drugie drzewo z
    pary analogicznie: jest pochylone w lewo, jak drugie drzewo z wejścia,
    ale jego grzywka ma wartości z pierwszego drzewa wejściowego.

    No, możemy odbębnić sukces, czyż nie? Nie do końca, bo wypadałoby
    jeszcze wyjaśnić dwie sprawy. Po pierwsze, jak można wyobrazić
    sobie spacerek?

    Żeby odpowiedzieć na to pytanie, zobaczmy jak wygląda spacerek
    po grzywce przykładowego drzewa [t1']. *)

Compute depthWalk t1'.
(* ===>
= Susp 1
   (fun x : ?B =>
    Susp 2
      (fun x0 : ?B =>
       Susp 3
         (fun x1 : ?B =>
          Susp 4
            (fun x2 : ?B =>
             Result
               (Node (Leaf x)
                  (Node (Leaf x0) (Node (Leaf x1) (Leaf x2))))))))
: Iterator ?B nat (Tree ?B) *)

(** Moim zdaniem odpowiedź jest całkiem czytelna. Spacerek wygląda tak,
    że stąpamy po kolejnych liściach, wyrzucamy ich wartości na wejście,
    zbierając przy tym wartości z wejścia, a na koniec zwracamy drzewo
    z grzywką podmienioną wartościami wejściowymi. Oczywiście po węzłach
    wewnętrznych też przechodzimy, co widać w implementacji, ale nie
    interesują nas one, więc się w nich nie zatrzymujemy i dlatego tych
    kroków tutaj nie widać. Ćwiczenie: narysuj ładny obrazek.

    Pozostaje zatem pytanie ostateczne: co to są kontynuacje? Gdzie
    występują one w naszym rozwiązaniu i jak się przejawiają? Cóż,
    korzystając ze świętego prawa pisarza matematycznego, odpowiedź
    na to pytanie pozostawiam czytelnikowi jako ćwiczenie. *)
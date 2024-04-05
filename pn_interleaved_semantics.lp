% place(ID)
% trans(ID, LABEL)
% ptarc(PID, TID, W)
% tparc(PID, TID, W)
%
% Ricopiati dal paper
% https://arxiv.org/pdf/1306.3542.pdf
%

#const k=1.
#const ntok=10.
time(0..k+1).
num(0..ntok).

% Initial Marking
holds("__source_place__", 1, 0).
holds(P,0,0) :- place(P), P != "__source_place__".

% Esiste almeno un place P in *T con
% Q token, mentre per sparare T servono
% almeno N token, ma Q < N
notenabled(T,TS) :-
  ptarc(P,T,N), holds(P,Q,TS), Q < N,
  place(P), trans(T,_), time(TS),
  num(N), num(Q).

% Tutte le P in *T hanno abbastanza token
enabled(T,TS) :-
  trans(T,_), time(TS), not notenabled(T,TS).

% Spara esattamente una transizione ad ogni istante di tempo
% tra le abilitate
% (interleaved semantics)
fires("__source_trans__", 0).
fires("__sink_trans__", k).
{ fires(T,TS): enabled(T, TS), trans(T, _) } = 1 :- time(TS), TS <= k.

% Impossibile che all'ultimo istante di tempo
% non ci sia un token nel sink place
:- not holds("__sink_place__", 1, k+1).

% No token residui in altri place
:- holds(P,C,k+1), C > 0, place(P), P != "__sink_place__".

%%%% Attenzione! Questa cambia!
%%%% Nell'articolo c'è la set firing semantics
%%%% (~ più transizioni possono sparare nello stesso istante di tempo)
%%%% a noi interessa la interleaved semantics dove c'è esattamente una
%%%% transizione per istante di tempo
%%%% in più, noi vogliamo sparare solo transizioni che matchano l'attività corrente nella traccia
%%%% probabilmente sarà qualcosa così:
%%%% { fires(T,TS): enabled(T,TS), transition(T,A), trace(T,A) } = 1.
%%%% una transizione tra quelle enabled il cui label matcha l'attività corrente

% Ho sparato T all'istante TS
% Quindi aggiungerò ai place in T* Q token
add(P, Q, T, TS) :-
  fires(T,TS), tparc(T,P,Q), time(TS).

% Ho sparato T all'istante tS
% Quindi rimuovo dai place in *T Q token
del(P, Q, T, TS) :-
  fires(T,TS), ptarc(P,T,Q), time(TS).

% Aggregare su add/4, del/4
tot_incr(P,QQ,TS) :-
  QQ = #sum{Q,T: add(P,Q,T,TS)},
  time(TS), num(QQ), place(P).

tot_decr(P,QQ,TS) :-
  QQ = #sum{Q,T: del(P,Q,T,TS)},
  time(TS), num(QQ), place(P).

holds(P,Q,TS+1) :-
  holds(P,Q1,TS), 
  tot_incr(P,Q2,TS),
  time(TS+1),
  tot_decr(P,Q3,TS),
  place(P),
  num(Q), num(Q1), num(Q2), num(Q3),
  Q = Q1 + Q2 - Q3,
  time(TS).

consumesmore(P,TS) :- holds(P,Q,TS), tot_decr(P,Q1,TS), Q1 > Q.
consumesmore :- consumesmore(P,TS).
% non puoi sparare qualcosa se non hai abbastanza token
:- consumesmore.


%%%%%%%%%%%%%% Secondo me non è modellato benissimo
%%%%%%%%%%%%%% mi pare che holds/3 ricalcoli sempre il numero di token che c'è
%%%%%%%%%%%%%% in tutti i place
%%%%%%%%%%%%%% però ad ogni istante di tempo gli unici token-count influenzati sono quelli di place
%%%%%%%%%%%%%% entranti/uscenti una transizione
%%%%%%%%%%%%%% quindi si può cambiare secondo me in:
%%%%%%%%%%%%%%
%%%%%%%%%%%%%%
% place_affected(P, TS) :- fires(T, TS), ptarc(P, T).
% place_affected(P, TS) :- fires(T, TS), tparc(T, P).
% holds(P,Q,TS+1) :-
%  place_affected(P, TS),
%  % quelle che c'erano al giro di prima
%  holds(P,Q1,TS),
% % l'incremento, il decremento
% tot_incr(P,Q2,TS),
% tot_decr(P,Q3,TS),
% time(TS+1), time(TS),
% num(Q), num(Q1), num(Q2), num(Q3),
% Q = Q1 + Q2 + Q3.
% + inerzia per tutti gli altri
% che rimangono dov'erano
% holds(P, Q, TS+1) :- holds(P, Q, TS), not place_affected(P, TS).

#show.
%#show fires(T,TS): fires(T,TS).
%#show holds(P,Q,T): holds(P,Q,T), Q > 0.
#show trace(TS,A): fires(T,TS), trans(T,A).

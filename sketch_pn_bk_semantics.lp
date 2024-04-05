% place(ID)
% trans(ID, LABEL)
% ptarc(PID, TID, W)
% tparc(PID, TID, W)
%
% Ricopiati dal paper
% https://arxiv.org/pdf/1306.3542.pdf
%

#const k=10.

% f5
time(0..k).

% x1
#const ntok=3.
num(0..ntok).

% i1
holds(P, C, 0) :- initial_marking(P, C).

% e1, e2
notenabled(T,TS) :-
  ptarc(P,T,N), holds(P,Q,TS), Q < N,
  place(P), trans(T,_), time(TS),
  num(N), num(Q).

enabled(T,TS) :-
  trans(T,_), time(TS), not notenabled(T,TS).

% a1
{ fires(T,TS) } :-
  enabled(T,TS),
  trans(T,_),
  time(TS).

%%%% Attenzione! Questa cambia!
%%%% Nell'articolo c'è la set firing semantics
%%%% (~ più transizioni possono sparare nello stesso istante di tempo)
%%%% a noi interessa la interleaved semantics dove c'è esattamente una
%%%% transizione per istante di tempo
%%%% in più, noi vogliamo sparare solo transizioni che matchano l'attività corrente nella traccia
%%%% probabilmente sarà qualcosa così:
%%%% { fires(T,TS): enabled(T,TS), transition(T,A), trace(T,A) } = 1.
%%%% una transizione tra quelle enabled il cui label matcha l'attività corrente

% r1, r2
add(P, Q, T, TS) :-
  fires(T,TS), tparc(T,P,Q), time(TS).

del(P, Q, T, TS) :-
  fires(T,TS), ptarc(P,T,Q), time(TS).

% r3, r4
tot_incr(P,QQ,TS) :-
  QQ = ...non ho capito che fa l'aggregato...,
  time(TS), num(QQ), place(P).
tot_decr(P,QQ,TS) :-
  QQ = ...non ho capito che fa l'aggregato...,
  time(TS), num(QQ), place(P).

% r5
holds(P,Q,TS+1) :-
  holds(P,Q1,TS), tot_incr(P,Q2,TS),
  time(TS+1),
  tot_decr(P,Q3,TS),
  place(P),
  num(Q), num(Q1), num(Q2), num(Q3),
  Q = Q1 + Q2 - Q3,
  time(TS).

 % a2, a3, a4
 consumesmore(P,TS) :- holds(P,Q,TS), tot_decr(P,Q1,TS), Q1 > Q.
 consumesmore :- consumesmore(P,TS).
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
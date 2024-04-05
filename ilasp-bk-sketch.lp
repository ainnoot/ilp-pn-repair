%%%% COPIED FROM PN_INTERLEAVED_SEMANTICS.LP
%%%% HERE WE HAVE TRACE/2 FACTS - HENCE WE ARE ALLOWED TO FIRE ONLY TRANSITIONS
%%%% MATCHING TRACE EVENTS
%%%% WE ASSUME THAT TRACES ARE PADDED, E.G.
%%%% TRACE(0,"__start__"), TRACE(k,"__end__")
%%%% WHERE k IS THE NUMBER OF SIMULATION STEPS
%%%% AND trans("__sink_trans__", "__end__"), trans("__source_trans__", "__start__").
%%%%
%%%% TRACE(T,A) ----> fires(Trans,T), trans(Trans,A)

%%% PREVIOUS FILE: Satisfiable iff there exists a firing sequence such that final marking matches 1 token in the sink place
%%% THIS FILE: Satisfiable iff a given trace (that will be the ctx of an ILASP example) represents a valid firing sequence
%%% for our Petri Net

#const ntok=10. % NUMERO MASSIMO DI TOKEN IN UN PLACE
%%%%%%%%%%%%% THIS CHANGES
time(0..T+1) :- trace(T), not trace(T+1).   % STEP DI SIMULAZIONE
%%%%%%%%%%%%%%
num(0..ntok).   % NUMERO AMMMISSIBILE DI TOKEN IN UN PLACE DURANTE LA SIMULAZIONE

holds("__source_place__", 1, 0).
holds(P,0,0) :- place(P), P != "__source_place__".

notenabled(T,TS) :-
  ptarc(P,T,N), holds(P,Q,TS), Q < N,
  place(P), trans(T,_), time(TS),
  num(N), num(Q).

enabled(T,TS) :-
  trans(T,_), time(TS), not notenabled(T,TS).

fires("__source_trans__", 0).

%%%%%%%%%%%%%%%%%% THIS CHANGES
fires("__sink_trans__", T) :- trace(T), not trace(T+1).
%%%%%%%%%%%%%%%%%%


%%%%%% THIS CHANGES
{ fires(T,TS): enabled(T, TS), trace(TS,A), trans(T, A) } = 1 :- time(TS), TS > 0, TS < k.
%%%%%%%%%%%%%%%%%5
:- not holds("__sink_place__", 1, k+1).
:- holds(P,C,k+1), C > 0, place(P), P != "__sink_place__".
:- holds("__sink_place__", C, TS), TS <= k, C > 0.

affected(P,TS) :- fires(T,TS), ptarc(P,T,_).
affected(P,TS) :- fires(T,TS), tparc(T,P,_).
holds(P,Q,TS+1) :- holds(P,Q,TS), not affected(P,TS), time(TS+1).

add(P, Q, T, TS) :-
  fires(T,TS), tparc(T,P,Q), time(TS).

del(P, Q, T, TS) :-
  fires(T,TS), ptarc(P,T,Q), time(TS).

tot_incr(P,QQ,TS) :-
  affected(P,TS),
  QQ = #sum{Q,T: add(P,Q,T,TS)},
  time(TS), num(QQ), place(P).

tot_decr(P,QQ,TS) :-
  affected(P,TS),
  QQ = #sum{Q,T: del(P,Q,T,TS)},
  time(TS), num(QQ), place(P).

holds(P,Q,TS+1) :-
  affected(P,TS),
  holds(P,Q1,TS), 
  tot_incr(P,Q2,TS),
  time(TS+1),
  tot_decr(P,Q3,TS),
  place(P),
  num(Q), num(Q1), num(Q2), num(Q3),
  Q = Q1 + Q2 - Q3,
  time(TS).

:- holds(P,Q,TS), tot_decr(P,Q1,TS), Q1 > Q.

:- fires(T,TS), holds(P,Q,TS), ptarc(P,T,W), Q < W.

#show.
%#show fires(T,TS): fires(T,TS).
%#show holds(P,Q,T): holds(P,Q,T), Q > 0.

% LE AZIONI LABELLANO LE TRANSIZIONE
% PROIETTO LA FIRING SEQUENCE CHE SODDISFA I CONSTRAINT
% IN UNA TRACCIA PER LEGGIBILITÀ
#show trace(TS,A): fires(T,TS), trans(T,A).

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
last_step(T) :- trace(T,_), not trace(T+1,_).
time(0..T+1) :- last_step(T).   % STEP DI SIMULAZIONE
guessed_time(1..L) :- last_step(L).
%%%%%%%%%%%%%%
num(0..ntok).   % NUMERO AMMMISSIBILE DI TOKEN IN UN PLACE DURANTE LA SIMULAZIONE

holds("__source_place__", 1, 0).
holds(P,0,0) :- place(P), P != "__source_place__".


notenabled(T,TS) :-
  not rem_ptarc(P,T,N), ptarc(P,T,N), holds(P,Q,TS), Q < N,
  place(P), trans(T,_), time(TS),
  num(N), num(Q).

enabled(T,TS) :-
  trans(T,_), time(TS), not notenabled(T,TS).

%% THIS CAN BE INCLUDED IN THE GENERAL RULES(?)
fires("__source_trans__", 0).
fires("__sink_trans__", T) :- last_step(T).
%%%%%%%%%%%%%%%%%%


%%%%%% THIS CHANGES
%{ fires(T,TS): enabled(T, TS), trace(TS,A), trans(T, A) } = 1 :- time(TS), TS > 0, TS < k.
0 { fires(T,TS) } 1 :- trace(TS,A), trans(T, A), enabled(T, TS), guessed_time(TS).
:- not fires(T,TS), enabled(T,TS), trace(TS,A), trans(T, A), enabled(T, TS), guessed_time(TS).
:- fires(T1,TS), fires(T2,TS), T1 > T2, guessed_time(TS).
%%%%%%%%%%%%%%%%%5
:- not holds("__sink_place__", 1, L+1), last_step(L).
:- last_step(L), holds(P,C,L+1), C > 0, place(P), P != "__sink_place__".
:- last_step(L), holds("__sink_place__", C, TS), TS <= L, C > 0.

affected(P,TS) :- fires(T,TS), not rem_ptarc(P,T,_), ptarc(P,T,_).
affected(P,TS) :- fires(T,TS), not rem_tparc(T,P,_), tparc(T,P,_).
holds(P,Q,TS+1) :- holds(P,Q,TS), not affected(P,TS), time(TS+1).

add(P, Q, T, TS) :-
  fires(T,TS), not rem_tparc(T,P,_), tparc(T,P,Q), time(TS).

del(P, Q, T, TS) :-
  fires(T,TS), not rem_ptarc(P,T,Q), ptarc(P,T,Q), time(TS).

% ILASP NON SUPPORTA GLI AGGREGATI
% ASSUNZIONE = DATO CHE CONSIDERIAMO SOLO UNA TRACCIA ALLA VOLTA, AL PIU' UNA SOLA TRANSIZIONE PUO' AGGIUNGERE TOKEN IN UN PLACE 
tot_incr(P,Q,TS) :-
  affected(P,TS),
  add(P,Q,T,TS),
  time(TS), num(Q), place(P).
tot_incr(P,0,TS) :-
  affected(P,TS),
  not add(P,_,_,TS).

% ILASP NON SUPPORTA GLI AGGREGATI
% ASSUNZIONE = DATO CHE CONSIDERIAMO SOLO UNA TRACCIA ALLA VOLTA, AL PIU' UNA SOLA TRANSIZIONE PUO' AGGIUNGERE TOKEN IN UN PLACE 
tot_decr(P,Q,TS) :-
  affected(P,TS),
  del(P,Q,T,TS),
  time(TS), num(Q), place(P).
tot_decr(P,0,TS) :-
  affected(P,TS),
  not del(P,_,_,TS).

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

:- fires(T,TS), holds(P,Q,TS), not rem_ptarc(P,T,W), ptarc(P,T,W), Q < W.



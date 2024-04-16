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
  ptarc(P,T,N), holds(P,Q,TS), Q < N,
  place(P), trans(T,_), time(TS),
  num(N), num(Q).

enabled(T,TS) :-
  trans(T,_), time(TS), not notenabled(T,TS).

fires("__source_trans__", 0).

%%%%%%%%%%%%%%%%%% THIS CHANGES
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

affected(P,TS) :- fires(T,TS), ptarc(P,T,_).
affected(P,TS) :- fires(T,TS), tparc(T,P,_).
holds(P,Q,TS+1) :- holds(P,Q,TS), not affected(P,TS), time(TS+1).

add(P, Q, T, TS) :-
  fires(T,TS), tparc(T,P,Q), time(TS).

del(P, Q, T, TS) :-
  fires(T,TS), ptarc(P,T,Q), time(TS).

% ILASP NON SUPPORTA GLI AGGREGATI
% ASSUNZIONE = AL PIU' UNA SOLA TRANSIZIONE PUO' AGGIUNGERE TOKEN IN UN PLACE 
tot_incr(P,Q,TS) :-
  affected(P,TS),
  add(P,Q,T,TS),
  time(TS), num(Q), place(P).
tot_incr(P,0,TS) :-
  affected(P,TS),
  not add(P,_,_,TS),
  time(TS), num(Q), place(P).

% ILASP NON SUPPORTA GLI AGGREGATI
% ASSUNZIONE = AL PIU' UNA SOLA TRANSIZIONE PUO' RIMUOVERE TOKEN IN UN PLACE 
tot_decr(P,Q,TS) :-
  affected(P,TS),
  del(P,Q,T,TS),
  time(TS), num(Q), place(P).
tot_decr(P,0,TS) :-
  affected(P,TS),
  not del(P,_,_,TS),
  time(TS), num(Q), place(P).

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


%place("p1").
%place("p3").
%place("p2").
%place("__source_place__").
%place("__sink_place__").
%trans("t1","t1").
%trans("t2","t2").
%trans("__source_trans__","__start__").
%trans("__sink_trans__","__end__").
%ptarc("__source_place__","__source_trans__",1).
%ptarc("p1","t1",1).
%ptarc("p2","t2",1).
%ptarc("p3","__sink_trans__",1).
%tparc("__sink_trans__","__sink_place__",1).
%tparc("t1","p2",1).
%tparc("t2","p3",1).
%tparc("__source_trans__","p1",1).
%label("t1").
%label("t2").
%label("__start__").
%label("__end__").


%#pos({}, {}, {
%trace(0,"__start__").
%trace(1,"t1"). 
%trace(2,"t2"). 
%trace(3,"__end__"). 
%}).


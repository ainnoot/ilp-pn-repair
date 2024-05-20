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

#const ntok=10. % Max number of tokens in one place (necessary??)
num(0..ntok).   
%%%%%%%%%%%%% 
last_step(T) :- trace(T,_), not trace(T+1,_).
time(0..T+1) :- last_step(T).        % all steps
guessed_time(1..T) :- last_step(T).  % guessed steps (first and second, deterministic for wf net property)

% Consider only valid elements (i.e., transitions not removed plus recently added)
valid(E) :- original(E), not remove(E).
valid(E) :- add(E).

place(P)   :- valid(place(P)).
trans(T,L) :- valid(trans(T,L)).
ptarc(P,T,W) :- valid(ptarc(P,T,W)).
tparc(T,P,W) :- valid(tparc(T,P,W)).

% Transition T is not enabled at time TS
notenabled(T,TS) :-
  ptarc(P,T,N), holds(P,Q,TS), Q < N,
  place(P), trans(T,_), time(TS),
  num(N), num(Q).

enabled(T,TS) :-
  trans(T,_), time(TS), not notenabled(T,TS).

%%%%%%%%%%%%%%%
% Deterministic part 
% First step: for workflow property, only one token in source_place
holds(source_place, 1, 0).
holds(P,0,0) :- place(P), P != source_place.

% Last step: for workflow property, only one token in sink_place
:- last_step(L), not holds(sink_place, 1, L+1).
:- last_step(L), holds(P,C,L+1), C > 0, place(P), P != sink_place.
% If a token ends up in sink_place before last step, then error
:- last_step(L), holds(sink_place, C, TS), TS <= L, C > 0.

% Firing for first and last step
fires(source_transition, 0).
fires(sink_transition, T) :- last_step(T).
%%%%%%%%%%%%%%%


%%%%%%%%%%%%%%%%
% Guess firing one transition per time
0 { fires(T,TS) } 1 :- trace(TS,A), trans(T, A), enabled(T, TS), guessed_time(TS).
:- not fires(_,TS), guessed_time(TS).
:- fires(T1,TS), fires(T2,TS), T1 > T2, guessed_time(TS).
%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%
% Compute holds after firing
affected(P,TS) :- fires(T,TS), ptarc(P,T,_).
affected(P,TS) :- fires(T,TS), tparc(T,P,_).

holds(P,Q,TS+1) :- holds(P,Q,TS), not affected(P,TS), time(TS+1).

add(P, Q, T, TS) :-
  fires(T,TS), tparc(T,P,Q), time(TS).

del(P, Q, T, TS) :-
  fires(T,TS), ptarc(P,T,Q), time(TS).

% Just one increment per place per time (one firing)
tot_incr(P,Q,TS) :-
  affected(P,TS), add(P,Q,T,TS),
  time(TS), num(Q), place(P).

tot_incr(P,0,TS) :-
  affected(P,TS),
  not add(P,_,_,TS).

% Just one increment per place per time (one firing)
tot_decr(P,Q,TS) :-
  affected(P,TS), del(P,Q,T,TS),
  time(TS), num(Q), place(P).

tot_decr(P,0,TS) :-
  affected(P,TS),
  not del(P,_,_,TS).

holds(P,Q,TS+1) :-
  affected(P,TS),
  holds(P,Q1,TS), 
  tot_incr(P,Q2,TS),
  tot_decr(P,Q3,TS),
  time(TS+1),
  place(P),
  num(Q), num(Q1), num(Q2), num(Q3),
  Q = Q1 + Q2 - Q3,
  time(TS).


:- holds(P,Q,TS), tot_decr(P,Q1,TS), Q1 > Q.
:- fires(T,TS), holds(P,Q,TS), ptarc(P,T,W), Q < W.


%% Just one label per transition 
:- trans(T,L), trans(T,L1), L > L1.
%% Just one edge per (place,transition)
:- ptarc(P,T,W), ptarc(P,T,W2), W >W2.
:- tparc(T,P,W), tparc(T,P,W2), W >W2.


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Transitions must have at least one input place, at least one output place
invalid_trans(T) :- trans(T,_), not ptarc(_,T,_).
invalid_trans(T) :- trans(T,_), not tparc(T,_,_).
:- trans(T,_), invalid_trans(T).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% The whole network should be connected
edge(X,Y) :- ptarc(X,Y,_).
edge(X,Y) :- tparc(X,Y,_).
edge(Y,X) :- edge(X,Y).
node(X) :- edge(X,_).
node(X) :- edge(_,X).
reach(X,X) :- node(X).
reach(X,Y) :- edge(X,Y).
reach(X,Z) :- reach(X,Y), reach(Y,Z).
:- node(X), node(Y), not reach(X,Y).
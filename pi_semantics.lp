%%%% Satisfiable iff a given trace (that will be the ctx of an ILASP example) represents a valid firing sequence for our Petri Net

%%%%%%%%%%%%% 
last_step(T) :- trace(T,_), not trace(T+1,_).
time(0..T+1) :- last_step(T).        % all steps

% Transition T is not enabled at time TS
notenabled(T,TS) :-
  ptarc(P,T,N), holds(P,Q,TS), Q < N,
  place(P), trans(T,_), time(TS).

enabled(T,TS) :-
  trans(T,_), time(TS), not notenabled(T,TS).

%%%%%%%%%%%%%%%
% Deterministic part 
% First state: consistent with initial marking
holds(S,T,0) :- initial_marking(S,T).
holds(P,0,0) :- initial_marking(S,_), place(P), P != S.

% Last step: check consistency with final marking
fail :- last_step(L), final_marking(F,T), not holds(F, T, L+1).
fail :- last_step(L), final_marking(F,T), place(P), P != F, holds(P,C,L+1), C > 0.
%%%%%%%%%%%%%%%


%%%%%%%%%%%%%%%%
% Guess firing one transition per time
0 { fires(T,TS) } 1 :- trace(TS,A), trans(T, A), enabled(T, TS), time(TS), last_step(L), TS <=L.
fail :- not fires(_,TS), time(TS), last_step(L), TS <=L.
fail :- fires(T1,TS), fires(T2,TS), T1 > T2, time(TS).
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
  time(TS), place(P).

tot_incr(P,0,TS) :-
  affected(P,TS),
  not add(P,_,_,TS).

% Just one increment per place per time (one firing)
tot_decr(P,Q,TS) :-
  affected(P,TS), del(P,Q,T,TS),
  time(TS),  place(P).

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
  Q = Q1 + Q2 - Q3,
  time(TS).

%% added to remove negative examples
ok :- not fail.

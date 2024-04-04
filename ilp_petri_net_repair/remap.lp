firing_transition(P, A, P') :-
  place(P), place(P'), transition(T, A),
  arc(P, T, _), arc(T, P', _).

#show.
#defined transition/3.
#defined place/1.
#defined initial_marking/2.
#defined final_marking/2.
#show transition(P,A,P'): firing_transition(P,A,P').
#show activity(A): firing_transition(_,A,_).
#show place/1.
#show initial_marking/2.
#show final_marking/2.
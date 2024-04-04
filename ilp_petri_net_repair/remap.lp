input_place(P, T) :-
  place(P), transition(T,L),
  arc(P, T, _).

output_place(P, T) :-
  place(P), transition(T,L),
  arc(T, P, _).

#show.
#defined place/1.
#defined initial_marking/2.
#defined final_marking/2.
#show activity(A): transition(_,A).
#show output_place/2.
#show input_place/2.
#show transition/2.
#show place/1.
#show initial_marking/2.
#show final_marking/2.
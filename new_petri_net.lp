new(place(P))   :- original(place(P)).
new(trans(T,L)) :- original(trans(T,L)).
new(ptarc(P,T,W)) :- original(ptarc(P,T,W)), not edit(remove,ptarc(P,T,W)).
new(tparc(T,P,W)) :- original(tparc(T,P,W)), not edit(remove,tparc(T,P,W)).
new(ptarc(P,T,W)) :- edit(add,ptarc(P,T,W)).
new(tparc(T,P,W)) :- edit(add,tparc(T,P,W)).

#show.
#show  original(E) : new(E).
#show  final_marking/2.
#show  initial_marking/2.


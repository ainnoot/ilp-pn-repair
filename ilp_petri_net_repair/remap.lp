ptarc(P,T,W) :- place(P), transition(T,_), arc(P,T,W).
tparc(T,P,W) :- place(P), transition(T,_), arc(P,T,W).

#show.
#defined place/1.
#defined initial_marking/2.
#defined final_marking/2.
#defined ptarc/3.
#defined tparc/3.
#defined transition/2.

#show label(A): transition(_,A).
#show ptarc/3.
#show tparc/3.
#show place/1.
#show transition/2.
#show initial_marking/2.
#show final_marking/2.
% Consider only valid elements (i.e., transitions not removed plus recently added)
% If remove plance, then remove connected transitions
remove(ptarc(P,T,W)) :- original(ptarc(P,T,W)), remove(place(P)).
remove(tparc(T,P,W)) :- original(tparc(T,P,W)), remove(place(P)).
valid(E) :- original(E), not remove(E).
valid(E) :- add(E).

place(P)   :- valid(place(P)).
trans(T,L) :- valid(trans(T,L)).
ptarc(P,T,W) :- valid(ptarc(P,T,W)).
tparc(T,P,W) :- valid(tparc(T,P,W)).
initial_marking(T,W) :- valid(initial_marking(T,W)).
final_marking(T,W) :- valid(final_marking(T,W)).

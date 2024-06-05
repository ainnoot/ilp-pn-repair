% Number of edits (to arcs)
#const n=1.

% unwrap petri net
place(P)   :- original(place(P)).
trans(T,L) :- original(trans(T,L)).
ptarc(P,T,W) :- original(ptarc(P,T,W)).
tparc(T,P,W) :- original(tparc(T,P,W)).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Add tp- or pt-arcs if not included in original model, by default the weight is 1
add(tparc(T,P,1)) :- place(P), trans(T,_), not tparc(T,P,_).
add(ptarc(P,T,1)) :- place(P), trans(T,_), not ptarc(P,T,_).

% Remove tp- or pt-arcs if in original model, but not frozen
remove(tparc(T,P,W)) :- place(P), trans(T,_), tparc(T,P,W).
remove(ptarc(P,T,W)) :- place(P), trans(T,_), ptarc(P,T,W).


{ edit(add,E): add(E); edit(remove,E): remove(E)} = n.

#show  edit/2.

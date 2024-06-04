% Default frozen places/trans
frozen(source_place).
frozen(sink_place).
frozen(sink_trans).
frozen(source_trans).

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
remove(tparc(T,P,W)) :- place(P), trans(T,_), tparc(T,P,W), not frozen(P), not frozen(T).
remove(ptarc(P,T,W)) :- place(P), trans(T,_), ptarc(P,T,W), not frozen(P), not frozen(T).

% Change label of a transition
label(L) :- trans(_,L), L != workflow_start, L != workflow_end.
replace(trans(T,L),trans(T,L')) :- trans(T,L), not frozen(T), label(L'), L' != L.

% Remove place
remove(place(P)) :- place(P).


% Default cost of abducibles is 1
abducible(add(A),1) :- add(A).
abducible(remove(A),1) :- remove(A).
abducible(remove(A),1) :- replace(A,_).
abducible(add(B),1) :- replace(_,B).

% Abducibles with costs
% abducible(add(A),C) :- add(A,C).
% abducible(remove(A),C) :- remove(A,C).
% abducible(remove(A),C) :- replace(A,_,C).
% abducible(add(B),C) :- replace(_,B,C).

{ head(A): abducible(A,C) } = 1.

#show.
#show  (C,A) : head(A), abducible(A,C).

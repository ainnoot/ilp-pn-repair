% Number of frozen elements
#const n=1.

% unwrap petri net
place(P)   :- original(place(P)).
trans(T,L) :- original(trans(T,L)).
ptarc(P,T,W) :- original(ptarc(P,T,W)).
tparc(T,P,W) :- original(tparc(T,P,W)).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

avoid(T) :- edit(_,ptarc(_,T,_)).
avoid(T) :- edit(_,tparc(T,_,_)).
avoid(P) :- edit(_,ptarc(P,_,_)).
avoid(P) :- edit(_,tparc(_,P,_)).

possible_frozen(T) :- trans(T,L), not avoid(T).
possible_frozen(P) :- place(P), not avoid(P).

{ frozen(E) : possible_frozen(E)} = n.

#show  frozen/1.

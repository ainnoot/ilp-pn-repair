%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Transitions must have at least one input place, at least one output place
ptarc_after_edit(P,T,W) :- ptarc(P,T,W), not rem_ptarc(P,T,W).
tparc_after_edit(P,T,W) :- ptarc(P,T,W), not rem_tparc(T,P,W).
invalid_trans(T) :- trans(T,_), not ptarc_after_edit(_,T,_).
invalid_trans(T) :- trans(T,_), not tparc_after_edit(T,_,_).
:- trans(T,_), invalid_trans(T).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% The whole network should be connected
edge(X,Y) :- ptarc_after_edit(X,Y,_).
edge(X,Y) :- tparc_after_edit(X,Y,_).
edge(Y,X) :- edge(X,Y).
node(X) :- edge(X,_).
node(X) :- edge(_,X).
reach(X,X) :- node(X).
reach(X,Y) :- edge(X,Y).
reach(X,Z) :- reach(X,Y), reach(Y,Z).
:- node(X), node(Y), not reach(X,Y).

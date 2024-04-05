ptarc(P,T,W) :- place(P), trans(T,_), arc(P,T,W).
tparc(T,P,W) :- place(P), trans(T,_), arc(T,P,W).

% a new source place that joins to all places in the initial mark
place("__source_place__").
trans("__source_trans__", "__start__").

% the unique initial place is linked to the introduced transition
ptarc("__source_place__", "__source_trans__", 1).

% using the introduced transition creates the "original" initial marking
% e.g. it produces the initial marking
tparc("__source_trans__", P, C) :- initial_marking(P,C).

% a new sink place that joins all places in the final marking
place("__sink_place__").
trans("__sink_trans__", "__end__").

% the unique sink place is the output place of the sink transition
tparc("__sink_trans__", "__sink_place__", 1).

% the sink transition clears up all the tokens in the final configuration of the petri net
ptarc(P, "__sink_trans__", C) :- final_marking(P, C).

% now, we force the final configuration to have a single token in the source place
% and the final configuration to have a single token in the sink place
source("__source_place__").
sink("__sink_place__").

%%%%%% in workflow nets, all places and transitions must be in the path from src to sink
reach(X,Y) :- ptarc(X,Y,_).
reach(X,Y) :- tparc(X,Y,_).
reach(X,Z) :- reach(X,Y), reach(Y,Z).
:- place(P), P != "__source_place__", not reach("__source_place__", P).
:- trans(T,_), not reach("__source_place__", T).
:- place(P), P != "__sink_place__", not reach(P, "__sink_place__").
:- trans(T,_), not reach(T, "__sink_place__").


#show.
#defined place/1.
#defined trans/2.
#defined ptarc/3.
#defined tparc/3.
#show label(A): trans(_,A).
#show place/1.
#show trans/2.
#show ptarc/3.
#show tparc/3.
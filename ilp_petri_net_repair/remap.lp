ptarc(P,T,W) :- place(P), trans(T,_), arc(P,T,W).
tparc(T,P,W) :- place(P), trans(T,_), arc(P,T,W).

% a new source place that joins to all places in the initial mark
place("__source_place__").
trans("__source_trans__", "__start__").

% the unique initial place is linked to the introduced transition
ptarc("__source_place__", "__source_trans__", 0).

% using the introduced transition creates the "original" initial marking
% e.g. it produces the initial marking
tparc("__source_trans__", P, C) :- initial_marking(P,C).

% a new sink place that joins all places in the final marking
place("__sink_place__").
trans("__sink_trans__", "__end__").

% the unique sink place is the output place of the sink transition
tparc("__sink_trans__", "__sink_place__", 0).

% the sink transition clears up all the tokens in the final configuration of the petri net
ptarc(P, "__sink_trans__", C) :- final_marking(P, C).

% now, we force the final configuration to have a single token in the source place
% and the final configuration to have a single token in the sink place
im(P,0) :- place(P), P != "__source_place__".
fm(P,0) :- place(P), P != "__sink_place__".
im("__source_place__",1).
fm("__sink_place__",1).

#show.
#defined place/1.
#defined im/2.
#defined fm/2.
#defined ptarc/3.
#defined tparc/3.
#defined trans/2.

#show label(A): trans(_,A).
#show ptarc/3.
#show tparc/3.
#show place/1.
#show trans/2.
#show im/2.
#show fm/2.
%%%% Petri net

place("__source_place__").
place("__sink_place__").
place(p1).
place(p2).

trans("__source_trans__","DUMMY-START").
trans("__sink_trans__","DUMMY-END").
trans(t1,tick).
trans(t2,tock).

ptarc("__source_place__", "__source_trans__", 1).
ptarc(p1, t2, 1).
ptarc(p2, "__sink_trans__", 1).
ptarc(p2, t2, 1).

tparc("__source_trans__", p1, 1).
tparc(t1, p2, 1).
tparc(t2, p1, 1).
tparc("__sink_trans__", "__sink_place__", 1).

%%%%%%%%%%%%
% Add here new places and transitions (not connected)
% place(p3).
% trans(t3,tack).
%%%%%%%%%%%%




#pos(idp1, {}, {}, {
trace(0,"DUMMY-START"). 
trace(1,tick).
trace(2,"DUMMY-END"). 
}).

#pos(idp2, {}, {}, {
trace(0,"DUMMY-START"). 
trace(1,tick).
trace(2,tock).
trace(3,tick).
trace(4,"DUMMY-END"). 
}).

#neg(idn1, {}, {}, {
trace(0,"DUMMY-START"). 
trace(1,"DUMMY-END"). 
}).

#neg(idn2, {}, {}, {
trace(0,"DUMMY-START"). 
trace(1,tick).
trace(2,tock).
trace(3,"DUMMY-END"). 
}).



#modeh(ptarc(const(place),const(trans),const(weight))).
#modeh(tparc(const(trans),const(place),const(weight))).
#modeh(rem_ptarc(const(place),const(trans),const(weight))).
#modeh(rem_tparc(const(trans),const(place),const(weight))).

#constant(place, p1).
#constant(place, p2).
% #constant(place, p3).
% #constant(trans, t1).
#constant(trans, t1).
#constant(trans, t2).
#constant(weight, 1).



#bias("
place(p1).
place(p2).
% place(p3).
% trans(t3,tack).
trans(t1,tick).
trans(t2,tock).
ptarc(p1, t2, 1).
ptarc(p2, t2, 1).
tparc(t1, p2, 1).
tparc(t2, p1, 1).
weight(1).


new_tparc(T,P,W) :- trans(T,A), place(P), weight(W), not tparc(T,P,W).
new_ptarc(T,P,W) :- trans(T,A), place(P), weight(W), not ptarc(P,T,W).
:- head(ptarc(P,T,W)), ptarc(P,T,W).
:- head(tparc(T,P,W)), ptarc(T,P,W).
:- head(rem_ptarc(P,T,W)), new_ptarc(P,T,W).
:- head(rem_tparc(T,P,W)), new_tparc(T,P,W).
").
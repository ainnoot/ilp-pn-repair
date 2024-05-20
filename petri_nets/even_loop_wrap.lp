original(place(source_place)).
original(place(sink_place)).
original(place(p1)).
original(place(p2)).

original(trans(source_transition,workflow_start)).
original(trans(sink_transition,workflow_end)).
original(trans(t1,tick)).
original(trans(t2,tock)).

original(ptarc(source_place, source_transition, 1)).
original(ptarc(p1, t1, 1)).
original(ptarc(p2, sink_transition, 1)).
original(ptarc(p2, t2, 1)).

original(tparc(source_transition, p1, 1)).
original(tparc(t1, p2, 1)).
original(tparc(t2, p1, 1)).
original(tparc(sink_transition, sink_place, 1)).

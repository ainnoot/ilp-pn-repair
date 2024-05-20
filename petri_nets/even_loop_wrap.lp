original(place(source_place)).
original(place(sink_place)).
original(place(p1)).
original(place(p2)).

original(trans(source_trans,workflow_start)).
original(trans(sink_trans,workflow_end)).
original(trans(t1,tick)).
original(trans(t2,tock)).

original(ptarc(source_place, source_trans, 1)).
original(ptarc(p1, t1, 1)).
original(ptarc(p2, sink_trans, 1)).
original(ptarc(p2, t2, 1)).

original(tparc(source_trans, p1, 1)).
original(tparc(t1, p2, 1)).
original(tparc(t2, p1, 1)).
original(tparc(sink_trans, sink_place, 1)).

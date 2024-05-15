place(source_place).
place(sink_place).
place(p1).
place(p2).

trans(source_trans,workflow_start).
trans(sink_trans,workflow_end).
trans(t1,tick).
trans(t2,tock).

ptarc(source_place, source_trans, 1).
ptarc(p1, t1, 1).
ptarc(p2, sink_trans, 1).
ptarc(p2, t2, 1).

tparc(source_trans, p1, 1).
tparc(t1, p2, 1).
tparc(t2, p1, 1).
tparc(sink_trans, sink_place, 1).
